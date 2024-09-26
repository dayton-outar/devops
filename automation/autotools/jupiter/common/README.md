# How this _Makefile.am_ works

Here’s a breakdown of what each line does:

1. `noinst_LTLIBRARIES = libjupcommon.la`
- **Purpose**: This line specifies that a shared library named `libjupcommon.la` will be built, but it will not be installed in the system directories.
- **`noinst_LTLIBRARIES`**: This variable indicates that the library is for internal use only (not intended for installation). It won't be available for other projects or users outside of the current build environment.
- **`libjupcommon.la`**: This is the name of the library file that will be created. The `.la` extension indicates it's a Libtool archive, which is often used to represent shared libraries.

2. `libjupcommon_la_SOURCES = jupcommon.h print.c`
- **Purpose**: This line specifies the source files used to build the `libjupcommon.la` library.
- **`libjupcommon_la_SOURCES`**: This variable lists the source files associated with the `libjupcommon` library.
- **Source Files**:
  - `jupcommon.h`: This is a header file containing declarations and definitions that can be shared across multiple source files.
  - `print.c`: This is a C source file that likely implements some functionality for the library.

3. `check_PROGRAMS = test_print`
- **Purpose**: This line indicates that a program named `test_print` will be built as part of the test suite for the project.
- **`check_PROGRAMS`**: This variable specifies programs that should be built for testing purposes, typically used in conjunction with the `make check` command.
  
4. `test_print_SOURCES = test_print.c`
- **Purpose**: This line specifies the source file used to create the `test_print` program.
- **`test_print_SOURCES`**: This variable lists the source files for the `test_print` program.
- **Source File**:
  - `test_print.c`: This is the C source file that likely contains test code to verify the functionality of the `libjupcommon` library.

## Summary

- The `Makefile.am` defines:
  - A non-installable shared library `libjupcommon.la` built from `jupcommon.h` and `print.c`.
  - A test program `test_print` built from `test_print.c`, used to perform checks on the library.
  
When you run `make`, it will compile `print.c` into the `libjupcommon.la` library and `test_print.c` into the `test_print` executable, allowing you to use the library internally and test its functionality.