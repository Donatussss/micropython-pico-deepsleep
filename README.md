# Porting pico deepsleep (picosleep) to micropython

Hi, so in this repo you'll find material and instructions on how to port the ~1.3mA picosleep to micropython  
A good detail of the sleep and the actual C source was obtained from thee excelent [ghubcoder](https://ghubcoder.github.io/posts/deep-sleeping-the-pico-micropython/)'s site  
It being a bit outdated with respect to the micropython repo I thought I'd issue guidance on people interested in this venture  
To port picosleep to micropython here I've had to build micropython from source, without actually 'interfering' with the source by adding the picosleep implementation as an [external c module](https://docs.micropython.org/en/latest/develop/cmodules.html)  

## Getting required source
I used wsl in my case for building  
Clone micropython and fetch its submodules as follows

```bash
$ mkdir pico
$ cd pico
$ git clone https://github.com/micropython/micropython.git --branch master
$ cd micropython
$ make -C ports/rp2 submodules
```

Copy over the rp2 directory to a new directory say rp2_custom to make changes
```bash
$ cp -r ports/rp2 ports/rp2_custom
```

You can add the [pico-extras](https://github.com/raspberrypi/pico-extras) repo as a submodule or anywhere reachable in your system
In this case I added it as a submodule in the `lib` directory and the include_directories and target_sources commands in the resulting micropython.cmake file are with respect to this location
```bash
$ cd lib/
$ git submodule add https://github.com/raspberrypi/pico-extras
$ cd ..
```

You'll then have your tree as follows
```
micropython/  
└──examples/  
    └──usercmodule/  
        └──picosleep/  
            ├── picosleep.c  
            ├── micropython.mk  
            └── micropython.cmake
        └── micropython.cmake
```

The picosleep source was obtained from [ghubcoder's repo](https://github.com/ghubcoder/PicoSleepDemo/blob/master/main.c) upon which I added some minor changes

Perhaps you can 'interfere' with the source at least to rename the micropython you are building to distinguish it better by editing the [mpconfigport.h](https://github.com/micropython/micropython/blob/master/ports/rp2/mpconfigport.h) as follows

```c
#define MICROPY_HW_MCU_NAME                     "RP2040 (picosleep)"
```

Some of these commands are also in the [rasbperry-pi-pico-python-sdk](https://datasheets.raspberrypi.com/pico/raspberry-pi-pico-python-sdk.pdf)

```bash
$ sudo apt update
$ sudo apt install cmake gcc-arm-none-eabi libnewlib-arm-none-eabi build-essential
$ make -C mpy-cross
$ cd ports/rp2_custom
$ make USER_C_MODULES=../../examples/usercmodule/micropython.cmake
```

Note that the pico-extras source files have to be specified in the micropython.cmake file  
pico-sdk source files are recognised due to other cmake commands that I'd wish to point out but I only have little knowledge of cmake at the moment

If everything goes well you should see a `firmware.uf2` file in the `rp2_custom/build-RPI_PICO` folders