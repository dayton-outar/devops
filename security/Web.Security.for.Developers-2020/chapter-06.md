# Chapter 6

## Web Security for Developers-2020

Source: [Web.Security.for.Developers-2020-6.pdf](Web.Security.for.Developers-2020-6.pdf) — 16 PDF pages.

<!-- Source S6, PDF page 1 -->

### Injection Attacks

> [Decorative chapter-opening artwork placeholder — source S6, PDF page 1; 9 image tiles.]

Now that you have a solid grasp of how the internet works, let’s focus on specific vulnerabilities and the methods hackers use to exploit them. This chapter covers injection attacks, which occur when the attacker injects external code into an application in an effort to take control of the application or read sensitive data.

Recall that the internet is an example of a client-server architecture, meaning that a web server handles connections from many clients at once. Most clients are web browsers, responsible for generating HTTP requests to the web server as a user navigates the website. The web server returns HTTP responses containing the HTML that makes up the content of the website’s pages.

Because the web server controls the website’s content, server-side code naturally expects specific types of user interactions to occur, and therefore expects the browser to generate specific types of HTTP requests. For instance, the server expects to see a `GET` request to a new URL each time the

<!-- Source S6, PDF page 2 -->

user clicks a link, or a `POST` request if they enter their login credentials and click Submit.

However, it’s perfectly possible for a browser to generate unexpected HTTP requests to a server. In addition, web servers happily accept HTTP requests from any type of client, not just browsers. A programmer equipped with an HTTP client library can write scripts that send requests to arbitrary URLs on the internet. The hacking tools we reviewed in Chapter 1 do exactly that.

Server-side code has no reliable way of telling whether a script or a browser generated an HTTP request, because the contents of the HTTP request are indistinguishable regardless of the client. The best a server can do is to check the `User-Agent` header, which is supposed to describe the type of agent that generated the request, but scripts and hacking tools typically spoof the contents of this header, so it matches what a browser would send.

Knowing all of this, hackers attacking a website frequently pass malicious code in an HTTP request so that it tricks the server into executing the code. This is the basis of an injection attack on a website.

Injection attacks are astonishingly common on the internet and, if successful, can be devastating in their impact. As a web developer, you’ll need to know all the ways they can occur and how to defend against them. When writing website code, it’s important to consider what could come through in the HTTP requests being handled by the site, not just what you expect to come through. In this chapter, you’ll look at four types of injection attacks: SQL injection attacks, command injection attacks, remote code execution attacks, and attacks that exploit file upload vulnerabilities.

### SQL Injection

SQL injection attacks target websites that use an underlying SQL database and construct data queries to the database in an insecure fashion. SQL injection attacks pose one of the greatest risks to websites because SQL databases are so common. This was evident in 2008, when hackers stole 130 million credit card numbers from Heartland Payment Systems, a payment processor that stores credit card details and handles payments for merchants. The hackers used a SQL injection attack to access the web servers that handled payment data, which was a disaster for a company that relies on the assurance of their information’s security to do business.

Let’s begin by reviewing how SQL databases work, so that we can get to the heart of how SQL injection works and how we can stop it.

### What Is SQL?

Structured Query Language, or SQL, extracts data and data structures in relational databases. Relational databases store data in tables; each row in a table is a data item (for example, a user, or a product being sold). SQL syntax allows applications such as web servers to add rows to the database by using `INSERT` statements, read rows by using `SELECT` statements, update rows by using `UPDATE` statements, and remove rows by using `DELETE` statements.

<!-- Source S6, PDF page 3 -->

Consider the SQL statements that a web server might run behind the scenes when you sign up on a website, as shown in Listing 6-1.

```text
[1] INSERT INTO users (email, encrypted_password)

   VALUES ('billy@gmail.com', '$10$WMT9Y')
[2] SELECT * FROM users WHERE email = 'billy@gmail.com'

   AND encrypted_password = '$10$WMT9Y'
[3] UPDATE USERS users encrypted_password ='3D$MW$10Z'

   WHERE email='billy@gmail.com'
[4] DELETE FROM users WHERE email = 'billy@gmail.com'
```

Listing 6-1: Typical SQL statements that a web server might run when a user interacts with a website

