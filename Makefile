install: dependencies build

build:
	tar -xf binutils-2.28.1.tar.gz
	tar -xf gcc-9.3.0-tar.gz

	export PREFIX="$HOME/opt/cross-test"
	export TARGET=i686-elf
	export PATH="$PREFIX/bin:$PATH"

	mkdir build-binutils
	cd build-binutils
	../binutils-2.28.1/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
	make
	make install

	cd ..

	mkdir build-gcc
	cd build-gcc
	../gcc-9.3.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
	make all-gcc
	make all-target-libgcc
	make install-gcc
	make install-target-libgcc

dependencies:
	sudo apt install -y build-essential
	sudo apt install -y bison
	sudo apt install -y flex
	sudo apt install -y libgmp3-dev
	sudo apt install -y libmpc-dev
	sudo apt install -y libmpfr-dev
	sudo apt install -y texinfo
