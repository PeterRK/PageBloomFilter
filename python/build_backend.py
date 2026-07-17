import base64
import csv
import hashlib
import io
import os
import pathlib
import shutil
import sys
import sysconfig
import tarfile
import tempfile
import zipfile

from setuptools import Distribution, Extension
from setuptools.command.build_ext import build_ext


NAME = "pagebloomfilter"
VERSION = "1.3.0"
SUMMARY = "Fast page-based Bloom filter"
ROOT = pathlib.Path(__file__).resolve().parent


def _find_source_root():
    for candidate in (ROOT.parent, ROOT):
        if (candidate / "include" / "pbf-c.h").is_file() and (candidate / "src" / "hash.cc").is_file():
            return candidate
    raise RuntimeError("PageBloomFilter C/C++ sources were not found")


SOURCE_ROOT = _find_source_root()


def _normalize_dist_info_name(name):
    return name.replace("-", "_")


def _platform_tag():
    return sysconfig.get_platform().replace("-", "_").replace(".", "_")


def _interpreter_tag():
    if sys.implementation.name != "cpython":
        raise RuntimeError("the native extension currently supports CPython only")
    return f"cp{sys.version_info.major}{sys.version_info.minor}"


def _abi_tag():
    tag = _interpreter_tag()
    flags = getattr(sys, "abiflags", "")
    if sysconfig.get_config_var("Py_GIL_DISABLED") and "t" not in flags:
        flags += "t"
    return f"{tag}{flags}"


def _wheel_tag():
    return f"{_interpreter_tag()}-{_abi_tag()}-{_platform_tag()}"


def _compile_extension(output_dir):
    output_dir = pathlib.Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    if os.name == "nt":
        extra_compile_args = ["/O2"]
    else:
        extra_compile_args = ["-O3", "-fno-strict-aliasing"]

    extension = Extension(
        "_pbf",
        sources=[
            str(ROOT / "bind.c"),
            str(SOURCE_ROOT / "src" / "pbf-c.cc"),
            str(SOURCE_ROOT / "src" / "hash.cc"),
        ],
        include_dirs=[str(SOURCE_ROOT / "include"), str(SOURCE_ROOT / "src")],
        language="c++",
        extra_compile_args=extra_compile_args,
    )
    distribution = Distribution({"name": NAME, "ext_modules": [extension]})
    command = build_ext(distribution)
    command.ensure_finalized()
    command.build_lib = str(output_dir)
    command.build_temp = str(output_dir / "temp")
    command.force = True
    command.run()

    ext_path = pathlib.Path(command.get_ext_fullpath("_pbf"))
    if not ext_path.is_file():
        raise RuntimeError(f"extension build did not produce {ext_path}")
    return ext_path


def _project_text(name):
    for base in (SOURCE_ROOT, ROOT):
        path = base / name
        if path.is_file():
            return path.read_text(encoding="utf-8")
    return ""


def _metadata_text():
    return "\n".join(
        [
            "Metadata-Version: 2.2",
            f"Name: {NAME}",
            f"Version: {VERSION}",
            f"Summary: {SUMMARY}",
            "Author: Ruan Kunliang",
            "Requires-Python: >=3.9",
            "License: BSD-3-Clause",
            "License-File: LICENSE",
            "Project-URL: Homepage, https://github.com/PeterRK/PageBloomFilter",
            "Project-URL: Repository, https://github.com/PeterRK/PageBloomFilter",
            "Project-URL: Issues, https://github.com/PeterRK/PageBloomFilter/issues",
            "Description-Content-Type: text/markdown",
            "",
            _project_text("README.md"),
        ]
    )


def _wheel_text(tag):
    return "\n".join(
        [
            "Wheel-Version: 1.0",
            "Generator: pagebloomfilter-build-backend",
            "Root-Is-Purelib: false",
            f"Tag: {tag}",
            "",
        ]
    )


def _record_line(path, data):
    digest = hashlib.sha256(data).digest()
    encoded = base64.urlsafe_b64encode(digest).rstrip(b"=").decode("ascii")
    return (path, f"sha256={encoded}", str(len(data)))


def _build_layout(build_dir):
    build_dir = pathlib.Path(build_dir)
    build_dir.mkdir(parents=True, exist_ok=True)
    module_path = build_dir / "pbf.py"
    shutil.copy2(ROOT / "pbf.py", module_path)
    extension_path = _compile_extension(build_dir)
    return build_dir, module_path, extension_path


