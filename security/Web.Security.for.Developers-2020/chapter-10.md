# Chapter 10

## Web Security for Developers-2020

Source: [Web.Security.for.Developers-2020-10.pdf](Web.Security.for.Developers-2020-10.pdf) — 10 PDF pages.

<!-- Source S10, PDF page 1 -->

### Session Hijacking

> [Decorative chapter-opening artwork placeholder — source S10, PDF page 1; 9 image tiles.]

When a website successfully authenticates a user, the browser and the server open a session. A session is an HTTP conversation in which the browser sends a series of HTTP requests corresponding to user actions, and the web server recognizes them as coming from the same authenticated user without requiring the user to log back in for each request.

If a hacker can access or forge session information that the browser sends, they can access any user’s account on your site. Thankfully, modern web servers contain secure session-management code, which makes it practically impossible for an attacker to manipulate or forge a session. However, even if there are no vulnerabilities in a server’s session-management capabilities, a hacker can still steal someone else’s valid session while it’s in progress; this is called session hijacking.

<!-- Source S10, PDF page 2 -->

Session hijacking vulnerabilities are generally a bigger risk than the authentication vulnerabilities discussed in the previous chapter, because again, they allow an attacker to access any of your users’ accounts. This is such a tantalizing prospect that hackers have found many ways to hijack sessions.

In this chapter, you’ll first look at how websites implement session management. Then you’ll learn about the three ways hackers hijack sessions: cookie theft, session fixation, and taking advantage of weak session IDs.

### How Sessions Work

To understand how an attacker hijacks a session, you first need to understand what happens when a user and a web server open a session.

When a user authenticates themselves under HTTP, the web server assigns them a session identifier during the login process. The session identifier (session ID)—typically a large, randomly generated number—is the minimal information the browser needs to transmit with each subsequent HTTP request so the server can continue the HTTP conversation with the authenticated user. The web server recognizes the session ID supplied with each request, maps it to the appropriate user, and performs actions on their behalf.

Note that the session ID must be a temporarily assigned value that’s different from the username. If the browser used a session ID that was simply the username, hackers could pretend to be any user they pleased. By design, only a very small minority of possible session IDs should correspond to a valid session on the server at any given time. (If this is not the case, the web server exhibits a weak session vulnerability, which we will discuss later in this chapter.)

Besides the username, the web server typically stores other session state alongside the session ID, containing relevant information about the user’s recent activity. The session state might, for example, contain a list of pages the user has visited, or the items currently sitting in their shopping basket.

Now that we understand what happens when users and web servers open a session, let’s look at how websites implement these sessions. There are two common implementations, typically described as server-side sessions and client-side sessions. Let’s review how these methods work, so you can see where the vulnerabilities occur.

### Server-Side Sessions

In a traditional model of session management, the web server keeps the session state in memory, and both the web server and browser pass the session identifier back and forth. This is called a server-side session. Listing 10-1 shows the Ruby on Rails implementation of server-side sessions.

```text
# Get a session from the cache.
def find_session(env, sid)
  unless sid && (session = @cache.read(cache_key(sid))[3])
```

<!-- Source S10, PDF page 3 -->

```text
    sid, session = generate_sid[1], {}
  end
  [sid, session]
end

   # Set a session in the cache.
   def write_session(env, sid, session, options)
     key = cache_key(sid)
     if session
    [2] @cache.write(key, session, expires_in: options[:expire_after])

  else
    @cache.delete(key)
  end
  sid
end
```

Listing 10-1: Ruby on Rails implements server-side sessions using the session ID (`sid`).

The session object is created at [1], written to the server’s memory at [2], and then reloaded from memory at [3].

Historically, web servers have experimented with transferring session IDs in multiple ways: either in the URL, as an HTTP header, or in the body of HTTP requests. By far, the most common (and reliable) mechanism the web development community has decided upon is to send session IDs as a session cookie. When using session cookies, the web server returns the session ID in the `Set-Cookie` header of the HTTP response, and the browser attaches the same information to subsequent HTTP requests using the `Cookie` header.

