import os
from Cython.Build import cythonize # type: ignore
from setuptools import setup, Extension # type: ignore

os.makedirs("temp", exist_ok=True)

CFLAGS = ["-Os", "-flto", "-s"]

extensions = [
    Extension(
        "evalator",
        ["evaluator.py"],
        include_dirs=["/usr/include/python3.13"],
        extra_compile_args=CFLAGS,
        extra_link_args=CFLAGS + ["-s"],
    ),
    Extension(
        "parser", 
        ["parser.py"], 
        include_dirs=["/usr/include/python3.13"],
        extra_compile_args=CFLAGS,
        extra_link_args=CFLAGS + ["-s"]
    ),
    Extension(
        "lexer", 
        ["lexer.py"], 
        include_dirs=["/usr/include/python3.13"],
        extra_compile_args=CFLAGS,
        extra_link_args=CFLAGS + ["-s"]
    ),
]

setup(
    name="sigma",
    ext_modules=cythonize(
        extensions,
        build_dir="temp",
        compiler_directives={
            "language_level": "3",
            "boundscheck": False,
            "wraparound": False,
            "initializedcheck": False,
            "cdivision": True,
        },
    ),
    url="https://github.com/dimini171/sigma",
    download_url="https://github.com/dimini171/sigma/releases/latest",
    author="luna",
    author_email="luna@hackclub.app",
    maintainer="luna",
    maintainer_email="luna@hackclub.app"
)