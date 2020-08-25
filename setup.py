#!/usr/bin/env python
# -*- encoding: utf-8 -*-
# adapted from : https://blog.ionelmc.ro/2014/05/25/python-packaging

from __future__ import absolute_import
from __future__ import print_function

import io
import re
from glob import glob
from os.path import basename
from os.path import dirname
from os.path import join
from os.path import splitext

from setuptools import find_packages
from setuptools import setup


setup(
    name="coco",
    version="0.1a1",
    license="Expat",
    author="Peter Tonner",
    # author_email="",
    long_description="Blur the lines between code and configuration with hy-lang.",
    description="Code is config (is code).",
    url="https://github.com/ptonner/coco",
    packages=find_packages("src"),
    package_dir={"": "src"},
    package_data={"coco": ["*.hy"]},
    py_modules=[splitext(basename(path))[0] for path in glob("src/*.py")],
    include_package_data=True,
    zip_safe=False,
    classifiers=[
        # complete classifier list: http://pypi.python.org/pypi?%3Aaction=list_classifiers
        "Development Status :: 2 - Pre-Alpha",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: MIT License",
        "License :: DFSG approved",
        "Operating System :: OS Independent",
        "Programming Language :: Lisp",
        "Programming Language :: Python",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.5",
        "Programming Language :: Python :: 3.6",
        "Programming Language :: Python :: 3.7",
        "Programming Language :: Python :: 3.8",
        "Topic :: Software Development :: Code Generators",
        "Topic :: Software Development :: Libraries",
        "Topic :: Utilities",
    ],
    keywords=[
        # eg: 'keyword1', 'keyword2', 'keyword3',
    ],
    python_requires="!=3.0.*, !=3.1.*, !=3.2.*, !=3.3.*, !=3.4.*",
    install_requires=["hy"],
    # setup_requires=["pytest-runner",],
    entry_points={"console_scripts": ["coco = coco.run:main",]},
)
