# Jupiter: Automake Example

This folder contains material from the Jupiter project source code repository for the No Starch Press book, Autotools, 2nd Edition. The book would delve into various components of the Autotools suite, which includes **Autoconf**, **Automake**, **Libtool**, and related utilities.

## File Structure

- `common`: contains a library header and implementation
- `include`: contains a header
- `libjup`: contains an implementation
- `src`: contains source for executable
- `test`: contains an Autotest example
- `configure.ac`: Configuration for this project
- `Makefile.am`: Automake that makes reference to recursively build projects containing header files and implementations

## How the Autoconf works in Jupiter

This `configure.ac` file is the core input to Autoconf for generating a `configure` script. It contains macros and instructions that define how to check for dependencies, set up build configurations, and create the appropriate files for a project. Let's break down each section to understand its role:

### 1. **Header Comments**
   ```bash
   #                                               -*- Autoconf -*-
   # Process this file with autoconf to produce a configure script.
   ```
   - These are just comments indicating that this file should be processed by `autoconf` to generate a `configure` script.

### 2. **Basic Configuration Setup**
   ```bash
   AC_PREREQ([2.69])
   AC_INIT([Jupiter], [1.0], [jupiter-bugs@example.org])
   AM_INIT_AUTOMAKE
   ```
   - **`AC_PREREQ([2.69])`**: Specifies the minimum required version of Autoconf, which is 2.69.
   - **`AC_INIT([Jupiter], [1.0], [jupiter-bugs@example.org])`**: Initializes the project with the name `Jupiter`, version `1.0`, and sets an email for bug reports (`jupiter-bugs@example.org`).
   - **`AM_INIT_AUTOMAKE`**: Initializes Automake, which will help generate `Makefile.in` templates.

### 3. **Libtool Setup**
   ```bash
   LT_PREREQ([2.4.6])
   LT_INIT([dlopen])
   ```
   - **`LT_PREREQ([2.4.6])`**: Sets the minimum required version of Libtool to 2.4.6.
   - **`LT_INIT([dlopen])`**: Initializes Libtool for dynamic loading (dlopen) support. This is used to load shared libraries at runtime.

### 4. **Source and Configuration Files**
   ```bash
   AC_CONFIG_SRCDIR([src/main.c])
   AC_CONFIG_HEADERS([config.h])
   ```
   - **`AC_CONFIG_SRCDIR([src/main.c])`**: Checks if the file `src/main.c` exists to verify that we are in the correct source directory.
   - **`AC_CONFIG_HEADERS([config.h])`**: Tells Autoconf to generate a `config.h` header file containing macro definitions based on the configuration.

### 5. **Test and Makefile Configuration Files**
   ```bash
   AC_CONFIG_TESTDIR([tests])
   AC_CONFIG_FILES([tests/Makefile
                    tests/atlocal])
   ```
   - **`AC_CONFIG_TESTDIR([tests])`**: Specifies the directory where tests are located.
   - **`AC_CONFIG_FILES([...])`**: Specifies which files Autoconf should generate. This includes the `Makefile` for tests and other configuration files.

### 6. **Program Checks**
   ```bash
   AC_PROG_CC
   AC_PROG_INSTALL
   ```
   - **`AC_PROG_CC`**: Checks for an appropriate C compiler.
   - **`AC_PROG_INSTALL`**: Checks for the `install` program, which is used to copy files during installation.

