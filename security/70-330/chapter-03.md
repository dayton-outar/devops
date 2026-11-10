# Chapter 3

<a id="section-2"></a>

## Implementing Security for Applications-2005

Source: [Implementing.Security.for.Applications-2005-3-2.pdf](Implementing.Security.for.Applications-2005-3-2.pdf) — section 2, 10 pages.

<!-- Section 2, PDF page 1 -->

### Lesson 2: Testing Assemblies for Vulnerabilities

Unit testing has its limits for vulnerability testing. Specifically, unit testing cannot detect poor coding practices, such as not declaring permission requirements. Unit testing also cannot detect confidential data being transmitted through unencrypted communica- tions channels, nor vulnerability to denial-of-service (DoS) attacks. As a developer, it is worthwhile for you to perform these fundamental types of tests against your own assemblies.

After this lesson, you will be able to

- List key steps in the developer’s pre-release security testing process.

- Improve the effectiveness of vulnerability testing.

- List no-cost tools for testing your applications for security vulnerabilities.

Estimated lesson time: 30 minutes

### The Developer’s Pre-Release Security Testing Process

Formal security testing involves using one of several different well-known processes. This book won’t attempt to describe these formalized processes, because this book is about development, not testing. However, before handing off an application you develop to QA, you should consider the following steps when examining it for poten- tial security vulnerabilities:

1. Assess the attack surface Identify all potential points of direct entry to your application, including ASP.NET pages that accept input, Web services, and all pub- lic methods. Each potential point of entry should be examined for vulnerabilities.

2. Identify likely targets, and also potential attackers who would be attracted to those targets For example, a Web application with forum capabilities is likely to be targeted with CSS attacks by forum users against other forum users. An e-commerce application is more likely to be targeted by financially motivated attackers seeking credit card numbers. Assume an application is vulnerable to all major types of attack, unless it has a specific resistance. For example, Windows Forms applications are generally not targeted by CSS attacks, and applications built on the .NET Framework are very resistant to buffer overflow attacks.

3. Assess communication security Can an attacker with access to the network equipment capture traffic and derive confidential information?

4. Verify that your application’s default configuration is the most secure If your application requires tuning after installation to improve the security, it is not following the secure by default tenet.

<!-- Section 2, PDF page 2 -->

5. Verify that the least privilege principle is followed Specifically, test that databases have restricted permissions and client-side applications that can be run by a standard user account.

See Also For more information about the secure-by-default and least privilege principles, see Chapter 2.

6. Test the server component’s resistance to DoS attacks Generally, tools that test scalability reveal DoS susceptibility.

See Also For more information about formal security testing methodologies, read the Open Source Security Testing Methodology Manual, available at http://www.isecom.org/projects /osstmm.shtml.

### Best Practices for Vulnerability Testing

Thoroughly covering vulnerability testing would require an entire book, so this section provides best practices. Developers who are performing preliminary vulnerability testing on their own applications prior to handoff to QA should apply as many of these best practices as they can:

- Monitor attack trends Stay up to date on the latest types of attacks, because new types of exploits appear regularly.

See Also For information about exploiting vulnerable applications, see Chapter 1.

- Simulate attacks and examine events Determine whether administrators can detect and analyze a particular attack based on the monitoring information pro- vided by the application. Do log files provide enough information to identify the attacker and understand the attack technique?

- Test beyond the application If your application trusts DNS when contacting a server because it doesn’t use any server authentication, that might be okay—but it’s important to disclose this to your customers.

- Filter test requests from usage logs If you are testing a Web application that is already in a production environment, configure your usage-reporting software to ignore requests from the test computer or computers.

- Test Windows Forms applications as a regular user By not using an admin- istrator account, you will identify any problems your application has complying with the principle of least privilege.

<!-- Section 2, PDF page 3 -->

### Available Security Testing Tools

