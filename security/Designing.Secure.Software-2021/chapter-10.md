# Chapter 10

## Designing Secure Software-2021

Source: [Designing.Secure.Software-2021-10.pdf](Designing.Secure.Software-2021-10.pdf) — 18 PDF pages.

<!-- Source S10, PDF page 1 -->

### Untrusted Input

I like engineering, but I love the creative input.

—John Dykstra

> [Decorative chapter-opening artwork placeholder — source S10, PDF page 1.]

Untrusted inputs are perhaps the greatest source of concern for developers writing secure code. The term itself can be confusing, and may best be understood as encompassing all inputs to a system that are not trusted inputs, meaning inputs from code that you can trust to provide well-formed data. Untrusted inputs are those that are out of your control and might be manipulated, and include any data entering the system that you do not fully trust. That is, they’re inputs you should not trust, not inputs you mistakenly trust.

Any data coming from the outside and entering the system is best considered untrusted. The system’s users may be nice, trustworthy people, but when it comes to security they are best considered untrusted, because they could do anything—including falling victim to the tricks of others. Untrusted inputs

<!-- Source S10, PDF page 2 -->

are worrisome because they represent an attack vector, a way to reach into the system and cause trouble. Maliciously concocted inputs that cross trust boundaries are of special concern because they can penetrate deep into the system, causing exploits in privileged code, so it’s essential to have good first lines of defense. The world’s greatest source of untrusted inputs has to be the internet, and since it’s so rare for software to be fully disconnected, this represents a serious threat for almost all systems.

Input validation (or input sanitization) is defensive coding that imposes restrictions on inputs, forcing conformity to prescribed rules. By validating that inputs meet specific constraints and ensuring that code works properly for all valid inputs, you can successfully defend against these attacks. This chapter centers on managing untrusted inputs using input validation, and why doing so is important to security. The topic may seem mundane and it isn’t technically difficult, but the need is so commonplace that doing a better job at input validation is perhaps the most impactful low-hanging fruit available to developers for reducing vulnerabilities. As such, it’s covered in depth. Character string inputs present specific challenges and the security implications of Unicode are too little known, so we’ll also survey the basic issues they present. Then we’ll walk through some examples of injection attacks perpetrated using untrusted data with various technologies: SQL, path traversal, regular expressions, and XML external entities (XXE). Finally, I’ll summarize the available mitigation techniques for this broad set of vulnerabilities.

### Input Validation

Before you look for validation in others, try and find it in yourself.

—Greg Behrendt

Now that you understand what untrusted inputs are, consider their potential effects within a system and how to protect against harm. Untrusted inputs routinely flow through systems, often reaching down many layers into trusted components—so just because your code is directly invoked from trusted code, there is no guarantee that those inputs can be trusted. The problem is that components might be passing through data from anywhere. The more ways an attacker can potentially manipulate the data, the more untrusted it is. Upcoming examples should make this point clear.

Input validation is a good defense, as it dials untrusted input down to a range of values that the application can safely process. The essential job of input validation is to ensure that untrusted inputs conform to design specifications so that code downstream of the validation only deals with well-formed data. Let’s say you are writing a user login authentication service that receives a username and password, and issues an authentication token if the credentials are correct. By restricting usernames to between 8 and 40 characters and requiring that they consist of a well-defined subset of Unicode code points, you can make the handling of that input much simpler, because it’s a known quantity. Subsequent code can use fixed-size

<!-- Source S10, PDF page 3 -->

buffers to hold a copy of the username, and it need not worry about the ramifications of obscure characters. You could likely simplify processing based on that assurance in other ways, too.

We have already seen input validation used to fix low-level vulnerabilities in the previous chapter. The paycheck integer computation code had input validation consisting of one `if` statement to guard against overly large input values:

```text
if (millihours > max_millihours       // 100 hours max
    || hourlycents > max_hourlycents) // $200/hour rate

return 0;
```

There’s no need to repeat the explanation for this, but it serves as a fine example of basic input validation. Almost any code you write will only work correctly within certain limitations: it won’t work for extreme values such as massive memory sizes, or perhaps text in different languages. Whatever the limitations are, we don’t want to expose code to inputs it wasn’t designed for, as this risks unintended consequences that could create vulnerabilities. One easy method to mitigate this danger is to impose artificial restrictions on inputs that screen out all problematic inputs.

There are some nuances worth pointing out, however. Of course, restrictions should never reject inputs that should have been rightfully handled; for instance, in the paycheck example, we cannot reject 40-hour work weeks as invalid. If the code cannot handle all valid inputs, then we need to fix it so it can handle a broader scope of inputs. Also, an input validation strategy may need to consider the interaction of multiple inputs. In the paycheck example, the product of the pay rate and hours worked could exceed the fixed-width integer size, as we saw in Chapter 9, so validation could limit the product of these two inputs, or set limits on each separately. The former approach is more permissive but may be more difficult for callers to accommodate, so the right choice depends on the application.

