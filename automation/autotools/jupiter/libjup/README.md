# How this _Makefile.am_ works

The provided `Makefile.am` instructions define how to build a shared library named `libjupiter.la`. Here's a breakdown of each line:

1. `lib_LTLIBRARIES = libjupiter.la`
- **Purpose**: This line indicates that a shared library named `libjupiter.la` will be built.
- **`lib_LTLIBRARIES`**: This variable specifies libraries that should be built as Libtool shared libraries (indicated by the `.la` extension). These libraries can be linked with other programs and libraries.

2. `libjupiter_la_SOURCES = jup_print.c`
- **Purpose**: This line specifies the source files used to create the `libjupiter.la` library.
- **`libjupiter_la_SOURCES`**: This variable lists the source files that are compiled to create the `libjupiter` library.
- **Source File**: 
  - `jup_print.c`: This C source file contains the implementation for the functions that will be included in the `libjupiter` library.

3. `libjupiter_la_CPPFLAGS = -I$(top_srcdir)/include -I$(top_srcdir)/common`
- **Purpose**: This line specifies additional flags to be used when compiling the source files for the library.
- **`libjupiter_la_CPPFLAGS`**: This variable sets the C preprocessor flags for the library's compilation.
- **Flags**:
  - `-I$(top_srcdir)/include`: This tells the compiler to look for header files in the `include` directory located in the top source directory.
  - `-I$(top_srcdir)/common`: This tells the compiler to look for header files in the `common` directory located in the top source directory.
- The `$(top_srcdir)` variable expands to the top-level source directory of the project, ensuring the paths are correct regardless of where the build is executed.

4. `libjupiter_la_LIBADD = ../common/libjupcommon.la`
- **Purpose**: This line specifies additional libraries to link against when building the `libjupiter` library.
- **`libjupiter_la_LIBADD`**: This variable lists other libraries that should be linked with `libjupiter`.
- **Library Reference**:
  - `../common/libjupcommon.la`: This indicates that `libjupiter` will depend on the `libjupcommon` library located in the `common` directory one level up from the current directory. This is a shared library that will be linked at compile time, allowing `libjupiter` to use the functionality provided by `libjupcommon`.

## Summary

In summary, these instructions specify the creation of a shared library `libjupiter.la` from the source file `jup_print.c`, with additional include paths for headers and a dependency on the `libjupcommon` library from the common directory. This setup ensures that the library is compiled correctly and can access required header files and other libraries during the linking process.