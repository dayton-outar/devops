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
- **$\***: The stem of the target's filename without suffix.
- **\$+**: Like `$^` (all prerequisites), but preserves duplicates and order.
- **$|**: The names of all the order-only prerequisites.
- **$(@D)**: The directory part of the target file's name.

---

## **Pattern Rules**
Pattern rules allow you to define a general rule for files with similar names.

```make
%.o: %.c
    cc -c $< -o $@
```

This means: for any `.c` file, create an object `.o` file.

Here’s an example of a **pattern rule** using **`$?`**:

### **Pattern Rule Example using `$?`**

```makefile
%.o: %.c
    gcc -c $< -o $@ $(CFLAGS) $(CPPFLAGS)

program: file1.o file2.o
    gcc -o program $^ $(LDFLAGS)

.PHONY: all
all: program

.PHONY: rebuild
rebuild: program
    @echo "Rebuilding changed files"
    gcc -o program $? $(LDFLAGS)
```

### **Explanation:**
- **`%.o: %.c`**: A pattern rule that says for any `.c` file, generate the corresponding `.o` file by compiling with `gcc`.
  - `$<` is the first prerequisite, i.e., the `.c` file.
  - `$@` is the target, i.e., the `.o` file.

- **`program: file1.o file2.o`**: This target builds the `program` executable from `file1.o` and `file2.o`.

- **`rebuild`**: This target rebuilds the program by compiling only the files that have changed.
  - `$?` represents the prerequisites that are **newer** than the target (in this case, the `.o` files that are newer than `program`).
  - This allows only the changed `.o` files to be recompiled when `rebuild` is called, rather than recompiling everything.

By using `$?`, this rule ensures only the changed files are recompiled, which is more efficient than recompiling everything.

Here's an example of a **pattern rule** using **`$^`**:

### **Pattern Rule Example using `$^`**

```makefile
%.o: %.c
    gcc -c $< -o $@ $(CFLAGS)

program: file1.o file2.o file3.o
    gcc -o program $^ $(LDFLAGS)

.PHONY: all
all: program
```

### **Explanation:**
- **`%.o: %.c`**: This pattern rule compiles each `.c` file into its corresponding `.o` object file.
  - **`$<`**: The first prerequisite (the `.c` file).
  - **`$@`**: The target (the `.o` file).

- **`program: file1.o file2.o file3.o`**: This rule links all the object files into the `program` executable.
  - **`$^`**: All prerequisites, which in this case are `file1.o`, `file2.o`, and `file3.o`.

In this example, `$^` is used in the `program` target to represent all object files (`file1.o file2.o file3.o`), which are passed to the `gcc` linker to build the final executable.

Here’s a list of the additional automatic variables in GNU Make, with short descriptions and explanations:

### **Additional Automatic Variables**

- **`$*`**:   
  **Explanation**: In a pattern rule like `%.o: %.c`, `$*` refers to the "stem" of the matched file, which is the filename without the extension (for example, `file` if the target is `file.o`).

  **Example**:
  ```makefile
  %.o: %.c
      gcc -c $< -o $*.o
  ```

- **`$+`**:  
  **Explanation**: Useful when you want to pass repeated or ordered prerequisites to the recipe (for example, when linking certain files multiple times).

  **Example**:
  ```makefile
  lib: obj1.o obj2.o obj1.o
      ar rcs lib.a $+
  ```

- **`$|`**:   
  **Explanation**: Order-only prerequisites are dependencies that must be built before the target, but do not cause the target to rebuild if they change.

  **Example**:
  ```makefile
  all: main.o | lib
      gcc -o all main.o lib.a
  ```

- **`$(@D)`**:   
  **Explanation**: If the target is `dir/file.o`, `$(@D)` would expand to `dir`. This is useful for making sure the directory exists before creating the target.

  **Example**:
  ```makefile
  $(OBJDIR)/%.o: %.c
      mkdir -p $(@D)
      gcc -c $< -o $@
  ```

These variables offer more control and flexibility in handling filenames, directories, and ordered dependencies in your Makefiles.

---

### **Command Prefixes**

- **`@`**:  
  **Description**: Suppresses the command echo.  
  **Example**:
  ```makefile
  all:
      @echo "Building the project"
  ```
  The `@` prevents `echo "Building the project"` from being printed to the terminal, so only the output (`Building the project`) is shown.

- **`-`**:  
  **Description**: Ignores errors from the command.  
  **Example**:
  ```makefile
  clean:
      -rm *.o
  ```
  The `-` makes Make ignore errors from the `rm` command, so it won't stop if some `.o` files don’t exist.

- **`+`**:  
  **Description**: Forces the command to be executed in a sub-shell, even if `make` is run without the `-j` (parallel) option.  
  **Example**:
  ```makefile
  all:
      +make -C subdir
  ```
  The `+` ensures that the command `make -C subdir` runs in a sub-shell.

- **`$(SHELL)`**:  
  **Description**: Executes the command with the current shell.  
  **Example**:
  ```makefile
  all:
      $(SHELL) -c "echo Hello, world!"
  ```
  This forces the command to be run in the shell specified by the `SHELL` variable.

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

## Further Reading

1. [GNU Make: Quick Reference](https://www.gnu.org/software/make/manual/html_node/Quick-Reference.html)

## Videos

1. [Makefile-Related Videos](https://www.youtube.com/playlist?list=PL9IEJIKnBJjEPxenuhKU7J5smY4XjFnyg) - [Jacob Sorber](https://www.youtube.com/@JacobSorber)