def _dist_info_dir(base_dir):
    return pathlib.Path(base_dir) / f"{_normalize_dist_info_name(NAME)}-{VERSION}.dist-info"


def _write_metadata(dist_info):
    dist_info = pathlib.Path(dist_info)
    dist_info.mkdir(parents=True, exist_ok=True)
    (dist_info / "METADATA").write_text(_metadata_text(), encoding="utf-8")
    (dist_info / "WHEEL").write_text(_wheel_text(_wheel_tag()), encoding="utf-8")
    (dist_info / "LICENSE").write_text(_project_text("LICENSE"), encoding="utf-8")


def prepare_metadata_for_build_wheel(metadata_directory, config_settings=None):
    dist_info = _dist_info_dir(metadata_directory)
    _write_metadata(dist_info)
    return dist_info.name


def get_requires_for_build_wheel(config_settings=None):
    return []


def get_requires_for_build_sdist(config_settings=None):
    return []


def _build_wheel_file(wheel_directory):
    tag = _wheel_tag()
    wheel_name = f"{_normalize_dist_info_name(NAME)}-{VERSION}-{tag}.whl"
    wheel_path = pathlib.Path(wheel_directory) / wheel_name

    with tempfile.TemporaryDirectory() as tmp:
        layout, module_path, extension_path = _build_layout(pathlib.Path(tmp) / "wheel")
        dist_info = _dist_info_dir(layout)
        _write_metadata(dist_info)

        payload = [
            module_path,
            extension_path,
            dist_info / "METADATA",
            dist_info / "WHEEL",
            dist_info / "LICENSE",
        ]
        records = []
        for path in payload:
            rel = path.relative_to(layout).as_posix()
            records.append(_record_line(rel, path.read_bytes()))

        record_path = dist_info / "RECORD"
        record_rel = record_path.relative_to(layout).as_posix()
        with record_path.open("w", encoding="utf-8", newline="") as fp:
            writer = csv.writer(fp)
            writer.writerows(records)
            writer.writerow((record_rel, "", ""))
        payload.append(record_path)

        with zipfile.ZipFile(wheel_path, "w", compression=zipfile.ZIP_DEFLATED) as zf:
            for path in payload:
                zf.write(path, path.relative_to(layout).as_posix())

    return wheel_name


def build_wheel(wheel_directory, config_settings=None, metadata_directory=None):
    pathlib.Path(wheel_directory).mkdir(parents=True, exist_ok=True)
    return _build_wheel_file(wheel_directory)


def _sdist_files():
    files = [
        (ROOT / "pyproject.toml", pathlib.Path("pyproject.toml")),
        (ROOT / "build_backend.py", pathlib.Path("build_backend.py")),
        (ROOT / "setup.py", pathlib.Path("setup.py")),
        (ROOT / "pbf.py", pathlib.Path("pbf.py")),
        (ROOT / "bind.c", pathlib.Path("bind.c")),
        (SOURCE_ROOT / "README.md", pathlib.Path("README.md")),
        (SOURCE_ROOT / "LICENSE", pathlib.Path("LICENSE")),
    ]
    for directory in ("include", "src"):
        base = SOURCE_ROOT / directory
        for path in sorted(base.rglob("*")):
            if path.is_file():
                files.append((path, path.relative_to(SOURCE_ROOT)))
    return files


def build_sdist(sdist_directory, config_settings=None):
    pathlib.Path(sdist_directory).mkdir(parents=True, exist_ok=True)
    base_name = f"{_normalize_dist_info_name(NAME)}-{VERSION}"
    sdist_name = f"{base_name}.tar.gz"
    sdist_path = pathlib.Path(sdist_directory) / sdist_name
    with tarfile.open(sdist_path, "w:gz", format=tarfile.PAX_FORMAT) as archive:
        for source, relative in _sdist_files():
            archive.add(source, arcname=(pathlib.Path(base_name) / relative).as_posix(), recursive=False)
        metadata = _metadata_text().encode("utf-8")
        info = tarfile.TarInfo((pathlib.Path(base_name) / "PKG-INFO").as_posix())
        info.size = len(metadata)
        info.mode = 0o644
        archive.addfile(info, io.BytesIO(metadata))
    return sdist_name


def build_inplace():
    return _compile_extension(ROOT)
