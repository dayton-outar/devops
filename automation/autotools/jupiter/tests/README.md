# **Autotest Framework**

Autotest is a testing framework that integrates with GNU Autotools (Autoconf, Automake, etc.) to automate software testing, particularly in Unix-like environments. It allows developers to define, run, and check tests as part of their build and distribution process. Tests are typically written in the `.at` format, a special syntax designed for portability and flexibility across systems.

## Key Components of Autotest:
1. **`.at` Files**: Test scripts that use a mix of shell commands and macros.
2. **`testsuite` File**: An executable script generated from `.at` files, acting as the main test driver.
3. **Autoconf & Automake Integration**: Autotest works seamlessly with these tools, allowing tests to be run during the build (`make check`), after installation (`make installcheck`), and automatically in distributed tarballs.

---

**Autotest** is generally considered deprecated or outdated for modern C or C++ application development. While it remains part of the **GNU Autotools** suite, it hasn't seen much development or new features in recent years. Modern projects, especially in C or C++, have largely moved away from Autotest for several reasons:

### **Reasons Autotest is Considered Outdated:**
1. **Lack of Active Maintenance**: Autotest has not been actively developed or maintained, so there are few updates or improvements.
2. **Limited Features**: While it served well for simple testing, it lacks features such as advanced reporting, parallel testing, and integration with modern development practices (like CI/CD pipelines).
3. **Complexity**: The combination of Autoconf, Automake, and Autotest introduces a lot of complexity, and setting up even simple tests can involve significant boilerplate code.
4. **Portability Issues**: Although Autotest is meant to be portable, there are now better cross-platform tools that are more flexible and easier to configure.

### **Modern Alternatives for C/C++ Testing**
For modern C and C++ projects, there are more robust and feature-rich testing frameworks available that integrate better with modern development practices. Here are some popular alternatives:

