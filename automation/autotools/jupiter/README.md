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

   Reference is made to 5 sub-directories: _[common](./common/)_, _[include](./include/)_, _[libjup](./libjup/)_, _[src](./src/)_, and _[tests](./tests/)_. These directories contain further instructions in their _Makefile.am_

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

#### Output after performing `autoreconf -i`

```
libtoolize: putting auxiliary files in '.'.
libtoolize: copying file './ltmain.sh'
libtoolize: putting macros in AC_CONFIG_MACRO_DIRS, 'm4'.
libtoolize: copying file 'm4/libtool.m4'
libtoolize: copying file 'm4/ltoptions.m4'
libtoolize: copying file 'm4/ltsugar.m4'
libtoolize: copying file 'm4/ltversion.m4'
libtoolize: copying file 'm4/lt~obsolete.m4'
configure.ac:12: installing './compile'
configure.ac:12: installing './config.guess'
configure.ac:12: installing './config.sub'
configure.ac:10: installing './install-sh'
configure.ac:10: installing './missing'
Makefile.am: installing './INSTALL'
Makefile.am: installing './COPYING' using GNU General Public License v3 file
Makefile.am:     Consider adding the COPYING file to the version control system
Makefile.am:     for your code, to avoid questions about which license your project uses
common/Makefile.am: installing './depcomp'
```

### Output after performing `./configure`

```
checking for a BSD-compatible install... /usr/bin/install -c
checking whether build environment is sane... yes
checking for a race-free mkdir -p... /usr/bin/mkdir -p
checking for gawk... gawk
checking whether make sets $(MAKE)... yes
checking whether make supports nested variables... yes
checking build system type... x86_64-pc-linux-gnu
checking host system type... x86_64-pc-linux-gnu
checking how to print strings... printf
checking whether make supports the include directive... yes (GNU style)
checking for gcc... gcc
checking whether the C compiler works... yes
checking for C compiler default output file name... a.out
checking for suffix of executables... 
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether the compiler supports GNU C... yes
checking whether gcc accepts -g... yes
checking for gcc option to enable C11 features... none needed
checking whether gcc understands -c and -o together... yes
checking dependency style of gcc... gcc3
checking for a sed that does not truncate output... /usr/bin/sed
checking for grep that handles long lines and -e... /usr/bin/grep
checking for egrep... /usr/bin/grep -E
checking for fgrep... /usr/bin/grep -F
checking for ld used by gcc... /usr/bin/ld
checking if the linker (/usr/bin/ld) is GNU ld... yes
checking for BSD- or MS-compatible name lister (nm)... /usr/bin/nm -B
checking the name lister (/usr/bin/nm -B) interface... BSD nm
checking whether ln -s works... yes
checking the maximum length of command line arguments... 1572864
checking how to convert x86_64-pc-linux-gnu file names to x86_64-pc-linux-gnu format... func_convert_file_noop
checking how to convert x86_64-pc-linux-gnu file names to toolchain format... func_convert_file_noop
checking for /usr/bin/ld option to reload object files... -r
checking for objdump... objdump
checking how to recognize dependent libraries... pass_all
checking for dlltool... no
checking how to associate runtime and link libraries... printf %s\n
checking for ar... ar
checking for archiver @FILE support... @
checking for strip... strip
checking for ranlib... ranlib
checking command to parse /usr/bin/nm -B output from gcc object... ok
checking for sysroot... no
checking for a working dd... /usr/bin/dd
checking how to truncate binary pipes... /usr/bin/dd bs=4096 count=1
checking for mt... mt
checking if mt is a manifest tool... no
checking for stdio.h... yes
checking for stdlib.h... yes
checking for string.h... yes
checking for inttypes.h... yes
checking for stdint.h... yes
checking for strings.h... yes
checking for sys/stat.h... yes
checking for sys/types.h... yes
checking for unistd.h... yes
checking for dlfcn.h... yes
checking for objdir... .libs
checking if gcc supports -fno-rtti -fno-exceptions... no
checking for gcc option to produce PIC... -fPIC -DPIC
checking if gcc PIC flag -fPIC -DPIC works... yes
checking if gcc static flag -static works... yes
checking if gcc supports -c -o file.o... yes
checking if gcc supports -c -o file.o... (cached) yes
checking whether the gcc linker (/usr/bin/ld -m elf_x86_64) supports shared libraries... yes
checking whether -lc should be explicitly linked in... no
checking dynamic linker characteristics... GNU/Linux ld.so
checking how to hardcode library paths into programs... immediate
checking for shl_load... no
checking for shl_load in -ldld... no
checking for dlopen... yes
checking whether a program can dlopen itself... yes
checking whether a statically linked program can dlopen itself... no
checking whether stripping libraries is possible... yes
checking if libtool supports shared libraries... yes
checking whether to build shared libraries... yes
checking whether to build static libraries... yes
checking for gcc... (cached) gcc
checking whether the compiler supports GNU C... (cached) yes
checking whether gcc accepts -g... (cached) yes
checking for gcc option to enable C11 features... (cached) none needed
checking whether gcc understands -c and -o together... (cached) yes
checking dependency style of gcc... (cached) gcc3
checking for stdlib.h... (cached) yes
checking for ltdl.h... yes
checking for library containing pthread_create... none required
checking for pthread.h... yes
checking for library containing lt_dlopen... -lltdl
checking that generated files are newer than configure... done
configure: creating ./config.status
config.status: creating tests/Makefile
config.status: creating tests/atlocal
config.status: creating Makefile
config.status: creating common/Makefile
config.status: creating include/Makefile
config.status: creating libjup/Makefile
config.status: creating src/Makefile
config.status: creating src/modules/hithere/Makefile
config.status: creating config.h
config.status: executing depfiles commands
config.status: executing libtool commands
config.status: executing tests/atconfig commands
-------------------------------------------------

Jupiter Version 1.0

Prefix: '/usr/local'.
Compiler: 'gcc -g -O2 '
Libraries: '-lltdl '

Package features:
  Async Execution: yes

  Now type 'make [<target>]'
    where the optional <target> is:
      all                - build all binaries
      install            - install everything

--------------------------------------------------
```

