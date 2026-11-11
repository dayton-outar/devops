# Chapter 8

## Web Security for Developers-2020

Source: [Web.Security.for.Developers-2020-8.pdf](Web.Security.for.Developers-2020-8.pdf) — 6 PDF pages.

<!-- Source S8, PDF page 1 -->

### Cross-Site Request Forgery Attacks

### Cross-Site Request Forgery Attacks

![Figure 8-1: Chapter-opening artwork](/.attachments/8-1-Web.Security.for.Developers-2020-8.png)

*Figure 8-1: Chapter-opening artwork*

<!-- Source: Web.Security.for.Developers-2020-8.pdf, PDF page 1. -->

In the previous chapter, you saw how attackers use cross-site scripting attacks to inject JavaScript into a user’s web browser through page elements like comment sections, search results, and URLs. Now you’ll look at how attackers use malicious links to hack your users.

No website is an island. Because your website has a public URL, other sites will frequently link to it, which you should generally encourage as a site owner. More inbound links to your site means more traffic and better search engine rankings.

However, not everybody linking to your site has good intentions. An attacker can trick a user into clicking a malicious link that triggers undesirable or unexpected side effects. This is called cross-site request forgery (CSRF or XSRF). Security researchers sometimes pronounce CSRF as “sea-surf.”

CSRF is a remarkably common vulnerability that most major websites have exhibited at one time or another. Attackers have used CSRF to steal

<!-- Source S8, PDF page 2 -->

Gmail contact lists, trigger one-click purchases on Amazon, and change router configuration. This chapter examines how CSRF attacks typically work and shows some coding practices that protect against them.

### Anatomy of a CSRF Attack

Attackers usually launch CSRF attacks by exploiting websites that implement `GET` requests that change the state of a web server. A `GET` request is triggered when a victim clicks a link, allowing the attacker to craft misleading links into the target site that perform unexpected actions. `GET` requests are the only type of HTTP request that contain the entirety of the request’s contents in a URL, so they’re uniquely vulnerable to CSRF attacks.

In an early iteration of Twitter, you could create tweets via `GET` requests rather than the `POST` requests the site currently uses. This oversight made Twitter vulnerable to CSRF attacks: it made it possible to create URL links that, when clicked, would post on a user’s timeline. Listing 8-1 shows one of these URL links.

```text
https://twitter.com/share/update?status=in%20ur%20twitter%20CSRF-ing%20ur%20tweets
```

Listing 8-1: A link that, at one point, would have tweeted the text in ur twitter CSRF-ing ur tweets to a victim’s timeline when clicked

One canny hacker used this loophole to create a viral worm on Twitter. Because they could use a single `GET` request to write a tweet, they constructed a malicious link that, when clicked, would post a tweet containing an obscene message and the same malicious link. When readers of the tweet clicked the link that the first victim tweeted, they too were tricked into tweeting the same thing.

The hacker tricked a handful of victims into clicking the malicious link, and those victims tweeted unexpected posts on the timelines. As more and more users read the original tweets and clicked the embedded link out of curiosity, they too tweeted the same thing. Soon, tens of thousands of Twitter users were being tricked into expressing their desire to molest goats (the content of the initial tweet). The first Twitter worm was born, and the Twitter development team scrambled to close the security hole before things got out of hand.

### Mitigation 1: Follow REST Principles

To protect your users against CSRF attacks, make sure that your `GET` requests don’t change the state of the server. Your website should use `GET` requests only to fetch web pages or other resources. You should perform actions that change server state—for example, logging the user in or out, resetting passwords, writing posts, or closing an account—only through `PUT`, `POST`, or `DELETE` requests. This design philosophy, called Representational State Transfer (REST), comes with a host of other benefits besides CSRF protection.

<!-- Source S8, PDF page 3 -->

REST states that you should map website operations to the appropriate HTTP method according to their intention. You should fetch data or pages with `GET` requests, create new objects on the server (such as comments, uploads, or messages) with `PUT` requests, modify objects on the server with `POST` requests, and delete objects with `DELETE` requests.

Not all actions have an obvious corresponding HTTP method. For instance, when a user logs in, it’s a philosophical discussion as to whether the user is creating a new session or modifying their status. In terms of protecting against CSRF attacks, though, the key thing is to avoid assigning actions that change the server state to `GET` requests.

Protecting your `GET` requests doesn’t mean that there aren’t vulnerabilities in other types of requests, as you’ll see with our second mitigation.

### Mitigation 2: Implement Anti-CSRF Cookies

Defusing your `GET` requests shuts the door on most CSRF attacks, but you still need to protect against requests using the other HTTP verbs. Attacks using those verbs are much less common than `GET`-based CSRF attacks, and require much more work, but an attacker might try them if they think the payoff is sufficient.

For instance, they can trick a user into initiating a `POST` request to your site by having the victim submit a malicious form or script hosted on a third-party site under the attacker’s control. If your site performs sensitive actions in response to `POST` requests, you need to use anti-CSRF cookies to ensure that these requests are initiated only from within your site. Sensitive actions should be triggered only from your own login forms and JavaScript, rather than malicious pages that may trick the user into performing unexpected actions.

An anti-CSRF cookie is a randomized string token that the web server writes out to a named cookie parameter. Recall that cookies are small pieces of text passed back and forth between the browser and web server in HTTP headers. If the web server returns an HTTP response containing a header value like `Set-Cookie: _xsrf=5978e29d4ef434a1`, the browser will send back the same information in the next HTTP request in a header with form `Cookie: _xsrf=5978e29d4ef434a1`.

