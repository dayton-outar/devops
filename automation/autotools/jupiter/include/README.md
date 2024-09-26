# How this _Makefile.am_ works

In the provided child directory `Makefile.am`, the line:

```makefile
include_HEADERS = libjupiter.h
```

## Explanation of Behavior

1. **Library Definition**:
   - The child `Makefile.am` does not explicitly define any libraries to be built (e.g., no `lib_LTLIBRARIES` or `lib_LIBRARIES` definitions). Instead, it only specifies a header file, `libjupiter.h`, which is intended to be included in other source files.

2. **Header File Installation**:
   - The `include_HEADERS` variable tells Automake that `libjupiter.h` should be installed in the system's standard include directory (typically `/usr/local/include` or similar) when you run `make install`. This allows other programs to include this header file.

3. **No Library Built**:
   - Since there are no instructions to build a library in the child `Makefile.am`, no shared or static library will be created in this directory. It’s purely a header file directory.

## Interaction with Parent Directory

- **Parent `Makefile.am` Context**:
  - The parent `Makefile.am` defines subdirectories using `SUBDIRS = common include libjup src tests`. Since the `include` directory contains the child `Makefile.am`, the build process initiated by the parent `Makefile.am` will include the header file installation process specified in the child.

4. **Installation**:
   - When you run `make install` from the root directory of the project:
     - The header file `libjupiter.h` will be copied to the appropriate include directory (e.g., `/usr/local/include/libjupiter.h`), but no library will be installed from this child directory.
     - The project as a whole will include any libraries defined in the `libjup` directory (if present) or any other subdirectories that are included in the build.

### Header File Inclusion

1. **Using `#include <libjupiter.h>`**:
   - When a header file is installed in the system's standard include directory (e.g., `/usr/local/include`), you can include it in your C files using angle brackets, like so:
     ```c
     #include <libjupiter.h>
     ```
   - This syntax is used for system or library headers, allowing the compiler to search for the file in the standard system include directories.

2. **Using `#include "libjupiter.h"`**:
   - If you include the header file using quotes:
     ```c
     #include "libjupiter.h"
     ```
   - This tells the compiler to look for the header file in the current directory first, and if it doesn’t find it there, it will then look in the standard include directories.

After the header file `libjupiter.h` is installed in the system include path, it can be included using `#include <libjupiter.h>`. This is the preferred method for including installed headers, as it clarifies that the file is part of a library or external resource, rather than a local file.

## Summary
In summary, the child `Makefile.am` specifies that `libjupiter.h` will be installed as an include file, but no libraries will be built or installed from this directory. It relies on the parent `Makefile.am` to manage the overall build process, including any libraries defined elsewhere in the project structure.