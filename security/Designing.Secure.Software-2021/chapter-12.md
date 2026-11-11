# Chapter 12

## Designing Secure Software-2021

Source: [Designing.Secure.Software-2021-12.pdf](Designing.Secure.Software-2021-12.pdf) — 16 PDF pages.

<!-- Source S12, PDF page 1 -->

### Security Testing

Testing leads to failure, and failure leads to understanding.

—Burt Rutan

![Figure 12-2: Chapter-opening artwork](/.attachments/12-2-Designing.Secure.Software-2021-12.png)

*Figure 12-2: Chapter-opening artwork*

<!-- Source: Designing.Secure.Software-2021-12.pdf, PDF page 1. -->

This chapter introduces security testing as an essential part of developing reliable, secure code. Testing proactively to detect security vulnerabilities is both well understood and not difficult to do, but it’s vastly underutilized in practice and so represents a major opportunity to raise security assurance.

This chapter opens with a quick overview of the uses of security testing, followed by a walkthrough of how security testing could have saved the world from a major vulnerability. Next, we look at the basics of writing security test cases to detect and catch vulnerabilities or their precursors. Fuzz testing is a powerful supplementary technique that can help you ferret out deeper problems. We’ll also cover security regression tests, created in response to existing vulnerabilities to ensure that the same mistakes are

<!-- Source S12, PDF page 2 -->

never made twice. The chapter concludes with a discussion of how testing helps to prevent denial-of-service (DoS) and related attacks, followed by a summary of security testing best practices (which covers a wide range of ideas for security testing, but is by no means comprehensive).

### What Is Security Testing?

To begin, it’s important to define what I mean by security testing. Most testing consists of exercising code to check that functionality works as intended. Security testing simply flips this around, ensuring that operations that should not be allowed aren’t (an example with code will shortly make this distinction clear).

Security testing is indispensable because it ensures that mitigations are working. Given that coders reasonably focus on getting the intended functionality to work with normal use, attacks that do the unexpected can be difficult to fully anticipate. The material covered in the preceding chapters should immediately suggest numerous security testing possibilities. Here are some basic kinds of security test cases corresponding to the major classes of vulnerabilities covered previously:

Integer overflows

Establish permitted ranges of values and ensure that detection and rejection of out-of-range values work.

Memory management problems

Test that the code handles extremely large data values correctly, and rejects them when they’re too big.

Untrusted inputs

Test various invalid inputs to ensure they are either rejected or converted to a valid form that is safely processed.

Web security

Ensure that HTTP downgrade attacks, invalid authentication and CSRF tokens, and XSS attacks fail (see the previous chapter for details on these).

Exception handling flaws

Force the code through its various exception handling paths (using dependency injection for rare ones) to check that it recovers reasonably.

What all of these tests have in common is that they are off the beaten path of normal usage, which is why they are easily forgotten. And since all these areas are ripe for attack, thorough testing makes a big difference. Security testing makes code more secure by anticipating such cases and

<!-- Source S12, PDF page 3 -->

confirming that the necessary protection mechanisms always work. In addition, for security-critical code, I recommend thorough code coverage to ensure the highest possible quality, since bugs in those areas tend to be devastating.

Security testing is likely the best way you can start making real improvements to application security, and it isn’t difficult to do. There are no public statistics for how much or how little security testing is done in the software industry, but the preponderance of recurrent vulnerabilities strongly suggests that it’s an enormous missed opportunity.

### Security Testing the GotoFail Vulnerability

What a testing of character adversity is.

—Harry Emerson Fosdick

Recall the GotoFail vulnerability we examined in Chapter 8, which caused secure connection checks to be bypassed. Extending the simplified example presented there, let’s look at how security testing would have easily detected problems like that.

The GotoFail vulnerability was caused by a single line of code accidentally being doubled up, as shown by the highlighted line in the following code snippet. Since that line was a `goto` statement, it short-circuited a series of important checks and caused the verification function to unconditionally produce a passing return code. Earlier we looked only at the critical lines of code (in my simplified version), but to security test it, we need to examine the entire function:

