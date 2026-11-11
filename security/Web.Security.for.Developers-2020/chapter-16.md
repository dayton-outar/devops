# Chapter 16

## Web Security for Developers-2020

Source: [Web.Security.for.Developers-2020-16.pdf](Web.Security.for.Developers-2020-16.pdf) — 9 PDF pages.

<!-- Source S16, PDF page 1 -->

### Don’t Be an Accessory

![Figure 16-1: Chapter-opening artwork](/.attachments/16-1-Web.Security.for.Developers-2020-16.png)

*Figure 16-1: Chapter-opening artwork*

<!-- Source: Web.Security.for.Developers-2020-16.pdf, PDF page 1. -->

Malicious actors have a lot of places to hide on the internet. Hackers routinely impersonate other people and use compromised servers to evade detection. This chapter explores various ways that your web presence may be helping attackers get away with malicious acts, even when you aren’t the target of their attacks.

Making sure you aren’t being an accessory will win you good internet citizen points. More practically, if hackers are using your system as a jumpingoff point for attacking others, you will quickly find your domain and IP addresses getting blacklisted from key services, and you may even end up being cut off by your hosting provider.

This chapter covers several vulnerabilities that can make you an accessory to malicious acts on the internet. The first couple of vulnerabilities are used by hackers to send harmful emails: scammers frequently use email address spoofing to disguise who is sending an email, and use open redirects on websites to disguise malicious links in email.

<!-- Source S16, PDF page 2 -->

Next, you’ll see how your site can be hosted within a frame on someone else’s page and be used as part of a clickjacking attack. In this type of attack, your site is used in a bait-and-switch scheme to trick users into clicking something harmful.

You saw in the preceding chapter how hackers can use vulnerabilities in XML parsers in order to trigger network requests. If an attacker can craft malicious HTTP requests that trigger outbound network access from your server, you are enabling server-side request forgery attacks. You will learn common ways this type of attack can be launched and how to protect against it.

Finally, you will look at the risk of malware being installed on your servers for use in a botnet. You may unknowingly be hosting zombie code that can be controlled remotely by an attacker!

### Email Fraud

Email is sent using the Simple Mail Transfer Protocol (SMTP). One major oversight in the original design of SMTP is that it does not have a mechanism for authentication: the sender of an email is able to attach any email address they want in the `From` header, and until relatively recently, there was no way for the receiving agent to verify that the sender is who they claim to be.

As a result, of course, we all receive massive amounts of spam email. Experts estimate that around half of all email sent is spam—nearly 15 billion spam emails are sent every day. Spam email generally contains unwanted (and often misleading) marketing material that is a nuisance to the recipient.

Related to spam email is phishing email: the sender attempts to trick the recipient into revealing sensitive personal information such as passwords or credit card details. A common trick is to email a victim with what looks like a password reset email for a website they use, but have the reset link to a doppelganger domain—a domain whose name looks superficially similar to the real domain name that hosts a fake version of the site. The fake site will harvest the user’s credentials on behalf of the attacker, and then redirect the user to the real site so the victim is none the wiser.

An even more vicious form of this type of attack is spearphishing, whereby the content of a malicious email is tailored to a small audience. Fraudsters sending this type of email often conduct detailed research on their victims in order to be able to name-drop or impersonate colleagues. CEO fraud—through which a scammer pretends to be a C-level officer and emails another employee to request a wire transfer—netted hackers over $26 billion between 2016 and 2019 according to the FBI. And that’s just counting the victims who reported the loss to law enforcement.

Thankfully, mail service providers have developed sophisticated algorithms for detecting spam and phishing email. Gmail, for instance, will scan each incoming email and quickly decide whenever it is legitimate, sending anything that looks suspicious to the junk folder. Spam filters use many inputs when classifying email: keywords in the email and the subject line, the email domain, and the presence of any suspicious outgoing links in the body of the mail.

<!-- Source S16, PDF page 3 -->

Your website and organization likely send email from a custom domain, so the onus is on you to prevent your email from being marked as spam and to protect your users from malicious email that pretends to be from your domain. You have a couple of ways to do this: by implementing a Sender Policy Framework and by using DomainKeys Identified Mail when you generate email.

### Implement a Sender Policy Framework

Implementing a Sender Policy Framework (SPF) entails whitelisting the IP addresses that are authorized to send email from your web domain in the DNS. Because SMTP sits on top of the TCP, the IP address that an email is sent from cannot be spoofed in the same way as the `From` header. By explicitly whitelisting IP addresses in your domain name records, mail receiving agents will be able to verify that incoming mail originated from a permitted source.

