# STM32_Static_Lib

STM32 F3 Code as Static Library

This project is not maintained to have the latest version of all the code from ST Micro. It instead is just a framework project for how to build ST code as a static library. To update the code simply copy files from ST to the appropriate sub-folders. Secondly this only includes code for the F3 series products. By default it builds for F303RxE devices. To build for other F3 series devices see CMSIS/CMakeLists.txt for the list of ST devices.

# Building the Project

{BUILD_TYPE} :

 - RELEASE
 - DEBUG
    
```

mkdir -p build/${BUILD_TYPE}

cd build/${BUILD_TYPE}

cmake -DCMAKE_TOOLCHAIN_FILE=../../arm-none-eabi-gcc.cmake -DCMAKE_BUILD_TYPE=${BUILD_TYPE} ../../

cmake --build . -- -j 4

```