Generally, you should validate untrusted inputs as soon as possible, so as to minimize the risk of unconstrained input flowing to downstream code that may not handle it properly. Once validated, subsequent code benefits from only being exposed to well-behaved data; this helps developers write secure code, because they know exactly what the range of inputs will be. Consistency is key, so a good pattern is to stage input validation in the first layer of code that handles incoming data, then hand the valid input off to business logic in deeper layers that can confidently assume that all inputs are valid.

We primarily think of input validation as a defense against untrusted inputs—specifically, what’s on the attack surface—but this does not mean that all other inputs can be blithely ignored. No matter how much you trust the provider of some data, it may be possible for a mistake to result in unexpected inputs, or for an attack to somehow compromise part of the system and effectively expand the attack surface. For all of these reasons, defensive input validation is your friend. It’s safest to err on the side of redundant

<!-- Source S10, PDF page 4 -->

input validation rather than risk creating a subtle vulnerability—if you don’t know for certain that incoming data is reliably validated, you probably need to do it to be sure.

### Determining Validity

Input validation begins with deciding what’s valid. This is not as straightforward as it sounds, because it amounts to anticipating all future valid input values and figuring out how, with good reason, to disallow the rest. This decision is usually made by the developer, who must weigh what users may want against the extra coding involved in permitting a wider range. Ideally, software requirements specify what constitutes valid input, and a good design may provide guidance.

For an integer input, the full range of 32-bit integers may appear to be an obvious choice because it’s a standard data type. But thinking ahead, if the code will add these values together at some point, that’ll require a bigger integer, so the 32-bit restriction becomes arbitrary. Alternatively, if you can reasonably set a lower limit for validity, then you can make sure the sum of the values will fit into 32 bits. Determining the right answer for what constitutes a valid input will require examining the application-specific context—a great example of how domain knowledge is important to security. Once the range of values deemed valid is specified, it’s easy to determine the appropriate data type to use.

What usually works well is to establish an explicit limit on inputs and then leave plenty of headroom in the implementation to be certain of correctly processing all valid inputs. By headroom, I mean if you are copying a text string into a 4,096-byte buffer, use 4,000 bytes as the maximum valid length so you have a little room to spare. (In C, the additional null terminator overflowing a buffer by one byte is a classic mistake that’s easy to make.) Some programmers like a good challenge, but if you’re too generous (by allowing the widest possible range of input), then you are forcing the implementation to take on a bigger and harder job than is necessary, leading to greater code complexity and test burden. Even if your online shopping application can manage a cart with a billion items, attempting to process such an unrealistic transaction would be counterproductive. It would be kindest to reject the input (which may well be due to somebody’s cat sitting on their keyboard).

### Validation Criteria

Most input validation checks consist of several criteria, including ensuring the input doesn’t exceed a maximum size, that the data arrives in the proper format, and that it’s within a range of acceptable values.

Checking the value’s size is a quick test primarily intended to avoid DoS threats to your code, which would cause your application to lumber or even crash under the weight of megabytes of untrusted input. The data format may be a sequence of digits for a number, strings consisting of certain allowed characters, or a more involved format, such as XML or JSON. Typically, it’s wise to check these in this order: limit size first, so you don’t

<!-- Source S10, PDF page 5 -->

waste time trying to deal with excessively massive inputs, then make sure the input is well formed before parsing it, and then check that the resulting value is within the acceptable range.

Deciding on a valid range of values can be the most subjective choice, but it’s important to have specific limits. How that range is defined will depend on the data type. For integers, the range will be no less than a minimum and no greater than a maximum value. For floating-point numbers, there may be limits on precision (decimal places) as well. For strings, it’s a maximum length, encoding, and usually an allowable format or syntax, as determined by a regular expression or the like. I recommend specifying maximum string lengths in characters rather than bytes, if only so that non-programmers have some hope of knowing what this constraint means.

It’s helpful to think about inputs as valid for a purpose, rather than in the abstract. For example, a language translation system might accept input that is first validated to conform to the supported character set and maximum length common to all supported languages. If the next processing stage analyzes the text to determine what language it is, having chosen the language you can then further restrict the text to the appropriate character set.