Listing 16-1 shows how to specify a Sender Policy Framework in your DNS records.

```text
v=spf1[1] ip4:192.0.2.0/24 ip4:198.51.100.123[2] a[3] -all[4]
```

Listing 16-1: A DNS record to whitelist a range of IP addresses authorized to send email from a given domain as part of your SPF

This record would be added as a .txt record in your domain name records. In this syntax, the `v=` argument [1] defines the version of SPF used. The `ip4` [2] and `a` [3] flags specify the systems permitted to send messages for the given domain: in this case, a range of IP addresses, and the IP address corresponding to the domain (indicated by the `a` flag) itself. The `-all` flag [4] at the end of the record tells mail providers that if the preceding mechanisms did not match, the message should be rejected.

### Implement DomainKeys Identified Mail

DomainKeys can be used to generate a digital signature for outgoing mail, to prove an email was legitimately sent from your domain and that it wasn’t modified in transit. DomainKeys Identified Mail (DKIM) uses public-key cryptography, signing outgoing messages from a domain with a private key and allowing recipients to validate the signature by using a public key hosted in DNS. Only the sender knows the private signing key, so only they can generate legitimate signatures. A mail receiving agent will recalculate the signature by combining the email’s content and the public signing key hosted on your domain. If the recalculated signature does not match the signature attached to the mail, the email will be rejected.

To implement DKIM, you need to add a DomainKey in a .txt record to your domain. Listing 16-2 shows an example.

<!-- Source S16, PDF page 4 -->

```text
k=rsa;[1] p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDmzRmJRQxLEuyYiyMg4suA[2]
```

Listing 16-2: A (public) domain key is hosted in the DNS system, and the corresponding private key needs to be shared with the application generating email for the domain.

In this example, `k` indicates the key type [1], and `p` is the public key used to recalculate the signature [2].

### Securing Your Email: Practical Steps

Your organization likely generates email from multiple locations. Email sent to a user in response to their actions on your website—called transactional email—will be triggered by your web server software, and often is generated via email services such as SendGrid or Mailgun. Email written by hand will be sent either by a webmail service (for example, Gmail) or from email server software hosted on your network (for example, Microsoft Exchange or Postfix). Your team may also be using email marketing or newsletter services such as Mailchimp or TinyLetter to send email.

Consult the documentation of your service providers or email server to see how to generate and add the DNS entries needed to implement SPF and DKIM. In fact, you may already be using DKIM, because many transactional email and marketing services require you to add the relevant DNS entries when you sign up to the service. As you lock down IP ranges and domains as part of your SPF implementation, remember to consider all the software that is sending email from your domain!

### Disguising Malicious Links in Email

Spam algorithms look for malicious links in email, and to support this, webmail providers keep up-to-date blacklists of domains that are known to be harmful. Scanning for links to such domains is a common and effective way to block dangerous email.

As such, scammers have had to come up with new tricks to disguise harmful links, to prevent their email from being flagged and sent directly to the junk folder. One way to do this is to use a URL-shortening service like Bitly, which will encode a URL in a shorter form and redirect the user when they visit the link. However, in the ever-escalating spam wars, email scanning algorithms now unroll links to known URL-shortening services and check whether the final destination is harmful.

Hackers have found a subtler way to disguise malicious links in email. If your website can be used to disguise a link to an arbitrary URL on the internet—if you implement an open redirect anywhere on your site—you may be helping hackers disguise malicious links in the same way as a URL- shortening service. Not only are you making your users vulnerable to phishing scams, but the genuine email you send is liable to be blacklisted by spam-detection algorithms.

<!-- Source S16, PDF page 5 -->

### Open Redirects

In HTTP, a redirect occurs when a web server responds with a `301` (temporary redirect) or `302` (permanent redirect) response code, and supplies a URL that the browser should navigate to instead. One of the most common uses of redirects is to send an unauthenticated user to the login page if they attempt to visit a site. In this scenario, the site typically issues a second redirect back to the original URL after the user has authenticated themselves.

To enable this second redirect, the web server has to remember the original destination as the user logs in. Frequently, this is done by encoding the final destination URL within a query parameter in the login URL. If a hacker can encode an arbitrary URL in this query parameter—in other words, if the second redirect can send the user to a whole different website on the internet—you have what is known as an open redirect.

### Preventing Open Redirects