```text
vulnerable code
                /*
                 * Copyright (c) 1999-2001,2005-2012 Apple Inc. All Rights Reserved.
                 *
                 * @APPLE_LICENSE_HEADER_START@
                 *
                 * This file contains Original Code and/or Modifications of Original Code
                 * as defined in and that are subject to the Apple Public Source License
                 * Version 2.0 (the 'License'). You may not use this file except in
                 * compliance with the License. Please obtain a copy of the License at
                 * http://www.opensource.apple.com/apsl/ and read it before using this
                 * file.
                 *
                 * The Original Code and all software distributed under the License are
                 * distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
                 * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
                 * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
                 * FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
                 * Please see the License for the specific language governing rights and
                 * limitations under the License.
                 *
                 * @APPLE_LICENSE_HEADER_END@
                 */
```

<!-- Source S12, PDF page 4 -->

```text
int VerifyServerKeyExchange(ExchangeParams params,
                            uint8_t *expected_hash, size_t expected_hash_len)
{
  int err;
  HashCtx ctx = 0;
  uint8_t *hash = 0;
  size_t hash_len;
  if ((err = ReadyHash(&ctx)) != 0)
    goto fail;
1 if ((err = SSLHashSHA1.update(ctx, params.clientRandom, PARAM_LEN)) != 0)
    goto fail;
2 if ((err = SSLHashSHA1.update(ctx, params.serverRandom, PARAM_LEN)) != 0)
    goto fail;
    goto fail;
3 if ((err = SSLHashSHA1.update(ctx, params.signedParams, PARAM_LEN)) != 0)
    goto fail;
  if ((err = SSLHashSHA1.final(ctx, &hash, &hash_len)) != 0)
    goto fail;
  if (hash_len != expected_hash_len) {
    err = -106;
    goto fail;
  }
4 if ((err = memcmp(hash, expected_hash, hash_len)) != 0) {
    err = -100;  // Error code for mismatch
  }
  SSLFreeBuffer(hash);

fail:
  if (ctx)
    SSLFreeBuffer(ctx);
  }
  return err;
}
```

### Security Testing

The `VerifyServerKeyExchange` function takes a `params` argument consisting of three fields, computes the message digest hash over its contents, and compares the result to the `expected_hash` value that authenticates the data. A zero return value indicates that the hashes match, which is required for a valid request. A nonzero return value means there was a problem: the hash values did not match (`-100`), the hash lengths did not match (`-106`), or some nonzero error code was returned from the hash computation library due to an unspecified error. Security depends on this: any tampering with the hash value or the data causes the hashes to mismatch, signaling that something is amiss.

Let’s first walk through the correct version of the code, before the duplicated `goto` statement was introduced. After setting up a `HashCtx ctx` context variable, it hashes the three data fields of `params` in turn (at `1`, `2`, and `3`). If any error occurs, it jumps to the `fail` label to return the error

<!-- Source S12, PDF page 5 -->

code in the variable `err`. Otherwise, it continues, copying the hash result into a buffer and comparing that (at `4`) to the expected hash value. The comparison function `memcmp` returns `0` for equal, or if the hashes are different, the code assigns an error code of `-100` to `err` and falls through to return that result.

### Functional Testing

Before considering security testing, let’s start with a functional test for the `VerifyServerKeyExchange` function. Functional testing checks that the code performs as expected, and this simple example is by no means complete. This example uses the MinUnit test framework for C. To follow along, all you need to know is that `mu_assert(``condition``,` `message``)` checks that the expression `condition` is true; if not, the assertion fails, printing the `message` provided:

```text
mu_assert(0 == VerifyServerKeyExchange(test0, expected_hash, SIG_LEN),
    "Expected correct hash check to succeed.");
```

This calls the function with known-good parameters, so we expect a return value of `0` to pass the test. In the function itself, the three fields will be hashed (at `1`, `2`, and `3`). The hashes compare equal at `4`. Not shown are the test values for the three fields of data (in the `ExchangeParams` struct named `test0`) with the precomputed correct hash (`expected_hash`) that the server would sign.

### Functional Testing with the Vulnerability

Now let’s introduce the GotoFail vulnerability (that highlighted line of code) and see what impact it has. When we rerun the functional test with the extra `goto`, the test still passes. The code works fine up to the duplicated `goto`, but then jumps over the hashing of the third data field (at `3`) and the comparison of hashes (at `4`). The function will continue to verify correct inputs, but now it will also verify some bad inputs that it should reject. However, we don’t know that yet. This is precisely why security testing is so important—and why it’s so easily overlooked.