Or consider validating an integer input that represents the quantity of items ordered on a purchase invoice. The maximum quantity any customer might ever actually order is not easy to determine, but it’s a good question to consider up front. If you have access to past data, a quick SQL query might return an interesting example worth knowing for reference. While one could argue that the maximum 32-bit integer value is the least limiting and hence best choice, in practice this rarely makes much sense. Who wouldn’t consider an order of 4,294,967,295 of any product as anything but some sort of mistake? Since non-programmers are never going to remember such strange numbers derived from binary, choosing a more user-friendly limit, such as 1,000,000, makes more sense. Should anyone ever legitimately run up against such a limit, it probably is worth knowing about, and should be easy to adjust. What’s more, the developer will learn about a real use case in the process that was previously unimagined.

The primary purpose of input validation is to ensure that no invalid input gets past it. The simplest way to do this is to simply reject invalid inputs, as we have been doing implicitly in the discussion so far. A more forgiving alternative is to detect any invalid input and modify it into a valid form. Let’s look at these different approaches, and when to do which.

### Rejecting Invalid Input

Rejection of input that does not conform to specified rules is the simplest and arguably safest approach. Complete acceptance or rejection is cleanest and clearest, and usually easiest to get right. It’s like the common-sense advice for deciding if it’s safe to swim in the ocean: “When in doubt, don’t go out.” This can be as simple as refusing to process a web form if any field is improperly filled out, or as extreme as rejecting an entire batch of incoming data because of a single violation in some record.

<!-- Source S10, PDF page 6 -->

Whenever people are providing the input directly, such as in the case of a web form, it’s kindest to provide informative error messages, making it easy for them to correct their mistakes and resubmit. Users presumably submit invalid input either as a mistake or due to ignorance of the validation rules, neither of which is good. Calling a halt and asking the data source to provide valid input is the conservative way to do input validation, and it affords a good chance for regular providers to learn and adapt.

When input validation rejects bad input from people, best practices include:

• Explain what constitutes a valid entry as part of the user interface, saving at least those who read it from having to guess and retry. (How am I supposed to know that area codes should be hyphenated rather than parenthesized?) • Flag multiple errors at once, so they can be corrected and resubmitted in one step. • When people are directly providing the input, keep the rules simple and clear. • Break up complicated forms into parts, with a separate form for each part, so people can see that they’re making progress.

When inputs come from other computers, not directly from people, more rigid input validation may be wise. The best way to implement these requirements is by writing documentation precisely describing the expected input format and any other constraints. In the case of input from professionally run systems, fully rejecting an entire batch of inputs, rather than attempting to partially process the valid subset of data, may make the most sense, as it indicates something is out of spec. This allows the error to be corrected and the full dataset submitted again without needing to sort out what was or wasn’t processed.

### Correcting Invalid Input

Safe and simple as it may be to insist on receiving completely valid inputs and rejecting everything else, by no means is this always the best way to go. For online merchants seeking customers at all costs, rejecting inputs during checkout could lead to more instances of the dreaded “abandoned cart,” and lost sales. For interactive user input, rigid rules can be frustrating, so if the software can help the user provide valid input, it should.

If you don’t want to stop the show for a minor error, then your input validation code may attempt to correct the invalid inputs, transforming them into valid values instead of rejecting them. Easy examples of this include truncating long strings to whatever the maximum length is, or removing extraneous leading or trailing spaces. Other examples of correcting invalid inputs are more complicated. Consider the common example of entering a mailing address in the exact form allowed by the postal service. This is a considerable challenge because of the precise spacing, spelling of

<!-- Source S10, PDF page 7 -->

street names, and form of abbreviation expected. Just about the only way to do this is to offer best-guess matches of similar addresses in the official format for the respondent to choose from.

The best cure for tricky validation requirements is to design inputs to be as simple as possible. For example, many of us have struggled when providing phone numbers that require area codes in parentheses, or dashes in certain positions. Instead, let phone numbers be strings of digits and avoid syntax rules in the first place.

While adjustments may save time, any correction introduces the possibility that the correction will modify the input in an unintended fashion (from the user’s standpoint). Take the example of a telephone number form field where the input is expected to be 10 digits long. It should be safe to strip out common characters such as hyphens and accept the input if the result produces 10 valid digits, but if the input has too many digits, the user might have intended to provide an international number, or they might have made a typo. Either way, it probably isn’t safe to truncate it.

Proper input validation requires careful judgment, but it makes software systems much more reliable, and hence more secure. It reduces the problem space, eliminates needless tricky edge cases, improves testability, and results in the entire system being better defined and stable.

### Character String Vulnerabilities

If you are a programmer working in 2006 and you don’t know the basics of characters, character sets, encodings, and Unicode, and I catch you, I’m going to punish you by making you peel onions for six months in a submarine.

—Joel Spolsky

Nearly all software components process character strings, at least as command line parameters or when displaying output in legible form. Certain applications process character strings extensively; these include word processors, compilers, web servers and browsers, and many more. String processing is ubiquitous, so it’s important to be aware of the common security pitfalls involved. What follows is a sampling of the many issues to be aware of to avoid inadvertently creating vulnerabilities.

