# Chapter 7

## Web Security for Developers-2020

Source: [Web.Security.for.Developers-2020-7.pdf](Web.Security.for.Developers-2020-7.pdf) — 11 PDF pages.

> Source boundary note: PDF page 1 is printed page 64, the concluding page of chapter 6. It is retained here with its supplied source. Chapter 7 begins on PDF page 2.

<!-- Source S7, PDF page 1 -->

You can mitigate the risks around all types of injection attacks by following the principle of least privilege: processes and software components should run with only the permissions they require to perform their assigned tasks, and no more. This approach reduces the harm an attack can do if they inject harmful code. Examples of following the principle of least privilege include limiting file and network access for your web server process, and connecting to your database under an account with limited permissions.

In the next chapter, you’ll look at how hackers can use JavaScript vulnerabilities to attack your website.

<!-- Source S7, PDF page 2 -->

### Cross-Site Scripting Attacks

> [Decorative chapter-opening artwork placeholder — source S7, PDF page 2; 9 image tiles.]

In the previous chapter, you saw how attackers can inject code into web servers to compromise websites. If your web server is secure, a hacker’s next best injection target is the web browser. Browsers obediently execute any JavaScript code that appears in a web page, so if an

attacker can find a way to inject malicious JavaScript into a user’s browser while the user views your website, that user is in for a bad time. We call this type of code injection a cross-site scripting (XSS) attack.

JavaScript can read or modify any part of a web page, so there’s a lot an attacker can do with cross-site scripting vulnerabilities. They can steal login credentials or other sensitive information like credit card numbers as the user types them in. If JavaScript can read the HTTP session information, they can hijack a user’s session entirely, allowing them to log in as that user remotely. (You’ll learn more about session hijacking in Chapter 10).

Cross-site scripting is a remarkably common type of attack, and the dangers it poses are clear. This chapter presents the three most common types of cross-site scripting attacks and explains how to protect against them.

<!-- Source S7, PDF page 3 -->

### Stored Cross-Site Scripting Attacks

Websites routinely generate and render HTML using information stored in a database. Retail websites will store product information in a database, and social media sites will store user conversations. Websites will take content from the database according to the URL the user has navigated to, and interpolate it into the page to produce the finished HTML.

Any page content coming from the database is a potential attack vector for hackers. Attackers will attempt to inject JavaScript code into the database so that the web server will write out the JavaScript when it renders HTML. We call this type of attack a stored cross-site scripting attack: the JavaScript is written to the database, but executed in the browser when an unsuspecting victim views a particular page on the site.

Malicious JavaScript can be planted in a database by using the SQL injection method described in Chapter 6, but attackers will more commonly insert malicious code through legitimate avenues. For instance, if a website allows users to post comments, the site will store the comment text in a database and display it back to other users who view the same comment thread. In this scenario, an easy way for a hacker to perform a cross-site scripting attack is to write a comment containing a `<script>` tag to the database. If the website fails to construct HTML securely, the `<script>` tag will get written out whenever the page is rendered to other users, and the JavaScript will be executed in the victim’s browser.

Let’s look at a concrete example. Imagine you run a popular website for people who like to bake, https://breddit.com. Your site encourages users to participate in discussion threads about bread-related topics. While using the online forum for discussion, the users themselves contribute most of the site’s content. When a user adds a post, your website records it to the database and shows it to other users participating in the same thread. This is a perfect opportunity for an attacker to inject some JavaScript through a comment, as shown in Figure 7-1.

> [Figure 7-1: An attacker injects JavaScript through a comment. — image placeholder; source S7, PDF page 3.]

<!-- Source S7, PDF page 4 -->

If your website doesn’t escape the injected script when it renders the HTML (as we’ll discuss in the following section), the next user to view the thread will have the attacker’s `<script>` tag written out to their browser and executed, as shown in Figure 7-2.

> [Figure 7-2: An attacker’s &lt;script&gt; tag is written out to the victim’s browser and executed. — image placeholder; source S7, PDF page 4.]

A rogue `alert()` dialog is more of an annoyance than a genuine threat, but attackers typically start with this approach to check whether cross-site scripting attacks are possible. If an attacker can call the `alert()` function, they can escalate to more dangerous attacks, like stealing other users’ sessions, or redirecting victims to harmful sites. The baking community would never feel safe online again!

Comment threads aren’t the only place that can exhibit this type of vulnerability. Any user-controlled content is a potential avenue of attack that you need to secure. Attackers have performed cross-site scripting attacks by injecting malicious script tags into usernames, profile pages, and online reviews, for example. Let’s look at a couple of straightforward protections you should implement.