As a developer, you probably do not have a significant amount of time allocated to test- ing your own applications. To allow you to perform some pre-QA security testing as efficiently as possible, this section describes no-cost tools that automate and simplify the process of identifying vulnerabilities in your application.

### FxCop

FxCop compares assemblies to a list of rules based on the Microsoft .NET Framework Design Guidelines. FxCop reveals a large number of both common and uncommon coding mistakes, many of which are security related. For example, making IntPtr and UIntPtr pointers public fields exposes a potential security vulnerability, because another assembly might be able to read or modify the pointers. Most rules do not have a direct impact on the vulnerability level of the application. However, following the .NET Framework Design Guidelines will make the code more consistent and easier to review, which in turn improves security.

See Also Read the .NET Framework Design Guidelines at http://msdn.microsoft.com /library/en-us/cpgenref/html/cpconnetframeworkdesignguidelines.asp.

See Also The practice at the end of this lesson walks you through the process of using FxCop.

Figure 3-2 shows FxCop discovering a number of weaknesses in an assembly, includ- ing uncaught exceptions.

> [Figure 3-2 placeholder — FxCop discovers that specific exceptions are not caught. Source: section 2 source PDF above, PDF page 3.]

<!-- Section 2, PDF page 4 -->

### Network Monitor

Network Monitor is a protocol analyzer (more commonly known as a sniffer) that is included free with Microsoft server operating systems. Network Monitor captures and analyzes raw network communications. After it captures traffic, you can examine the communications to determine whether encryption is used and whether any confiden- tial information is being transmitted across the network without being encrypted or obscured.

To install Network Monitor on Windows Server 2003:

1. From Control Panel, launch the Add or Remove Programs applet.

2. Click Add/Remove Windows Components.

3. In the Windows Components Wizard, click Management And Monitoring Tools, and then click Details.

4. Select the Network Monitor Tools check box, and then click OK.

5. Click Next. Respond to any prompts that appear. Finally, click Finish.

After installation, you can run Network Monitor from the Administrative Tools group. You can run Network Monitor on either the client or the server; however, the version of Network Monitor included free with Microsoft server operating systems is capable of capturing only traffic sent to or from the computer on which it is running. Figure 3-3 shows captured Web communications—evidently unencrypted, because the details of the request are visible.

> [Figure 3-3 placeholder — Use Network Monitor to verify that Network Communications cannot be easily analyzed. Source: section 2 source PDF above, PDF page 4.]

<!-- Section 2, PDF page 5 -->

See Also To use Network Monitor effectively, you must have a detailed understanding of network protocols. For more information about using Network Monitor, see Windows Server 2003 Help And Support Center.

Real World Detecting Communications Vulnerabilities If your application is sending user names and passwords in clear text across the network, Network Monitor will make that weakness painfully obvious. Several no-cost tools are available that perform the same type of protocol analysis, so attackers won’t have any problem re-creating your test and using the information against you. Network Monitor makes it obvious that your application exposes pri- vate information only when you use the clear text format. For example, anyone can manually decode ROT13 (which rotates characters 13 letters through the alphabet), but Network Monitor won’t help you out.

Early in my career I spent some time studying Request For Comments (RFCs), especially those relating to Web communications. The RFCs taught me that basic user authentication between a browser and a Web server uses Base64 encoding, but every other piece of documentation I read said that the password was trans- mitted in “clear text.” To reconcile this, I pulled up Network Monitor and captured an authentication attempt. I quickly found where the password was in the packet, but it was definitely not in clear text—it appeared to be gibberish. I knew that Base64 encoding could be decoded without a password or key, but not simply. Eventually, I wrote a Perl script to do the conversion and verified that it was, indeed, easy to identify the raw password.

To the untrained eye, the weakest of encryption techniques, or even reversible encoding, appears to be encrypted. In short, you can use Network Monitor to detect only obvious, glaring communications vulnerabilities. However, you not seeing any problems doesn’t mean a sophisticated attacker can’t find a weakness.

