# GNU Make Cheat Sheet

## **Basics**

- **Makefile**: The file that contains rules for building the project.
- **Target**: A file that needs to be created or updated.
- **Prerequisites**: Files needed to create/update the target.
- **Recipe**: The commands to execute to build the target.

### General Structure
```make
target: prerequisites
    recipe
```

- Lines starting with `#` are comments.
- Commands in recipes are indented with a **TAB**, not spaces.

---

## **Special Variables**
- **$@**: The target of the rule.
- **$<**: The first prerequisite.
- **$^**: All prerequisites.
- **$?**: All prerequisites newer than the target.

---

## **Common Commands**
- **`make`**: Default command, runs the first target in the Makefile.
- **`make target`**: Runs a specific target.
- **`make -f filename`**: Use a different file instead of the default `Makefile`.
- **`make -n`**: Show commands without running them.
- **`make -k`**: Continue building even if errors occur.
- **`make -j [jobs]`**: Run multiple jobs in parallel.

---

## **Automatic Variables**
- **$@**: Represents the target name.
- **$<**: First prerequisite.
- **$?**: Prerequisites newer than the target.
- **$^**: All prerequisites.

---

## **Pattern Rules**
Pattern rules allow you to define a general rule for files with similar names.

```make
%.o: %.c
    cc -c $< -o $@
```

This means: for any `.c` file, create an object `.o` file.

---

## **Built-in Rules**
GNU `make` comes with built-in rules for common tasks. For example:
```make
.c.o:
    $(CC) $(CFLAGS) -c $< -o $@
```

- **`.c.o`**: Tells `make` how to convert `.c` to `.o` files.
- You can override or define your own rules if necessary.

---

## **Phony Targets**
Phony targets are not real files but just labels for running recipes.

```make
.PHONY: clean
clean:
    rm *.o
```

The `.PHONY` target prevents `make` from confusing the target name with actual file names.

---

## **Variables**
Variables store values you can reuse.

```make
CC = gcc
CFLAGS = -Wall -g

program: program.o
    $(CC) $(CFLAGS) -o program program.o
```

### Variable Assignment
- **`=`**: Simple assignment (evaluates when used).
- **`:=`**: Immediate assignment (evaluates when defined).
- **`+=`**: Appends to the variable's value.
  
---

## **Functions**
GNU `make` supports functions for manipulating text.

### Example Functions:
- **`$(wildcard pattern)`**: Returns files matching the pattern.
- **`$(patsubst pattern,replacement,text)`**: Replaces parts of a string.
- **`$(shell command)`**: Executes a shell command and returns the output.

---

## **Conditional Parts**

You can make conditional statements in Makefiles using `ifeq`, `ifneq`, `ifdef`, and `ifndef`.

```make
ifeq ($(CC),gcc)
    CFLAGS = -O2
else
    CFLAGS = -g
endif
```

---

## **Dependency Management**
Dependencies are used to specify which files a target depends on.

```make
program: file1.o file2.o file3.o
    gcc -o program file1.o file2.o file3.o
```

If any `.o` file is newer than `program`, `make` rebuilds `program`.

### **Automatic Dependency Generation**

To automatically generate dependencies for C files:

```make
%.d: %.c
    $(CC) -M $< > $@
include $(wildcard *.d)
```

This generates `.d` files that contain the dependencies for `.c` files and includes them in the Makefile.

---

## **Suffix Rules (Deprecated in Modern Usage)**
Used for transforming files, suffix rules are older versions of pattern rules.

```make
.SUFFIXES: .c .o
.c.o:
    gcc -c $< -o $@
```

These are now generally replaced by pattern rules (`%.o: %.c`).

---

## **Environment Variables**
You can use environment variables within a Makefile. For example, setting `CC=gcc` in the environment overrides `CC` in the Makefile unless `?=` (conditional assignment) is used:

```make
CC ?= gcc
```

---

## **Recursive Make**
If you have subdirectories with separate Makefiles, you can use recursive `make`:

```make
subdir:
    $(MAKE) -C subdir
```

The `-C` option tells `make` to run in the subdirectory.

---

## **Error Handling**
To make `make` continue despite errors, use `-` before a command:

```make
clean:
    -rm *.o
```

---

## **Debugging**
- **`make -d`**: Debugging information.
- **`make -p`**: Print all variables and implicit rules.

---

This cheat sheet covers the essential commands, variables, and patterns you'll need to use GNU `make`. You can dive deeper into specific features or error handling by referring to the book.

## Videos

1. [Makefile-Related Videos](https://www.youtube.com/playlist?list=PL9IEJIKnBJjEPxenuhKU7J5smY4XjFnyg) - [Jacob Sorber](https://www.youtube.com/@JacobSorber)