More thorough functional testing might well include additional test cases, such as to check for verification failure (a nonzero return value). However, functional testing often stops short of thoroughly covering all the cases where we need the verify function to reject inputs in the name of security. This is where security testing comes in, as we shall see next.

### Security Test Cases

Now let’s write some security test cases. Since there are three chunks of data to hash, that suggests writing three corresponding tests; each of these will change the data values in some way, resulting in a hash that won’t match the expected value. The target verify function should reject these inputs because the changed values potentially represent data tampering, which the hash comparison is supposed to prevent. The actual values (`test1`, `test2`,

<!-- Source S12, PDF page 6 -->

`test3`) are copies of the correct `test0` with slight variations in one of the three data fields; the values themselves are unimportant and not shown. Here are the three test cases:

```text
mu_assert(-100 == VerifyServerKeyExchange(test1, expected_hash, SIG_LEN),
    "Expected to fail hash check: wrong client random.");
mu_assert(-100 == VerifyServerKeyExchange(test2, expected_hash, SIG_LEN),
    "Expected to fail hash check: wrong server random.");
mu_assert(-100 == VerifyServerKeyExchange(test3, expected_hash, SIG_LEN),
    "Expected to fail hash check: wrong signed parameters.");
```

All three of these will fail due to the bug. The verify function works fine up to the troublesome `goto`, but then unconditionally jumps to the label `fail`, leaving its hashing job incomplete and never comparing hash values `4`. Since we wrote these tests to expect verification failure as correct, a return value of `0` causes the tests to fail. Now we have a testing safety net that would have caught this vulnerability before release, avoiding the resulting fiasco.

In the spirit of completeness, another security test case suggests itself. What if all three values are correct, as in the `test0` case, but with a different signed hash (`wrong_hash`)? Here’s the test case for this:

```text
mu_assert(-100 == VerifyServerKeyExchange(test0, wrong_hash, SIG_LEN),
    "Expected check against the wrong hash value to fail.");
```

This test fails as well with the errant `goto`, as we would expect. While for this particular vulnerability just one of these tests would have caught it, the purpose of security testing is to cover as broad a range of potential vulnerabilities as possible.

### The Limits of Security Tests

Security testing aims to detect the potential major points of failure in code, but it will never cover all of the countless ways for code to go wrong. It’s possible to introduce a vulnerability that the tests we just wrote won’t detect, but it’s unlikely to happen inadvertently. Unless test coverage is extremely thorough, the possibility of crafting a bug that slips through the tests remains; however, the major threat here is inadvertent bugs, so a modest set of security test cases can be quite effective.

Determining how thorough the security test cases need to be requires judgment, but the rules of thumb are clear:

• Security testing is more important for code that is crucial to security. • The most important security tests often check for actions such as denying access, rejecting input, or failing (rather than success). • Security test cases should ensure that each of the key steps (in our example, the three hashes and the comparison of hashes) works correctly.

<!-- Source S12, PDF page 7 -->

Having closely examined a real security vulnerability with a simple (if unexpected) cause, and how to security test for such eventualities, let’s consider the general case and see how we could have anticipated this sort of problem and proactively averted it.

### Writing Security Test Cases

A good test case is one that has a high probability of detecting an as yet undiscovered error.

—Glenford Myers

A security test case confirms that a specific security failure does not occur. These tests are motivated by the second of the Four Questions: What can go wrong? This differs from penetration testing, where honest people ethically pound on software to find vulnerabilities so they can be fixed before bad actors find them, in that it does not attempt to scope out all possible exploits. Security testing also differs from penetration testing by providing protection against future vulnerabilities being introduced.

A security test case checks that protective mechanisms work correctly, which often involves the rejection or neutralization of invalid inputs and disallowed operations. While nobody would have anticipated the GotoFail bug specifically, it’s easy to see that all of the `if` statements in the `VerifyServerKeyExchange` function are critical to security. In the general case, code like this calls for test coverage on each condition that enforces a security check. With that level of testing in place, when the extraneous `goto` creates a vulnerability, one of those test cases will fail and call the problem to your attention.