### Mitigation 1: Escape HTML Characters

To prevent stored cross-site scripting attacks, you need to escape all dynamic content coming from a datastore so that the browser knows to treat it as the content of HTML tags, as opposed to raw HTML. Escaping content in the browser means replacing control characters in the HTML with their corresponding entity encoding, as illustrated in Table 7-1.

<!-- Source S7, PDF page 5 -->

**Table 7-1: Entity Encodings of HTML Control Characters**

Source S7, PDF page 5.

| Character | Entity encoding |
| --- | --- |
| " | &amp;quot; |
| &amp; | &amp;amp; |
| ' | &amp;apos; |
| &lt; | &amp;lt; |
| &gt; | &amp;gt; |

Any character that has special meaning in HTML, like the `<` and `>` characters that denote the start and end of tags, has a corresponding safe entity encoding. Browsers that encounter entity encodings recognize them as escaped characters, and render them visually as the appropriate character, but, crucially, won’t treat them as HTML tags. Listing 7-1 shows how a secure website will write out the comment entered by the attack in Figure 7-1. The bolded text represents characters that could be used to construct HTML tags.

```text
<div class="comment">
  &lt;script&gt;alert(&quot;HAXXED&quot;)&lt;/script&gt;
</div>
```

Listing 7-1: This attempted XSS attack has been defused.

The conversion of escaped characters to unescaped characters happens after the browser has constructed the DOM for the page, so the browser will not execute the `<script>` tag. Escaping HTML control characters in this fashion closes the door on most cross-site scripting attacks.

Since cross-site scripting is such a common vulnerability, modern web frameworks tend to escape dynamic content by default. Templates, in particular, typically escape interpolated values without being asked. The syntax for interpolating a variable in an Embedded Ruby (ERB) template looks like Listing 7-2.

```text
<div class="comment">
  <%= comment %>
</div>
```

Listing 7-2: Implicit escaping of dynamic content in an Embedded Ruby template

The ERB templating engine will automatically escape sensitive characters via the `<%= comment %>` syntax when dynamic content is evaluated.

In order to write raw, unescaped HTML (and hence be vulnerable to XSS attacks), ERB templates require an explicit call to the `raw` function, as shown in Listing 7-3.

```text
<div class="comment">
  <%= raw comment %>
</div>
```

Listing 7-3: The syntax to allow raw injection of HTML in Embedded Ruby templates

<!-- Source S7, PDF page 6 -->

All secure templating languages follow the same design principle: the templating engine implicitly escapes dynamic content unless the developer explicitly chooses to construct raw HTML. Make sure you understand how escaping works in your templates, and check that dynamic content is securely escaped during code reviews! In particular, if you have helper functions or methods that construct raw HTML for injection into templates, check to see that an attacker can’t abuse their inputs to commit cross-site scripting attacks.

### Mitigation 2: Implement a Content Security Policy

Modern browsers allow websites to set a content security policy, which you can use to lock down JavaScript execution on your site. Cross-site scripting attacks rely on an attacker being able to run malicious scripts on a victim’s web page, usually by injecting `<script>` tags somewhere within the `<html>` tag of a page, also known as inline JavaScript. The example hack illustrated in Figure 7-2 uses inline JavaScript, written out as the text of a comment.

By setting a content security policy in your HTTP response headers, you can tell the browser to never execute inline JavaScript. The browser will execute JavaScript on your page only if it is imported via a `src` attribute in the `<script>` tag. A typical content security policy header will look like Listing 7-4. This policy specifies that scripts can be imported from the same domain (`'self'`), or the apis.google .com domain, but inline JavaScript should not be executed.

```text
Content-Security-Policy: script-src 'self' https://apis.google.com
```

Listing 7-4: A content security policy set in an HTTP response header

You can also set your site’s content security policy in a `<meta>` tag in the `<head>` element of the HTML of your web pages, as shown in Listing 7-5.

```text
<meta http-equiv="Content-Security-Policy" content="script-src 'self' https://apis.google.com">
```

Listing 7-5: The equivalent content security policy set in a `<head>` element of the HTML document

By whitelisting the domains from which your browser loads scripts, you implicitly state that inline JavaScript isn’t allowed. In this example content security policy, the browser will load JavaScript only from the domains apis .google.com and whatever the domain of the site is—for example, breddit.com. To permit inline JavaScript, the policy would have to include the keyword `unsafe-inline`.