### Length Issues

Length is the first challenge because character strings are potentially of unbounded length. Extremely long strings invite buffer overflow when copied into fixed-length storage areas. Even if handled correctly, massive strings can result in performance problems if they consume excessive cycles or memory, potentially threatening availability. So, the first line of defense is to limit the length of incoming untrusted strings to reasonable sizes. At the risk of stating the obvious, don’t confuse character count with byte length when allocating buffers.

<!-- Source S10, PDF page 8 -->

### Unicode Issues

Modern software usually relies on Unicode, a rich character set that spans the world’s written languages, but the cost of this richness is a lot of hidden complexity that can be fertile ground for exploits. There are numerous character encodings to represent the world’s text as bytes, but most often software uses Unicode as a kind of lingua franca. The Unicode standard (version 13.0) is just over 1,000 pages long, specifying over 140,000 characters, canonicalization algorithms, legacy character code standard compatibility, and bidirectional language support; it covers nearly all the world’s written languages, encoding more than one million code points.

Unicode text has several different encodings that you need to be aware of. UTF-8 is the most common, but there are also UTF-7, UTF-16, and UTF-32 encodings. Accurately translating between bytes and characters is important for security, lest the contents of the text inadvertently morph in the process. Collation (sorted order) depends on the encoding and the language, which can create unintended results if you aren’t aware of it. Some operations may work differently in the context of a different locale, such as when run on a computer configured for another country or language, so it’s important to test for correctness in all these cases. When there is no need to support different locales, consider specifying the locale explicitly rather than inheriting an arbitrary one from the system configuration.

Because Unicode has many surprising features, the bottom line for security is to use a trustworthy library to handle character strings, rather than attempting to work on the bytes directly. You could say that in this regard, Unicode is analogous to cryptography in that it’s best to leave the heavy lifting to experts. If you don’t know what you are doing, some quirk of an obscure character or language you’ve never heard of might introduce a vulnerability. This section details some of the major issues that are well worth being aware of, but a comprehensive deep dive into the intricacies of Unicode would deserve a whole book. Detailed guidance about security considerations for developers who need to understand the finer points is available from the Unicode Consortium. UTR#36: Unicode Security Considerations is a good starting point.

### Encodings and Glyphs

Unicode encodes characters, not glyphs (rendered visual forms of characters). This simple dictum has many repercussions, but perhaps the easiest way to explain it is that the capital letter I (U+0049) and the Roman numeral one (U+2160) are separate characters that may appear as identical glyphs (called homomorphs). Web URLs support international languages, and the use of look-alike characters is a well-known trick that attackers use to fool users. Famously, someone got a legitimate server certificate using a Cyrillic character (U+0420) that looks just like the P in PayPal, creating a perfect phishing setup.

<!-- Source S10, PDF page 9 -->

Unicode includes combining characters that allow different representations for the same character. The Latin letter Ç (U+00C7) also has a two-character representation, consisting of a capital C (U+0043) followed by the “Combining Cedilla” character (U+0327). Both the one- and two-character forms display as the same glyph, and there is no semantic difference, so code should generally treat them as equivalent forms. The typical coding strategy would be to first normalize input strings to a canonical form, but unfortunately, Unicode has several kinds of normalization, so getting the details right requires further study.

### Case Change

Converting strings to upper- or lowercase is a common way of canonicalizing text so that code treats `test`, `TEST`, `tEsT`, and so forth as identical. Yet it turns out that there are characters beyond the English alphabet that have surprising properties under case transformations.

For example, the following strings are different yet nearly identical to casual observers: `'This ıs a test.'` and `'This is a test.'` (Note the missing dot over the second lowercase `i` in the first sentence.) Converted to uppercase, they both turn into the identical `'THIS IS A TEST.'` since the lowercase dotless `ı` (U+0131) and the familiar lowercase `i` (U+0069) both become uppercase `I` (U+0049). To see how this leads to a vulnerability, consider checking an input string for the presence of `<script>`: the code might convert to lowercase, scan for that substring, then convert to uppercase for output. The string `<scrıpt>` would slip through but appear as `<SCRIPT>` in the output, which could allow script injection on a web page—the very thing the code was trying to prevent.

### Injection Vulnerabilities

If you ever injected truth into politics you would have no politics.

—Will Rogers

