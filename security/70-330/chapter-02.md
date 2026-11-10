# Chapter 2

<a id="section-1"></a>

## Implementing Security for Applications-2005

Source: [Implementing.Security.for.Applications-2005-2-1.pdf](Implementing.Security.for.Applications-2005-2-1.pdf) — section 1, 17 pages.

<!-- Section 1, PDF page 1 -->

### Lesson 1: Validating Input

Treat all input as hostile. All input, whether received directly from a user or from another application, must go through a three-step validation process before being considered safe by your application. This lesson describes techniques for implementing each of these three phases in your application:

1. Constrain Reject input unless it meets your expectations for type, length, format, and range.

2. Reject Reject input that meets the constraining requirements and contains known malicious values and phrases.

3. Sanitize Filter out characters nested within input that might have a special meaning when processed by your application or end users.

Figure 2-1 shows the input validation process.

> [Figure 2-1 placeholder — Use a three-step process to validate input. Source: section 1 source PDF above, PDF page 1.]

<!-- Section 1, PDF page 2 -->

After this lesson, you will be able to

- Constrain most invalid input by allowing only valid formats, types, lengths, and ranges.

- Reject malicious input by examining input for specific characters and phrases.

- Sanitize valid input that contains characters that have the potential to interrupt normal application processing.

Estimated lesson time: 35 minutes

### Guidelines for Constraining Input

Start the input validation process by constraining input and checking for known good data by validating for type, length, format, and range. There are several different techniques for validating data, including using regular expressions, strong types, ASP.NET validator controls, typed data expressions, and the String.Length property. Use regular expressions to constrain string input, or use the String.Length property when you are only checking the length. Use strong types to constrain input other than strings, such as numbers and dates, and use typed data comparisons to limit their range. When creating a Web application, use regular expressions to validate input without writing code by using ASP.NET validator controls.

Options for Constraining Data Table 2-1 summarizes the options that are available for constraining and sanitizing data.

**Table 2-1    Options for Constraining Data**

| Data Checks | Validation Technique |
| --- | --- |
| Type checks | • Strong types • Regular expressions • ASP.NET validator controls |
| Length checks | • Regular expressions • String.Length property |
| Format checks | • Strong types • Regular expressions |
| Range checks | • ASP.NET validator controls • Typed data comparisons |

<!-- Section 1, PDF page 3 -->

### Use Regular Expressions to Constrain String Input

When building security into your application, regular expressions are the most efficient way to validate user input. If you build an application that accepts a five-digit number from a user, you can use a regular expression to ensure that the input is exactly five characters long and that each character is a number between 0 and 9, inclusive. Similarly, when prompting a user for her first and last name, you can check her input with a regular expression and throw an exception when the input contains numbers, delimiters, or any other non-alphabetic character.

Tip A regular expression is a set of characters that can be compared with a string to determine whether the string meets specified format requirements. For example, you can create regular expressions that match strings consisting entirely of integers, strings that contain only lowercase letters, or strings that match hexadecimal input. Regular expressions have been used for decades in tools like the Unix console tool grep, and the scripting language Perl. The .NET Framework also supports regular expressions.

The .NET Framework classes that perform the parsing of regular expressions are contained within the System.Text.RegularExpressions assembly. To demonstrate how regular expressions can be used, create a console application named TestRegExp that accepts two strings as input and determines whether the first string (a regular expression) matches the second string. The following console application performs this check, and throws an exception when the input is invalid.

```text
using System;
        using System.Text.RegularExpressions;C#
        namespace TestRegExp
        {
            class Class1
            {
                 [STAThread]
                static void Main(string[] args)
                {
                    if (Regex.IsMatch(args[1], args[0]))
                    {
                        Console.WriteLine(“Input matches regular expression.”);
                    }
                    else
                    {
                        Console.WriteLine(“Input DOES NOT match regular expression.”);
                    }
                }
            }
        }
```

<!-- Section 1, PDF page 4 -->

```text
Imports System
        Imports System.Text.RegularExpressions
VB  Namespace TestRegExp
            Class Class1
                <STAThread> _
                Shared  Sub Main(ByVal args() As String)
                    If Regex.IsMatch(args(1),args(0)) Then
                        Console.WriteLine(“Input matches regular expression.”)
                    Else
                        Console.WriteLine(“Input DOES NOT match regular expression.”)
                    End If
                End Sub
            End Class
        End Namespace
```

Next, test the application by determining whether the regular expression “^\d{5}$” matches the string “12345” or “1234”. Your output should resemble the following:

```text
C:\>TestRegExp ^\d{5}$ 1234
        Input DOES NOT match regular expression.
```

```text
C:\>TestRegExp ^\d{5}$ 12345
        Input matches regular expression.
```

The simple TestRegExp application uses regular expressions without declaring any additional variables. However, the System.Text.RegularExpressions namespace provides a robust and flexible set of classes.

See Also For more information about the classes, search for the namespace within MSDN at http://msdn.microsoft.com/.

Understanding the syntax is the most complex part of using regular expressions. Table 2-2 contains the complete list of regular expression metacharacters and a detailed description of each. As you read the description of each of the metacharacters, use the TextRegExp application to experiment with how metacharacters can be used to match various types of input.

<!-- Section 1, PDF page 5 -->

Characters Used in Regular Expressions Table 2-2 describes the characters used in regular expressions.

**Table 2-2   Characters Used in Regular Expressions**