SQL databases typically store information about the website’s users in a `users` table. When a user first signs up and chooses a username and password, the web server runs an `INSERT` statement on the database to create a new row in the `users` table [1]. The next time a user logs in to the website, the web server runs a `SELECT` statement to attempt to find the corresponding row in the `users` table [2]. If the user changes their password, the web server runs an `UPDATE` statement to update the corresponding row in the `users` table [3]. Finally, if the user closes their account, the website might run a `DELETE` statement to remove their row from the `users` table [4].

For each interaction, the web server is responsible for taking parts of the HTTP request (for example, the username and password entered into a login form) and constructing a SQL statement to run against the database. The actual execution of the statement happens through the database driver, a dedicated code library used to communicate with the database.

### Anatomy of a SQL Injection Attack

SQL injection attacks occur when the web server insecurely constructs the SQL statement it passes to the database driver. This allows the attacker to pass arguments via the HTTP request that cause the driver to perform actions other than those the developer intends.

Let’s look at an insecurely constructed SQL statement that reads user data from the database when a user attempts to log in to a website, as shown in the Java code in Listing 6-2.

```text
Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
Statement statement = connection.createStatement();
String sql = "SELECT * FROM users WHERE email='" + email +
             "' AND encrypted_password='" + password + "'";
statement.executeQuery(sql);
```

Listing 6-2: An insecure method of reading user data from the database during a login attempt

The construction of this SQL statement isn’t secure! This snippet uses the `email` and `password` parameters taken from the HTTP request, and inserts them directly into the SQL statement. Because the parameters aren’t checked for SQL control characters (such as `'`) that change the meaning of the SQL

<!-- Source S6, PDF page 4 -->

statement, a hacker can craft input that bypasses the website’s authentication system.

An example of this is shown in Listing 6-3. In this example, the attacker passes the user `email` parameter as `billy@gmail.com'--`, which terminates the SQL statement early and causes the password-checking logic to not execute:

```text
statement.executeQuery(
  "SELECT * FROM users WHERE email='billy@gmail.com'[1]--' AND encrypted_password='Z$DSA92H0'[2]");
```

Listing 6-3: Using SQL injection to bypass authentication

The database driver executes only the SQL statement [1], and ignores everything that comes after it [2]. In this type of SQL injection attack, the single quote character (`'`) closes the email argument early, and the SQL comment syntax (`--`) tricks the database driver into ignoring the end of the statement that does password checking. This SQL statement allows the attacker to log in as any user without having to know their password! All the attacker has to do is add the `'` and `--` characters to the user’s email address in the login form.

This is a relatively simple example of a SQL injection attack. A more advanced attack might cause the database driver to run additional commands on the database. Listing 6-4 shows a SQL injection attack that runs a `DROP` command to remove the `users` table entirely, in order to corrupt the database.

```text
statement.executeQuery("SELECT * FROM users WHERE email='billy@gmail.com';[1]
DROP TABLE users;[2]--' AND encrypted_password='Z$DSA92H0'");
```

Listing 6-4: A SQL injection attack in progress

In this scenario, the attacker passes the email parameter as `billy@gmail` `.com'; DROP TABLE users;--`. The semicolon character (`;`) terminates the first SQL statement [1], after which the attacker inserts an additional, destructive statement [2]. The database driver will run both statements, leaving your database in a corrupt state!

If your website is vulnerable to SQL injection, an attacker can often run arbitrary SQL statements against your database, allowing them to bypass authentication; read, download, and delete data at will; or even inject malicious JavaScript into the pages rendered to your users. To scan websites for SQL injection vulnerabilities, hacking tools like Metasploit can be used to crawl websites and test HTTP parameters with potential exploits. If your site is vulnerable to SQL injection attacks, you can be sure that somebody will eventually take advantage of it.

### Mitigation 1: Use Parameterized Statements

To protect against SQL injection attacks, your code needs to construct SQL strings using bind parameters. Bind parameters are placeholder characters that the database driver will safely replace with some supplied inputs—like

<!-- Source S6, PDF page 5 -->

the email or password values shown in Listing 6-1. A SQL statement containing bind parameters is called a parameterized statement.

SQL injection attacks use “control characters” that have special meaning in SQL statements to “jump out” of the context and change the whole semantics of the SQL statement. When you use bind parameters, these control characters are prefixed with “escape characters” that tell the database not to treat the following character as a control character. This escaping of control characters defuses potential injection attacks.

A securely constructed SQL statement using bind parameters should look like Listing 6-5.