Unsolicited credit card offers comprise a major chunk of the countless tons of junk mail that clog up the postal system, but one clever recipient managed to turn the tables on the bank. Instead of tossing out a promotional offer to sign up for a card with terms he did not like, Dmitry Agarkov scanned the attached contract and carefully modified the text to specify terms extremely favorable to him, including 0 percent interest, unlimited credit, and a generous payment that he would receive should the bank cancel the card. He signed the modified contract and returned it to the bank, and soon received his new credit card. Dmitry enjoyed the generous terms of his uniquely advantageous contract for a while, but things got ugly when the bank finally caught on. After a protracted legal battle that included a favorable judgment upholding the validity of the modified contract, he eventually settled out of court.

This is a real-world example of an injection attack: contracts are not the same as code, but they do compel the signatories to perform prescribed actions in much the same way as a program behaves. By altering the

<!-- Source S10, PDF page 10 -->

terms of the contract, Dmitry was able to force the bank to act against its will, almost as if he had modified the software that manages credit card accounts in his favor. Software is also susceptible to this sort of attack: untrusted inputs can fool it into doing unexpected things, and this is actually a fairly common vulnerability.

There is a common software technique that works by constructing a string or data structure that encodes an operation to be performed, and then executing that to accomplish the specified task. (This is analogous to the bank writing a contract that defines how its credit card service operates, expecting the terms to be accepted unchanged.) When data from an untrusted source is involved, it may be able to influence what happens upon execution. If the attacker can change the intended effect of the operation, that influence may cross a trust boundary and get executed by software at a higher privilege. This is the idea of injection attacks in the abstract.

Before explaining the specifics of some common injection attacks, let’s consider a simple example of how the influence of untrusted data can be deceptive. According to an apocryphal story, just this kind of confusion was exploited successfully by an intramural softball team that craftily chose the name “No Game Scheduled.” Several times opposing teams saw this name on the schedule, assumed it meant that there was no game that day, and lost by forfeit as no-shows. This is an example of an injection attack because the team name is an input to the scheduling system, but “No Game Scheduled” was misinterpreted as being a message from the scheduling system.

The same injection attack principles apply to many different technologies (that is, forms of constructed strings that represent an operation), including but not limited to:

• SQL statements • Filepath names • Regular expressions (as a DoS threat) • XML data (specifically, XXE declarations) • Shell commands • Interpreting strings as code (for example, JavaScript’s `eval` function) • HTML and HTTP headers (covered in Chapter 11)

The following sections explain the first four kinds of injection attacks in detail. Shell command and code injection work similarly to SQL injection, where sloppy string construction is exploitable by untrusted inputs. We’ll cover web injection attacks in the next chapter.

### SQL Injection

The classic xkcd comic #327 (Figure 10-1) portrays an audacious SQL injection attack, wherein parents give their child an unlikely and unpronounceable name that includes special characters. When entered into the local school district’s database, this name compromises the school’s records.

<!-- Source S10, PDF page 11 -->

> [Figure 10-1: Exploits of a Mom (courtesy of Randall Munroe, xkcd.com/327) — image placeholder; source S10, PDF page 11.]

To understand how this works, assume that the school registration system uses a SQL database and adds student records with a SQL statement of the form shown here:

```text
INSERT INTO Students (name) VALUES ('Robert');
```

In this simplified example, that statement adds the name “Robert” to the database. (In practice, more columns than just `name` would appear in the two sets of parenthesized lists; those are omitted here for simplicity.)

Now imagine a student with the ludicrous name of `Robert'); DROP TABLE` `students;--`. Consider the resultant SQL command, with the parts corresponding to the student’s name highlighted:

```text
INSERT INTO Students (name) VALUES ('Robert'); DROP TABLE Students;--');
```

According to SQL command syntax rules, this string actually contains two statements:

```text
INSERT INTO Students (name) VALUES ('Robert');
DROP TABLE Students; --');
```

The first of these two SQL commands inserts a “Robert” record as intended. However, since the student’s name contains SQL syntax, it also injects a second, unintended command, `DROP TABLE`, that deletes the entire table. The double dashes denote a comment, so the SQL engine ignores the following text. This trick allows the exploit to work by consuming the trailing syntax (single quote and close parenthesis) in order to avoid a syntax error that would prevent execution.

Now let’s look at the code a little more closely to see what a SQL injection vulnerability looks like and how to prevent it. The hypothetical school registration system code works by forming SQL commands as text strings, such as in the first basic example we covered, and then executing them. The input data provides names and other information to fill out student records. In theory, we can even suppose that staff verified this input against official records to ensure their accuracy (assuming, with a large grain of salt, that legal names can include ASCII special characters).

<!-- Source S10, PDF page 12 -->

The programmer’s fatal mistake was in writing a string concatenation statement such as the following without considering that an unusual name could “break out” of the single quotes:

```text
vulnerable code
                sql_stmt = "INSERT INTO Students (name) VALUES ('" + student_name + "');";
```