#### Output after performing `make`

```
make  all-recursive
make[1]: Entering directory '/home/dayton/Documents/Projects/devops/automation/autotools/jupiter'
Making all in common
make[2]: Entering directory '/home/dayton/Documents/Projects/devops/automation/autotools/jupiter/common'
/bin/bash ../libtool  --tag=CC   --mode=compile gcc -DHAVE_CONFIG_H -I. -I..     -g -O2 -MT print.lo -MD -MP -MF .deps/print.Tpo -c -o print.lo print.c
libtool: compile:  gcc -DHAVE_CONFIG_H -I. -I.. -g -O2 -MT print.lo -MD -MP -MF .deps/print.Tpo -c print.c  -fPIC -DPIC -o .libs/print.o
libtool: compile:  gcc -DHAVE_CONFIG_H -I. -I.. -g -O2 -MT print.lo -MD -MP -MF .deps/print.Tpo -c print.c -o print.o >/dev/null 2>&1
mv -f .deps/print.Tpo .deps/print.Plo
/bin/bash ../libtool  --tag=CC   --mode=link gcc  -g -O2   -o libjupcommon.la  print.lo  -lltdl 
libtool: link: ar cr .libs/libjupcommon.a .libs/print.o 
libtool: link: ranlib .libs/libjupcommon.a
libtool: link: ( cd ".libs" && rm -f "libjupcommon.la" && ln -s "../libjupcommon.la" "libjupcommon.la" )
make[2]: Leaving directory '/home/dayton/Documents/Projects/devops/automation/autotools/jupiter/common'
Making all in include
make[2]: Entering directory '/home/dayton/Documents/Projects/devops/automation/autotools/jupiter/include'
make[2]: Nothing to be done for 'all'.
make[2]: Leaving directory '/home/dayton/Documents/Projects/devops/automation/autotools/jupiter/include'
Making all in libjup
make[2]: Entering directory '/home/dayton/Documents/Projects/devops/automation/autotools/jupiter/libjup'
/bin/bash ../libtool  --tag=CC   --mode=compile gcc -DHAVE_CONFIG_H -I. -I..  -I../include -I../common   -g -O2 -MT libjupiter_la-jup_print.lo -MD -MP -MF .deps/libjupiter_la-jup_print.Tpo -c -o libjupiter_la-jup_print.lo `test -f 'jup_print.c' || echo './'`jup_print.c
libtool: compile:  gcc -DHAVE_CONFIG_H -I. -I.. -I../include -I../common -g -O2 -MT libjupiter_la-jup_print.lo -MD -MP -MF .deps/libjupiter_la-jup_print.Tpo -c jup_print.c  -fPIC -DPIC -o .libs/libjupiter_la-jup_print.o
libtool: compile:  gcc -DHAVE_CONFIG_H -I. -I.. -I../include -I../common -g -O2 -MT libjupiter_la-jup_print.lo -MD -MP -MF .deps/libjupiter_la-jup_print.Tpo -c jup_print.c -o libjupiter_la-jup_print.o >/dev/null 2>&1
mv -f .deps/libjupiter_la-jup_print.Tpo .deps/libjupiter_la-jup_print.Plo
/bin/bash ../libtool  --tag=CC   --mode=link gcc  -g -O2   -o libjupiter.la -rpath /usr/local/lib libjupiter_la-jup_print.lo ../common/libjupcommon.la -lltdl 
libtool: link: gcc -shared  -fPIC -DPIC  .libs/libjupiter_la-jup_print.o  -Wl,--whole-archive ../common/.libs/libjupcommon.a -Wl,--no-whole-archive  -lltdl  -g -O2   -Wl,-soname -Wl,libjupiter.so.0 -o .libs/libjupiter.so.0.0.0
libtool: link: (cd ".libs" && rm -f "libjupiter.so.0" && ln -s "libjupiter.so.0.0.0" "libjupiter.so.0")
libtool: link: (cd ".libs" && rm -f "libjupiter.so" && ln -s "libjupiter.so.0.0.0" "libjupiter.so")
libtool: link: (cd .libs/libjupiter.lax/libjupcommon.a && ar x "/home/dayton/Documents/Projects/devops/automation/autotools/jupiter/libjup/../common/.libs/libjupcommon.a")
libtool: link: ar cr .libs/libjupiter.a  libjupiter_la-jup_print.o  .libs/libjupiter.lax/libjupcommon.a/print.o 
libtool: link: ranlib .libs/libjupiter.a
libtool: link: rm -fr .libs/libjupiter.lax
libtool: link: ( cd ".libs" && rm -f "libjupiter.la" && ln -s "../libjupiter.la" "libjupiter.la" )
make[2]: Leaving directory '/home/dayton/Documents/Projects/devops/automation/autotools/jupiter/libjup'
Making all in src
make[2]: Entering directory '/home/dayton/Documents/Projects/devops/automation/autotools/jupiter/src'
Making all in modules/hithere
make[3]: Entering directory '/home/dayton/Documents/Projects/devops/automation/autotools/jupiter/src/modules/hithere'
/bin/bash ../../../libtool  --tag=CC   --mode=compile gcc -DHAVE_CONFIG_H -I. -I../../..     -g -O2 -MT hithere.lo -MD -MP -MF .deps/hithere.Tpo -c -o hithere.lo hithere.c
libtool: compile:  gcc -DHAVE_CONFIG_H -I. -I../../.. -g -O2 -MT hithere.lo -MD -MP -MF .deps/hithere.Tpo -c hithere.c  -fPIC -DPIC -o .libs/hithere.o
libtool: compile:  gcc -DHAVE_CONFIG_H -I. -I../../.. -g -O2 -MT hithere.lo -MD -MP -MF .deps/hithere.Tpo -c hithere.c -o hithere.o >/dev/null 2>&1
mv -f .deps/hithere.Tpo .deps/hithere.Plo
/bin/bash ../../../libtool  --tag=CC   --mode=link gcc  -g -O2 -module -avoid-version  -o hithere.la -rpath /usr/local/lib/jupiter hithere.lo  -lltdl 
libtool: link: gcc -shared  -fPIC -DPIC  .libs/hithere.o   -lltdl  -g -O2   -Wl,-soname -Wl,hithere.so -o .libs/hithere.so
libtool: link: ar cr .libs/hithere.a  hithere.o
libtool: link: ranlib .libs/hithere.a
libtool: link: ( cd ".libs" && rm -f "hithere.la" && ln -s "../hithere.la" "hithere.la" )
make[3]: Leaving directory '/home/dayton/Documents/Projects/devops/automation/autotools/jupiter/src/modules/hithere'
make[3]: Entering directory '/home/dayton/Documents/Projects/devops/automation/autotools/jupiter/src'
gcc -DHAVE_CONFIG_H -I. -I..  -I../include   -g -O2 -MT jupiter-main.o -MD -MP -MF .deps/jupiter-main.Tpo -c -o jupiter-main.o `test -f 'main.c' || echo './'`main.c
mv -f .deps/jupiter-main.Tpo .deps/jupiter-main.Po
/bin/bash ../libtool  --tag=CC   --mode=link gcc  -g -O2   -o jupiter jupiter-main.o ../libjup/libjupiter.la -dlopen modules/hithere/hithere.la -lltdl 
libtool: link: rm -f .libs/jupiter.nm .libs/jupiter.nmS .libs/jupiter.nmT
libtool: link: rm -f ".libs/jupiter.nmI"
libtool: link: (cd .libs && gcc -g -O2 -c -fno-builtin "jupiterS.c")
libtool: link: rm -f ".libs/jupiterS.c" ".libs/jupiter.nm" ".libs/jupiter.nmS" ".libs/jupiter.nmT" ".libs/jupiter.nmI"
libtool: link: gcc -g -O2 -o .libs/jupiter jupiter-main.o .libs/jupiterS.o  ../libjup/.libs/libjupiter.so -lltdl
make[3]: Leaving directory '/home/dayton/Documents/Projects/devops/automation/autotools/jupiter/src'
make[2]: Leaving directory '/home/dayton/Documents/Projects/devops/automation/autotools/jupiter/src'
Making all in tests
make[2]: Entering directory '/home/dayton/Documents/Projects/devops/automation/autotools/jupiter/tests'
make[2]: Nothing to be done for 'all'.
make[2]: Leaving directory '/home/dayton/Documents/Projects/devops/automation/autotools/jupiter/tests'
make[2]: Entering directory '/home/dayton/Documents/Projects/devops/automation/autotools/jupiter'
make[2]: Leaving directory '/home/dayton/Documents/Projects/devops/automation/autotools/jupiter'
make[1]: Leaving directory '/home/dayton/Documents/Projects/devops/automation/autotools/jupiter'
```