Most sites won’t ever need to redirect to an external URL. If any part of your website encodes a URL within another URL for the purpose of redirecting the user to that destination, you should make sure that these encoded URLs are relative URLs rather than absolute URLs: encoded links should point within your site, rather than externally.

Relative URLs begin with a forward slash (/), which is easy to check for. Hackers have found a few ways to disguise absolute URLs to look like relative URLs, so your code needs to account for that. Listing 16-3 shows how to check that a URL is a relative URL via simple pattern-matching logic.

```text
import re
def is_relative(url):
  return re.match(r"^\/[^\/\\]"[1], url)
```

Listing 16-3: A function to check that a link is relative (internal to a website), using a regular expression in Python

This pattern [1] states that the URL must begin with a forward slash, and the following character must not be another forward slash or a backslash (\). The second character is checked to protect against URLs such as //:www.google.com, which are interpreted by browsers as absolute URLs; they will be automatically prefixed by http or https depending on what protocol the page is currently using.

Another approach to preventing open redirects is to avoid encoding URLs within query parameters altogether. If you are encoding a URL for an eventual redirect following login, consider dropping the URL in a temporary cookie instead of a query parameter. An attacker is unable to forge a cookie in a victim’s browser quite as easily, so you will close the door to abusive linking.

<!-- Source S16, PDF page 6 -->

### Other Considerations

Some types of websites do require external links to be posted by users. For instance, if you run a social news site, your users will often post links to external URLs. If this applies to your site, use the Google Safe Browsing API to check each URL against a blacklist of harmful sites.

After you have secured your email and redirect code, it’s important to make sure your web pages can’t be wrapped in other people’s malicious websites. Let’s look at how to protect your users against clickjacking attacks.

### Clickjacking

HTML permits a web page to contain another web page, by using an `<iframe>` tag. This allows content from different web domains to be mixed in a controlled fashion, because JavaScript running on the page within the frame cannot access the containing page. The `<iframe>` tags are commonly used to embed third-party content in a web page—OAuth and CAPTCHA widgets often use them to secure cookies.

As with anything useful on the internet, hackers have found ways to abuse `<iframe>` tags. Modern CSS allows page elements to be layered on top of each other using the `z-index` attribute; elements with a higher `z-index` will hide elements with a lower `z-index` and receive click events first. Page elements can also be made transparent using the `opacity` attribute. By combining these techniques, a hacker can position a transparent `<div>` over an `<iframe>` element, and then trick a victim into clicking whatever content is stored in the `<div>` rather than the underlying content they believe they are clicking.

This click-hijacking—clickjacking—has been used in a variety of ways. In some cases, victims have been tricked into switching on their webcam so the attacker can watch them remotely. Another variation of this technique is likejacking, whereby a victim is tricked into liking something on Facebook without their knowledge. Selling likes on the dark web for promotional purposes is a big money-spinner for a hacker.

### Preventing Clickjacking

If you run a website, you should make sure your site isn’t used as bait in a clickjacking attack. Most sites never need to be hosted in `<iframe>` tags, so you should tell the browser that directly. Modern browsers support the `Content` `-Security-Policy` header that allows the response from the server to specify that the page should have no `frame-ancestors`, as shown in Listing 16-4.

```text
Content-Security-Policy: frame-ancestors 'none'
```

Listing 16-4: A header that tells the browser never to host your website in a frame

Implementing this policy tells the browser to never put your website in a frame.

If for some reason your site does need to be contained within an `<iframe>`, you should tell the browsers which sites are permitted to host such

<!-- Source S16, PDF page 7 -->

a frame. You can do this by using the same `Content-Security-Policy` header to specify that the website can be its own frame ancestor. Listing 16-5 shows how to use the keyword `self` to permit your site to host iframes pointing to other parts of the same site.

```text
Content-Security-Policy: frame-ancestors 'self'
```

Listing 16-5: A header that permits a site to host iframes of itself

Finally, if you need third-party websites to be able to host your site in a frame, you can whitelist individual web domains, as shown in Listing 16-6.

```text
Content-Security-Policy: frame-ancestors example.com google.com
```

Listing 16-6: A header that permits a site to be hosted in an iframe by example.com and google.com

Now that you’ve looked at how to protect against clickjacking, let’s see how attackers will try to launch malicious network requests from your server.

### Server-Side Request Forgery