You should create security test cases when you write other unit tests, not as a reaction to finding vulnerabilities. Secure systems protect valuable resources by blocking improper actions, rejecting malicious inputs, denying access, and so forth. Create security test cases wherever such security mechanisms exist to ensure that unauthorized operations indeed fail.

General examples of commonplace security test cases include testing that login attempts with the wrong password fail, that unauthorized attempts to access kernel resources from user space fail, and that digital certificates that are invalid or malformed in various ways are always rejected. Reading the code is a great way to get ideas for good security test cases.

### Testing Input Validation

Let’s consider security test cases for input validation. As a simple example, we’ll test input validation code that requires a string that is at least 10 characters and at most 20 characters long, consisting only of alphanumeric ASCII characters.

You could create helper functions to perform this sort of standardized input validation, ensuring that it happens uniformly and without fail, then combine input validation with matching test cases to confirm that the validation checks work and that the code performs properly, right up to the

<!-- Source S12, PDF page 8 -->

allowable limits. In fact, since off-by-one errors are legion in programming, it’s good practice to check both right at and just beyond the limits. The following unit tests cover the input validation test cases for this example:

• Check that a valid input of length 10 works, but an input of length 9 or less fails. • Check that a valid input of length 20 works, but an input of length 21 or more fails. • Check that inputs with one or more invalid characters always fail.

Of course, the functional tests should have already checked that sample inputs that satisfy all constraints work properly.

For another similar example, suppose the code under test stores a byte array parameter in a fixed-length buffer of N bytes. Security test cases should ensure that the code works as expected with inputs of sizes up to and including N, but that an input of size N+1 gets safely rejected.

### Testing for XSS Vulnerabilities

Now let’s look at a more challenging security test case and some of the different test strategies that are available. Recall the XSS vulnerability from Chapter 11, where an untrusted input injects itself into HTML generated on the web server and breaks out into the page, such as by introducing script that runs to launch an attack. The root cause of this vulnerability is improper escaping, so that is where our security tests will focus.

Say the code under test is the following Python function, which composes a fragment of HTML based on strings that describe its contents:

```text
vulnerable code
                def html_tag(name, attrs):
                    """Build and return an HTML fragment with attribute values.
                    >>> html_tag('meta', {'name': 'test', 'content': 'example'})
                    '<meta name="test" content="example">'
                    """
                    result = '<%s' % name
                    for attr in attrs:
                        result += ' %s="%s"' % (attr, html.escape(attrs[attr]))
                    return result + ">"
```

The `doctest` (marked with the `>>>` prefix) example in the comments (delimited by `"""`) illustrates how to use this function to generate HTML text for a `<meta>` tag. The first line builds the first section of the text string result: the angle bracket (`<`) that opens every HTML tag, followed by the tag name. Then the loop iterates through the attributes (`attrs`), appending a space and its declaration (of the form `X="Y"`) for each attribute.

The code applies the `html.escape` function to each attribute string value correctly, but we still should test it. (For our purposes, we’ll assume that attribute values are the only potential source of untrusted input that needs escaping. While in practice this is usually sufficient, anything is possible, so more escaping or input validation might be necessary in some applications.)

<!-- Source S12, PDF page 9 -->

Let’s write the test cases with Python’s `unittest` library:

```text
class ExampleTestCases(unittest.TestCase):
    def test_basic(self):
        self.assertEqual(html_tag('meta', {'name': 'test', 'content': '123'}),
                         '<meta name="test" content="123">')

    def test_special_char(self):
        self.assertEqual(html_tag('meta', {'name': 'test', 'content': 'x"'}),
                         '<meta name="test" content="x&quot;">')

if __name__ == '__main__':
    unittest.main()
```

The first test case is a basic functional test that shows how these unit tests work. When run from the command line, the module invokes the unit test framework `main` in the last line. This automatically calls each method of all subclasses of `unittest.TestCase`, which contain the unit tests. The `assertEqual` method compares its arguments, which should be equal, or else the test fails.

Now let’s look at the security test case, named `test_special_char`. Since we know XSS can exploit the code by breaking out of the double quotes that the untrusted input goes into, we test the escaping with a string containing a double quote. Correct HTML escaping should convert this to the HTML entity `&quot;`, as shown in the expected string of the `assertEqual` statement. If we remove the `html.escape` function in the target method, this test will indeed fail, as we want it to.