Cookies have been part of the HyperText Transfer Protocol since they were first introduced by Netscape in 1995. Unlike HTTP-native authentication, they’re used by pretty much every website under the sun. (Because of European Union legislation, you’ll be well aware of this fact: websites are required by European law to inform you that they’re using cookies.)

Server-side sessions have been widely implemented and are generally very secure. They do have scalability limitations, however, because the web server has to store the session state in memory.

That means that at authentication time, only one of the web servers will know about the established session. If subsequent web requests for the same user gets directed to a different web server, the new web server needs to be able to recognize the returning user, so web servers need a way of sharing session information.

Typically, this requires writing session state to a shared cache or to a database with every request, and having each web server read that cached session state when a new HTTP request comes through. Both of these are time- and resource-consuming operations that can limit the responsiveness of sites with large userbases, since each user added to the website adds a significant load to the session store.

<!-- Source S10, PDF page 4 -->

### Client-Side Sessions

Because server-side sessions have proven difficult to scale for large sites, web server developers invented client-side sessions. A web server implementing client-side sessions passes all session state in the cookie, instead of passing back just the session ID in the `Set-Cookie` header. The server serializes session state to text before the session state is set in the HTTP header. Often, web servers encode the session state as JavaScript Object Notation (JSON)—and deserialize it when returning it to the server. Listing 10-2 shows an example of Ruby on Rails implementing a client-side session.

```text
def set_cookie(request, session_id, cookie)
  cookie_jar(request)[@key] = cookie
end

def get_cookie(req)
  cookie_jar(req)[@key]
end

def cookie_jar(request)
  request.cookie_jar.signed_or_encrypted
end
```

Listing 10-2: Ruby on Rails code that stores session data as a client-side cookie

By using client-side sessions, a site’s web servers no longer have to share state. Each web server has everything it needs to reestablish the session with an incoming HTTP request. This is a great bonus when you’re trying to scale to thousands of simultaneous users!

Client-side sessions do create an obvious security problem, however. With a naive implementation of client-side sessions, a malicious user can easily manipulate the contents of a session cookie or even forge them entirely. This means the web server has to encode the session state in a way that prevents meddling.

One popular way to secure client-side session cookies is to encrypt the serialized cookie before sending it to the client. The web server then decrypts the cookie when the browser returns it. This approach makes the session state entirely opaque on the client side. Any attempt to manipulate or forge the cookie will corrupt the encoded session and make the cookie unreadable. The server will simply log out the malicious user and redirect them to an error page.

Another, slightly more lightweight approach to securing session cookies is to add a digital signature to the cookie as it’s sent. A digital signature acts as a unique “fingerprint” for some input data—in this case, the serialized session state—that anyone can easily recalculate as long as they have the signing key originally used to generate the signature. Digitally signing cookies allows the web server to detect attempts to manipulate the session state, since it’ll calculate a different signature value and reject the session if there has been any tampering.

<!-- Source S10, PDF page 5 -->

Signing cookies rather than encrypting them still allows a nosy user to read the session data in a browser debugger. Bear this in mind if you’re storing data about a user—like tracking information—that you might not want them to see!

### How Attackers Hijack Sessions

Now that we’ve discussed sessions and how websites implement them, let’s look at how attackers hijack sessions. Attackers use three main methods to hijack sessions: cookie theft, session fixation, and taking advantage of weak session IDs.

### Cookie Theft

With the use of cookies being so widespread nowadays, attackers normally achieve session hijacking by stealing the value of a `Cookie` header from an authenticated user. Attackers usually steal cookies by using one of three techniques: injecting malicious JavaScript into a site as the user interacts with it (cross-site scripting), sniffing network traffic in order to intercept HTTP headers (a man-in-the-middle attack), or triggering unintended HTTP requests to the site when they’ve already authenticated (cross-site request forgery).

Fortunately, modern browsers implement simple security measures that allow you to protect your session cookies against all three of these techniques. You can enable these security measures simply by adding keywords to the `Set-Cookie` header returned by the server, as shown in Listing 10-3.

```text
Set-Cookie: session_id=278283910977381992837; HttpOnly; Secure; SameSite=Lax
```

Listing 10-3: A session cookie appearing in an HTTP response that is protected from session hijacking by a combination of keyword instructions

