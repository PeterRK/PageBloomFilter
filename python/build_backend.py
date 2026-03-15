import base64
import csv
import hashlib
import os
import pathlib
import shutil
import subprocess
import sys
import sysconfig
import tempfile
import zipfile


NAME = "pbf"
VERSION = "0.1"
SUMMARY = "Page Bloom Filter"
ROOT = pathlib.Path(__file__).resolve().parent
REPO_ROOT = ROOT.parent


def _normalize_dist_info_name(name):
    return name.replace("-", "_")


def _platform_tag():
    return sysconfig.get_platform().replace("-", "_").replace(".", "_")


def _interpreter_tag():
    return f"cp{sys.version_info.major}{sys.version_info.minor}"


def _wheel_tag():
    tag = _interpreter_tag()
    return f"{tag}-{tag}-{_platform_tag()}"


def _extension_suffix():
    return sysconfig.get_config_var("EXT_SUFFIX") or ".so"


def _run(cmd, cwd=None):
    subprocess.check_call(cmd, cwd=cwd)


def _compile_extension(output_dir):
    output_dir = pathlib.Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    cc = os.environ.get("CC", "gcc")
    cxx = os.environ.get("CXX", "g++")
    include_python = sysconfig.get_paths()["include"]
    cflags = [flag for flag in (sysconfig.get_config_var("CFLAGS") or "").split() if flag]
    cppflags = [flag for flag in (sysconfig.get_config_var("CPPFLAGS") or "").split() if flag]
    ldflags = [flag for flag in (sysconfig.get_config_var("LDFLAGS") or "").split() if flag]

    bind_obj = output_dir / "bind.o"
    pbf_c_obj = output_dir / "pbf-c.o"
    hash_obj = output_dir / "hash.o"
    ext_path = output_dir / f"_pbf{_extension_suffix()}"

    common_includes = [f"-I{include_python}", f"-I{REPO_ROOT / 'include'}"]
    _run([cc, "-O3", "-fPIC", "-c", str(ROOT / "bind.c"), "-o", str(bind_obj), *common_includes, *cppflags, *cflags])
    _run([cxx, "-O3", "-std=c++14", "-fPIC", "-c", str(REPO_ROOT / "src" / "pbf-c.cc"), "-o", str(pbf_c_obj),
          f"-I{REPO_ROOT / 'include'}"])
    _run([cxx, "-O3", "-std=c++14", "-fPIC", "-c", str(REPO_ROOT / "src" / "hash.cc"), "-o", str(hash_obj),
          f"-I{REPO_ROOT / 'include'}"])
    _run([cxx, "-shared", str(bind_obj), str(pbf_c_obj), str(hash_obj), "-o", str(ext_path), *ldflags])
    return ext_path


def _metadata_text():
    return "\n".join(
        [
            "Metadata-Version: 2.1",
            f"Name: {NAME}",
            f"Version: {VERSION}",
            f"Summary: {SUMMARY}",
            "",
        ]
    )


def _wheel_text(tag):
    return "\n".join(
        [
            "Wheel-Version: 1.0",
            "Generator: local-build-backend",
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
    shutil.copy2(ROOT / "pbf.py", build_dir / "pbf.py")
    _compile_extension(build_dir)
    return build_dir


def _dist_info_dir(base_dir):
    return pathlib.Path(base_dir) / f"{_normalize_dist_info_name(NAME)}-{VERSION}.dist-info"


def prepare_metadata_for_build_wheel(metadata_directory, config_settings=None):
    dist_info = _dist_info_dir(metadata_directory)
    dist_info.mkdir(parents=True, exist_ok=True)
    (dist_info / "METADATA").write_text(_metadata_text(), encoding="utf-8")
    (dist_info / "WHEEL").write_text(_wheel_text(_wheel_tag()), encoding="utf-8")
    return dist_info.name


def get_requires_for_build_wheel(config_settings=None):
    return []


def get_requires_for_build_editable(config_settings=None):
    return []


def _build_wheel_file(wheel_directory):
    tag = _wheel_tag()
    wheel_name = f"{_normalize_dist_info_name(NAME)}-{VERSION}-{tag}.whl"
    wheel_path = pathlib.Path(wheel_directory) / wheel_name
    dist_info_name = f"{_normalize_dist_info_name(NAME)}-{VERSION}.dist-info"

    with tempfile.TemporaryDirectory() as tmp:
        tmp_path = pathlib.Path(tmp)
        layout = _build_layout(tmp_path / "wheel")
        dist_info = layout / dist_info_name
        dist_info.mkdir(parents=True, exist_ok=True)

        metadata = _metadata_text().encode("utf-8")
        wheel = _wheel_text(tag).encode("utf-8")
        (dist_info / "METADATA").write_bytes(metadata)
        (dist_info / "WHEEL").write_bytes(wheel)

        records = []
        files = [layout / "pbf.py", next(layout.glob("_pbf*.so")), dist_info / "METADATA", dist_info / "WHEEL"]
        for path in files:
            rel = path.relative_to(layout).as_posix()
            records.append(_record_line(rel, path.read_bytes()))

        record_rel = f"{dist_info_name}/RECORD"
        with (dist_info / "RECORD").open("w", encoding="utf-8", newline="") as fp:
            writer = csv.writer(fp)
            writer.writerows(records)
            writer.writerow((record_rel, "", ""))

        with zipfile.ZipFile(wheel_path, "w", compression=zipfile.ZIP_DEFLATED) as zf:
            for path in [layout / "pbf.py", next(layout.glob("_pbf*.so")), dist_info / "METADATA",
                         dist_info / "WHEEL", dist_info / "RECORD"]:
                zf.write(path, path.relative_to(layout).as_posix())

    return wheel_name


def build_wheel(wheel_directory, config_settings=None, metadata_directory=None):
    pathlib.Path(wheel_directory).mkdir(parents=True, exist_ok=True)
    return _build_wheel_file(wheel_directory)


def build_editable(wheel_directory, config_settings=None, metadata_directory=None):
    return build_wheel(wheel_directory, config_settings, metadata_directory)


def build_inplace():
    ext_path = _compile_extension(ROOT)
    return ext_path