### 7. **Header Checks**
   ```bash
   AC_CHECK_HEADERS([stdlib.h ltdl.h])
   ```
   - **`AC_CHECK_HEADERS([...])`**: Checks for the existence of the header files `stdlib.h` (standard C library) and `ltdl.h` (Libtool's dynamic loading header). If they are found, they will be used in the project.

### 8. **Command-Line Option Handling**
   ```bash
   AC_ARG_ENABLE([async-exec],
       [AS_HELP_STRING([--disable-async-exec],
           [disable asynchronous execution @<:@default: no@:>@])],
       [async_exec=${enableval}], [async_exec=yes])
   ```
   - **`AC_ARG_ENABLE([...])`**: Defines a command-line option `--disable-async-exec` that allows users to disable asynchronous execution. By default, asynchronous execution is enabled (`async_exec=yes`), but users can override this during configuration.

   Step 8, which handles the disabling of asynchronous execution, is needed because not all systems or environments support multi-threading (typically enabled through the POSIX threads, or `pthreads` library). Asynchronous execution often relies on threading to run multiple tasks concurrently, and if the system does not support threads, the program would need to fall back to a simpler, single-threaded execution model to avoid compilation errors or runtime issues.

   Here’s why this step is important:

   1. **Portability**
      - **Different platforms**: Not all platforms provide support for `pthreads` or threading libraries in general. By allowing asynchronous execution to be disabled, the project can still be built and run on systems where threading is not available.
      - **Cross-compilation**: In some cases, you might be cross-compiling your software for a platform that does not have `pthread` support, so having an option to disable threading ensures that the project remains portable.

   2. **System Constraints**
      - **Embedded systems**: Some systems, such as embedded devices, may not have the resources to support multi-threading or may not include the necessary libraries. By disabling asynchronous execution, the software can still be used on such constrained systems in a simpler, single-threaded mode.
      - **Older or minimalist systems**: Some older or very minimal Unix-like systems may not provide `pthread` support, so having the option to disable it ensures broader compatibility.

   3. **Optional Feature Control**
      - **User preference**: Some users might not want asynchronous execution even if threading support is available. For example, they may prioritize deterministic, single-threaded execution due to debugging concerns or to avoid the complexity and potential race conditions that come with multi-threaded code.
      - **Performance concerns**: In some cases, threading may introduce overhead that could negatively impact performance, especially on systems with limited CPU cores. Users may opt to disable it to avoid this overhead.

   4. **Graceful Fallback**
      - If the system lacks `pthread` support, the project needs a **graceful fallback** to single-threaded execution. Step 8 ensures that if threading isn't supported, the configuration process automatically switches to a single-threaded mode and continues without failure. This avoids the build process stopping due to missing libraries or headers (`pthread_create` or `pthread.h`).

   5. **Compilation Failures**
      - **Missing headers or libraries**: If the system does not provide the `pthread.h` header or the `pthread` library, the code would not compile properly if it relies on threading. The checks in Step 8 ensure that, if these are missing, the build system disables threading support before compilation starts, preventing failures.

   Step 8 is necessary for:
    - Ensuring the **portability** of the code to different systems.
    - Allowing users to control whether or not asynchronous (multi-threaded) execution is enabled, based on **system constraints** or **user preference**.
    - Providing a **graceful fallback** to single-threaded execution when threading support (via `pthread`) is not available, avoiding compilation failures.

   By adding these checks, the `configure.ac` script ensures that the project can be built and run on a wide range of systems, with or without multi-threading support.

### 9. **Asynchronous Execution Check and Pthread Detection**
   ```bash
   if test "x${async_exec}" = xyes; then
       have_pthreads=no
       AC_SEARCH_LIBS([pthread_create], [pthread], [have_pthreads=yes])

       if test "x${have_pthreads}" = xyes; then
           AC_CHECK_HEADERS([pthread.h], [], [have_pthreads=no])
       fi

       if test "x${have_pthreads}" = xno; then
           AC_MSG_WARN([
   ------------------------------------------
   Unable to find pthreads on this system.
   Building a single-threaded version.
   ------------------------------------------])
           async_exec=no
       fi
   fi
   ```
   - This block checks if asynchronous execution is enabled (`async_exec=yes`). If so, it tries to find the `pthread_create` function in the `pthread` library to verify that threading is supported.
   - If the `pthread_create` function or `pthread.h` header file is not found, it disables asynchronous execution and prints a warning, building a single-threaded version instead.

### 10. **Setting Configuration Variables**
   ```bash
   AC_SUBST([async_exec])
   if test "x${async_exec}" = xyes; then
       AC_DEFINE([ASYNC_EXEC], [1], [async execution enabled])
   fi
   ```
   - **`AC_SUBST([async_exec])`**: Substitutes the value of `async_exec` into relevant output files, such as Makefiles.
   - **`AC_DEFINE([ASYNC_EXEC], [1], [async execution enabled])`**: Defines a preprocessor macro `ASYNC_EXEC` if asynchronous execution is enabled.

### 11. **Library Check**
   ```bash
   AC_SEARCH_LIBS([lt_dlopen], [ltdl])
   ```
   - **`AC_SEARCH_LIBS([lt_dlopen], [ltdl])`**: Searches for the `lt_dlopen` function in the `ltdl` library (Libtool’s dynamic loader) to ensure dynamic loading support is available.

### 12. **Makefile Setup**
   ```bash
   AC_CONFIG_FILES([Makefile
                    common/Makefile
                    include/Makefile
                    libjup/Makefile
                    src/Makefile
                    src/modules/hithere/Makefile])
   AC_OUTPUT
   ```
   - **`AC_CONFIG_FILES([...])`**: Specifies the various `Makefile` files that need to be generated. These files cover the main project directory (`Makefile`), common files, include directory, libraries (`libjup`), source code (`src`), and a module (`hithere`).

   - **`AC_OUTPUT`**: Instructs Autoconf to generate the files specified above.

### 13. **Final Output Message**
   ```bash
   cat << EOF
   -------------------------------------------------

   ${PACKAGE_NAME} Version ${PACKAGE_VERSION}

   Prefix: '${prefix}'.
   Compiler: '${CC} ${CFLAGS} ${CPPFLAGS}'
   Libraries: '${LIBS}'

   Package features:
     Async Execution: ${async_exec}

     Now type 'make @<:@<target>@:>@'
       where the optional <target> is:
         all                - build all binaries
         install            - install everything

   --------------------------------------------------
   EOF
   ```
   - This `cat` command outputs a summary of the project configuration, including the project name and version, compiler details, linked libraries, and whether asynchronous execution is enabled.
   - It provides instructions for building and installing the software.

   You can write shell scripts within `configure.ac` because Autoconf generates a shell script (`configure`). This means you can use standard shell constructs like `if`, `for`, and variable assignments. Shell scripting can be combined with Autoconf macros to dynamically adjust the configuration process. For example, you can check for libraries, headers, or custom options, and use shell logic to set variables or flags based on the system's environment. This flexibility allows `configure.ac` to adapt to different platforms and build requirements.

### **Summary**

This `configure.ac` file sets up the build configuration for the `Jupiter` project. It checks for necessary tools (like the C compiler), libraries (like `pthread` and `ltdl`), and allows optional asynchronous execution using threading (via `pthread`). Based on these checks, it configures the build system to generate the appropriate `Makefile`s and outputs instructions on how to proceed with building the project.

### Addendum

#### Add Macro Directory

In your `configure.ac`, the `AC_CONFIG_MACRO_DIRS([m4])` command should be placed **before any macros or commands that rely on macros located in the `m4` directory**, typically early in the file, after `AC_INIT` but before the `AM_INIT_AUTOMAKE`.

Here's where you should place it in the context of your `configure.ac`:

```bash
AC_PREREQ([2.69])
AC_INIT([Jupiter], [1.0], [jupiter-bugs@example.org])

# Specify the directory for custom macros
AC_CONFIG_MACRO_DIRS([m4])

AM_INIT_AUTOMAKE
LT_PREREQ([2.4.6])
LT_INIT([dlopen])

AC_CONFIG_SRCDIR([src/main.c])
AC_CONFIG_HEADERS([config.h])
```

##### Why at this point?
- `AC_CONFIG_MACRO_DIRS([m4])` tells Autoconf to look for additional macros in the `m4` directory.
- It needs to be declared early, before `AM_INIT_AUTOMAKE` and other macros that might depend on custom or external macros stored in `m4`.
  
This ensures that if there are any macro definitions in `m4`, they will be properly located and processed before `automake` or `libtool` macros are invoked.

##### Warnings
The warning `aclocal: warning: couldn't open directory 'm4': No such file or directory` occurs because `aclocal` is trying to search for the `m4` directory, but it doesn't exist. To resolve this issue, you need to create the `m4` directory manually.

Here’s how to fix it:

1. **Create the `m4` directory**:
   ```bash
   mkdir m4
   ```

2. **Rerun `autoreconf -i`** to regenerate the configuration files:
   ```bash
   autoreconf -i
   ```

Even if you don’t currently have any custom macros to place in the `m4` directory, creating it satisfies `aclocal` and prevents the warning.

Simply create the `m4` directory to eliminate the warning:
```bash
mkdir m4
```

#### Avoid Missing Release Documents

To exclude `AUTHORS`, `NEWS`, and `ChangeLog` from being required by `automake`, you can modify the `Makefile.am` file by telling `automake` not to expect these files. You can do this by overriding the `dist` targets for these files. Here’s how to do it:

```makefile
# Do not include AUTHORS, NEWS, or ChangeLog in the distribution
DIST_SUBDIRS = $(SUBDIRS)
EXTRA_DIST =

# Prevent automake from looking for these files
MAINTAINERCLEANFILES = ChangeLog NEWS AUTHORS
```

This setup tells `automake` that these files are not necessary for the build process, and it will skip checking for them. The `MAINTAINERCLEANFILES` variable prevents `automake` from requiring those files during the build.

This will avoid errors while still keeping `automake` satisfied.

#### Remove Files Generated by `autoreconf`

```bash
rm -rf autom4te.cache
rm -rf m4
rm -f aclocal.m4 configure config.h.in config.status config.log
rm -f Makefile.in
rm -f ltmain.sh
rm -f install-sh missing depcomp
rm -f compile config.sub config.guess
```

#### Generate `config.h`

See below what the generated `config.h` looks like,

```c
/* config.h.  Generated from config.h.in by configure.  */
/* config.h.in.  Generated from configure.ac by autoheader.  */

/* async execution enabled */
#define ASYNC_EXEC 1

/* Define to 1 if you have the <dlfcn.h> header file. */
#define HAVE_DLFCN_H 1

/* Define to 1 if you have the <inttypes.h> header file. */
#define HAVE_INTTYPES_H 1

/* Define to 1 if you have the <ltdl.h> header file. */
#define HAVE_LTDL_H 1

/* Define to 1 if you have the <pthread.h> header file. */
#define HAVE_PTHREAD_H 1

/* Define to 1 if you have the <stdint.h> header file. */
#define HAVE_STDINT_H 1

/* Define to 1 if you have the <stdio.h> header file. */
#define HAVE_STDIO_H 1

/* Define to 1 if you have the <stdlib.h> header file. */
#define HAVE_STDLIB_H 1

/* Define to 1 if you have the <strings.h> header file. */
#define HAVE_STRINGS_H 1

/* Define to 1 if you have the <string.h> header file. */
#define HAVE_STRING_H 1

/* Define to 1 if you have the <sys/stat.h> header file. */
#define HAVE_SYS_STAT_H 1

/* Define to 1 if you have the <sys/types.h> header file. */
#define HAVE_SYS_TYPES_H 1

/* Define to 1 if you have the <unistd.h> header file. */
#define HAVE_UNISTD_H 1

/* Define to the sub-directory where libtool stores uninstalled libraries. */
#define LT_OBJDIR ".libs/"

/* Name of package */
#define PACKAGE "jupiter"

/* Define to the address where bug reports for this package should be sent. */
#define PACKAGE_BUGREPORT "jupiter-bugs@example.org"

/* Define to the full name of this package. */
#define PACKAGE_NAME "Jupiter"

/* Define to the full name and version of this package. */
#define PACKAGE_STRING "Jupiter 1.0"

/* Define to the one symbol short name of this package. */
#define PACKAGE_TARNAME "jupiter"

/* Define to the home page for this package. */
#define PACKAGE_URL ""

/* Define to the version of this package. */
#define PACKAGE_VERSION "1.0"

/* Define to 1 if all of the C90 standard headers exist (not just the ones
   required in a freestanding environment). This macro is provided for
   backward compatibility; new code need not use it. */
#define STDC_HEADERS 1

/* Version number of package */
#define VERSION "1.0"
```