Mitigating injection attacks is not hard but requires vigilance, lest you get sloppy and write code like this. Mixing untrusted inputs and command strings is the root cause of the vulnerability, because those inputs can break out of the quotes with unintended harmful consequences.

Determining what strings constitute a valid name is an important requirements issue, but let’s just focus on the apostrophe character used in this SQL statement as a single quote. Since there are names (such as O’Brien) that contain the apostrophe, which is key to cracking open the SQL command syntax, the application cannot forbid this character as part of input validation. This name could be correctly written as the quoted string `'O''Brien'`, but there could be many other special characters requiring special treatment to effectively eliminate the vulnerability in a complete solution.

As a further defense, you should configure the SQL database such that the software registering students does not have the administrative privileges to delete any tables, which it does not need to do its job. (This is an example of the “Least Privilege” pattern from Chapter 4.)

Rather than “reinventing the wheel” with custom SQL sanitization code, the best practice is to use a library intended to construct SQL commands to handle these problems. If a trustworthy library isn’t available, create test cases to ensure that attempted injection attacks are either rejected or safely processed, and that everything works for students with names like O’Brien.

Here are a few simple Python code snippets showing the wrong and then the right way to do this. First is the wrong way, using a mock-up of the Bobby Tables attack:

```text
vulnerable code
                import sqlite3
                con = sqlite3.connect('school.db')
                student_name = "Robert'); DROP TABLE Students;--"
                # The WRONG way to query the database follows:
                sql_stmt = "INSERT INTO Students (name) VALUES ('" + student_name + "');"
                con.executescript(sql_stmt)
```

After creating a connection (`con`) to the SQL database, the code assigns the student’s name to the variable `student_name`. Next, the code constructs the SQL `INSERT` statement by plugging the string `student_name` into the `VALUES` list and assigning that to `sql_stmt`. Finally, that string is executed as a SQL script.

The right way to handle this is to let the library insert parameters involving untrusted data, as shown in the following code snippet:

```text
fixed code
            import sqlite3
            con = sqlite3.connect('school.db')
            student_name = "Robert'); DROP TABLE Students;--"
            # The RIGHT way to query the database follows:
            con.execute("INSERT INTO Students (name) VALUES (?)", (student_name,))
```

<!-- Source S10, PDF page 13 -->

In this implementation, the `?` placeholder is filled in from the following tuple parameter consisting of the `student_name` string. Note that there are no quotes required within the `INSERT` statement string—that’s all handled for you. This syntax avoids the injection and safely enters Bobby’s strange name into the database.

There is a detail in this example that deserves clarification. Making the original exploit work requires the `executescript` library function, because `execute` only accepts a single statement, which serves as a kind of a defense against this particular attack. However, it would be a mistake to think that all injection attacks involve additional commands, and that this limitation confers much protection. For example, suppose there’s another student with a different unpronounceable name at the school, `Robert', 'A+');--`. He and plain old Robert are both failing—but when his grades are recorded in another SQL table, his mark gets elevated to an A+. How so?

When plain old Robert’s grades are submitted using the vulnerable code, the command enters the intended grade of an F as follows:

```text
INSERT INTO Grades (name, grade) VALUES ('Robert', 'F');
```

But with the name `Robert', 'A+');--` that command becomes:

```text
INSERT INTO Grades (name, grade) VALUES ('Robert', 'A+');--', 'F');
```

One final remark is in order about xkcd’s “Little Bobby Tables” example that attentive readers may have noticed. Setting aside the absurdity of the premise, it is a remarkable coincidence that Bobby’s parents were able to foresee the arbitrarily chosen specific name of the database table (`Students`). This is best explained by artistic license.

### Path Traversal

Filepath traversals are a common vulnerability closely related to injection attacks. Instead of escaping from quotation marks, as we saw in the previous section’s examples, this attack escapes into parent directories to gain unexpected access to other parts of the filesystem. For example, to serve a collection of images, an implementation might collect image files in a directory named `/server/data/image_store` and then process requests for an image named `X` by fetching image data from the path formed from the (untrusted) input name `X`: `/server/data/image_store/X`.

The obvious attack would be requesting the name `../../secret/key`, which would return the file `/server/secret/key` that should have been private. Recall that . (dot) is a special name for the current directory and .. (dot-dot) is the parent directory that allows traversal toward the filesystem root, as shown by this sequence of equivalent pathnames:

```text
•
    /server/data/image_store/../../secret/key
•
    /server/data/../secret/key
•
    /server/secret/key
```

<!-- Source S10, PDF page 14 -->

The best way to secure against this kind of attack is to limit the character set allowed in the input (`X` in our example). Often, input validation ensuring that the input is an alphanumeric string suffices to completely close the door. This works well because it excludes the troublesome file separator and parent directory forms needed to escape from the intended part of the filesystem.

