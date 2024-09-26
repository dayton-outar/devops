# How this _Makefile.am_ works

Here’s a breakdown of the instructions in the provided `Makefile.am`:

```
SUBDIRS = modules/hithere

bin_PROGRAMS = jupiter
jupiter_SOURCES = main.c module.h
jupiter_CPPFLAGS = -I$(top_srcdir)/include
jupiter_LDADD = ../libjup/libjupiter.la -dlopen modules/hithere/hithere.la
```

1. `lib_LTLIBRARIES = libjupiter.la`
- **Definition**: This line specifies that a shared library named `libjupiter.la` will be created.
- **Explanation**: The variable `lib_LTLIBRARIES` is used by Automake to indicate which libraries should be built using Libtool (denoted by the `.la` extension). This library can be linked into other programs or libraries.

2. `libjupiter_la_SOURCES = jup_print.c`
- **Definition**: This line specifies the source files that will be compiled to create the `libjupiter.la` library.
- **Explanation**: The variable `libjupiter_la_SOURCES` lists the C source files associated with the `libjupiter` library. In this case, `jup_print.c` is the sole source file that will be compiled to produce the library.

3. `libjupiter_la_CPPFLAGS = -I$(top_srcdir)/include -I$(top_srcdir)/common`
- **Definition**: This line defines the preprocessor flags to be used when compiling the source files for the `libjupiter` library.
- **Explanation**: The variable `libjupiter_la_CPPFLAGS` sets the flags for the C preprocessor. The `-I` flag is used to specify additional directories where the compiler should look for header files:
  - `-I$(top_srcdir)/include`: This tells the compiler to include headers from the `include` directory located at the top level of the source directory.
  - `-I$(top_srcdir)/common`: This directs the compiler to also look for headers in the `common` directory at the top level of the source directory.
- **Note**: `$(top_srcdir)` is a variable that expands to the top source directory of the project, making it easier to reference paths regardless of where the build is initiated.

4. `libjupiter_la_LIBADD = ../common/libjupcommon.la`
- **Definition**: This line specifies additional libraries to link against when creating the `libjupiter` library.
- **Explanation**: The variable `libjupiter_la_LIBADD` lists other libraries that should be linked with `libjupiter`. 
  - `../common/libjupcommon.la`: This indicates that `libjupiter` will depend on the shared library `libjupcommon` found in the `common` directory, which is located one level up from the current directory.
- This means that when building `libjupiter.la`, it will link with `libjupcommon.la`, allowing `libjupiter` to utilize the functionality defined in `libjupcommon`.

## Summary

In summary, this `Makefile.am` outlines the configuration for building the shared library `libjupiter.la` from the source file `jup_print.c`, specifies include directories for headers, and defines a dependency on another library (`libjupcommon.la`). This setup ensures that `libjupiter` is compiled correctly and can link against necessary libraries for its functionality.