Preventing the execution of inline JavaScript is a great security measure, but it means you’ll have to move any inline JavaScript your site currently implements into separate imports. In other words, `<script>` tags on a page have to reference JavaScript in a separate file via a `src` attribute, rather than writing the JavaScript between the start and end tags.

This separation of JavaScript into external files is the preferred approach in web development, since it makes for a more organized codebase. Inline

<!-- Source S7, PDF page 7 -->

script tags are considered bad practice in modern web development, so banning inline JavaScript actually forces your development team into good habits. Nevertheless, inline script tags are common in older, legacy sites. Indeed, it may take some time to refactor your templates to remove all inline JavaScript tags.

To help with this refactoring, consider using content security policy violation reports. If you add a `report-uri` directive to your content security policy header, as shown in Listing 7-6, the browser will notify you of any policy violations, rather than preventing JavaScript from executing.

```text
Content-Security-Policy-Report-Only: script-src 'self'; report-uri https://example.com/csr-reports
```

Listing 7-6: A content security policy that instructs the browser to report any content security violations to https://example.com/csr-reports

If you collect all these violation reports in a log file, your development team should be able to see all the pages they need to rewrite in order to meet the restrictions imposed by the proposed content security policy.

You should set a content security policy in addition to escaping HTML, since it’ll protect your users effectively! It’s difficult for an attacker to find an instance of unescaped content and to smuggle a malicious script onto your whitelisted domains. We call using multiple layers of defense for the same vulnerability defense in depth, as you learned in Chapter 6; this will be a theme throughout this book.

### Reflected Cross-Site Scripting Attacks

Rogue JavaScript in the database isn’t the only vector for cross-site scripting attacks. If your site takes part of an HTTP request and displays it back in a rendered web page, your rendering code needs to protect against attacks that inject malicious JavaScript via the HTTP request. We call this type of attack a reflected cross-site scripting attack.

Virtually all websites display some part of HTTP requests in rendered HTML. Consider the Google search page: if you perform a search for “cats,” Google passes the search term as part of the HTTP in the URL: https://www.google.com/search?q=cats. The search term `cats` displays in the search box above the search results.

Now, if Google were a less secure company, it’d be possible to replace the cats parameter in the URL with malicious JavaScript, and have that JavaScript code execute whenever anybody opens that URL in their browser. An attacker could email the URL as a link to a victim, or trick a user into visiting the URL by adding it to a comment. This is the essence of a reflected cross-site scripting attack: an attacker sends the malicious code in the HTML request, and then the server reflects it back.

Thankfully, Google employs more than a few security experts, so if you attempt to insert `<script>` tags into its search results, the server won’t execute the JavaScript. In the past, hackers have discovered reflected

<!-- Source S7, PDF page 8 -->

cross-site scripting vulnerabilities in the Google Apps admin interface found at https://admin.google.com, so it goes to show that even big companies get caught out. If you want any chance of keeping your users safe, you need to protect against this attack vector.

### Mitigation: Escape Dynamic Content from HTTP Requests

You mitigate reflected cross-site scripting vulnerabilities the same way you mitigate stored cross-site scripting vulnerabilities: by escaping control characters in dynamic content that the website interpolates into HTML pages. Whether dynamic content comes from the backend database or the HTTP request, you need to escape it in the same way.

Thankfully, template languages typically apply escaping to all interpolated variables, whether the templates load them from the database or pull them from the HTTP request. However, your development team still needs to be aware of the risk of injection via HTTP requests when auditing code. Code reviews often overlook reflected cross-site scripting vulnerabilities because developers are too busy looking for stored cross-site scripting vulnerabilities.

Common target areas for reflected cross-site scripting attacks are search pages and error pages, since they usually display parts of the query string back to the user. Make sure your team understands the risks and knows how to spot the vulnerability when reviewing code changes. Stored cross-site scripting attacks tend to be more harmful, because a single malicious piece of JavaScript injected into your database table can attack your users over and over again. But reflected attacks are more common, since they’re easier to implement.

Before we close this chapter, let’s look at one more type of cross-site scripting attack.

### DOM-Based Cross-Site Scripting Attacks

Defusing most cross-site scripting attacks means inspecting and securing server-side code; however, the increasing popularity of rich frameworks for client-side code has led to the rise of DOM-based cross-site scripting, whereby attackers smuggle malicious JavaScript into a user’s web page via the URI fragment.

To understand these attacks, you first need to understand how URI fragments operate. Let’s start with a reminder of how URLs (universal resource locators), the addresses shown in the browser bar, are structured. A typical URL looks like Figure 7-3.