Let’s review the three techniques of cookie theft, as well as the keywords that can mitigate them.

### Cross-Site Scripting

Attackers often use cross-site scripting (which we discussed in detail in Chapter 7) to steal session cookies. An attacker will try to use JavaScript injected into a user’s browser to read the user’s cookies and send them to an external web server that the attacker controls. The attacker will then harvest these cookies as they appear in the web server’s log file, and then cut and paste the cookie values into a browser session—or more likely, add them to a script—to perform actions under the hacked user’s session.

To defuse session hijacking via cross-site scripting, mark all cookies as `HttpOnly` in the `Set-Cookie` header. This tells the browser not to make cookies available to JavaScript code. Append the `HttpOnly` keyword to the `Set-Cookie` response header, as shown in Listing 10-4.

<!-- Source S10, PDF page 6 -->

```text
Set-Cookie: session_id=278283910977381992837; HttpOnly
```

Listing 10-4: Mark your cookies as `HttpOnly` to stop JavaScript from accessing them.

There’s rarely a good reason to allow client-side JavaScript access to cookies, so there are very few downsides to this approach.

### Man-in-the-Middle Attacks

An attacker can also steal cookies by using a man-in-the-middle attack: the attacker finds a way to sit between the browser and the web server and read network traffic as it passes back and forth. To protect against cookie theft via man-in-the-middle attacks, your website should use HTTPS. You’ll learn how to enable HTTPS in Chapter 13.

After you’ve enabled HTTPS on the web server, you should mark your cookies as `Secure`, as shown in Listing 10-5, so the browser knows to never send unencrypted cookies over HTTP.

```text
Set-Cookie: session_id=278283910977381992837; Secure
```

Listing 10-5: Marking your cookies as secure means adding the `Secure` keyword to the `Set-Cookie` response header.

Most web servers are configured to respond to both HTTP and HTTPS, but will redirect HTTP URLs to the HTTPS equivalent. Marking your cookies as `Secure` will keep the browser from transmitting the cookie data until the redirect has occurred.

### Cross-Site Request Forgery

The final way an attacker can hijack sessions is via cross-site request forgery (detailed in Chapter 8). An attacker using CSRF doesn’t need to get access to a user’s session cookie. Instead, they simply need to trick the victim into clicking a link to your site. If the user already has a session open on your site, the browser will send their session cookie along with the HTTP request triggered by the link, which might result in the user inadvertently performing a sensitive action (such as Liking an item the hacker is attempting to promote).

To defuse CSRF attacks, mark your cookies with the `SameSite` attribute, which instructs the browser to send only session cookies with HTTP requests generated from your site. The browser will strip session cookies from other HTTP requests, like those generated by clicking a link in an email.

The `SameSite` attribute has two settings: `Strict` and `Lax`. The `Strict` setting, shown in Listing 10-6, has the advantage of stripping cookies from all HTTP requests triggered from external sites.

```text
Set-Cookie: session_id=278283910977381992837; SameSite=Strict
```

Listing 10-6: The `Strict` setting will strip cookies from requests generated to your site from external sites.

<!-- Source S10, PDF page 7 -->

The `Strict` setting can prove annoying if a user shares your content via social media, because the setting forces anyone clicking their link to log in again to view the content. To solve this annoyance for your users, configure the browser to allow cookies only on `GET` requests by using the `SameSite=Lax` setting, as shown in Listing 10-7.

```text
Set-Cookie: session_id=278283910977381992837; SameSite=Lax
```

Listing 10-7: The `Lax` setting allows for painless sharing of links on social media, while still defusing session-hijacking attacks via CSRF.

This `SameSite=Lax` setting instructs the browser to attach cookies to inbound `GET` requests, while stripping them from other request types. Because websites usually perform sensitive actions (such as writing content or sending messages) through `POST`, `PUT`, or `DELETE` requests, an attacker can’t trick a victim into performing these types of sensitive actions.

### Session Fixation

In the early history of the internet, many browsers didn’t implement cookies, so web servers found other ways to pass session IDs. The most popular way of doing this was by URL rewriting—appending the session ID to each URL the user visited. To this day, the Java Servlet Specification describes how developers can add session IDs to the end of the URL when cookies aren’t available. Listing 10-8 shows an example of a URL rewritten to include a session ID.

