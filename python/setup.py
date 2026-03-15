#!/usr/bin/env python3

import pathlib
import shutil
import sys

import build_backend


def main(argv):
    if argv == ["build_ext", "--inplace"]:
        ext_path = build_backend.build_inplace()
        print(ext_path)
        return 0

    if argv == ["bdist_wheel"]:
        dist_dir = pathlib.Path(__file__).resolve().parent / "dist"
        dist_dir.mkdir(exist_ok=True)
        wheel_name = build_backend.build_wheel(str(dist_dir))
        print(dist_dir / wheel_name)
        return 0

    if argv == ["clean"]:
        root = pathlib.Path(__file__).resolve().parent
        for path in root.glob("_pbf*.so"):
            path.unlink()
        shutil.rmtree(root / "dist", ignore_errors=True)
        shutil.rmtree(root / "__pycache__", ignore_errors=True)
        return 0

    sys.stderr.write("supported commands: build_ext --inplace | bdist_wheel | clean\n")
    return 1


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