Hackers making malicious HTTP requests often seek to disguise where those requests are launched from. For instance, denial-of-service attacks— covered in the next chapter—are more effective when coming from many different IP addresses. If your web server makes outgoing HTTP requests, and a hacker can control which URLs those requests are sent to, you are vulnerable to a server-side request forgery (SSRF) attack, and a hacker can use your server to send malicious requests.

There are some legitimate reasons to make outbound network requests from your server. If you use any kind of third-party API, these are typically made available as web services over HTTPS. You might, for example, use server-side APIs to send transactional email, index content for searching, record unexpected errors in an error-reporting system, or process payments. Problems occur, however, when an attacker is able to manipulate the server into calling a URL of their choosing.

Typically, SSRF vulnerabilities occur when the outbound URL of an HTTP request sent from the web server is insecurely constructed from a part of an HTTP request sent to the server. A hacker will check a site for SSRF vulnerabilities by spidering through it, navigating to every page, and using hacking tools to replace every HTTP parameter they encounter with a URL under their control. If they detect any HTTP requests to their trap URL, they know the requests must have been triggered from your server, and that you are vulnerable to SSRF.

Hackers will also check to see if any part of your site accepts XML content, and use XML external entity attacks in an attempt to commit SSRF. Chapter 15 discussed this attack vector.

<!-- Source S16, PDF page 8 -->

### Protecting Against Server-Side Forgery

You can protect yourself against server-side forgery at several levels. The first, and most important step, is to audit any parts of your code that make outbound HTTP requests. You will almost always know ahead of time which domains need to be invoked as part of API calls, so the construction of URLs for API calls should use web domains recorded in your configuration or code rather than coming from the client. One way of ensuring this is to use the software development kit (SDK) that is usually made freely available with most APIs.

Because you should be following the practice of defense in depth—protecting yourself from vulnerabilities in multiple, overlapping ways—it makes sense to install safeguards against SSRF at the network level too. Whitelisting the individual domains that you need access to in your firewall, and banning all others, is a good way to catch any security issues you may have overlooked during code review.

Finally, consider employing penetration testing to detect SSRF vulnerabilities in your code. This can be done by employing an external team to find vulnerabilities in your website or by using an automated online tool to do the same. Effectively, you will be using the same tools that hackers use to detect vulnerabilities, before they get the chance to do so themselves.

### Botnets

Hackers are always looking for spare computing power to power their attacks. If a hacker manages to compromise your server, they will frequently install a bot—a piece of malware that they can control using remote commands. Most bots operate as part of a peer-to-peer network of individual bots—a botnet— that communicate with each other by using an encrypted protocol.

Bots are often used to infect regular consumer devices like laptops. Managing to install a bot on a server is big prize, however, because significantly more computing power will be available to the bot. Scammers will pay a good price on the dark web for access keys that allow them to control botnets. They commonly use this spare computing power to mine bitcoin or commit click fraud—that is, artificially inflate page-view numbers of websites. Botnets are also used to generate spam email or to commit denial-ofservice attacks (covered in the next chapter).

### Protecting Against Malware Infection

Clearly, you want to avoid having any bot malware installed on the server. Chapter 6 discussed command injection and file upload vulnerabilities that could allow a hacker to install a bot on your server. Make sure you follow that chapter’s advice to secure such vulnerabilities.

Additionally, you should also proactively protect your servers from infections. Running up-to-date antivirus software will help you quickly spot any kind of malware. Monitoring your outgoing network access will highlight suspicious activity: installed bots will periodically poll other IPs

<!-- Source S16, PDF page 9 -->

looking for other bots. You should also consider running an integrity checker on your web servers—a piece of software that checks for unexpected file changes on sensitive directories.

If you are using virtualized services or containers, you have an advantage here: any rebuild of the system will typically wipe away malicious software that was installed. Rebuilding from an image periodically will do a lot to keep your system safe from bot infestations.

### Summary

Avoid being an accessory to attacks on others on the internet by doing the following:

• Protect the email you send by implementing SPF and DKIM headers in your domain name records. • Make sure you have no open redirects on your site. • Prevent your site from being hosted in an `<iframe>` tag by setting a content security policy. • Audit your code to ensure that the server cannot be tricked into sending HTTP requests to an external URL of an attacker’s choosing, and whitelist outbound network access to avoid being used in server-side request forgery attacks. • Use virtualized servers, virus scanners, or vulnerability scanning tools to check for and remove bots.

In the next chapter, you will look at a brute-force technique that hackers can use to take your web server offline: the denial-of-service attack.