Secure websites use anti-CSRF cookies to verify that `POST` requests originate from pages hosted on the same web domain. HTML pages on the site add this same string token as an `<input type="hidden" name="_xsrf"` `value="5978e29d4ef434a1">` element in any HTML form used to generate `POST` requests. When a user submits the form to the server, and the `_xsrf` value in the returned cookie doesn’t match the `_xsrf` value in the request body, the server rejects the request entirely. This way, the server validates and ensures that the request originated from within the site rather than from a malicious third-party site; the browser will send the required cookie only when the web page is loaded from the same domain.

Most modern web servers support anti-CSRF cookies. Make sure to consult the security documentation of your chosen web server to understand

<!-- Source S8, PDF page 4 -->

how they implement these cookies, since the syntax varies slightly among web servers. Listing 8-2 shows a template file for the Tornado web server that includes anti-CSRF protection.

```text
   <form action="/new_message" method="post">
  [1] {% module xsrf_form_html() %}

  <input type="text" name="message"/>
  <input type="submit" value="Post"/>
</form>
```

Listing 8-2: A template file for the Tornado web server in Python that includes anti-CSRF protection

In this example, the `xsrf_form_html()` function [1] generates a randomized token and writes it out in the HTML form as an input element like so: `<input type="hidden" name="_xsrf" value="5978e29d4ef434a1">`. The Tornado web server then writes out this same token in the HTTP response headers as `Set-Cookie: _xsrf=5978e29d4ef434a1`. When the user submits the form, the web server validates that the token from the form and the token in the return `Cookie` header match. The browser security model will return cookies according to the same-origin policy, so the cookie values can only have been set by the web server. Hence the server can be sure that the `POST` request originated from the host website.

You should use anti-CSRF cookies to validate HTTP requests made from JavaScript, too, which allows you to also protect `PUT` and `DELETE` requests. The JavaScript needs to query out the anti-CSRF token from the HTML, and pass it back to the server in the HTTP request.

After you’ve implemented anti-CSRF cookies, your website should be much safer. Now you need to close one final loophole, to make sure attackers can’t steal your anti-CSRF tokens and embed them in malicious code.

### Mitigation 3: Use the SameSite Cookie Attribute

The final protection against CSRF attacks you must implement is to specify a `SameSite` attribute when you set cookies. By default, when a browser generates a request to your website, it will attach to the request the last known cookies that the site set, regardless of the source of the request. This means that malicious cross-site requests will arrive at your web server with any security cookies you previously set. This doesn’t defeat anti-CSRF measures in and of itself, but if an attacker steals the security token from your HTML forms, and installs it in their own malicious forms, they can still launch a CSRF attack.

Specifying a `SameSite` attribute when you set a cookie tells the browser to strip cookies on a request to your site when the request is generated from an external domain—like a malicious website set up by an attacker. Setting a cookie with the `SameSite=Strict` syntax in Listing 8-3 ensures that the browser will send the cookie only with requests initiated from within your own site.

<!-- Source S8, PDF page 5 -->

```text
Set-Cookie: _xsrf=5978e29d4ef434a1; SameSite=Strict;
```

Listing 8-3: Setting the `SameSite` attribute to our anti-CSRF cookie ensures that the cookie attaches to only requests from our site.

It’s a good idea to set a `SameSite` attribute on all your cookies, not just those used for CSRF protection. There’s a caveat to this, however: if you use cookies for session management, setting the `SameSite` attribute to your session cookie strips the cookie of any requests to your site generated from other websites. This means that any inbound links to your site will force the user to log in again.

This behavior can be a little annoying for users who already have a session open on your site. Imagine if you had to log back into Facebook every time somebody shared a video. Frustrating, right? To prevent this behavior, Listing 8-4 shows a more useful value of the `SameSite` attribute, `Lax`, that allows only `GET` requests from other sites to send cookies.

```text
Set-Cookie: session_id=82938d911e13f3; SameSite=Lax;
```

Listing 8-4: Setting the `SameSite` attribute on an HTTP cookie allows cookies on `GET` requests.

This allows seamless linking into your site, but strips the ability of an attacker to forge malicious actions such as `POST` requests. Provided your `GET` requests are side-effect free, this setting is no less safe.

### Bonus Mitigation: Require Reauthentication for Sensitive Actions

You might notice that some websites force you to reconfirm your login details when you perform sensitive actions, such as when you change your password or initiate a payment. This is known as reauthentication, and it’s a common way to secure sites against CSRF attacks, because it gives the user a clear indication that you’re about to do something significant and potentially dangerous.

Reauthentication also has the positive side effect of protecting your users if they accidentally leave themselves logged in on shared or stolen devices. If your website handles financial transactions or confidential data, you should strongly consider forcing your users to reenter their credentials when they perform sensitive actions.

### Summary

Attackers can use web requests from other sites to trick your users into performing undesired actions. The solution to such cross-site request forgery attacks is threefold.

<!-- Source S8, PDF page 6 -->

First, make sure your `GET` requests are side-effect free, so the server state is not changed when a user clicks malicious links. Second, use anti-CSRF cookies to protect other types of requests. Third, set these cookies with a `SameSite` attribute to strip cookies from requests generated by other sites.

For very sensitive actions on your site, it’s a good idea to require the user to reauthenticate themselves when they request to perform these actions. This adds an additional layer of protection against CSRF attacks, and protects your users if they accidentally leave themselves logged in on shared or stolen devices.

In the next chapter, you’ll look at how hackers try to exploit vulnerabilities during the authentication process.
