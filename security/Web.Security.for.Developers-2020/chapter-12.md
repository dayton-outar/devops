# Chapter 12

## Web Security for Developers-2020

Source: [Web.Security.for.Developers-2020-12.pdf](Web.Security.for.Developers-2020-12.pdf) — 4 PDF pages.

<!-- Source S12, PDF page 1 -->

### Information Leaks

![Figure 12-1: Chapter-opening artwork](/.attachments/12-1-Web.Security.for.Developers-2020-12.png)

*Figure 12-1: Chapter-opening artwork*

<!-- Source: Web.Security.for.Developers-2020-12.pdf, PDF page 1. -->

Hackers frequently use publicized security vulnerabilities, especially zero-day vulnerabilities—security flaws that have been made public in the last 24 hours. When someone publishes a zero-day vulnerability for a software component, hackers will immediately scan for web

servers running the vulnerable software in order to exploit the security hole. To protect yourself from such threats, you should ensure that your web server doesn’t leak information about the type of software stack you’re running on. If you inadvertently advertise your server technology, you’re making yourself a target.

In this chapter, you’ll learn some common ways web servers leak information about your technology choices and how to mitigate each of these risks.

<!-- Source S12, PDF page 2 -->

### Mitigation 1: Disable Telltale Server Headers

Make sure to disable any HTTP response headers in your web server configuration that reveal the server technology, language, and version you’re running. By default, web servers usually send a `Server` header back with each response, describing which software is running on the server side. This is great advertising for the web server vendor, but the browser doesn’t use it. It simply tells an attacker which vulnerabilities they can probe for. Make sure your web server configuration disables this `Server` header. (Or if you’re feeling mischievous, have it report the wrong web server technology!)

### Mitigation 2: Use Clean URLs

When you design your website, avoid telltale file suffixes in URLs, such as .php, .asp, and .jsp. Implement clean URLs instead—URLs that do not give away implementation details. URLs with file extensions are common in older web servers, which explicitly reference template filenames. Make sure to avoid such extensions.

### Mitigation 3: Use Generic Cookie Parameters

The name of the cookie your web server uses to store session state frequently reveals your server-side technology. For instance, Java web servers usually store the session ID under a cookie named `JSESSIONID`. Attackers can check these kinds of session cookie names to identify servers, as shown in Listing 12-1.

```text
[1] if response.get_cookies.match(/JSESSIONID=(.*);(.*)/i)

   jsessionid = $1
   post_data  = "j_username=#{username}&j_password=#{password}"

   response = send_request_cgi({
                'uri'          => '/admin/j_security_check',
                'method'       => 'POST',
                'content-type' => 'application/x-www-form-urlencoded',
                'cookie'       => "JSESSIONID=#{jsessionid}",
                'data'         => post_data,
              })
```

Listing 12-1: The hacking tool Metasploit attempting to detect and compromise an Apache Tomcat server

Note that the Metasploit code checks the name of the session cookie [1]. Make sure that your web server sends nothing back in cookies that give clues about your technology stack. Change your configuration to use generic names for the session cookie (for example, `session`).

<!-- Source S12, PDF page 3 -->

### Mitigation 4: Disable Client-Side Error Reporting

Most web servers support client-side error reporting, which allows the server to print stack traces and routing information in the HTML of the error page. Client-side error reporting is really useful when debugging errors in test environments. However, stack traces and error logs also tell an attacker which modules or libraries you’re using, helping them pick out security vulnerabilities to target. Errors occurring in your data access layer can even reveal details about the structure of your database, which is a major security hazard!

You must disable error reporting on the client side in your production environment. You should keep the error page your users see completely generic. At most, users should know that an unexpected error occurred and that someone is looking into the problem. Detailed error reports should be kept in production logs and error reporting tools, which only administrators can access.

Consult your web server’s documentation on how to disable client-side error reporting. Listing 12-2 illustrates how you would disable this functionality in a Rails config file.

```text
  # Full error reports are disabled.
  config.consider_all_requests_local = false
```

Listing 12-2: Make sure your production configuration file (typically stored at config /environments/production.rb in Ruby on Rails) disables client-side error reporting.

### Mitigation 5: Minify or Obfuscate Your JavaScript Files

Many web developers preprocess their JavaScript code before deploying it by using a minifier, which takes JavaScript code and outputs a functionally equivalent but highly compressed JavaScript file. Minifiers remove all extraneous characters (such as whitespace) and replace some code statements with shorter, semantically identical statements. A related tool is an obfuscator, which replaces method and function names with short, meaningless tokens without changing any behavior in the code, deliberately making the code less readable. The popular UglifyJS utility has both capabilities, and can be invoked directly from the command line with the syntax `uglifyjs` `[``input files``]`, which makes it straightforward to plug into your build process.

Developers usually minify or obfuscate JavaScript code for performance, because smaller JavaScript files load faster in the browser. This preprocessing also has the positive side effect of making it harder for an attacker to detect which JavaScript libraries you’re using. Researchers or attackers periodically discover security vulnerabilities in popular JavaScript libraries that permit cross-site scripting attacks. Making it harder to detect the libraries you’re using will give you more breathing room when exploits are discovered.

<!-- Source S12, PDF page 4 -->

### Mitigation 6: Sanitize Your Client-Side Files

It’s important that you conduct code reviews and use static analysis tools to make sure sensitive data doesn’t end up in comments or that dead code doesn’t get passed to the client. It’s easy for developers to leave comments in HTML files, template files, or JavaScript files that share a little too much information, since we forget that these files get shipped to the browser. Minifying JavaScript might strip comments, but you need to spot sensitive comments in template files and hand-coded HTML files during code reviews and remove them.

Hacking tools make it easy for an attacker to crawl your site and extract any comments that you’ve accidentally left behind—hackers often use this technique to scan for private IP addresses accidentally left in comments. This is often a first port of call when a hacker is attempting to compromise your website.

### Stay on Top of Security Advisories

Even with all your security settings locked down, a sophisticated hacker can still make a good guess about the technology you’re running. Web servers have telltale behaviors in the way they respond to specific edge cases: deliberately corrupted HTTP requests or requests with unusual HTTP verbs, for example. Hackers can use these unique server-technology fingerprints to identify the server-side technology stack. Even when you follow best practices regarding information leakage, it’s important to stay on top of security advisories for the technology you use and deploy patches in a prompt manner.

### Summary

You should ensure that your web server doesn’t leak information about the type of software stack you’re running on, because hackers will use this information against you when trying to figure out how to compromise your website. Make sure your configuration disables telltale headers and uses a generic session cookie name in the HTTP response. Use clean URLs that don’t contain filename extensions. Minify or obfuscate your JavaScript so it’s harder to tell which third-party libraries you’re using. Turn off verbose client-side error reporting in your production site. Make sure to sanitize your template files and HTML for comments that give out too much information. Finally, stay on top of security advisories so you can deploy patches in a timely manner.

In the next chapter, you will take a look at how to secure traffic to your website by using encryption.
