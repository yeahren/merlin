#!/bin/bash

set -e

current_working_dir=$(pwd)
tools_dir=${current_working_dir}/$(dirname $0)
cd $tools_dir

echo "Get htk with HDecode from github.com/yeahren/htk"
rm -rf htk/
git clone https://github.com/yeahren/htk

## Download HTS patch:
HTS_PATCH_URL=http://hts.sp.nitech.ac.jp/archives/2.3alpha/HTS-2.3alpha_for_HTK-3.4.1.tar.bz2
tar xf HTS-2.3alpha_for_HTK-3.4.1.tar.bz2

# apply HTS patch
cd htk
patch -p1 -d . < ../HTS-2.3alpha_for_HTK-3.4.1.patch

echo "compiling HTK..."
(
    ./configure --prefix=$PWD/build;
    make all;
    make install
)

HTK_BIN_DIR=$tools_dir/bin/htk

mkdir -p $tools_dir/bin
mkdir -p $HTK_BIN_DIR

cp $tools_dir/htk/build/bin/* $HTK_BIN_DIR/

if [[ ! -f ${HTK_BIN_DIR}/HVite ]]; then
    echo "Error installing HTK tools"
    exit 1
else
    echo "HTK successfully installed...!"
fi