So far, so good. But note that in order to write the test we had to know in advance what kinds of inputs might be problematic (double quote characters). Since the HTML specification is fairly involved, how do we know there aren’t more important test cases needed? We could try a bunch of other special characters, a number of which the `escape` function would convert to various HTML entity values (for example, converting the greater-than sign to `&gt;`). However, adjusting our test cases to cover all the possibilities like this would involve a lot of effort.

Since we are working with HTML, we can use libraries that know all about the specification in detail to do the heavy lifting for us. The following test case checks the result of forming HTML tags as we did earlier for the same two test values, the normal case and the one with a string containing a double quote character, assigned to the variable `content` in turn:

```text
    def test_parsed_html(self):
        for content in ['x', 'x"']:
            result = html_tag('meta', {'name': 'test', 'content': content})
            soup = BeautifulSoup(result, 'html.parser')
            node = soup.find('meta')
            self.assertEqual(node.get('name'), 'test')
            self.assertEqual(node.get('content'), content)
```

Inside the loop is the common code that tests both cases, beginning with a call to the target function to construct a string HTML `<meta>` tag.

<!-- Source S12, PDF page 10 -->

Instead of checking for an explicit expected value, we invoke the BeautifulSoup parser, which produces a tree of objects that logically represent the parsed HTML structure (colorfully referred to as a soup of objects). The variable `soup` is the root of the HTML node structure, and we can use it to navigate and examine its contents through an object model.

The `find` method finds the first `<meta>` tag in the soup, which we assign to the variable `node`. The `node` object sports a `get` method that looks up the values of attributes by name. The code tests that both the `name` and `content` attributes of the `<meta>` tag have the expected values. The big advantage of using the parser is that it takes care of spaces or line breaks in the HTML text, handles escaping and unescaping, converts entity expressions, and does everything else that HTML parsing entails.

Because we used the parser library, this security test case works on the parsed objects, shielded from the idiosyncrasies of HTML. If the XSS injects a malicious input that manages to break out of the double quotes, the parsed HTML won’t have the same value in the `node` object for the `<meta>` tag. So, even if you had no clue that double quote characters were problematic for some XSS attacks, you could easily try a range of special characters and rely on the parser to figure out which were working properly (or not). The next topic takes this idea of trying a number of test case variations and automates it at scale.

### Fuzz Testing

Fuzz testing is a technique that automatically generates test cases in an effort to bombard the target code with test inputs. This helps you determine if particular inputs might cause the code to fail or crash the process. Here’s an analogy that might help: a dishwasher cleans by spraying water at many different angles from a rotating arm. Without knowledge of how dishware happens to be loaded or at what angle shooting water will be effective, it sprays at random and still manages to get everything clean. In contrast to how security test cases written with specific intentions, the scattershot method of fuzz testing can be quite effective at finding a wider range of bugs, some of which will be vulnerabilities.

For security test cases, the typical approach is to “fuzz” untrusted inputs (that is, try lots of different values) and look for anomalous results or crashes. To actually identify a security vulnerability, you will need to investigate the leads that the results of fuzz testing produce.

You could convert `test_parsed_html` from the previous section into a fuzz test by checking many more characters.

```text
    def test_fuzzy_html(self):
        for fuzz in string.punctuation:
            content = 'q' + fuzz
            result = html_tag('meta', {'name': 'test', 'content': content})
            soup = BeautifulSoup(result, 'html.parser')
            node = soup.find('meta')
            self.assertEqual(node.get('name'), 'test')
            self.assertEqual(node.get('content'), content)
```

<!-- Source S12, PDF page 11 -->

Rather than trying a chosen list of test cases, this code loops over all ASCII punctuation characters, which are defined by a constant in the standard string library. On each iteration, the variable `fuzz` takes the value of a punctuation character and prepends this with the letter `q` to construct the two-character `content` value. The rest of the code is identical to the original example, only here it runs many more test cases.