However, sometimes that approach is too limiting. When it’s necessary to handle arbitrary filenames this simple method is too restrictive, so you have more work to do (and it can get complicated because filesystems are complicated). Furthermore, if your code will run across different platforms, you need to be aware of possible filesystem differences (for example, the *nix path separator is a slash, but on Microsoft Windows it’s a backslash). Here is a simple example of a function that inspects input strings before using them as subpaths for accessing files in the directory that this Python code resides in (denoted by `__file__`). The idea is to provide access only to files in a certain directory or its subdirectories—but absolutely not to arbitrary files elsewhere. In the version shown here, the guard function `safe_path` checks the input for a leading slash (which goes to the filesystem root) or parent directory dot-dot and rejects inputs that contain these. To get this right you should work with paths using standard libraries, such as Python’s `os.path` suite of functionality, rather than ad hoc string manipulation. But this alone isn’t sufficient to ensure against breaking out of the intended directory:

```text
vulnerable code
                def safe_path(path):
                    """Checks that argument path is a safe file path. If not, returns None.
                    If safe, returns the normalized absolute file path.
                    """
                    if path.startswith('/') or path.startswith('..'):
                        return None
                    base_dir = os.path.dirname(os.path.abspath(__file__))
                    filepath = os.path.normpath(os.path.join(base_dir, path))
                    return filepath
```

The remaining hole in this protection is that the path can name a valid directory, and then go up to the parent directory, and so on to break out. For example, since the current directory this sample code runs in is five levels below the root, the path `./../../../../../etc/passwd` (with five dot-dots) resolves to the `/etc/passwd` file.

We could improve the string-based tests for invalid paths by rejecting any path containing dot-dot, but such an approach can be risky, since it’s hard to be certain that we’ve anticipated all possible tricks and completely blocked them. Instead, there’s a straightforward solution that relies on the `os.path` library, rather than constructing path strings with your own code:

<!-- Source S10, PDF page 15 -->

```text
fixed code
            def safe_path(path):
                """Checks that argument path is a safe file path. If not, returns None.
                If safe, returns the normalized absolute file path.
                """
                base_dir = os.path.dirname(os.path.abspath(__file__))
                filepath = os.path.normpath(os.path.join(base_dir, path))
                if base_dir != os.path.commonpath([base_dir, filepath]):
                    return None
                return filepath
```

This protection you can take to the bank, and here’s why. The base directory is a reliable path because there is no involvement of untrusted input: it’s fully derived from values completely under the programmer’s control. After joining with the input path string, that path gets normalized, which resolves any dot-dot parent references to produce an absolute path (`filepath`). Now we can check that the longest common subpath of these is the intended directory to which we want to restrict access.

### Regular Expressions

Efficient, flexible, and easy to use, a regex (regular expression) offers a remarkably wide range of functionality and is perhaps the most versatile tool we have for parsing text strings. They’re generally faster (both to code and execute) than ad hoc code, and more reliable. Regex libraries compile state tables that an interpreter (a finite state machine or similar automaton) executes to match against a string.

Even if your regex is correctly constructed it can cause security issues, as some regular expressions are prone to excessive execution times, and if attackers can trigger these they can cause a serious DoS. Specifically, execution time can balloon if the regex incurs backtracking—that is, when it scans forward a long way, then needs to go back and rescan over and over to find a match. The security danger generally results from allowing untrusted inputs to specify the regex; or, if the code already contains a backtracking regex, from an untrusted input that supplies a long worst-case string that maximizes the computational effort.

A backtracking regex can look innocuous, as an example will demonstrate. The following Python code takes more than three seconds to run on my modest Raspberry Pi Model 4B. Your processor is likely much faster, but since each `D` added to the 24 in the example doubles the running time, it isn’t hard to lock up any processor with a slightly longer string:

```text
import re
print(re.match(r'(D+)+$', 'DDDDDDDDDDDDDDDDDDDDDDDD!'))
```

<!-- Source S10, PDF page 16 -->

The danger of excessive runtime exists with any kind of parsing of untrusted inputs, in cases where backtracking or other nonlinear computations can blow up. In the next section you’ll see an XML entity example along these lines, and there are many more.

The best way to mitigate these issues depends on the specific computation, but there are several general approaches to countering these attacks. Avoid letting untrusted inputs influence computations that have the potential to blow up. In the case of regular expressions, don’t let untrusted inputs define the regex, avoid backtracking if possible, and limit the length of the string that the regex matches against. Figure out what the worst-case computation could be, and then test it to ensure that it’s not excessively slow.

### Dangers of XML