```text
   Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
   Statement statement = connection.createStatement();
[1] String sql = "SELECT * FROM users WHERE email = ? and encrypted_password = ?";
[2] statement.executeQuery(sql, email, password);
```

Listing 6-5: Using bind parameters to protect against SQL injection

This code constructs the SQL query in parameterized form using `?` as the bind parameter [1]. The code then binds the input values for each parameter to the statement [2], asking the database driver to insert the parameter values into the SQL statement while securely handling any control characters. If an attacker attempts to hack this code using the method outlined in Listing 6-4 by passing in a username of `billy@email.com'--`, your securely constructed SQL statement will defuse the attack, as shown in Listing 6-6.

```text
statement.executeQuery(
  "SELECT * FROM users WHERE email = ? AND encrypted_password = ?",
  "billy@email.com'--,",
  "Z$DSA92H0");
```

Listing 6-6: The SQL injection attack is defused.

Because the database driver makes sure not to terminate the SQL statement early, this `SELECT` statement will safely return no users, and the attack should fail. Parameterized statements ensure that the database driver treats all control characters (such as `'`, `--`, and `;`) as an input to the SQL statement, rather than as part of the SQL statement. If you’re not sure whether your website is using parameterized statements, go check immediately! SQL injection is probably the biggest risk your website will face.

Similar types of injection attacks may be possible whenever a web server communicates with a separate backend by constructing a statement in the backend’s native language. This includes NoSQL databases like MongoDB and Apache Cassandra, distributed caches like Redis and Memcached, and directories that implement the Lightweight Directory Access Protocol (LDAP). Libraries that communicate with these platforms have their own implementation of bind parameters, so be sure to understand how they work and to use them in your code.

<!-- Source S6, PDF page 6 -->

### Mitigation 2: Use Object-Relational Mapping

Many web server libraries and frameworks abstract away the explicit construction of SQL statements in code and allow you to access data objects by using object-relational mapping. Object-relational mapping (ORM) libraries map rows in database tables to code objects in memory, meaning the developer generally doesn’t have to write their own SQL statements in order to read from and update the database. This architecture protects against SQL injection attacks under most circumstances, but can still be vulnerable if custom SQL statements are used—so it’s important to understand how your ORM works behind the scenes.

The ORM that people are probably most familiar with is the Ruby on Rails ActiveRecord framework. Listing 6-7 shows a simple line of Rails code that finds a user in a secure fashion.

```text
User.find_by(email: "billy@gmail.com")
```

Listing 6-7: Ruby on Rails code that looks up a user by email in a way that is protected against injection attacks

Because ORMs use bind parameters under the hood, they protect against injection attacks in most cases. However, most ORMs also have backdoors that allow the developer to write raw SQL if needed. If you use these types of functions, you need to be careful about how you construct the SQL statements. For instance, Listing 6-8 shows Rails code that is vulnerable to injection.

```text
def find_user(email, password)
  User.where("email = '" + email + "' and encrypted_password = '" + password + "'")
end
```

Listing 6-8: Ruby on Rails code that is vulnerable to injection

Because this code passes part of the SQL statements as a raw string, an attacker can pass in special characters to manipulate the SQL statement that Rails generates. If the attacker can set the `password` variable to `' OR 1=1`, they can run a SQL statement that disables the password check, as shown in Listing 6-9.

```text
SELECT * FROM users WHERE email='billy@gmail.com' AND encrypted_password ='' OR 1=1
```

Listing 6-9: The `1=1` statement, which is trivially true, disables the password check.

The final clause of this SQL statement disables the password check, allowing the attacker to log in as that user. You can securely call the `where` function in Rails by using bind parameters, as shown in Listing 6-10.

```text
def find_user(email, encrypted_password)
  User.where(["email = ? and encrypted_password = ?", email, encrypted_password])
end
```

Listing 6-10: Secure use of the `where` function

<!-- Source S6, PDF page 7 -->

In this scenario, the ActiveRecord framework will securely handle any SQL control characters an attacker adds to the `email` or `password` parameter.

### Bonus Mitigation: Use Defense in Depth

As a rule of thumb, you should always secure your website with redundancies. It’s not enough to check your code line by line for vulnerabilities. You need to consider and enforce security at every level of the stack, allowing failures at one level to be mitigated by other strategies. This is an approach called defense in depth.