#### 1. **Google Test (gtest)**
   - **Overview**: One of the most popular testing frameworks for C++. It provides a rich set of assertions, fixtures, and support for unit testing and mocking.
   - **Features**: Advanced reporting, test discovery, mocking (using Google Mock), and integration with CI/CD tools like Jenkins, GitHub Actions, and others.
   - **Usage**: Easy to integrate with modern build systems like **CMake**.
   - **Link**: [Google Test](https://github.com/google/googletest)

#### 2. **Catch2**
   - **Overview**: A single-header testing framework for C++ with simple syntax and rich feature sets, like behavior-driven development (BDD).
   - **Features**: BDD-style tests, rich assertions, easy integration with modern C++ (supports newer C++ standards).
   - **Usage**: Works well with CMake and can be included as a header-only library.
   - **Link**: [Catch2](https://github.com/catchorg/Catch2)

#### 3. **Boost.Test**
   - **Overview**: Part of the Boost C++ Libraries, it provides a rich set of testing features, including unit tests, logging, and test suites.
   - **Features**: Support for both unit testing and large-scale system testing, highly customizable, and integrates with other Boost libraries.
   - **Usage**: Often used in C++ projects that already use the Boost libraries.
   - **Link**: [Boost.Test](https://www.boost.org/doc/libs/1_76_0/libs/test/doc/html/index.html)

#### 4. **CMocka**
   - **Overview**: A lightweight and simple unit testing framework for C, supporting C89 and newer.
   - **Features**: Minimal overhead, designed for embedded systems, easy to integrate.
   - **Usage**: Popular for C projects where simplicity and low overhead are required.
   - **Link**: [CMocka](https://cmocka.org/)

#### 5. **CppUnit**
   - **Overview**: A C++ port of the JUnit framework, providing similar features for unit testing.
   - **Features**: Test fixtures, assertions, and test runners for structured unit tests.
   - **Usage**: Not as commonly used today but still available for legacy projects or developers familiar with the JUnit-style API.
   - **Link**: [CppUnit](https://sourceforge.net/projects/cppunit/)

#### 6. **Doctest**
   - **Overview**: A fast and feature-rich C++ testing framework that is also header-only, inspired by Catch2.
   - **Features**: Focuses on simplicity and efficiency, ideal for embedding directly into source files.
   - **Usage**: Works well with modern CMake-based projects.
   - **Link**: [Doctest](https://github.com/onqtam/doctest)

### **Recommended Approach for Modern C/C++ Development**
1. **Use CMake**: CMake has become the de facto standard for modern C/C++ projects, and most modern testing frameworks (like Google Test, Catch2, etc.) integrate seamlessly with it.
2. **Adopt a Modern Testing Framework**: Frameworks like **Google Test**, **Catch2**, and **Boost.Test** offer far more features, better CI/CD integration, and more active communities than Autotest.
3. **Continuous Integration (CI)**: Modern frameworks can easily integrate with CI pipelines (GitHub Actions, Jenkins, etc.) to automate testing on multiple platforms.

### **When to Use Autotest?**
Autotest might still be useful if:
- You’re working with legacy code that already uses the GNU Autotools suite extensively.
- Portability and simple shell scripting are key to your project, and you're working on a Unix-like system where Autotools are already established.

However, for modern projects, switching to a modern framework will provide more flexibility, efficiency, and ease of use.

---

### **Conclusion**
Autotest is generally considered deprecated and not recommended for new projects. For modern C or C++ development, it's best to use alternatives like **Google Test**, **Catch2**, or **Boost.Test** that offer better features, active maintenance, and easier integration with modern build systems like CMake.

---

## **Autotest Cheat Sheet**

### 1. **Basic Structure of a `.at` File**
An Autotest script (`.at` file) consists of macros and shell commands. Here's an example template:

```bash
# Define a test group
AT_INIT([Test Group Name])

# Define a test case
AT_SETUP([Test Description])

# Shell commands for the test
echo "Hello World"
test "$(echo Hello)" = "Hello"

# End the test case and check the status
AT_CHECK([your_command], [expected_exit_status], [stdout_file], [stderr_file])

AT_CLEANUP
```

### 2. **Commonly Used Macros**

| Macro          | Description                                                                                  |
|----------------|----------------------------------------------------------------------------------------------|
| `AT_INIT([name])`     | Initializes the test suite. This should be the first macro in the `.at` file.            |
| `AT_SETUP([description])` | Defines a new test case with a human-readable description.                             |
| `AT_CHECK([command], [status], [stdout], [stderr])` | Runs the given command and checks its exit status, stdout, and stderr. |
| `AT_DATA([filename], [content])` | Creates a file with the given content inside a test case.                      |
| `AT_CLEANUP`   | Cleans up the environment and finishes the test.                                              |

### 3. **Basic Macros**

| Macro                  | Usage Example                                                   | Description |
|------------------------|-----------------------------------------------------------------|-------------|
| `AT_INIT([tests])`      | `AT_INIT([Basic Functionality Tests])`                         | Initializes the test suite with a description or name. |
| `AT_SETUP([test name])` | `AT_SETUP([Basic Hello World Test])`                           | Defines the start of a test with a description.         |
| `AT_CHECK([cmd])`       | `AT_CHECK([echo hello])`                                       | Runs a shell command and checks its exit status.        |
| `AT_CHECK([cmd], [0])`  | `AT_CHECK([ls nonexistent], [1], [ignore], [stderr])`          | Checks the command, status, and optional output files.  |
| `AT_CLEANUP`            | `AT_CLEANUP`                                                   | Marks the end of a test. Cleans up after the test.      |

### 4. **Checking Outputs & Status Codes**

| Command                                                   | Description |
|-----------------------------------------------------------|-------------|
| `AT_CHECK([cmd])`                                          | Executes `cmd` and verifies its exit status is `0`. |
| `AT_CHECK([cmd], [1], [stdout], [stderr])`                 | Verifies the command’s exit status is `1`, checks stdout and stderr. |
| `AT_CHECK([cmd], [exit_status], [stdout], [stderr])`       | Custom exit status, stdout, and stderr checks. |

### 5. **Creating Test Data**

| Command                      | Description |
|------------------------------|-------------|
| `AT_DATA([filename], [content])` | Creates a file with the specified content during a test. |

Example:
```bash
AT_DATA([testfile.txt], [[
Hello, this is a test file.
]])
```

### 6. **Running the Test Suite**
Once `.at` files are created and configured in `Makefile.am`, the following commands can be used to run tests:

| Command                      | Description |
|------------------------------|-------------|
| `make check`                 | Runs the test suite. |
| `make installcheck`          | Runs tests in the installed environment. |
| `make distcheck`             | Verifies the test suite works in a distribution tarball. |

### 7. **Automake Integration**

To integrate Autotest with Automake, include your `.at` test scripts in the `Makefile.am`:

```makefile
TESTS = $(srcdir)/testsuite
EXTRA_DIST = testsuite.at some_test.at another_test.at
```

Autotest will generate the `testsuite` file based on these `.at` files.

### 8. **Cleaning Test Artifacts**

- Autotest will leave behind some temporary files (`atconfig`, `atlocal`). You can clean them using the `clean-local` target in your `Makefile.am`:

```makefile
clean-local:
    rm -f atconfig atlocal
```

### 9. **Example `.at` Test File**

```bash
AT_INIT([Example Test])

# Setup the test case
AT_SETUP([Testing echo command])

# Check if echo outputs correctly
AT_CHECK([echo "Hello, Autotest!"], [0], [stdout], [ignore])

# End the test case
AT_CLEANUP
```

### 10. **Example `Makefile.am` Integration**

```makefile
EXTRA_DIST = testsuite.at mytest.at another_test.at
TESTS = $(srcdir)/testsuite
TESTSUITE_AT = mytest.at another_test.at
```

---

## **Tips**

- **`make check`**: Use this to run your test suite during development.
- **`make distcheck`**: Ensures your test suite and package are ready for distribution.
- **Error Reporting**: Review test logs for failures to get detailed output on what's going wrong.
- **Portability**: Autotest is designed to be portable across different environments, which makes it very useful for open-source projects targeting multiple platforms.

---

Autotest provides a powerful and portable testing framework for developers using the GNU build system, making it easier to automate and run tests throughout the software development lifecycle.

## Further Reading

1. [Using Autotest](https://www.gnu.org/software/autoconf/manual/autoconf-2.69/html_node/Using-Autotest.html)