### Application Center Test

Application Center Test, a tool included with Visual Studio .NET, is primarily designed to test the performance of ASP.NET applications. However, it should not be overlooked as a tool for testing resistance to DoS attacks. DoS attacks against applications are effec- tive because the applications do not scale efficiently. Testing an ASP.NET application under heavy load simulates one type of a DoS attack against your application, and Application Center Test will reveal how your application responds to heavy load, and which pages in your application fail.

<!-- Section 2, PDF page 6 -->

Figure 3-4 shows a Web application being tested. As shown in the figure, the Web application is responding to between 0 and 40 requests per second—a relatively low rate that is not likely to withstand even an unsophisticated DoS attack. However, the application is not producing HTTP errors, which is a good sign.

> [Figure 3-4 placeholder — Microsoft Application Center Test is a good way to test resistance to DoS attacks. Source: section 2 source PDF above, PDF page 6.]

Application Center Test produced the following summary output from a live Web server that handled about 250 requests per second. In the Response Codes section, notice that 100 percent of the response codes were 200—the HTTP success response code. An application that was less resistant to DoS attacks would have begun returning other HTTP response codes, such as 500.

### Errors Counts

- HTTP: 0

- DNS: 0

- Socket: 0

### Additional Network Statistics

- Average bandwidth (bytes/sec): 1,120,257.96

- Number of bytes sent (bytes): 18,957,590

- Number of bytes received (bytes): 317,119,798

- Average rate of sent bytes (bytes/sec): 63,191.97

<!-- Section 2, PDF page 7 -->

- Average rate of received bytes (bytes/sec): 1,057,065.99

- Number of connection errors: 0

- Number of send errors: 0

- Number of receive errors: 0

- Number of timeout errors: 0

### Response Codes

- Response Code: 200 - The request completed successfully.

- Count: 48,719

- Percent (%): 100.00

If the application does not scale well, you can view the Requests report to determine which pages are the sources of the bottleneck. Application Center Test records the average time to first byte and time to last byte for each page in your test.

Tip You should focus your development time on increasing the efficiency of the pages that had the highest response times; they are the most likely to be targeted during a DoS attack.

When creating tests, remember that attackers might not use standard, well-formed HTTP requests. They might submit invalid information to your application specifically to induce a processor-intensive error-handling routine. Fortunately, Application Center Test provides a great deal of flexibility and can simulate a potentially malicious request during a test.

Off the Record Unfortunately, no amount of testing or scalability can make your applica- tion entirely resistant to DoS attacks. Well-formed distributed DoS attacks will almost always cause an application, computer, or the underlying network to become inaccessible. Yes, with proper tuning, you can enable your application to resist an attacker with a single computer. However, if your application gets targeted by an attacker who controls thousands of zombie computers (compromised computers that an attacker controls), you’re going offline.

### Permissions View Tool

The Permissions View tool (Permview.exe) is a command-line tool that developers and testers can use to view the permission sets requested by an assembly or to view all declarative security used by an assembly. For example, you can use Permview.exe to verify that a developer has specifically requested permissions in the assembly, and that the permissions are not excessive. The following output shows Permview analyzing an

<!-- Section 2, PDF page 8 -->

assembly that contains a minimum permission set request of Unrestricted, which would be considered excessive in most circumstances:

```text
Microsoft (R) .NET Framework Permission Request Viewer.  Version 1.1.4322.573 Copyright
         (C) Microsoft Corp. 1998-2000
```

```text
minimal permission set:
         <PermissionSet class="System.Security.PermissionSet” version ="1">
            <Unrestricted/>
         </PermissionSet>
```

```text
optional permission set:
            Not specified
```

```text
refused permission set:
            Not specified
```

Permview is included with the .NET Framework software development kit. It is prob- ably not in your path by default, but if you installed Visual Studio .NET 2003, you can find it in the C:\Program Files\Microsoft Visual Studio .NET 2003\SDK\v1.1\Bin\ folder.