Consider how you secure your home. The most important defense is installing locks on all doors and windows, but it also helps to have a burglar alarm, security cameras, household insurance, and maybe a large badtempered dog, in order to cover all eventualities.

When it comes to preventing SQL injection, defense in depth means using bind parameters, but also taking additional steps to minimize the harm in case an attacker still finds a way to successfully execute injection attacks. Let’s look at a couple of other ways to mitigate the risk of injection attacks.

### Principle of Least Privilege

An additional way to mitigate injection attacks is to follow the principle of least privilege, which demands that every process and application run only with the permissions it needs to perform its permitted functions, and no more. This means that if an attacker injects code into your web server and compromises a particular software component, the damage they can do is limited to the actions permissible by that particular software component.

If your web server talks to a database, make sure the account it uses to log into the database has limited permissions on the data. Most websites need to run only SQL statements that fall under the subset of SQL called the data manipulation language (DML), which includes the `SELECT`, `INSERT`, `UPDATE`, and `DELETE` statements we discussed earlier.

A subset of the SQL language called data definition language (DDL) uses `CREATE`, `DROP`, and `MODIFY` statements to create, drop, and modify the table structures in the database itself. Web servers generally don’t require permissions to execute DDL statements, so don’t grant them the DDL set of permissions at runtime! Narrowing the web server privileges to the minimal DML set reduces the harm an attacker can do if they discover a code vulnerability.

### Blind and Nonblind SQL Injection

Hackers distinguish between blind and nonblind SQL injection attacks. If your website’s error message leaks sensitive information to the client, like the message `Unique constraint violated: this email address already exists in` `users table`, this is a nonblind SQL attack. In this scenario, the attacker gets immediate feedback on their attempts to compromise your system.

<!-- Source S6, PDF page 8 -->

If you keep your error messages to the client more generic, like the messages `Could not find this username and password` or `An unexpected error` `occurred`, this is a blind SQL attack. This scenario means the attacker is effectively operating in the dark and has less to work with. Websites vulnerable to nonblind injection attacks are much easier to compromise, so avoid leaking information in error messages.

### Command Injection

Another type of injection attack is command injection, which attackers can use to exploit a website that makes insecure command line calls to the underlying operating system. If your web application makes command line calls, make sure to construct your command strings securely. Otherwise, attackers can craft HTTP requests that execute arbitrary operating system commands, and seize control of your application.

For many programming languages, constructing command strings to invoke operating systems is actually pretty unusual. Java, for example, runs in a virtual machine, so although you could call out to the operating system by using the `java.lang.Runtime` class, Java applications are generally designed to be portable between different operating systems, so relying on the availability of specific operating systems functions would go against its philosophy.

Command line calls are more common for interpreted languages. PHP is designed to follow the Unix philosophy—programs should do one thing and communicate with each other via text streams—so it’s common for PHP applications to call other programs via the command line. Similarly, Python and Ruby are popular for scripting tasks, so they make it easy to execute commands at the operating system level.

### Anatomy of a Command Injection Attack

If your website makes use of command line calls, make sure an attacker can’t trick the web server into injecting extra commands into the execution call. Imagine, for instance, that you have a simple website that does `nslookup` to resolve domains and IP addresses. The PHP code takes the domain or IP address from the HTTP request and constructs an operating system call as shown in Listing 6-11.

```text
<?php
    if (isset($_GET['domain'])) {
        echo '<pre>';
        $domain = $_GET['domain'][1];
        $lookup = system("nslookup {$domain[2]}");
        echo($lookup);
        echo '</pre>';
    }
?>
```

Listing 6-11: PHP code receiving an HTTP request and constructing an operating system call

<!-- Source S6, PDF page 9 -->

The `domain` parameter is extracted from the HTTP request at [1]. Because the code does not escape the `domain` argument when constructing the command string [2], an attacker can craft a malicious URL and tag an extra command on the end, as shown in Figure 6-1.

> [Figure 6-1: Using the URL to inject a malicious command — image placeholder; source S6, PDF page 9.]

Here the attacker sends a domain parameter with the value `google.com` `&& echo "HAXXED"`, and the browser URL-encodes the whitespace and nonalphanumeric characters. The `&&` syntax in Unix concatenates separate commands. Because our PHP code doesn’t strip such control characters, the attacker carefully constructs the HTTP request to append an extra command. Two separate commands will get executed in this scenario: the expected `nslookup` command that looks up google.com, followed by the injected command `echo "HAXXED"`.

