# How this _Makefile.am_ works

This `Makefile.am` snippet is used in the context of an Automake-based build system to describe how to build a dynamic module called `hithere.la`. Let's break it down:

```
pkglib_LTLIBRARIES = hithere.la
hithere_la_SOURCES = hithere.c
hithere_la_LDFLAGS = -module -avoid-version
```

1. **`pkglib_LTLIBRARIES = hithere.la`**
- **Explanation**: This line specifies that the build target is a library called `hithere.la`, and it will be installed in the `pkglibdir` directory (a standard directory for installing architecture-independent libraries specific to a package).
  
- **`pkglib_LTLIBRARIES`**:
  - **`pkglib`**: Refers to a directory that is specific to the package. The actual location is determined during configuration, but it typically resides in a special package library folder.
  - **`LTLIBRARIES`**: This variable tells Automake that the target is a Libtool library (in this case, `hithere.la`), which means it will use Libtool to handle the dynamic loading aspects and platform-specific details for creating shared libraries or modules.
  
  **`.la`** files are Libtool's control files for shared libraries or modules, containing metadata about how the actual library or module (`.so`, `.dylib`, etc.) was built.

2. **`hithere_la_SOURCES = hithere.c`**
- **Explanation**: This line indicates that the source code for `hithere.la` is located in `hithere.c`. Automake will compile this C file into an object file (`hithere.o`) and use it to create the final library (`hithere.la`).

  - **`hithere_la_SOURCES`**:
    - `hithere_la`: Refers to the target (the `hithere.la` library).
    - `SOURCES`: Lists the source files required to build the target.
  
  In this case, only one source file, `hithere.c`, is needed to build the `hithere.la` module.

3. **`hithere_la_LDFLAGS = -module -avoid-version`**
- **Explanation**: This line defines the linker flags (`LDFLAGS`) used when creating the `hithere.la` library.

  - **`hithere_la_LDFLAGS`**:
    - `LDFLAGS`: Specifies flags passed to the linker when the `hithere.la` module is being linked.
  
  **Flags**:
  - `-module`: This tells Libtool that the output is a dynamically loadable module (as opposed to a shared library). Modules are typically used for plugins or dynamically loaded functionality, as in this case with `hithere.la`.
  - `-avoid-version`: This flag prevents versioning of the module. Normally, shared libraries might have version numbers (like `.so.1.0.0`), but for modules, versioning is typically unnecessary, so this flag tells Libtool to avoid attaching version numbers to the file.

## Summary
- **`pkglib_LTLIBRARIES = hithere.la`**: Instructs Automake to build and install a Libtool module named `hithere.la` in the package-specific library directory.
- **`hithere_la_SOURCES = hithere.c`**: Specifies that `hithere.c` is the source file used to build the `hithere.la` module.
- **`hithere_la_LDFLAGS = -module -avoid-version`**: Instructs the linker to treat `hithere.la` as a loadable module (not a shared library) and to avoid attaching a version number to it.

This setup is typically used in a plugin system where modules are loaded dynamically at runtime.