This example is simplistic to the point of stretching the definition of fuzz testing a bit, but it illustrates the power of brute-force testing 32 cases programmatically instead of carefully choosing and writing a collection of test cases by hand. A more elaborate version of this code might construct many more cases using longer strings composed of the troublesome HTML quoting and escaping characters.

There are many libraries that offer various fuzzing capabilities, from random fuzzing to the generation of variations based on the knowledge of specific formats such as HTML, XML, and JSON. If you have a particular testing strategy in mind, you can certainly write your own test cases and try them. The idea is that test cases are cheap, and generating lots of them is an easy way of getting good test coverage.

### Security Regression Tests

What regresses, never progresses.

—Umar ibn al-Khattâb

Once identified and fixed, security vulnerabilities are the last bugs we want to come back and bite us again. Yet this does happen, more often than it should, and when it does it’s a clear indication of insufficient security testing. When responding to a newly discovered security vulnerability, an important best practice is to create a security regression test that detects the underlying bug or bugs. This serves as a handy repro (a test case that reproduces the bug or bugs) as well as confirms that the fix actually eliminates the vulnerability.

That’s the idea, anyway, but this practice seems to be less than diligently followed, even by the largest and most sophisticated software makers. For example, when Apple released iOS 12.4 in 2019, it reintroduced a bug identical to one already found and fixed in iOS 12.3, immediately re-enabling a vulnerability after that door should have been firmly closed. Had the original fix included a security regression test case, this should never have happened.

It’s notable that in some cases security regressions can be far worse than new vulnerabilities. That iOS regression was particularly painful because the bug was already familiar to the security research community, so they quickly adapted the existing jailbreak tool built for iOS 12.3 to work on iOS 12.4 (a jailbreak is an escalation of privilege circumventing restrictions imposed by the maker limiting what the user can do on their device).

I recommend writing the test case first, before tackling the actual fix. In an emergency, you might prioritize the fix if it’s clear-cut, but unless you’re working solo, having someone develop the regression test in parallel is a good practice. In the process of developing an effective regression test,

<!-- Source S12, PDF page 12 -->

you may learn more about the issue and even get clues about related potential vulnerabilities.

A good security regression test should try more than a single specific test case that’s identical to a known attack; it should be more general. For example, for the SQL injection attack described in Chapter 10, it wouldn’t be sufficient to just test that the one known “Bobby Tables” attack now fails. Also try an excessively long name, which might suggest that input validation needs to length-check name input strings, too. Try variants on the attack, such as using a double quote instead of single quote, or a backslash (the SQL string escape character) at the end of the name. Also try similar attacks in other columns of the same table, or other tables. Just as you wouldn’t fix the SQL injection bug by narrowly rejecting only names beginning with `Robert');`, even though it would stop that specific attack, you shouldn’t write regression tests that way either.

In addition to addressing the newly discovered vulnerability, it’s common that the investigation will suggest similar vulnerabilities elsewhere in the system that might also be exploitable. Use your superior knowledge of system internals and familiarity with the source code to stay ahead of potential adversaries. If possible, probe for the presence of similar bugs immediately, so you can fix them as part of the update that closes the original vulnerability. This can be important, since you can bet that attackers will also be thinking along these lines, and releasing a fix will be a big clue about new ways they might target your system. If there is no time to explore all the leads, file away the details for investigation later, when time permits.

As an example, let’s consider how to write a security regression test for the Heartbleed vulnerability from Chapter 9. Recall that the exploit worked by sending a packet containing a payload of arbitrary bytes with a much larger byte count; the server response honored the byte count and sent back additional memory contents, often causing a serious internal data leak.

The correct behavior is to ignore such invalid requests. Some good security regression test cases include:

• Test that known exploit requests no longer receive a response. • Test with request byte counts greater than 16,384 (the maximum). • Test requests with payloads of 0 bytes and the maximum byte size. • Investigate whether other types of packets in the TLS protocol could have similar issues, and if so test those as well.

### Availability Testing

Worry about being unavailable; worry about being absent or fraudulent.

—Anne Lamott

DoS attacks represent a unique potential threat because the load limits that systems should be able to sustain are difficult to characterize. In particular, the term load packs a lot of meaning in that statement, including:

<!-- Source S12, PDF page 13 -->