XML is one of the most popular ways to represent structured data, as it is powerful as well as human-readable. However, you should be aware that the power of XML can also be weaponized. There are two major ways that untrusted XML can cause harm using XML entities.

XML entity declarations are a relatively obscure feature, and unfortunately, attackers have been creative in finding ways of abusing these. In the example that follows, a named entity `big1` is defined as a four-character string. Another named entity, `big2`, is defined as eight instances of `big1` (a total of 32 characters), and `big3` is eight more of those, and so on. By the time you get up to `big7`, you’re dealing with a megabyte of data, and it’s easy to go on up from there. This example concocts an 8-megabyte chunk of XML. As you can see, you would need to add only a few lines to go into the gigabytes:

```text
<!DOCTYPE dtd[
  <!ENTITY big1 "big!">
  <!ENTITY big2 "&big1;&big1;&big1;&big1;&big1;&big1;&big1;&big1;">
  <!ENTITY big3 "&big2;&big2;&big2;&big2;&big2;&big2;&big2;&big2;">
  <!ENTITY big4 "&big3;&big3;&big3;&big3;&big3;&big3;&big3;&big3;">
  <!ENTITY big5 "&big4;&big4;&big4;&big4;&big4;&big4;&big4;&big4;">
  <!ENTITY big6 "&big5;&big5;&big5;&big5;&big5;&big5;&big5;&big5;">
  <!ENTITY big7 "&big6;&big6;&big6;&big6;&big6;&big6;&big6;&big6;">
]>
<mega>&big7;&big7;&big7;&big7;&big7;&big7;&big7;&big7;</mega>
```

More tricks are possible with external entity declarations. Consider the following:

```text
  <!ENTITY snoop SYSTEM "file:///etc/passwd>" >
```

This does exactly what you would think: reads the password file and makes its contents available wherever `&snoop;` appears in the XML henceforth. If the attacker can present this as XML and then see the result of the entity expansion, they can disclose the contents of any file they can name.

Your first line of defense against these sorts of problems will be keeping untrusted inputs out of any XML that your code processes. Some modern

<!-- Source S10, PDF page 17 -->

libraries check for just this kind of attack, but you should check to be sure if you need to rely on it. If you don’t need XML external entities, then protect against this sort of attack by excluding them from inputs, or by disabling the processing of such declarations.

### Mitigating Injection Attacks

Just as various kinds of injection attacks rely on the common trick of using untrusted inputs to influence statements or commands that execute in the context of the application, mitigations for these issues also have common threads, though the details do vary. Input validation is always a good first line of defense, but depending on what allowable inputs may consist of, that alone is not necessarily enough.

Avoid attempting to insert untrusted data into constructed strings for execution, for instance as commands. Modern libraries for SQL and other functionality susceptible to injection attacks should provide helper functions that allow you to pass in data separately from the command. These functions handle quoting, escaping, or whatever it takes to safely perform the intended operation for all inputs. I recommend checking for a specific note about security in the library’s documentation, as there do exist slipshod implementations that just slap strings together and will be liable to injection attacks under the facade of the API. When in doubt, a security test case (see Chapter 12) is a good way to sanity-check this.

If you cannot, or will not, use a secure library—although, again, I caution against the slippery slope of “what could possibly go wrong?” thinking—first consider finding an alternative way to avoid the risk of injection. Instead of constructing a *nix `ls` command to enumerate the contents of a directory, use a system call. The reasoning behind this is clear: all that `readdir(3)` can possibly do is return directory entry information; by contrast, invoking a shell command could potentially do just about anything.

Using the filesystem as a homemade datastore may be the quickest solution in some cases, but I can hardly recommend it as a secure approach. If you insist on doing it the risky way, don’t underestimate the work required to anticipate and then block all potential attacks in order to fully secure it. Input validation is your friend here; if you can constrain the string to a safe character set (for example, names consisting only of ASCII alphanumerics), then you may be all right. As an additional layer of defense, study the syntax of the command or statement you are forming and be sure to apply all the necessary quoting or escaping to ensure nothing goes wrong. It’s worth reading the applicable specifications carefully, as there may be obscure forms you are unaware of.

The good news is that the dangerous operations where injections become a risk are often easy to scan for in source code. Check that SQL commands are safely constructed using parameters, rather than as ad hoc strings. For shell command injections, watch for uses of `exec(3)` and its variants, and be sure to properly quote command arguments (Python provides `shlex.quote`

<!-- Source S10, PDF page 18 -->

for exactly this purpose). In JavaScript, review uses of `eval` and either safely restrict them or consider not using it when untrusted inputs could possibly influence the constructed expression.

This chapter covered a number of injection attacks and related common vulnerabilities, but injection is a very flexible method that can appear in many guises. In the following chapter we will see it again (twice), in the context of web vulnerabilities.