### PEVerify Tool

The PEVerify (PEVerify.exe) tool helps developers who generate Microsoft intermediate language (MSIL)—such as compiler writers and script engine developers—determine whether their MSIL code and associated metadata meet type safety requirements. Some compilers generate verifiably type-safe code only if you avoid using certain language constructs. If, as a developer, you are using such a compiler, you might want to verify that you have not compromised the type safety of your code. In this situation, you can run the PEVerify tool on your files to check the MSIL and metadata.

PEVerify is included with the .NET Framework software development kit. It is probably not in your path by default, but if you installed Visual Studio .NET 2003, you can find it in the C:\Program Files\Microsoft Visual Studio .NET 2003\SDK\v1.1\Bin\ folder.

### Practice: Testing Assemblies for Vulnerabilities

In this practice, you use FxCop to analyze a sample assembly. Then, you analyze one of your own assemblies, and answer questions about the results. Complete the proce- dure in Exercise 1, and then answer the questions and complete the tasks in Exercise 2. If you are unable to answer a question, review the lesson materials and try the question again. You can find answers to the questions in the “Questions and Answers” section at the end of this chapter

<!-- Section 2, PDF page 9 -->

### Exercise 1: Using FxCop to Test an Assembly for Security Weaknesses

In this exercise, you use FxCop to analyze a sample assembly to identify potential security weaknesses.

1. Download and install the latest version of FxCop from http://www.gotdotnet.com /team/fxcop/.

2. If you did not complete the Practice associated with Lesson 1, complete the fol- lowing steps:

a. Use Windows Explorer to copy the NorthwindUnitTesting folder from the companion CD to your My Documents\Visual Studio Projects\ folder.

b. In Windows Explorer, select the My Documents\Visual Studio Projects\ folder, and then double-click NorthwindUnitTesting.csproj.

Visual Studio .NET 2003 will open the Northwind project.

c. Remove the contents of the DatabaseClassTest class.

3. In Visual Studio .NET 2003, with the NorthwindUnitTesting project open, click the Build menu, and then click Build Solution.

Visual Studio .NET 2003 compiles the application.

4. Launch the FxCop tool.

5. Click the File menu, and then click New Project.

6. Click the Project menu, and then click Add Targets. In the Open dialog box, select the My Documents\Visual Studio Projects\NorthwindUnitTesting\bin\Debug \NorthwindUnitTesting.exe file. Click Open.

7. Click the Project menu, and then click Analyze.

8. In the Analysis Summary dialog box, click OK.

FxCop displays a list of rules that have been violated, as shown in Figure 3-5.

> [Figure 3-5 placeholder — FxCop displays an analysis of the sample application. Source: section 2 source PDF above, PDF page 9.]

<!-- Section 2, PDF page 10 -->

9. Double-click the Assemblies Specify Permission Requests rule.

10. In the Active Message Details dialog box, click the Rule Details tab, shown in Figure 3-6.

> [Figure 3-6 placeholder — FxCop provides detailed information about broken rules. Source: section 2 source PDF above, PDF page 10.]

11. Read the description and additional information. (Chapter 6, “Implementing Code Access Security,” provides more information about permission requests.)

12. Click the Rule Support tab. Note that a URL is provided that contains additional information about the rule and about how to write code that uses permissions requests.

13. Click OK to return to FxCop, examine each of the other rules, and think about which of the rules could have an impact on security.

### Exercise 2: Analyzing FxCop Results

In this exercise, you answer questions about FxCop’s analysis of an application you have written. First, use FxCop to analyze the assembly you most recently compiled.

1. Which of the rules highlight weaknesses in your code that should be addressed?

2. Which of the rules can be safely ignored?

3. What potential security vulnerabilities are not discovered by FxCop? Is using FxCop sufficient to limit your risk from vulnerabilities?