| Character | Description |
| --- | --- |
| &#92; | Marks the next character as either a special character, a literal, a back reference, or an octal escape. For example, “n” matches the character “n”. The sequence “&#92;n” matches a newline character. The sequence “&#92;&#92;” matches “&#92;”, and “&#92;(” matches “(”. |
| ^ | Matches the position at the beginning of the input string. If the RegExp object’s Multiline property is set, “^” also matches the position following “&#92;n” or “&#92;r”. |
| $ | Matches the position at the end of the input string. If the RegExp object’s Multiline property is set, “$” also matches the position preceding “&#92;n” or “&#92;r”. |
| &#42; | Matches the preceding character or subexpression, zero or more times. For example, “zo&#42;” matches “z” and “zoo”. The “&#42;” character is equivalent to “{0,}”. |
| + | Matches the preceding character or subexpression, one or more times. For example, “zo+” matches “zo” and “zoo”, but not “z”. The “+” character is equivalent to “{1,}”. |
| ? | Matches the preceding character or subexpression, zero or one time. For example, “do(es)?” matches the “do” in “do” or “does”. The ? character is equivalent to “{0,1}”. |
| {n} | The n is a non-negative integer. Matches exactly n times. For example, “o{2}” does not match the “o” in “Bob”, but does match the two “o”s in “food”. |
| {n,} | The n is a non-negative integer. Matches at least n times. For example, “o{2,}” does not match the “o” in “Bob” but does match all the “o”s in “foooood”. The sequence “o{1,}” is equivalent to “o+”. The sequence “o{0,}” is equivalent to “o&#42;”. |
| {n,m} | The m and n are non-negative integers, where “n &lt;= m”. Matches at least n and at most m times. For example, “o{1,3}” matches the first three “o”s in “fooooood”. “o{0,1}” is equivalent to “o?”. Note that you cannot put a space between the comma and the numbers. |
| ? | When this character immediately follows any of the other quantifiers (&#42;, +, ?, {n}, {n,}, {n,m}), the matching pattern is non-greedy. A non-greedy pattern matches as little of the searched string as possible, whereas the default greedy pattern matches as much of the searched string as possible. For example, in the string “oooo”, “o+?” matches a single “o”, whereas “o+” matches all “o”s. |
| . | Matches any single character except “&#92;n”. To match any character including the “&#92;n”, use a pattern such as “[&#92;s&#92;S]”. |

<!-- Section 1, PDF page 6 -->

**Table 2-2     Characters Used in Regular Expressions**

| Character | Description |
| --- | --- |
| (pattern) | Matches pattern and captures the match. The captured match can be retrieved from the resulting Matches collection, using the SubMatches collection in Microsoft Visual Basic Script (VBScript) or the $0…$9 properties in JScript. To match parentheses characters ( ), use “&#92;(” or “&#92;)”. |
| (?:pattern) | Matches pattern but does not capture the match, that is, it is a non-capturing match that is not stored for possible later use. This is useful for combining parts of a pattern with the “or” character (“&#124;”). For example, “industr(?:y&#124;ies)” is a more economical expression than “industry&#124;industries”. |
| (?=pattern) | Positive lookahead search pattern that matches the search string at any point where a string matching pattern begins. This is a non-capturing match, that is, the match is not captured for possible later use. For example, “Windows (?=95&#124;98&#124;NT&#124;2000)” matches “Windows” in “Windows 2000” but not “Windows” in “Windows 3.1”. Lookaheads do not consume characters, that is, after a match occurs, the search for the next match begins immediately following the last match, not after the characters that make up the lookahead. |
| (?!pattern) | Negative lookahead that matches the search string at any point where a string not-matching pattern begins. This is a non-capturing match, that is, the match is not captured for possible later use. For example, “Windows (?!95&#124;98&#124;NT&#124;2000)” matches “Windows” in “Windows 3.1” but does not match “Windows” in “Windows 2000”. Lookaheads do not consume characters, that is, after a match occurs, the search for the next match begins immediately following the last match, not after the characters that make up the lookahead. |
| x&#124;y | Matches either x or y. For example, “z&#124;food” matches “z” or “food”. “(z&#124;f)ood” matches “zood” or “food”. |
| [xyz] | A character set. Matches any one of the enclosed characters. For example, “[abc]” matches the “a” in “plain”. |
| [^xyz] | A negative character set. Matches any character not enclosed. For example, “[^abc]” matches the “p” in “plain”. |
| [a-z] | A range of characters. Matches any character in the specified range. For example, “[a-z]” matches any lowercase alphabetic character in the range “a” through “z”. |
| [^a-z] | A negative range of characters. Matches any character not in the specified range. For example, “[^a-z]” matches any character not in the range “a” through “z”. |
| &#92;b | Matches a word boundary, that is, the position between a word and a space. For example, “er&#92;b” matches the “er” in “never” but not the “er” in “verb”. |
| &#92;B | Matches a nonword boundary. For example, “er&#92;B” matches the “er” in “verb” but not the “er” in “never”. |

<!-- Section 1, PDF page 7 -->

**Table 2-2   Characters Used in Regular Expressions**

| Character | Description |
| --- | --- |
| &#92;cx | Matches the control character indicated by x. For example, “&#92;cM” matches Control+M, or a carriage return character. The value of x must be in the range of A–Z or a–z. If not, c is assumed to be a literal “c” character. |
| &#92;d | Matches a digit character. Equivalent to “[0-9]”. |
| &#92;D | Matches a nondigit character. Equivalent to “[^0-9]”. |
| &#92;f | Matches a form-feed character. Equivalent to “&#92;x0c” and “&#92;cL”. |
| &#92;n | Matches a newline character. Equivalent to “&#92;x0a” and “&#92;cJ”. |
| &#92;r | Matches a carriage return character. Equivalent to “&#92;x0d” and “&#92;cM”. |
| &#92;s | Matches any whitespace character including SPACE, TAB, and form-feed. Equivalent to “[ &#92;f&#92;n&#92;r&#92;t&#92;v]”. |
| &#92;S | Matches any non-whitespace character. Equivalent to “[^ &#92;f&#92;n&#92;r&#92;t&#92;v]”. |
| &#92;t | Matches a TAB character. Equivalent to “&#92;x09” and “&#92;cI”. |
| &#92;v | Matches a vertical TAB character. Equivalent to “&#92;x0b” and “&#92;cK”. |
| &#92;w | Matches any word character including underscore. Equivalent to “[A-Za-z0- 9&#95;]”. |
| &#92;W | Matches any nonword character. Equivalent to “[^A-Za-z0-9&#95;]”. |
| &#92;xn | Matches n, where n is a hexadecimal escape value. Hexadecimal escape values must be exactly two digits long. For example, “&#92;x41” matches “A”; and “&#92;x041” is equivalent to “A1”. Allows ASCII codes to be used in regular expressions. |
| &#92;num | Matches num, where num is a positive integer. A reference back to captured matches. For example, “(.)&#92;1” matches two consecutive identical characters. |
| &#92;n | Identifies either an octal escape value or a backreference. If “&#92;n” is preceded by at least n captured subexpressions, n is a backreference. Otherwise, n is an octal escape value if n is an octal digit (0–7). |
| &#92;nm | Identifies either an octal escape value or a backreference. If “&#92;nm” is preceded by at least nm captured subexpressions, nm is a backreference. If “&#92;nm” is preceded by at least n captures, n is a backreference followed by literal m. If neither of the preceding conditions exists, “&#92;nm” matches octal escape value nm when n and m are octal digits (0–7). |
| &#92;nml | Matches octal escape value nml when n is an octal digit (0–3), and m and l are octal digits (0–7). |
| &#92;un | Matches n, where n is a Unicode character expressed as four hexadecimal digits. For example, “&#92;u00A9” matches the copyright symbol (©). |

<!-- Section 1, PDF page 8 -->

Compare each of the metacharacters used in the example code’s regular expression, “^\d{5}$”, with the metacharacters in Table 2-2. The first character, ^, matches the beginning of the input string. This character is critical. If you remove it, the regular expression “\d{5}$” will still match valid five-digit numbers, such as “12345”. However, it will also match the input string “abcd12345” or “‘ drop table customers -- 12345”. In fact, the modified regular expression will match any input string that ends in any five- digit number.

Important When building an application, forgetting that leading carat can expose a security vulnerability! Use peer code reviews to limit the risk of human error.

The second and third characters, “\d”, match numeric characters from 0 through 9. As Table 2-2 points out, the “\d” syntax has exactly the same meaning as “[0-9]”. Therefore, you could also write the regular expression “^[0-9]{5}$” to validate that input is a five-digit number.

The fourth, fifth, and sixth characters in the regular expression “{5}” mean the preceding symbol must be repeated five times. To match a seven-digit number, you could replace this with “{7}”. This can also match a range of repeated values. For example, to verify that input is a three-, four-, or five-digit number, you would use the regular expression “^\d{3,5}$”. This would match the values “123” and “1455”, but would not match “12” or “12a3”.

The last character in the regular expression, “$”, matches the end of the input string. If this character is omitted, any characters can follow the matched input. If you remove this character, the regular expression “^\d{5}” will still match valid five-digit numbers, such as “12345”. However, it will also match the input string “12345abcd” or “12345’ drop table customers --”. In fact, the modified regular expression will match any input string that begins in a five-digit number. Figure 2-2 summarizes the analysis of this simple regular expression.

> [Figure 2-2 placeholder — Analysis of a regular expression. Source: section 1 source PDF above, PDF page 8.]

<!-- Section 1, PDF page 9 -->

Security Alert When validating input, always begin regular expressions with a “^” character and end them with “$”. This ensures that input exactly matches the specified regular expression, and does not merely contain matching input.

Regular expressions can be used to match complex input patterns, too. The following regular expression matches e-mail addresses:

```text
^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-
9]{1,3})(\]?)$
```

Regular expressions are an extremely efficient way to check user input; however, using regular expressions has a downside:

- Regular expressions are difficult to create unless you are extremely familiar with the format If you have years of Perl programming experience, you won’t have any problem using regular expressions in C# code. However, if you have a background in Visual Basic scripting, the cryptic format of regular expressions will seem completely illogical.

- Creating regular expressions can be confusing, but reading regular expressions definitely is There is a good chance that other programmers will overlook errors in regular expressions when performing a peer code review. The more complex the regular expression, the greater the chance that the structure of the expression contains an error that will be overlooked.

Unfortunately, not all input is as easy to describe as numbers and e-mail addresses. Names and street addresses are particularly difficult to validate because they can contain a wide variety of characters from international alphabets unfamiliar to you. For example, O’Dell, Varkey Chudukatil, Skjønaa, Crciun, and McAskill-White are all legitimate last names of real people. Programmatically filtering these examples of valid input from malicious input such as “1’ DROP TABLE PRODUCTS --” (a SQL injection attack) is difficult.

One common approach is to instruct users to replace characters in their own names. For example, users who normally enter an apostrophe or a hyphen in their names could omit those characters. Users with letters that are not part of the standard Roman alphabet could replace letters with the closest similar Roman character. Although this allows you to more rigorously validate input, it requires users to sacrifice the accurate spelling of their names—something many people take very personally.

As an alternative, perform as much filtering as possible on the input, and then clean the input of any potentially malicious content. Most input validation should be pessimistic and allow only input that consists entirely of approved characters, but input validation of real names might need to be optimistic and cause an error only when specifically denied characters exist. For example, you could reject a user’s name if it contained one

<!-- Section 1, PDF page 10 -->

of the following characters: !, @, #, $, %, ^, *, (, ), <, >. All these characters are unlikely to appear in a name but likely to be used in an attack. Microsoft Visual Studio .NET provides the following regular expression to match valid names: “[a-zA-Z’`- Ã‚Â´\s]{1,40}”.

### Use Strong Types and Typed Data Comparisons for Non-String Data

User input is generally received in the form of a string. For example, input from an ASP.NET form is received by retrieving the “System.Web.UI.WebControls.TextBox.Text” string, and input from a Windows Form application is available within the “Sys- tem.Windows.Forms.TextBox.Text” string.

If the user is not typing text, your application should immediately convert the user input into a stronger type. For example, if you use a TextBox control to allow the user to enter a number from 1 through 100, the following code would convert that input and then validate the range:

```text
int myNumber = Int16.Parse(TextBox1.Text);
        if ( !((myNumber >= 1) && (myNumber <= 100)) )C#      throw new Exception(“Invalid input: Number out of bounds.”);
```

```text
Dim myNumber As Integer =  Int16.Parse(TextBox1.Text)
        If Not ((myNumber >= 1) && (myNumber <= 100)) ThenVB      Throw New Exception(“Invalid input: Number out of bounds.”)
        End If
```

This technique is extremely effective for filtering invalid input, because the .NET Framework throws a format exception when any part of the input string cannot be interpreted as an integer. If the user enters alphabetic characters, a decimal number, or anything other than the characters 0–9 (inclusive), the .NET Framework throws a For- matException with the message “Input string was not in a correct format”. If the input can be successfully converted but falls outside the inclusive range of 1–100, the example code manually throws an exception.

Use similar techniques for validating decimal numbers, currency, dates, and any other input type for which the .NET Framework has a specialized class. The following code verifies that the content of TextBox1 is a valid date, and catches the format exception if the conversion fails:

```text
try
        {C#      DateTime dt = DateTime.Parse(TextBox1.Text).Date;
        }
        catch(FormatException ex)
        {
            // Return invalid date message to caller
        }
```

<!-- Section 1, PDF page 11 -->

```text
Try
            Dim dt As DateTime =  DateTime.Parse(TextBox1.Text).Date
        Catch ex As FormatExceptionVB      ’ Return invalid date message to caller
        End Try
```

### Validate Strings Based on Their Length

Most strings that users type, including names, have a practical (if not theoretical) length limit. Therefore, validating strings based on their length can be extremely useful for .NET Framework applications. However, it is more than useful to other development environments—it is critical. Accepting input that is longer than the application was designed to handle leads to buffer overflow attacks. Fortunately, applications built on the .NET Framework are naturally resistant to buffer overflows, because the .NET Framework automatically verifies that the buffer can hold the contents you are writing into it.

There are times when you should check length, however. If there is a reasonable limit to how long a particular piece of user input should be, use a regular expression to verify that the input is of an expected length. As an alternative to using regular expressions, use strings that include the Length property. To throw an exception if the length of a string named input is greater than 20 characters, use the following line of code:

```text
if (input.Length > 20) throw new Exception(“Input too long.”);
C#
```

```text
If input.Length > 20 Then
            Throw New Exception(“Input too long.”)VB  End If
```

Tip If the string is going to be stored in a database or used to query a database value, verify that the string is not longer than the space allocated to the column in the database.

Validate Input in Your ASP.NET Controls

Any application that accepts user input can be attacked, but Web applications are the most likely to be attacked for the following reasons:

- Web applications are often accessible from the public Internet, where anyone can submit requests.

- Web applications typically use HTML forms to request user input. Attackers can easily analyze HTML forms to understand exactly what types of input the application accepts.

- For attackers with the skills to manually submit malicious input, techniques for attacking Web applications are well documented on the public Internet.

<!-- Section 1, PDF page 12 -->

- For attackers who lack the skill to manually submit malicious input to a Web application, tools are available to simplify and automate the process.

For these reasons, validating input in your ASP.NET applications is especially critical. You can use any technique supported by the .NET Framework, including regular expressions. ASP.NET also provides additional functionality in the form of five validator Web controls in the System.Web.UI.WebControls namespace:

- RequiredFieldValidator Verifies that a box contains at least one character.

- CompareValidator Verifies that input in one box exactly matches another. Primarily used to verify that a user completes Password and Confirm Password text boxes with identical characters.

- RangeValidator Validates that input falls within a defined upper and lower range. You can validate numbers, dates, and characters.

- RegularExpressionValidator Matches input against a defined regular expression.

- CustomValidator Allows you to write a custom method to validate user input.

Of these five controls, RangeValidator, RegularExpressionValidator, and CustomVali- dator are the most useful for filtering potentially malicious user input. Follow these steps to use a validator Web control:

1. Add Web controls, such as TextBox, to an ASP.NET Web form.

2. Add a validator Web control to the Web form.

3. Define the ErrorMessage property of the validator Web control. This message will be displayed when the user has entered invalid input.

4. Define the ControlToValidate property of the validator Web control as the name of the input Web control created in step 1 (Figure 2-3).

> [Figure 2-3 placeholder — Defining a property of a validator control to reduce the risk of accepting malicious input. Source: section 1 source PDF above, PDF page 12.]

<!-- Section 1, PDF page 13 -->

5. Specify additional settings specific to each type of validator Web control:

❑ RangeValidator Define the MaximumValue and MinimumValue properties, and then set the Type property to String, Integer, Double, Date, or Currency.

❑ RegularExpressionValidator Define the ValidationExpression property with a regular expression that the input must match. As shown in Figure 2-4, Visual Studio .NET includes the Regular Expression Editor to simplify generating regular expressions.

❑ CustomValidator Create a custom method to validate the input, and then set the ServerValidate property to the name of the server-side method that will validate the input. Optionally, you can set the ClientValidationFunction property to the name of a client script that the browser will run.

> [Figure 2-4 placeholder — Regular Expression Editor simplifying validation of complex input in ASP.NET forms. Source: section 1 source PDF above, PDF page 13.]

6. Add code to check the status of the validator controls. For example, the following code checks the status of a validator Web control, and throws an exception if the input is invalid:

```text
if (RangeValidator1.IsValid == true)
             {C#           // Parse validated input
             }
             else
             {
                 throw new Exception(“Invalid input”);
             }
```

```text
If myValidator.IsValid = True Then
                 ’ Parse validated inputVB       Else
                 Throw New Exception(“Invalid input”)
             End If
```

Each of these validators includes both a client-side and server-side component. The cli- ent-side component runs on the user’s browser in the form of a JavaScript. Using the client-side script does not improve the security of your application. Client-side validation gives immediate feedback to legitimate users who accidentally enter invalid input into a box. However, malicious attackers will simply bypass the client-side scripts.

<!-- Section 1, PDF page 14 -->

Tip You can disable the generation of client-side scripts by setting the EnableClientScript property of the control to False. You might choose to do this to keep attackers from learning the details of your validation method. Knowing those details could help an attacker identify a vulnerability, but it wouldn’t help that much, so it’s probably not worth the trouble.

The server-side component of the validator Web controls does improve security, however. When a validator Web control is configured to validate input, ASP.NET examines the user input before passing control back to your code. ASP.NET will not stop the processing of the input if the validator’s conditions are not met, however. You must manually check the state of the Boolean IsValid property of the validator control. If this property is true, the input was successfully validated. If it’s false, don’t trust the input.

Note Everyone knows Web applications will be attacked with malicious input, but many Windows Forms developers wrongly think GUI applications are immune. Windows Forms applications can be attacked, but it doesn’t happen as frequently. That’s probably why the .NET Framework includes an excellent set of validator controls in the System.Web.UI.WebControls namespace, but doesn’t include any validator controls in System.Windows.Forms. You can, and should, make your own GUI validator controls, however. For information about creating your own validator controls, read http://msdn.microsoft.com/library/en-us/dnadvnet/html /vbnet04082003.asp.

### Guidelines for Rejecting Malicious Input

The best way to validate input is to force it to constrain to a specific type, format, length, and range. However, not all potentially malicious input can be identified using this technique. Sometimes, you must constrain the input, and then specifically seek out potentially malicious input. For example, the following regular expression could be used to identify a script block within HTML input:

```text
<\s*script\s*>
```

Rejecting input that matched that regular expression would make it more difficult for an attacker to perform a cross-site scripting (CSS) attack that used a browser script, but it would not make the attack impossible. The attacker would merely need to find a way to format the script that did not match the regular expression you specified. For example, the sample regular expression would catch <script>, < script >, and <script lan- guage=“JavaScript”>, but it would not catch <SCRIPT>. A persistent attacker would quickly discover that your filtering algorithm was case-sensitive, and use that weakness to exploit your application.

<!-- Section 1, PDF page 15 -->

In summary, rejecting input that contains known, dangerous content can reduce the risk of your application being exploited. However, this technique is error-prone. You should use this technique only after input has been tightly constrained.

### Guidelines for Sanitizing Input

Sometimes, valid characters can be used with malicious intent by attackers. For example, an attacker can use apostrophes during SQL injection attacks because they are the most common delimiter in SQL commands. However, when trying to protect against this, you might not be able to reject all input containing an apostrophe because the character can appear in names, locations, and sentences.

In these circumstances, you must sanitize the input. You can use special characters to replace characters that might be legitimate but might also be part of an attack. For example, SQL handles two apostrophes together as a single, non-delimiting apostrophe. Therefore, replacing a single apostrophe with two apostrophes allows a name to be inserted into a dynamically generated SQL query without allowing the apostrophe to act as a delimiter. The following command performs this replacement:

```text
output = input.Replace(“‘”, “‘‘“);
C#
VB  output = input.Replace(“‘”, “‘‘“)
```

You can also use regular expressions to remove or replace invalid characters. For example, the following command removes all non-alphanumeric characters except for “@”, “-”, and “.”:

```text
Regex.Replace(input, “[^\w\.@-]", ““);
C#
VB  Regex.Replace(input, “[^\w\.@-]", ““)
```

Similarly, the following commands replace the characters “<” and “>” with “&lt” and “&gt”. Browsers interpret the “<” and “>” characters as delimiters for HTML codes or client- side scripts, and so they do not normally display them to the user. However, browsers will display “&lt” and “&gt” as less-than and greater-than signs. As a result, running these two commands on user input that is displayed on a Web page can help reduce the likelihood of CSS attacks while still allowing legitimate users to use those characters:

<!-- Section 1, PDF page 16 -->

```text
comment = comment.Replace(“<", “&lt”);
C#  comment = comment.Replace(“>", “&gt”);
```

```text
comment = comment.Replace(“<", “&lt”)
         comment = comment.Replace(“>", “&gt”)VB
```

Tip Simply stripping out “<” and “>” from user input will ruin everyone’s emoticons. :-<

### Practice: Validating Input

In this practice, you create an ASP.NET application that rigorously validates input. Read the scenario and then complete the exercise that follows. If you are unable to answer a question, review the lesson materials and try the question again. You can find answers to the questions in the “Questions and Answers” section at the end of this chapter.

### Scenario

Your organization, Northwind Traders, is creating a Web-based application to allow customers to enter their own contact information into your database. As a new employee, you are assigned a simple task: create the front-end interface and prepare the user input to be stored in a database. You begin by interviewing several company personnel and reviewing the technical requirements.

Interviews Following is a list of company personnel interviewed and their statements:

- IT Manager “This is your first assignment, so I’m starting you out easy. Slap together a Web page that takes user input. That should take you, what, five minutes?”

- Database Developer “Just drop the input into strings named ‘companyName’, ‘contactName’, and ‘phoneNumber’. It’s going into a SQL back-end database, but I’ll write that code after you’re done. Oh, the ‘companyName’ can’t be longer than 40 characters, ‘contactName’ is limited to 30 characters, and ‘phoneNumber’ is limited to 24 characters.”

- Chief Security Officer “This is not as easy an assignment as it seems. This page is going to be available to the unwashed public on the Internet, and there are lots of black hats out there. We’ve gotten some negative attention in the press recently for our international trade practices. Specifically, we’ve irritated a couple of groups with close ties to hacker organizations. Just do your best to clean up the input, because you’re going to see some malicious junk thrown at you.”

<!-- Section 1, PDF page 17 -->

Technical Requirements Create an ASP.NET application that accepts the following pieces of information from users, and validate them rigorously:

- Company name

- Contact name

- Phone number

### Exercise

Answer the following questions to show that you can implement best practices for validating potentially malicious user input:

1. How can you constrain the input before you write any code?

2. How can you further constrain the input by writing code?

### Lesson Summary

- Your primary defense against malicious input is to reject all input that does not meet exacting requirements for format, length, type, and range.

- Your secondary defense against malicious input is to examine it for known malicious content.

- Your final defense against malicious input is to sanitize it to remove potentially dangerous characters.

<a id="section-2"></a>

## Implementing Security for Applications-2005

Source: [Implementing.Security.for.Applications-2005-2-2.pdf](Implementing.Security.for.Applications-2005-2-2.pdf) — section 2, 6 pages.

<!-- Section 2, PDF page 1 -->

### Lesson 2: Minimizing Canonicalization Problems

Attacks exploiting canonicalization problems in Web applications have been, and will continue to be, one of the biggest challenges to Web developers. Canonicalization problems are not unique to Web applications, however. The same problems can be exploited in Windows Forms applications, because local filenames can be represented in multiple, and often confusing, ways. This lesson provides best practices for reducing your vulnerability to canonicalization problems by using features built into the .NET Framework.

After this lesson, you will be able to

- Avoid canonicalization problems in Windows Forms applications.

- Avoid canonicalization problems in ASP.NET applications.

Estimated lesson time: 15 minutes

### Best Practices for Avoiding Canonicalization Problems in Windows Forms Applications

If you validate a filename before the operating system canonicalizes it, an attacker can pass a filename that you won’t detect as invalid. You can reduce your vulnerability to canonicalization attacks by manually canonicalizing a path before validating it. Additionally, rather than optimistically attempting to match invalid input, you should validate that the path contains only allowed characters.

Tip Canonicalization is the process of simplifying a path to its most simple, absolute form. Any file can be identified by multiple names, such as C:\boot.ini, ..\..\..\BOOT.INI, and C:/ boot%2eini, so the operating system must canonicalize the name before processing the file. Applications don’t always canonicalize the name, which can introduce a vulnerability. For more information about canonicalization, see Chapter 1, “Implementing Security at Design Time.”

Consider a Windows Forms application, designed to run on a kiosk in the lobby of a business, that allows the user to view text files containing public information about the company. The following method accomplishes this simple task by displaying the contents of the file in the outputBox TextBox. If an error occurs, the method displays an error message.

```text
private void showFile(string fileName)
         {C#      try
             {
                 System.IO.StreamReader sr = new System.IO.StreamReader(fileName);
                 outputBox.Text = sr.ReadToEnd();
                 sr.Close();
             }
```

<!-- Section 2, PDF page 2 -->

```text
catch (Exception ex)
            {
                outputBox.Text = “ERROR: “ + ex.Message;
            }
        }
```

```text
Private  Sub showFile(ByVal fileName As String)
            TryVB          System.IO.StreamReader sr = New System.IO.StreamReader(fileName)
                outputBox.Text = sr.ReadToEnd()
                sr.Close()
            Catch ex As Exception
                outputBox.Text = “ERROR: “ + ex.Message
            End Try
        End Sub
```

Note For the sake of simplicity, please suspend disbelief for a moment—I know this example is a bit silly!

There’s a problem, though. An attacker could use the program to view the contents of the C:\boot.ini file, which would give her information that could be used to compromise the computer. Adding the following condition to the method should eliminate that possibility:

```text
if (fileName == @"C:\boot.ini”)
        {C#      throw new Exception (“No, that’s a system file!”);
        }
```

```text
If fileName = “C:\boot.ini” Then
            Throw New Exception (“No, that’s a system file!”)VB  End If
```

This condition will catch the attacker if she browses to select the C:\boot.ini file, or if she manually types C:\boot.ini. However, because the check is so specific, the attacker can type any of the following filenames to view the file:

- C:\boot.ini.

- ..\..\..\..\..\..\..\..\..\..\..\boot.ini

- \boot.ini

There are two ways you can fix this problem:

- Use regular expressions to search for the phrase “boot.ini” in the filename This will work, but it is risky because the attacker can find another way to identify the file. For example, a Web application might interpret “%2e” as a period, which will allow the name “C:\boot%2eini” to be used to identify the file.

<!-- Section 2, PDF page 3 -->

- Canonicalize the filename, and then compare it This is the more secure option, because the .NET Framework will provide the application with the absolute name of the file in a consistent format that you can reliably compare against.

Ultimately, evaluating the canonicalized filename is the most reliable way to ensure the C:\boot.ini file is never selected. To do this, the method can use the Sys- tem.IO.Path.GetFullPath method, as demonstrated here:

```text
try
        {C#      fileName = Path.GetFullPath(fileName);
            if (fileName == @"C:\boot.ini”)
            {
                throw new Exception (“No, that’s a system file!”);
            }
            System.IO.StreamReader sr = new System.IO.StreamReader(fileName);
            outputBox.Text = sr.ReadToEnd();
            sr.Close();
        }
        catch (Exception ex)
        {
            outputBox.Text = “ERROR: “ + ex.Message;
        }
```

```text
Try
            fileName = Path.GetFullPath(fileName)VB      If fileName = “C:\boot.ini” Then
                Throw New Exception (“No, that’s a system file!”)
            End If
            System.IO.StreamReader sr = New System.IO.StreamReader(fileName)
            outputBox.Text = sr.ReadToEnd()
            sr.Close()
        Catch ex As Exception
            outputBox.Text = “ERROR: “ + ex.Message
        End Try
```

As you can see, this code calls the System.IO.Path.GetFullPath method to return the absolute, canonicalized path to the file. This code will detect any variation on the name boot.ini, including the three examples cited earlier. For an attacker to defeat this check and open the boot.ini file, she would need to discover a vulnerability in the .NET Framework itself. Although discovering such a vulnerability is not impossible, the .NET Framework is much less likely to be exploited than any single application.

Caution There’s still at least one way to trick the application into opening the boot.ini file— can you find it? If you pass the filename “\\localhost\c$\boot.ini”, Path.GetFullPath won’t translate the network share into the local C drive. This vulnerability would exist only if the user could connect to the default \\localhost\c$ share, which is limited to Administrators.

<!-- Section 2, PDF page 4 -->

The System.IO.Path class includes several other methods that are useful for avoiding canonicalization errors, including the following:

- Combine Combines two path strings, enabling you to manually construct the path to a file while minimizing the potential for canonicalization vulnerabilities.

- GetDirectoryName Returns the absolute path to the file’s folder, without the filename or extension.

- GetExtension Returns only the file’s extension, such as .txt.

- GetFileName Returns the file’s name and extension, with all folder information removed.

- GetFileNameWithoutExtension Returns the file’s name without the extension.

- IsPathRooted Allows you to reliably determine whether a path is absolute or relative. Accepts a path string as an argument, and returns true if the path is absolute, or false if the path is relative.

Note It’s worth mentioning that the .NET Framework inherently eliminates several well- known canonicalization problems. For example, the Win32 API would have accepted the name “C:\boot.ini::$DATA” as a valid path, but the .NET Framework throws an exception with the message “The given path’s format is not supported.”

### Best Practices for Avoiding Canonicalization Problems in ASP.NET Applications

To avoid canonicalization problems in ASP.NET applications, use the Request.MapPath method to canonicalize input that specifies the path to a file. To understand how the Request.MapPath method works, you must know that Web requests are submitted to a virtual path that maps to a physical path on the server. For example, if an HTTP request for the virtual path “/index.htm” is submitted to the default Web site, the Web server canonicalizes the virtual path into the physical path C:\Inetpub\Wwwroot\Index.htm. Many paths are not as straightforward, however.

Microsoft Internet Information Server (IIS) allows for a great deal of flexibility when creating virtual paths. Any given path, such as /images/, can map to the default location under C:\Inetpub\, a location elsewhere on the local hard disk, or a shared folder on another networked computer. Therefore, canonicalizing a virtual path to a physical path requires analyzing the IIS virtual path structure.

Additionally, virtual paths can appear in both relative and absolute formats. Relative virtual paths, such as “logo.gif” or “../../images/logo.gif”, state the location of an object in relation to another object. Absolute virtual paths must include the root of a given Web site.

<!-- Section 2, PDF page 5 -->

Another factor that must be accommodated when deriving physical paths from virtual paths is character translation. Web browsers cannot transmit a space as part of a filename. Therefore, they encode the space using the sequence “%20”, which represents the space in hexadecimal ASCII notation. Other characters can be similarly encoded: a period can become “%2e”, a forward slash can become “%2f”, and the letter e can be rendered as “%65”.

The complexity of calculating physical paths from virtual paths, and the multiple ways Web servers and Web browsers can represent characters, makes analyzing the locations of Web files and folders extremely error prone. Fortunately, you can reduce canonicalization problems in ASP.NET applications by following the same guideline you use for Windows Forms applications: allow the .NET Framework to do the work for you. The Request.MapPath method, shown in the following code, accepts a relative or absolute virtual path, and returns the corresponding physical path. This not only saves you the labor of writing code to manually parse virtual paths, it also reduces the possibility that human error will lead to a vulnerability.

```text
string mappedPath = Request.MapPath(inputPath.Text);
C#
VB  Dim mappedPath As String =  Request.MapPath(inputPath.Text)
```

After the Request.MapPath method translates the virtual path, you can use standard techniques to verify the path of the request without worrying about intentionally malicious characters in the path. As an additional layer of protection, you can use the overloaded Request.MapPath method to verify that the path is within your application’s virtual folder. When this mode is used to prevent cross-application mapping, Request.MapPath throws an HttpException if the requested path is outside of your application’s directory, virtually eliminating the possibility that an attacker will exploit a canonicalization problem to force your application to process a file outside of its directory. To prevent cross-application mapping, pass Request.MapPath three parameters: the virtual path, the root path of your application, and the Boolean false value.

```text
try
        {C#      string mappedPath = Request.MapPath(inputPath.Text,Œ
        Request.ApplicationPath, false);
        }
        catch (HttpException ex)
        {
            // Cross-application mapping attempted
        }
```

<!-- Section 2, PDF page 6 -->

```text
Try
         Dim mappedPath As String =  Request.MapPath(inputPath.Text,Œ
         Request.ApplicationPath,False)VB  Catch ex As HttpException
             ’ Cross-application mapping attempted
         End Try
```

### Lesson Summary

- Use the System.IO.Path.GetFullPath method to reduce the vulnerability of canonicalization problems in Windows Forms applications.

- Use the Request.MapPath method to manually canonicalize virtual paths, reducing the likelihood of a canonicalization exploit in ASP.NET applications.

<a id="section-3"></a>

## Implementing Security for Applications-2005

Source: [Implementing.Security.for.Applications-2005-2-3.pdf](Implementing.Security.for.Applications-2005-2-3.pdf) — section 3, 14 pages.

<!-- Section 3, PDF page 1 -->

### Lesson 3: Minimizing SQL Injection Attacks

Although not as common as canonicalization problems or CSS attacks, SQL injection attacks might be the most harmful common server attack. By submitting malicious characters and commands to a database application that processes user input, a SQL injection attack can expose private data and modify (or even destroy) information stored in a database. This lesson provides guidelines for creating database applications that are resistant to SQL injection attacks, and provides detailed instructions for using features built into the .NET Framework to help prevent a database server from interpreting commands issued by attackers.

Note The Structured Query Language (SQL) command examples in this book were created for Microsoft SQL Server 2000. SQL commands for other back-end databases might require slight changes.

After this lesson, you will be able to

- Structure your application to simplify the maintenance of your database access code.

- Describe how to best use SQL permissions to limit damage done by successful SQL injection attacks.

- Describe what stored procedures are and how they can be used to limit the possibility of a successful SQL injection exploit.

- Explain what parameterized SQL commands are and how you can use them to reduce the risk of a back-end database running malicious commands.

- Protect pattern matching statements.

Estimated lesson time: 45 minutes

### Guidelines for Structuring Your Application to Simplify Maintenance of Database Access Code

Even skilled developers can make mistakes that lead to SQL injection vulnerabilities. You can greatly reduce the likelihood of making mistakes, and simplify the process of identifying and fixing mistakes, by creating separate classes for interacting with your database.

<!-- Section 3, PDF page 2 -->

Real World When Security Isn’t a Priority The reason I say that it’s possible for skilled developers to write code with vulnerabilities is that every developer I know, thousands of developers I don’t know, and I have done this. Everyone has been in the situation in which a deadline is looming and you’re making shortcuts in your code. Unfortunately, there are lots of shortcuts you can use when communicating with a database. Most of those shortcuts, like building dynamic SQL queries and not validating user input, lead to SQL injection vulnerabilities.

After all, when you have a deadline looming, all you want is the application to work. Applications don’t have to be secure to work, because most employers only test basic functionality—not how an application responds to invalid input.

This code sample shows the wrong way to issue a database request:

```text
private void Button1_Click(object sender, System.EventArgs e)
        {C#      string selectString = “SELECT * FROM table WHERE id = “ + input.text;
            SqlDataAdapter myData = new SqlDataAdapter(selectString, myConnection);
            DataSet myDS = new DataSet();
            myData.Fill(myDS, “DataSet”);
        }
```

```text
Private  Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs)
            Dim selectString As String="SELECT * FROM table WHERE id = “ + input.textVB      Dim myData As SqlDataAdapter=New SqlDataAdapter(selectString,myConnection)
            Dim myDS As DataSet =  New DataSet()
            myData.Fill(myDS, “DataSet”)
        End Sub
```

And this code sample shows a much better technique:

```text
private void Button1_Click(object sender, System.EventArgs e)
        {C#      DataSet myDataSet = new DataSet();
            myDataSet = GetDSFromID(input.txt);
        }
```

```text
private DataSet GetDSFromID(string ID)
        {
            string selectString = “SELECT * FROM table WHERE id = “ + input.text;
            SqlDataAdapter myData = new SqlDataAdapter(selectString, myConnection);
            DataSet myDS = new DataSet();
            myData.Fill(myDS, “DataSet”);
            return myDS;
        }
```

<!-- Section 3, PDF page 3 -->

```text
Private  Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs)
             Dim myDataSet As DataSet =  New DataSet()
             myDataSet = GetDSFromID(input.txt)VB  End Sub
```

```text
Private Function GetDSFromID(ByVal ID As String) As DataSet
             Dim selectString As String="SELECT * FROM table WHERE id = “ + input.text
             Dim myData As SqlDataAdapter=New SqlDataAdapter(selectString,myConnection)
             Dim myDS As DataSet =  New DataSet()
             myData.Fill(myDS, “DataSet”)
             Return myDS
         End Function
```

Both of these code samples contain SQL injection vulnerabilities. However, the second code sample is easier to fix, because code that is accessing the database is located in a separate method. Ideally, database access methods are centralized in a single class in your application. To make your code easier to maintain and fix, never open a database connection directly from methods that perform non-database functions.

### Best Practices for Configuring SQL Permissions

When starting the development of a database application, you must not only plan the structure of the tables, views, and indices, you must also plan and assign the database privileges. Each role in your application, including guests, authenticated users, and administrators who manage the application, should have a separate role in the database. Each of these roles should be granted the minimal privileges required to access the tables, views, and stored procedures in the database.

Microsoft SQL Server, and most other client-server databases, include robust authentication and authorization features. In the case of Microsoft SQL Server, these features are tightly integrated with the operating system, allowing a database administrator (DBA) to grant privileges to Windows users and groups. For example, a DBA could grant the Administrators group access to manage all functions of a database, whereas members of the Users group have permissions to only read data from specific tables within the database.

Microsoft SQL Server, when run in Mixed Mode, also supports creating user accounts solely for the purpose of authenticating to the database. A DBA can create a user account within the database and assign permissions to this user. An application can then authenticate to the database using the user’s credentials without requiring a Windows user account.

By default, only members of the Administrators group have access to a freshly installed SQL Server. Members of the Users group and Web applications have absolutely no access to the SQL Server and its databases. This is a good example of the secure-by-default principle.

However, many application vulnerabilities have been caused by developers overreacting to this lack of default privileges. After all, the quickest way to debug database

<!-- Section 3, PDF page 4 -->

errors caused by missing privileges is to connect to the database as the System Administrator (sa) user. As a developer, you can place the sa user name and password in your connection string, and never worry about not having sufficient access to your database. However, this causes two types of problems:

- Every request your application submits to the database is run without checking privileges. Though this alone is not a vulnerability that an attacker could exploit, if you fail to correctly parse user input and expose a SQL injection vulnerability, an attacker will have unrestricted access to your database.

- An attacker who gains access to your connection string (which might be stored in your source code but should be stored elsewhere) can authenticate directly to your database server.

Design Invite the database administrators to examine the structure of your application during the design phase—they’ll have interesting feedback about how you can improve the security of their data.

As shown in Figure 2-5, you can restrict what types of queries each user and role can run against each object in the database. Allowing SELECT queries enables the user to retrieve any information from the table. UPDATE enables making changes to existing rows, whereas INSERT allows the user to add new rows. Roles with DELETE permissions can remove rows from the database—a very dangerous permission to grant.

> [Figure 2-5 placeholder — Restricting query types for users and roles. Source: section 3 source PDF above, PDF page 4.]

<!-- Section 3, PDF page 5 -->

The more granular you assign permissions, the better. If tables contain a combination of information that should be available to a given role and information that should be kept private, you should assign permissions to individual columns. For example, if you are creating an employee directory application that pulls data from a human resources database containing personal information about employees, grant users access to only the rows your application will display, as shown in Figure 2-6. Restricting access to individual columns isn’t sufficiently secure, because you are trusting that an attacker will not modify your SQL queries and will not bypass your application by connecting directly to the database.

> [Figure 2-6 placeholder — Assigning permissions to individual columns in a table containing confidential information. Source: section 3 source PDF above, PDF page 5.]

See Also Databases are an important part of most business applications, and you must be familiar with database security concepts. However, detailed coverage of SQL Server security configuration is outside the scope of this book. For more information, see “Security Resources” on the Windows Server System page of the Microsoft Web site at http://www.microsoft.com/sql/techinfo/administration/2000/security/ .

<!-- Section 3, PDF page 6 -->

### What Are Stored Procedures?

Whenever possible, use stored procedures, rather than dynamically generated SQL, to communicate with the database. Stored procedures are SQL commands that are stored on the database. Calling a stored procedure is as easy as issuing a database query, but stored procedures are more difficult to abuse with a SQL injection attack. You should use parameterized stored procedures for data access whenever possible. The security benefits include:

- Being able to restrict user privileges so that users have access only to run stored procedures. There is no need to grant a user direct table access if the data in the table is returned through a stored procedure.

- Being able to add additional data validation to the stored procedure itself.

- Developers who call the stored procedure are required to use SQL parameters, which minimizes the risk of SQL injection attacks. (SQL parameters are described in more detail in the next section.)

Note Stored procedures also run a bit quicker than dynamically generated SQL, but this doesn’t improve security at all.

Important Using limited user accounts, permissions, and stored procedures cannot prevent SQL injection attacks. Only correctly parsing input prevents SQL injection attacks. These other techniques reduce the damage of successful SQL injection attacks, which is an important part of implementing defense-in-depth.

### What Are Parameterized SQL Commands?

You can dynamically generate SQL queries based on user input while minimizing the risk of being vulnerable to a SQL injection attack. It is never the most secure method for querying a database, however. The most secure way to query a database is to build SQL statements using parameterized SQL commands. Parameterized SQL commands are SQL commands that use typed parameters and parameter placeholders to ensure that input data is checked for length and type.

SQL parameters are placeholders in SQL commands that the database substitutes with values you provide separately. Because the values are provided separately from the SQL query, there is no opportunity for a value to include SQL commands. Additionally, you do not need to include delimiters in your SQL query.

<!-- Section 3, PDF page 7 -->

Exam Tip In order from least secure to most secure: dynamically generated SQL, parame! terized SQL commands, and parameterized stored procedures.

### Examples: Parameterized SQL Commands

Consider the following method, which retrieves the first row of the Products table based on the productID argument:

```text
private static DataRow GetRowFromID(string productID)
        {C#      // Construct a parameterized SQL query to retrieve the first row from
            // the Products table with the supplied ProductID
            // Note that no value is specified in the constructed query.
            // Instead, @ProductID, a parameter, is specified.
            SqlDataAdapter productAdapter=new SqlDataAdapter(“SELECT ProductID,Œ
        ProductName FROM Products WHERE ProductID=‘“ + productID + “‘",Œ
        ConfigurationSettings.AppSettings["appDSN"]);
            DataSet productDataSet = new DataSet();
```

```text
// Run the query, fill the dataset, and return the first row
            productAdapter.Fill(productDataSet, “DataSet”);
            DataTable productsTable = productDataSet.Tables[0];
            return productsTable.Rows[0];
        }
```

```text
Private Shared Function GetRowFromID(ByVal productID As String) As DataRow
            ’ Construct a parameterized SQL query to retrieve the first row fromVB      ’ the Products table with the supplied ProductID
            ’ Note that no value is specified in the constructed query.
            ’ Instead, @ProductID, a parameter, is specified.
            Dim productAdapter As SqlDataAdapter =  New SqlDataAdapterŒ
        (“SELECT ProductID, ProductName FROM Products WHERE ProductID=‘“ +Œ
        productID +"‘",ConfigurationSettings.AppSettings(“appDSN”))
            Dim productDataSet As DataSet =  New DataSet()
```

```text
’ Run the query, fill the dataset, and return the first row
            productAdapter.Fill(productDataSet, “DataSet”)
            Dim productsTable As DataTable =  productDataSet.Tables(0)
            Return productsTable.Rows(0)
        End Function
```

Next, consider the same method, implemented using SQL parameters:

```text
private static DataRow GetRowFromID(int productID)
        {C#      // Construct a parameterized SQL query to retrieve the first row from
            // the Products table with the supplied ProductID
            // Note that no value is specified in the constructed query.
            // Instead, @ProductID, a parameter, is specified.
            SqlDataAdapter productAdapter=new SqlDataAdapter(“SELECT ProductID,Œ
        ProductName FROM Products WHERE ProductID=@ProductID",Œ
        ConfigurationSettings.AppSettings["appDSN"]);
            DataSet productDataSet = new DataSet();
```

<!-- Section 3, PDF page 8 -->

```text
// Add a parameter to the SqlDataAdapter, and specify its value
            SqlParameter parm = Œ
        productAdapter.SelectCommand.Parameters.Add(“@ProductID", SqlDbType.Int);
            parm.Value = productID;
```

```text
// Run the query, fill the dataset, and return the first row
            productAdapter.Fill(productDataSet, “DataSet”);
            DataTable productsTable = productDataSet.Tables[0];
            return productsTable.Rows[0];
        }
```

```text
Private Shared Function GetRowFromID(ByVal productID As Integer) As DataRow
            ’ Construct a parameterized SQL query to retrieve the first row fromVB      ’ the Products table with the supplied ProductID
            ’ Note that no value is specified in the constructed query.
            ’ Instead, @ProductID, a parameter, is specified.
            Dim productAdapter As SqlDataAdapter = New SqlDataAdapter(Œ
        "SELECT ProductID, ProductName FROM Products WHERE Œ
        ProductID=@ProductID",ConfigurationSettings.AppSettings(“appDSN”))
            Dim productDataSet As DataSet = New DataSet()
```

```text
’ Add a parameter to the SqlDataAdapter, and specify its value
            Dim parm As SqlParameter = Œ
        productAdapter.SelectCommand.Parameters.Add(“@ProductID",SqlDbType.Int)
            parm.Value = productID
```

```text
’ Run the query, fill the dataset, and return the first row
            productAdapter.Fill(productDataSet, “DataSet”)
            Dim productsTable As DataTable = productDataSet.Tables(0)
            Return productsTable.Rows(0)
        End Function
```

### Why the Second Example Is More Secure Than the First Example

If you compare the two methods without considering security, the first is clearly superior. It is several lines shorter, and shorter code is almost always better. Also, it accepts the productID parameter in the native string format that it will have when entered by the user—saving the need to convert it from a string to an integer, and then back to a string.

```text
The second method is dramatically more secure, however. The first method is more
          efficient, but it won’t seem so efficient when it is exploited by a SQL injection attack.
       The second method is essentially impossible to exploit with a traditional SQL injection
         attack. First, it accepts the productID parameter as an integer. The code that calls the
       method will be forced to convert the user’s input from a string to the integer format,
        using a command such as Int32.Parse(productIDString.Text). However, the process
        of converting the string to an integer ensures that no SQL injection commands are
        present in the input.
```

<!-- Section 3, PDF page 9 -->

Even if the value being queried were a string, the second method would be more secure because the query value is passed by using a SQL parameter. The SQL Profiler tool reveals the SQL query generated by the .NET Framework. First, consider how a dynamically generated SQL query looks when a SQL injection vulnerability is successfully exploited when a user types the phrase ‘ drop table deleteme -- in a text box prompting for a product name:

```text
exec sp_executesql N’SELECT * FROM Products WHERE ProductName=‘‘ Œ
         drop table deleteme --’
```

Next, examine the parameterized SQL query when the same input is provided as a value in a parameterized SQL query:

```text
exec sp_executesql N’SELECT * FROM Products WHERE ProductName=@ProductName’,Œ
         N’@ProductName nvarchar(40)’, @ProductName = N’’’ drop table deleteme --’
```

The parameterized SQL query is functionally identical, except for a single character— an extra apostrophe. The .NET Framework sanitized the value provided for the @Pro- ductName parameter by automatically replacing the single apostrophe (a SQL delimiter) with two apostrophes, which the SQL engine will interpret as a single, non- delimiter apostrophe. Yes, you could make this replacement manually in your code, but if you forget to sanitize the input for any box, your application will be vulnerable to SQL injection attacks. Using parameterized SQL queries lets the .NET Framework do the work for you.

Off the Record The .NET Framework provides separate classes for submitting database queries that SELECT data, and for submitting queries that UPDATE data. These classes don’t protect your application from SQL injection attacks, however. The sample application in the practice at the end of this lesson demonstrates a SQL injection attack that drops a table using the .NET Framework DataSet class. You should use the SqlCommand class to perform updates in your application, but an attacker can still abuse other classes.

Note Remember, defense-in-depth isn’t about being a perfect programmer. It’s about providing multiple layers of defense to prevent the inevitable mistakes from being exploited. Using parameterized SQL queries is an excellent way to reduce the possibility for human error to be exploited.

### Best Practices for Protecting Pattern Matching Statements

The SQL injection attacks discussed so far in this chapter take advantage of the fact that dynamically generated SQL queries use an apostrophe as a delimiter. The apostrophe is not the only special character that can be exploited, however. Queries that use the LIKE clause assign special meanings to the %, [, and _ characters. For example, the following SQL command would return all rows in which the ProductName column starts with an A:

<!-- Section 3, PDF page 10 -->

```text
SELECT * FROM Products WHERE ProductName LIKE ’a%’
```

Passing wildcards into SQL parameters is acceptable, so you cannot rely on the .NET Framework to sanitize the input. Instead, create a method that sanitizes the input by enclosing the special characters in brackets. The following method performs this function:

```text
private string SafeSqlLikeClauseLiteral(string inputSQL)
         {C#      // Make the following replacements:
             // [  becomes  [[]
             // %  becomes  [%]
             // _  becomes  [_]
```

```text
string s = inputSQL.Replace(“[", “[[]”);
             s = s.Replace(“%", “[%]”);
             s = s.Replace(“_", “[_]”);
             return s;
         }
```

```text
Private Function SafeSqlLikeClauseLiteral(ByVal inputSQL As String) As String
             ’ Make the following replacements:VB      ’ [  becomes  [[]
             ’ %  becomes  [%]
             ’ _  becomes  [_]
```

```text
Dim s As String =  inputSQL.Replace(“[","[[]”)
             s = s.Replace(“%", “[%]”)
             s = s.Replace(“_", “[_]”)
             Return s
         End Function
```

```text
Notice that these methods do not replace a single apostrophe with a double apostrophe. If you are using SQL parameters, you should not replace single apostrophes,
        because the .NET Framework will do that for you. In fact, manually replacing the apostrophe in a SQL parameter would result in a single apostrophe being interpreted as two
        apostrophes by the SQL engine. As a result, the sentence “I won’t place user input into
      SQL queries” would be stored as “I won’’t place user input into SQL queries.” If you are
        not using SQL parameters, also add the command Replace(“‘”, “‘‘“).
```

### Practice: Preventing SQL Injection Attacks

In this practice, you will configure a SQL Server database to allow queries from an ASP.NET application. Then, you will improve the application to reduce the vulnerability to SQL injection exploits. Complete the procedures in Exercises 1 and 2, and then complete the task and answer the questions in Exercise 3. If you are unable to answer a question, review the lesson materials and try the question again. You can find answers to the questions in the “Questions and Answers” section at the end of this chapter.

<!-- Section 3, PDF page 11 -->

### Exercise 1: Creating a Vulnerable Application

In this exercise, you compile and run an ASP.NET application that is vulnerable to SQL injection attacks. Then, you will perform a SQL injection attack to drop a table in the database.

1. Launch SQL Enterprise Manager by clicking Start, All Programs, Microsoft SQL Server, and then Enterprise Manager.

2. In the left pane, expand Microsoft SQL Servers, SQL Server Group, local, and Security. Click Logins.

3. Right-click Logins, and then click New Login.

4. In the Name box, type NT AUTHORITY\NETWORK SERVICE. Click OK.

5. Under local, expand Databases and Northwind. Click Users.

6. Right-click Users, and then click New Database User.

7. Click the Login Name list, and then click NT AUTHORITY\NETWORK SERVICE.

8. In the Permit In Database Role list, select the public and db_owner check boxes, as shown in Figure 2-7.

> [Figure 2-7 placeholder — Granting users the db_owner Database role to give almost unrestricted access to the database. Source: section 3 source PDF above, PDF page 11.]

Security Alert Assigning a user the db_owner role is a very bad thing to do because it gives that user a great many rights to your database. However, it is a very common mistake for developers to make, because selecting the db_owner check box immediately resolves all database authorization-related problems.

<!-- Section 3, PDF page 12 -->

9. Click OK.

10. Use Windows Explorer to copy the Northwind folder and its contents from the companion CD to the C:\Inetpub\Wwwroot\ folder.

11. From the Administrative Tools group, launch the Internet Information Services (IIS) Manager.

12. Expand your computer node, expand Web Sites, and then expand Default Web Site. Right-click Northwind, and then click Properties.

The Northwind Properties dialog box appears.

13. On the Directory tab, click the Create button. Click OK, and then close the Internet Information Services (IIS) Manager.

14. In Windows Explorer, select the C:\Inetpub\Wwwroot\Northwind\ folder, and then double-click Northwind.csproj.

Microsoft Visual Studio .NET 2003 opens the Northwind project.

15. On the Standard toolbar, verify that the Release configuration is selected. Click the Debug menu, and then click Start Without Debugging.

16. When prompted, save the solution file.

Visual Studio compiles and launches the application from within Internet Explorer.

17. In the Query by name box, type Chocolade. Click Search.

The Northwind application shows the ID and name of the product, as shown in Figure 2-8. This verifies that the sample application is configured correctly. Leave SQL Enterprise Manager and Internet Explorer open for the next exercise.

> [Figure 2-8 placeholder — Querying for a product to verify that the sample application is correctly configured. Source: section 3 source PDF above, PDF page 12.]

<!-- Section 3, PDF page 13 -->

### Exercise 2: Exploiting a Vulnerable Application

In this exercise, you perform a SQL injection attack to exploit the vulnerability in the Northwind application.

1. In Internet Explorer, click the Create DeleteMe Table button.

The Northwind application displays the message Table Created. Later, you will drop this table by using a SQL injection attack. Creating a table specifically for this purpose prevents doing permanent damage to the database.

2. In Enterprise Manager, expand Databases and Northwind, and then click Tables. Press F5. In the right pane, notice that the DeleteMe table exists.

3. In the Query by name box, type ‘ drop table DeleteMe --. Click Search.

The Northwind application shows an exception error message, as shown in Figure 2-9. The error message indicates that it couldn’t find any rows matching your input. However, it did submit the query to the database.

> [Figure 2-9 placeholder — Error message indicating that no matching rows were found. Source: section 3 source PDF above, PDF page 13.]

4. In Enterprise Manager, select the Tables node in the left pane, and then press F5 to refresh the display. The DeleteMe table disappears, indicating that the table was successfully deleted.

<!-- Section 3, PDF page 14 -->

### Exercise 3: Fixing a Vulnerable Application

In this exercise, you fix the vulnerable application, and then answer questions about the techniques you used to repair the vulnerabilities. First, modify the application to remove all obvious SQL injection exploits. Then, answer the following questions:

1. What techniques did you use to limit your exposure to SQL injection vulnerabilities entered into the queryIDInput TextBox?

2. What techniques do you use to limit your exposure to SQL injection vulnerabilities entered into the queryNameInput TextBox?

3. Besides changing the code in the application, what techniques could be used to reduce the likelihood of a SQL injection exploit?

### Lesson Summary

- Create separate methods and classes for database access code to make managing the code more efficient.

- Use SQL permissions as an additional defense-in-depth layer to reduce the damage done by successful SQL injection attacks.

- Stored procedures reduce the likelihood of a SQL injection attack being successful.

- Parameterized dynamic SQL commands are not as secure as stored procedures, but are dramatically more resistant to SQL injection attacks when compared with standard dynamic SQL commands.

- If you use the LIKE clause in a SQL command, you must sanitize user input to remove characters that can be used as wildcards.

<a id="section-4"></a>

## Implementing Security for Applications-2005

Source: [Implementing.Security.for.Applications-2005-2-4.pdf](Implementing.Security.for.Applications-2005-2-4.pdf) — section 4, 6 pages.

<!-- Section 4, PDF page 1 -->

### Lesson 4: Minimizing Cross-Site Scripting

SQL injection attacks and attacks that exploit canonicalization problems both directly attack the server. Cross-site scripting attacks are different, because they use the server to attack end users. An attacker exploiting a CSS vulnerability places HTML or client- side script code into user input that the server then displays to other users. CSS attacks can cause your server to send dangerous and possibly objectionable content to innocent end users, which can hurt the Web site’s reputation. Applications that might be vulnerable to CSS attacks are online forums, comment pages, and guest books.

Off the Record I’m guilty of writing code vulnerable to a CSS attack. Lucky for me, the attacker was relatively kind and exploited only the vulnerability that causes visitors to the Web site to perform a denial-of-service attack against the site. The attacker inserted HTML code into a comment label that was displayed to all visitors. The HTML code caused the browsers to constantly refresh the page. The large number of requests brought the site down, but also made me aware of the vulnerability.

CSS attacks exploit one of two types of applications:

- Online forums, guest books, and comment pages in which user input is displayed to other users

- Dynamically generated pages that display request parameters

This lesson teaches you how to reduce the likelihood that both types of CSS vulnerabilities will be exploited by an attacker.

After this lesson, you will be able to

- Sanitize user comments that will be displayed to other users.

- Sanitize request parameters that will be rendered in the user’s own browser.

Estimated lesson time: 10 minutes

### Guidelines for Sanitizing User Comments

See Also For information about how CSS vulnerabilities are exploited, see Chapter 1.

To prevent CSS attacks, rigorously validate any user input that will be displayed to other users. In particular, be wary of HTML and client-side scripts contained in < > brackets. If you do not plan to allow users to create HTML, you can use the following code to sanitize input:

<!-- Section 4, PDF page 2 -->

```text
string sanitizedInput = HttpUtility.HtmlEncode(dirtyInput);
C#
VB  Dim sanitizedInput As String =  HttpUtility.HtmlEncode(dirtyInput)
```

If you do want to allow users to enter HTML input, it is much more difficult to validate input. The best approach to allowing use of limited HTML tags is to sanitize the entire input using the HtmlEncode method, and then convert specific tags back to native HTML. The following code sanitizes input while allowing HTML tags for bold and italic fonts:

```text
StringBuilder sanitizedInput = new StringBuilder(HttpUtility.HtmlEncode(dirtyInput));
        sanitizedInput.Replace(“&lt;b&gt;", “<b>“);C#  sanitizedInput.Replace(“&lt;/b&gt;", “</b>“);
        sanitizedInput.Replace(“&lt;i&gt;", “<i>“);
        sanitizedInput.Replace(“&lt;/i&gt;", “</i>“);
```

```text
Dim sanitizedInput As StringBuilder =  New StringBuilder(HttpUtility.HtmlEncode(dirtyI
        nput))VB  sanitizedInput.Replace(“&lt;b&gt;", “<b>“)
        sanitizedInput.Replace(“&lt;/b&gt;", “</b>“)
        sanitizedInput.Replace(“&lt;i&gt;", “<i>“)
        sanitizedInput.Replace(“&lt;/i&gt;", “</i>“)
```

If you want to provide users with more robust HTML capabilities, it will be almost impossible to prevent CSS exploits. Unfortunately, even the most mundane HTML tags can be used to launch client-side scripts on some browsers. For example, each of the following tags can cause a browser (but not necessarily all browsers, or even any modern browser) to run client-side code:

- <img dynsrc="javascript:[code]">

- <a href=http://www.contoso.com onmouseover="[code]">Hyperlink text</a>

- <img src="foo"onmouseover="[code]">

All modern browsers should ignore these attempted CSS exploits. However, not everyone uses a modern browser, and developers usually don’t have the option of limiting the browsers that request pages from a Web application. Additionally, you never know when a vulnerability will be discovered in a modern browser. Learn from the mistakes of the past, and avoid echoing input containing any type of HTML content to end users.

<!-- Section 4, PDF page 3 -->

### Guidelines for Sanitizing Request Parameters

The second form of a CSS attack involves an attacker enticing a victim to click a hyperlink to a vulnerable application. The hyperlink is specially formed to contain codes that will cause the application to generate a Web page that launches a client-side script on the user’s browser or causes the browser to send a request to a malicious server. Consider the Web page shown in Figure 2-10, which displays the contents of the name request parameter.

> [Figure 2-10 placeholder — Web page that could be used to trick a user. Source: section 4 source PDF above, PDF page 3.]

An attacker could abuse the Web page shown in Figure 2-10 by tricking an unsuspecting user into clicking a hyperlink that passed HTML code to the page, such as http: //localhost/xss/WebForm1.aspx?name=<a%20href="javascript:alert(1);">Click%20here </a>.

Many Web platforms would then pass the HTML unfiltered to the user. Fortunately, ASP.NET 1.1 enables the validateRequest attribute by default to make this type of vulnerability more difficult to exploit. Figure 2-11 shows the page that results when malicious HTML code is passed to an ASP.NET page. ASP.NET will throw this same exception any time HTML code is received as part of a request parameter, even if you do not attempt to display the contents of the request parameter.

<!-- Section 4, PDF page 4 -->

> [Figure 2-11 placeholder — Error resulting from malicious HTML code being passed to an ASP.NET page. Source: section 4 source PDF above, PDF page 4.]

```text
You cannot rely on ASP.NET to prevent CSS attacks, however. You must constrain,
reject, and sanitize user input received in ASP.NET request parameters just as you
would any other input. If you decide that you’d rather not use ASP.NET’s protection,
you can disable the validateRequest attribute on a page-by-page basis by adding <%@
Page validateRequest="false” %> to the Page attribute. Alternatively, you can disable
the feature for your entire application by adding the following element to the applica-
tion’s Web.Config file:
```

```text
<configuration>
  <system.web>
    <pages validateRequest="false” />
  </system.web>
</configuration>
```

See Also For more information about the validateRequest attribute, including details about how to enable similar functionality for ASP.NET 1.0 application, read “Adding Cross-Site Scripting Protection to ASP. NET 1.0” on the MSDN page of the Microsoft Web site at http: //msdn.microsoft.com/library/en-us/dnaspp/html/scriptingprotection.asp.

<!-- Section 4, PDF page 5 -->

### Practice: Preventing Cross-Site Scripting

In this practice, you will discuss techniques for preventing canonicalization problems from being exploited. Read the scenario and then complete the exercise that follows. If you are unable to answer the question, review the lesson materials and try the question again. You can find the answer to the question in the “Questions and Answers” section at the end of this chapter.

### Scenario

Your organization, Northwind Traders, is using a Perl script on its public Web site to allow potential customers to submit questions to your Sales team. This Perl script accepts several different request parameters, and then displays them to the user to request confirmation before storing the request to the database. Unfortunately, one of the systems administrators discovered that this Perl script was being exploited using a CSS attack. The attacker tricks users into clicking on a www.northwindtraders.com link (which users trust because your company has an excellent reputation) that passes HTML-encoded parameters to the Perl script. The Perl script then sends the parameters back to the user, as if the malicious input needed to be confirmed. The malicious input includes a client-side browser script that redirects the user’s browser to an unfavorable site that Northwind Traders would definitely not want to be associated with.

Your boss, the IT manager, asks you to interview key personnel and then to recommend how this problem should be fixed.

Interviews Following is a list of company personnel interviewed and their statements:

- IT Manager “A few years back we hired a consultant to write that Perl script. It seemed to be working fine, so we just never worried about it. I’m pretty irritated that it was being abused though. We really need to make sure this doesn’t happen again, and then check the rest of our scripts to make sure they don’t have the same vulnerability.”

- Database Administrator “Look, you can’t just remove the confirmation page from the script. If you do that, you’ll have users loading all sorts of stupid data into my database. They’ll forget to type their names, or they’ll put in the wrong phone numbers, whatever. Just make sure people still have a chance to double-check their input before it’s saved.”

- Chief Security Officer “This problem is more serious than a bad contract programmer. Clearly Perl isn’t a secure enough application environment, so we’d better find something less prone to vulnerabilities. Also, why did this go undiscovered for so long? What do I have to do to get your boss to perform a code review once in a while?”

<!-- Section 4, PDF page 6 -->

### Exercise

Answer the following question to show that you can implement best practices for validating potentially malicious request parameters and echoing them back to the user’s browser.

1. How would you recommend creating a form that meets everyone’s requirements?

### Lesson Summary

- Sanitize user comments that are displayed to other users by removing all HTML encoding. When necessary, you can allow a limited number of very specific HTML codes.

- Always sanitize request parameters by removing HTML codes. ASP.NET 1.1 provides this functionality automatically.