In this case, the injected command is a harmless `echo` command, which simply prints out `"HAXXED"` in the HTTP response. However, an attacker can use this vulnerability to inject and execute any command they choose on your server. With a bit of effort, they can explore the filesystem, read sensitive information, and compromise the entire application. Command line access on a web server gives the attacker complete freedom to take control of the system unless you take deliberate steps to lessen the impact.

### Mitigation: Escape Control Characters

As with SQL injection, you can defend against command injection by properly escaping inputs from the HTTP request. This means replacing sensitive control characters (like the `&` character in our example) with a

<!-- Source S6, PDF page 10 -->

safe alternative. How you do this depends on the operating system and programing language you’re using. To make the PHP code in Listing 6-11 more secure, we simply need to use a call to `escapeshellarg`, as shown in Listing 6-12.

```text
<?php
    if (isset($_GET['domain'])) {
        echo '<pre>';
        $domain = escapeshellarg[1]($_GET['domain']);
        $lookup = system("nslookup {$domain}");
        echo($lookup);
        echo '</pre>';
    }
?>
```

Listing 6-12: PHP code escaping inputs from the HTTP request

The call to `escapeshellarg` [1] ensures that attackers can’t inject extra commands via the `domain` parameter.

Python and Ruby can prevent potential command injection attacks too. In Python, the `call()` function should be invoked with an array, rather than a string, to prevent attackers from tagging extra commands onto the end, as shown in Listing 6-13.

```text
    from subprocess import call
    call(["nslookup", domain])
```

Listing 6-13: The `call` function in Python’s `subprocess` module

In Ruby, the `system()` function makes a command line call. Supply it with an array of arguments, rather than a string, to ensure that attackers can’t sneak in extra commands, as shown in Listing 6-14.

```text
    system("nslookup", domain)
```

Listing 6-14: The `system()` function in Ruby

As with SQL injection, following the principle of least privilege also helps limit the impact of successful command injection attacks. Your web server process should run with only the permissions it requires. For instance, you should limit the directories the web server process can read from and write to. On Linux, you can use the `chroot` command to prevent the process from exploring outside a designated root directory. You should try to limit the network access your web server has, too, by configuring firewalls and access control lists on the network. These steps will make it much harder for a hacker to exploit a command injection vulnerability, because even if they can execute commands, they can’t do anything besides read files in the web server’s running directory.

<!-- Source S6, PDF page 11 -->

### Remote Code Execution

So far, you’ve seen how vulnerabilities can creep in when web code constructs a call to databases, as with SQL injection, or to the operating system it’s running on, as with command injection. In other circumstances, attackers can inject malicious code to be executed in the language of the web server itself, a tactic called remote code execution. Remote code execution attacks on websites are rarer than the injection attacks we discussed earlier, but every bit as dangerous.

### Anatomy of a Remote Code Execution Attack

An attacker can achieve remote code execution by discovering a vulnerability in a particular type of web server, and then creating exploit scripts to target websites running on that web server technology. The exploit script incorporates malicious code in the body of the HTTP request, encoded in such a way that the server will read and execute that code when the request is handled. The techniques used to perform remote execution attacks vary significantly. Security researchers will analyze codebases for common web servers, looking for vulnerabilities that permit malicious code to be injected.

In early 2013, researchers discovered a vulnerability in Ruby on Rails that permitted attackers to inject their own Ruby code into the server process. Because the Rails framework automatically parses requests according to their `Content-Type` header, security researchers noticed that if they created an XML request with an embedded YAML object (a markup language commonly used in the Rails community for storing configuration data), they could trick the parsing process into executing arbitrary code.

### Mitigation: Disable Code Execution During Deserialization

Remote code execution vulnerabilities usually occur when web server software uses insecure serialization. Serialization is the process of converting an in-memory data structure into a stream of binary data, usually for the purpose of passing the data structure across a network. Deserialization refers to the reverse process that occurs at the other end, when the binary data is converted back into a data structure.

Serialization libraries exist in every major programming language and are widely used. Some serialization libraries, such as the YAML parser used by Rails, allow data structures to execute code as they reinitialize themselves in memory. This is a useful feature if you trust the source of the serialized data, but can be very dangerous if you don’t, because it can permit arbitrary code execution.