processing power, memory consumption, operating system resources, network bandwidth, disk space, and other potential bottlenecks (recall the entropy pool of a CSPRNG from Chapter 5). Operations staff typically monitor these factors in response to production use, but there are a few cases where security testing can avert attacks that intentionally exploit performance vulnerabilities.

Security testing should include test cases for identifying code that may be subject to nonlinear performance degradation. We saw some examples of this kind of vulnerability in Chapter 10, when we considered backtracking regex and XML entity expansion blow-ups. Since these can adversely impact performance exponentially, they are particularly potent vulnerabilities. Of course, these are just two instances of a larger phenomenon, and the same issue can occur in all kinds of code.

The next sections explain two basic strategies to test for this kind of problem: measuring the performance of specific functionality and monitoring overall performance against various loads.

### Resource Consumption

For functionality that you know may be susceptible to an availability attack, add security test cases that measure and determine a sensible limit on the input to protect blow-ups from occurring. Then test further to ensure that input validation prevents larger inputs from overloading the system.

For example, in the case of a backtracking regex, you could test with strings of length N and N+1 to estimate the geometric rate at which the computation time grows. Use that factor to extrapolate the time required for the longest valid input, and then check that it’s under the maximum threshold to pass the test.

For the sake of argument, let’s say that N = 20 takes 1 second and N = 21 takes 2 seconds, so the additional character doubles the runtime. If the maximum input length is 30 characters, you can estimate this will take 1,024 (210) seconds to process and decide if this is feasible or not. By extrapolating the processing time mathematically instead of actually executing the N = 30 case, you can avoid an extremely slow-running test case. However, bear in mind that actual performance times may depend on other factors, so more than two measurements may be necessary to validate a suitable model.

In addition to this kind of targeted testing, measure performance metrics for the overall system and set generous upper limits so that if an iteration causes a significant degradation, the test will flag it for inspection. Often, these measurements can be easily added to existing larger tests, including smoke tests, load tests, and compatibility tests.

One easy technique to guard against a code change causing dramatic increases in memory consumption is to run tests under artificially resourceconstrained conditions. Memory here refers to stack and heap space, swap space, disk file and database, and so forth. Unit tests should run with little available memory; if the test suite ever hits the limit, that’s worth investigating. Larger integration tests will need resources comparable to those

<!-- Source S12, PDF page 14 -->

available in production, and when run with minimal headroom they can serve as a “canary in the coal mine.” For example, if you can test the system successfully with 80 percent of the memory available in production, that provides some assurance of 20 percent headroom (excess capacity).

### Threshold Testing

One important but easily overlooked protection of system availability is to establish warning signs before fundamental limits are reached. A classic example of exceeding such a limit happened to a well-known software company not long ago, when the 32-bit counter that assigned unique IDs to the objects that the system managed wrapped from 2,147,483,647 to 0, resulting in the IDs of low-numbered objects being duplicated. It took hours to remedy the problem—a disaster that could easily have been averted by monitoring for the counter approaching its limit and issuing a warning when it reached, say, `0.99*INT_MAX`. Surely, in the early days of the product, it was difficult to imagine the counter ever reaching its maximum, but as the company grew and the prospect became a potential issue, nobody considered the possibility.

Warnings for such thresholds are often considered the responsibility of operational monitoring rather than security tests, but these are so often missed, and so easy to fix, that covering these eventualities under both categories is often worthwhile. Be sure to also watch out for other limits where the system will hit a brick wall, not just counters.

Storage capacity is another area where you’ll want significant advance warning, allowing you to respond smoothly. Rather than setting arbitrary thresholds, such as 99 percent of the limit, a more useful calculation looks at a time series (a set of measurements over time) and extrapolates the time it will take to reach the limit.

Don’t forget to stay ahead of time limits, too. The expiration dates of digital certificates are easily ignored until suddenly they fail to validate. Systems that rely on the certificates of partners that supply data feeds should monitor those and provide a heads-up in order to avoid an outage that, to your customers, will look like your problem.

The “Y2K bug” is now a distant memory of a non-event (possibly due to the extraordinary efforts made at the time to avoid the chaos that might have ensued in computer systems that stored years as two-digit values when the year changed from 1999 to 2000). However, we now have the “Y2k38 bug” to look forward to on January 19, 2038, when 2,147,483,647 seconds will have passed since 00:00:00 UTC on January 1, 1970 (the Unix epoch, as referenced in Figure 12-1). In less than two decades we will reach a point where the number of seconds elapsed since the epoch overflows the range of a 32-bit number, and this is almost certain to manifest all manner of nasty bugs. If it’s too soon to instrument your codebase for this, when is the right time?