> [Figure 7-3: The sections of a typical URL — image placeholder; source S7, PDF page 8.]

<!-- Source S7, PDF page 9 -->

The URI fragment is the optional part of the URL after the # sign. Browsers use URI fragments for intra-page navigation—if an HTML tag on the page has an `id` attribute matching the URI fragment, the browser scrolls to that tag after opening the page. For instance, if you load the URL https://en.wikipedia.org/wiki/Cat#Grooming in a browser, the browser opens the web page and then scrolls to the Grooming section of the Wikipedia page about cats. It behaves this way because the heading tag for that section looks something like Listing 7-7.

```text
<h3 id="Grooming">Grooming</h3>
```

Listing 7-7: An HTML tag corresponding to the URI fragment #Grooming

With this helpful built-in browser behavior, Wikipedia lets users link directly to sections within a page, so that you and your roommate can finally settle that contentious argument about cat grooming.

Single-page apps also often use URI fragments to record and reload state in an intuitive fashion. These types of apps, written in JavaScript frameworks like Angular, Vue.js, and React, are actually JavaScript-heavy web pages that seek to avoid the rendering blink that occurs when the browser reloads a web page.

One potential way to avoid this rendering blink is designing the whole app to load under a static URL that never changes, because changing the URL in the browser bar is typically what causes a web page to reload. However, if a user refreshes a browser for an unchanging URL, the browser resets the web page to its initial state, losing any information about what the user was doing previously.

Many single-page apps overcome this by using the URI fragment to keep state over browser refreshes. You’ll commonly see web pages implement infinite scrolling: a list of images dynamically loads in as the user scrolls down the page. The URI fragment updates with an indication of how far the user has scrolled down. Then, even if the browser refreshes, the JavaScript code can interpret the content of the URI fragment, and load in the relevant number of images as the page refreshes.

By design, browsers don’t send URI fragments to the server when the browser renders the page. When a browser receives a URL with a URI fragment, it makes a note of the fragment, strips it from the URL, and sends the stripped URL to the web server. Any JavaScript executed on the page can read the URI fragment, and the browser will write the full URL to the browser history, or to a bookmark, if the user bookmarks the page.

Unfortunately, this means that URI fragments aren’t available to any server-side code—securing server-side code can’t mitigate DOM-based XSS attacks. Client-side JavaScript code that interprets and uses URI fragments needs to be careful about how it interprets the content of those fragments. If the content is unescaped and written directly into the DOM of the web page, an attacker can smuggle malicious JavaScript through this channel. An attacker can craft a URL with some malicious JavaScript in the URI fragment, and then trick a user into visiting that URL to launch the cross-site scripting attack.

<!-- Source S7, PDF page 10 -->

DOM-based cross-site scripting is a relatively new form of attack, but is particularly dangerous because the injection of code happens completely on the client side, and can’t be detected by examining web server logs! This means you need to be keenly aware of the vulnerability when doing code reviews, and know how to mitigate it.

### Mitigation: Escaping Dynamic Content from URI Fragments

Any JavaScript code executing in the browser that takes part of the URI fragment and constructs HTML is prone to DOM-based cross-site scripting attacks. This means you need to take care to escape anything taken from a URI fragment before interpolating that value in HTML with the client-side code, just as you would with server-side code.

The authors of modern JavaScript templating frameworks are fully aware of the risks posed by URI fragments and discourage the construction of raw HTML in code. For instance, the syntax to write unescaped HTML in the React framework requires the developer to call the function `dangerously` `SetInnerHTML`, as shown in Listing 7-8.

```text
function writeSomeHTML () {
  return {__html: 'First &middot; Second'};
}
function MyComponent() {
  return <div dangerouslySetInnerHTML={writeSomeHTML()} />;
}
```

Listing 7-8: Dangerously setting raw HTML from text in the React framework

Consider switching to a modern JavaScript framework if your client-side JavaScript code is complex. It should make the codebase more manageable and security considerations much more apparent. And as always, be sure to set an appropriate content security policy.

### Summary

In this chapter, you learned about cross-site scripting attacks, whereby an attacker injects JavaScript into the pages of your site when users view them. Attackers usually inject malicious JavaScript into dynamic content that comes from a database, from the HTTP request, or from the URI fragment. You can defeat cross-site scripting attacks by escaping any HTML control characters in dynamic content, and by setting a content security policy that prevents the execution of inline JavaScript.

In the next chapter, you’ll look at another method that attackers can use to prey on the users of your website: cross-site request forgery.

<!-- Source S7, PDF page 11 -->