If a web server uses deserialization to handle data coming in from HTTP requests, it needs to defuse any serialization libraries it uses by disabling any code-execution capabilities; otherwise, an attacker may be able to find a way to inject code directly into the web server process. We can typically disable code execution via a relevant configuration setting that will allow your web server software to deserialize data without executing code.

<!-- Source S6, PDF page 12 -->

As a developer who uses a web server to build sites, rather than one who writes the web server code itself, protecting against remote code execution in your web stack usually amounts to staying aware of security advisories. You’re unlikely to be writing your own serialization libraries, so be aware of where your codebase uses third-party serialization libraries. Make sure to turn off active code execution features in your own code, and keep an eye out for vulnerability announcements issued by your web server vendor.

### File Upload Vulnerabilities

The final type of injection attack we’ll look at in this chapter takes advantage of vulnerabilities in file upload functions. Websites use file upload functions for a variety of purposes: letting users add images to their profile or posts, adding attachments to messages, submitting paperwork, sharing documents with other users, and so on. Browsers make it easy to upload files via built-in file-upload widgets and JavaScript APIs that allow you to drag files onto a web page and send them asynchronously to the server.

However, browsers aren’t exactly careful about checking the contents of a file. Attackers can easily abuse file upload functions by injecting malicious code into an uploaded file. Web servers typically treat uploaded files like large blobs of binary data, so it’s pretty easy for an attacker to upload a malicious payload without the web server detecting it. Even if your site has JavaScript code that checks a file’s content before uploading it, an attacker can write scripts to post file data to the server-side endpoint directly, circumventing any security measures you put in place on the client side.

Let’s see how attackers typically exploit file upload functions so that we identify the various security weaknesses that we need to plug.

### Anatomy of a File Upload Attack

As an example of a file upload vulnerability, let’s look at how an attacker could potentially abuse the profile image upload function of your site. The attacker first writes a small web shell, a simple executable script that will take an argument from an HTTP request, execute it on the command line, and output the result. Web shells are a common tool used by hackers attempting to compromise a web server. Listing 6-15 shows an example of a web shell written in PHP.

```text
<?php
  if(isset($_REQUEST['cmd'])) {
    $cmd = ($_REQUEST['cmd']);
    system($cmd);
  } else {
    echo "What is your bidding?";
  }
?>
```

Listing 6-15: A web shell written in the PHP language

<!-- Source S6, PDF page 13 -->

The attacker saves this script as hack.php on their computer and uploads it as their profile “image” on your site. PHP files are typically treated by operating systems as executable files, which is key to making this attack work. Clearly a file ending with .php isn’t a valid image file, but the attacker can fairly easily disable any JavaScript file-type checking done during the upload process.

Once the attacker has uploaded their “image” file, their website profile page will show a missing image icon, because their profile image is corrupted and not actually an image. However, at this point they have achieved their real aim: smuggling the web shell file onto your server, which means their malicious code is now deployed to your site, waiting to be executed in some fashion.

Because the web shell is available on a public URL, the attacker has potentially created a backdoor for executing the malicious code. If your server’s operating system has a PHP runtime installed, and the file was written to disk with executable privileges during the upload process, the attacker can pass commands to run the web shell simply by invoking the URL that corresponds to their profile image.

To perform a command injection attack, the hacker can pass a `cmd` argument to the web shell to execute arbitrary operating system commands on your server, as shown in Figure 6-2.

> [Figure 6-2: If your file upload function is vulnerable, a hacker could use a web shell to access your database credentials. — image placeholder; source S6, PDF page 13.]

In this scenario, the attacker can explore your filesystem. The attacker has taken advantage of your file upload function to gain the same access to your operating system as they would with a command injection attack.

### Mitigations

You can use several mitigations to protect yourself against vulnerabilities in file upload code. The most important mitigations ensure that any uploaded files can’t be executed as code. Following the principle of defense in depth, you should also analyze uploaded files and reject any that appear to be corrupt or malicious.

<!-- Source S6, PDF page 14 -->

### Mitigation 1: Host Files on a Secure System

The first, most important approach to securing file upload functions is to ensure that your web server treats uploaded files as inert rather than executable objects. You can do this by hosting your uploaded files in a content delivery network (CDN) such as Cloudflare or Akamai, as described in Chapter 4, which offloads the security burden to a third party who stores your files securely.

