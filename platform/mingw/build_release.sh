#!/bin/bash

dir=$(realpath .)
src_dir=$dir/modules/csound
build_dir=$src_dir/build/mingw/release
prefix=$dir/addons/csound/bin/windows/release

mkdir -p $build_dir
cd $build_dir

cmake -DCMAKE_TOOLCHAIN_FILE=$src_dir/vcpkg/scripts/buildsystems/vcpkg.cmake \
    -DVCPKG_CHAINLOAD_TOOLCHAIN_FILE=$src_dir/vcpkg/scripts/toolchains/mingw.cmake \
    -DCMAKE_MAKE_PROGRAM=gmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_VERBOSE_MAKEFILE=1 \
    -DCMAKE_INSTALL_PREFIX:PATH=$prefix \
    -DVCPKG_CMAKE_SYSTEM_NAME=Windows \
    -DCMAKE_SYSTEM_NAME=MinGW \
    -DVCPKG_TARGET_ARCHITECTURE=x64 \
    -DVCPKG_TARGET_TRIPLET=x64-mingw-static \
    -DVCPKG_DEFAULT_TRIPLET=x64-mingw-static \
    -DCMAKE_CXX_COMPILER=/usr/bin/x86_64-w64-mingw32-g++ \
    -DCMAKE_C_COMPILER=/usr/bin/x86_64-w64-mingw32-gcc \
    -DUSE_VCPKG=1 \
    -DBUILD_JAVA_INTERFACE=OFF \
    -DINSTALL_PYTHON_INTERFACE=OFF \
    -DBUILD_UTILITIES=OFF \
    -DBUILD_TESTS=OFF \
    -DCMAKE_SYSROOT=/usr/x86_64-w64-mingw32 \
    $src_dir

make
make install

cp $build_dir/csound64.dll $prefix/lib/
cp $prefix/lib/libcsound64.dll.a $prefix/lib/libcsound64.a
cp /usr/lib/gcc/x86_64-w64-mingw32/10-posix/libstdc++-6.dll $prefix/lib/
cp /usr/lib/gcc/x86_64-w64-mingw32/10-posix/libgcc_s_seh-1.dll $prefix/lib/
cp /usr/x86_64-w64-mingw32/lib/libwinpthread-1.dll $prefix/lib/

cd $dir
scons platform=windows target=template_release
