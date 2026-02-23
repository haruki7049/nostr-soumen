#!/usr/bin/env python3

import os
from SCons.Script import Environment, Exit

env = Environment()


# Add OS's PKG_CONFIG_PATH to env
if "PKG_CONFIG_PATH" in os.environ:
    env["ENV"]["PKG_CONFIG_PATH"] = os.environ["PKG_CONFIG_PATH"]


# Add thirdparty libraries' paths using pkg-config to env
if env.WhereIs("pkg-config"):
    env.ParseConfig("pkg-config CLI11 --cflags --libs")
else:
    print("The pkg-config program not found")
    Exit(1)


# Compile the cpp files in src dir
env.SConscript("./src/SConscript", variant_dir="build", exports="env")