CDNs have other nonsecurity-related benefits too. CDNs serve files extremely fast to the browser, and can put them through processing pipelines as you upload them. Many CDNs offer sophisticated JavaScript upload widgets that you can add with a few lines of code, and that provide bonus features like image cropping.

If for some reason a CDN isn’t an option, you can get many of the same benefits by storing uploaded files in cloud-based storage (for example, Amazon Simple Storage Service, or S3) or a dedicated content management system. Both approaches provide secure storage that defuses all web shells as they’re uploaded. (Although, if you’re hosting your own content management system, you’ll have to make sure to configure it correctly.)

### Mitigation 2: Ensure Uploaded Files Cannot Be Executed

If using a CDN or content management system isn’t an option, you need to take the same steps to secure your files that a CDN or content management does behind the scenes. This means ensuring that all files are written to disk without executable permissions, separating uploaded files into a particular directory or partition (so they aren’t intermingled with code), and hardening your servers so that only the minimally required software is installed. (Uninstall the PHP engine if you aren’t using it!) It’s a good idea to rename files as you upload them too, so you don’t write files with dangerous file extensions to disk.

The ways to achieve these ends vary depending on your hosting technology, operating system, and the programming language you use. If you’re running a Python web server on Linux, for instance, you can set file permissions when creating a file by using the `os` module, as shown in Listing 6-16.

```text
import os
file_descriptor = os.open("/path/to/file", os.O_WRONLY | os.O_CREAT, 0o600)
with os.fdopen(open(file_descriptor, "wb")) as file_handle:
  file_handle.write(...)
```

Listing 6-16: Writing a file with read-write (but not execute) permissions in Python on Linux

Removing unneeded software from your operating system is always a good idea, because it gives a hacker fewer tools to play with. The Center for Internet Security (CIS) provides prehardened operating system images that make a good starting point. They’re available as Docker images or as Amazon Machine Images (AMIs) in the Amazon Web Services Marketplace.

<!-- Source S6, PDF page 15 -->

### Mitigation 3: Validate the Content of Uploaded Files

If you’re uploading files with a known file type, consider adding some file-type checking in your code. Make sure the `Content-Type` header in the HTTP request of the upload matches the expected file type, but be aware that an attacker can easily spoof the header.

It’s possible to validate the file type after the file has been uploaded, particularly with image files, so it’s a good idea to implement this feature in your server-side code, as shown in Listing 6-17. Your mileage should vary, though; clever hackers in the past have infiltrated various systems by designing payloads that are valid for more than one type of file format.

```text
>>> import imghdr
>>> imghdr.what('/tmp/what_is_this.dat')
'gif'
```

Listing 6-17: Reading the file headers to validate a file format in Python

### Mitigation 4: Run Antivirus Software

Finally, if you’re running on a server platform that’s prone to viruses (hello, Microsoft Windows!) make sure you’re running up-to-date antivirus software. File upload functions are an open door to virus payloads.

### Summary

In this chapter, you learned about various injection attacks, whereby an attacker crafts malicious HTTP requests to take control of backend systems.

SQL injection attacks take advantage of web code that doesn’t securely construct SQL strings when communicating with a SQL database. You can mitigate SQL injection by using bind parameters when communicating with the database driver.

Command injection attacks take advantage of code that makes insecure calls to operating system functions. You can similarly defuse command injection through correct use of binding.

Remote code execution vulnerabilities allow hackers to run exploits inside the web server process itself, and typically stem from insecure serialization libraries. Make sure to stay on top of any security advisories for the serialization libraries you use, and for your web server software.

File upload functions often enable command injection attacks if your file upload functionality writes uploaded files to disk with executable privileges. Make sure to write uploads to a third-party system or to disk with appropriate permissions, and do whatever you can to validate the file type as you upload them.

<!-- Source S6, PDF page 16 -->

You can mitigate the risks around all types of injection attacks by following the principle of least privilege: processes and software components should run with only the permissions they require to perform their assigned tasks, and no more. This approach reduces the harm an attack can do if they inject harmful code. Examples of following the principle of least privilege include limiting file and network access for your web server process, and connecting to your database under an account with limited permissions.

In the next chapter, you’ll look at how hackers can use JavaScript vulnerabilities to attack your website.
