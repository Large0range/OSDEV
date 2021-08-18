PREFIX=${HOME}/opt/cross
TARGET=x86_64-elf

install: dependencies build

build: binutils-2.28.1.tar.gz gcc-9.3.0.tar.gz
	tar -xf binutils-2.28.1.tar.gz
	tar -xf gcc-9.3.0.tar.gz

	mkdir build-binutils
	cd build-binutils && ../binutils-2.28.1/configure --target=$(TARGET) --prefix="$(PREFIX)" --with-sysroot --disable-nls --disable-werror
	cd build-binutils && make
	cd build-binutils && make install

	mkdir build-gcc
	cd build-gcc && ../gcc-9.3.0/configure --target=$(TARGET) --prefix="$(PREFIX)" --disable-nls --enable-languages=c,c++ --without-headers
	cd build-gcc && make all-gcc
	cd build-gcc && make all-target-libgcc
	cd build-gcc && make install-gcc
	cd build-gcc && make install-target-libgcc

dependencies:
	sudo apt install -y build-essential
	sudo apt install -y bison
	sudo apt install -y flex
	sudo apt install -y libgmp3-dev
	sudo apt install -y libmpc-dev
	sudo apt install -y libmpfr-dev
	sudo apt install -y texinfo

binutils-2.28.1.tar.gz:
	wget https://ftp.gnu.org/gnu/binutils/binutils-2.28.1.tar.gz

gcc-9.3.0.tar.gz:
	wget http://mirrors.concertpass.com/gcc/releases/gcc-9.3.0/gcc-9.3.0.tar.gz