```text
http://www.example.com/catalog/index.html;jsessionid=1234
```

Listing 10-8: An example of a URL passing the session ID `1234`

All browsers have cookie support nowadays, so URL rewriting is an anachronism. However, legacy web stacks may be configured to still accept session IDs in this way, which introduces a couple of major security issues.

First, writing session IDs in the URL allows them to be leaked in log files. An attacker who gets access to your logs can hijack your users’ sessions simply by dropping these types of URLs in the browser.

The second issue is a vulnerability called session fixation. When web servers vulnerable to session fixation encounter an unknown session ID in a URL, they’ll ask the user to authenticate themselves, and then establish a session under the supplied session ID.

This allows a hacker to fixate the session ID ahead of time, sending victims tempting links (usually in unsolicited email or spam in a site’s comment sections) with the fixated session ID. Any user who clicks the link can have their session hijacked, because the attacker can simply use that same URL in their own browser, having fixed the session ID ahead of time. The act of clicking the link and logging it transforms the dummy session ID into a real session ID—one that the hacker knows.

<!-- Source S10, PDF page 8 -->

If your web server supports URL rewriting as a means of session tracking, you should disable it with the relevant configuration options. It serves no purpose and exposes you to session fixation attacks. Listing 10-9 shows how to disable URL rewriting in version 7.0 of the popular Java web server Apache Tomcat by editing the web.xml config file.

```text
<session-config>
     <tracking-mode>COOKIE</tracking-mode>
</session-config>
```

Listing 10-9: Specifying the session tracking to use the `COOKIE` mode in Apache Tomcat 7.0 will disable URL rewriting.

### Taking Advantage of Weak Session IDs

As we’ve already discussed, if an attacker gets access to a session ID, they can hijack a user’s session. They can do this by stealing a session cookie or by fixating a session ahead of time for servers that support URL rewriting. However, a more brute-force method is to simply guess the session ID. Because session IDs are typically just numbers, if these numbers are sufficiently small or predictable, an attacker can write a script to enumerate potential session IDs and test them against the web server until they find a valid session.

Genuinely random numbers are hard to generate in software. Most random number generation algorithms use environmental factors (such as the system’s clock time) as seeds to generate their random numbers. If an attacker can determine enough of the seed values (or reduce them to a reasonable number of potential values), they can enumerate potentially valid session IDs and test them against your server.

Early versions of the standard Apache Tomcat server were found to be vulnerable to this type of attack. Security researchers discovered that the seeds of the random session ID generation algorithm were the system time and the hashcode of an in-memory object. The researchers were able to use these seeds to narrow the potential input values in such a way that they could reliably guess session IDs.

Consult your web server’s documentation and ensure that it uses large session IDs that can’t be guessed, generated by a strong random number generation algorithm. Because security researchers frequently discover weak session ID algorithms before attackers can exploit them, make sure to also stay on top of security advisories, which will tell you when you need to patch vulnerabilities in your web stack.

### Summary

When a website successfully authenticates a user, the browser and the server open a session between them. Session state can be stored on the server side, or stored on the client side as an encrypted or digitally signed cookie.

<!-- Source S10, PDF page 9 -->

Hackers will attempt to steal your session cookies, so you should ensure they’re protected. To protect against session hijacking via cross-site scripting, make sure your cookies aren’t accessible to JavaScript code. To protect against session hijacking via man-in-the-middle attacks, make sure your cookies are passed only over HTTPS connections. To protect against session hijacking via cross-site request forgery, make sure to strip sensitive cross-site requests of cookies. You can add these protections by using the keywords `HttpOnly`, `SecureOnly`, and `SameSite`, respectively, when you write out your `Set` `-Cookie` header in the HTTP response.

Older web servers may be vulnerable to session-fixation attacks, so be sure to disable URL rewriting as a way of passing session IDs. Occasionally, web servers are found to use guessable session IDs, so stay aware of security advisories for your software stack and patch it as required.

In the next chapter, you will look at how to correctly implement access control, so malicious users can’t access your content or perform actions they aren’t supposed to.

<!-- Source S10, PDF page 10 -->