<!-- Source S12, PDF page 15 -->

![Figure 12-1: Bug (courtesy of Randall Munroe, xkcd.com/376 )](/.attachments/12-1-Designing.Secure.Software-2021-12.png)

*Figure 12-1: Bug (courtesy of Randall Munroe, xkcd.com/376 )*

<!-- Source: Designing.Secure.Software-2021-12.pdf, PDF page 15. -->

### Distributed Denial-of-Service Attacks

Denial-of-service (DoS) attacks are single actions that adversely impact availability; distributed denial-of-service (DDoS) attacks accomplish this through the cumulative effect of a number of concerted actions. For internetconnected systems, the open architecture of the internet creates an additional risk of DDoS attacks, such as from a coordinated botnet. Brute-force overloading from distributed anonymous sources generally ends up as a contest of scale of computing power. Mitigating these attacks typically requires reliance on DDoS protection vendors that have networking expertise backed by massive datacenter capacity.

I point this out as separate from the other categories of availability threats because this isn’t something you can easily mitigate on your own should your server be unfortunate enough to become a target of a serious DDoS attack.

### Best Practices for Security Testing

Writing solid security test cases is an important way to improve the security of any codebase. While security test cases can’t guarantee perfect security, they confirm that your protections and mitigations are working, and are thus a significant step in the right direction. A robust suite of security test cases, combined with security regression tests, dramatically lowers the chances of a major security lapse.

### Test-Driven Development

Security test cases are especially important when you’re writing critical code and thinking through its security implications. I strongly endorse test-driven development (TDD), where you write test cases concurrently with new code—rigorous practitioners of this method actually make the tests first, only authoring new code in order to fix the initially failing tests. TDD with

<!-- Source S12, PDF page 16 -->

security test cases included from the start ensures that security is built into the code, rather than as an afterthought, but whatever methodology you use for testing, security test cases need to be part of your test suite.

If others write the tests, developers should provide guidance that describes the security test cases needed, because they can be harder to intuit without a solid understanding of the security demands on the code.

### Leveraging Integration Testing

Integration testing puts systems through their paces to ensure that all the components, already unit-tested individually, work together as they should. These are important tests for quality assurance purposes—but once you’ve invested the effort, it’s easy to extend them for a little security testing, too.

In 2018, a major social media platform advised its customers to change their passwords due to a self-inflicted breach of security: a bug had caused account passwords to spew into an internal log in plaintext. By leveraging integration tests, they could easily have detected and fixed the code that introduced this vulnerability before it was released to production. Integration tests for this service should have included logging in with a fake user account, say, `USER1`, with some password, such as `/123!abc$XYZ` (even fake accounts should have secure passwords). After the test completed, a security test would scan the outputs for that distinctive password string and raise an error if it found any matches. This testing approach applies not just to log files, but to anywhere a potential leak could occur: in other residual files, publicly accessible web pages, client caches, and so forth. Tests like this can be as simple as a `grep(1)` command.

Passwords are a convenient example for explanatory purposes, but this technique applies to any private data. Test systems require a bunch of synthetic data to stand in for actual user data in production, and all of that private content could potentially leak in just the same way. A more comprehensive leak test would scan all system outputs not explicitly protected as confidential for any traces of test input data that are private.

### Security Testing Catch-Up

If you are working on a codebase bereft of security test cases, assuming that security is a priority, there is some important work that needs doing. If there is a design that considers security that has been threat modeled and reviewed, use it as a map of what code deserves attention first. It’s usually wise to divide the job into pieces with incremental milestones, do an achievable first iteration or two, and then assess the remaining need as you work through the tasks.

Target the protection mechanisms and functional areas in order of importance, letting the code guide you in determining what needs testing. Review existing test cases, as some may already do some security testing or be close enough to easily adapt for security. If someone is new to the project and needs to learn the code, have them write some of the security test cases; this is a great way to educate them and will produce lasting value.
