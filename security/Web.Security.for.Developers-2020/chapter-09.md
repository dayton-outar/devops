# Chapter 9

## Web Security for Developers-2020

Source: [Web.Security.for.Developers-2020-9.pdf](Web.Security.for.Developers-2020-9.pdf) — 12 PDF pages.

<!-- Source S9, PDF page 1 -->

### Compromising Authentication

> [Decorative chapter-opening artwork placeholder — source S9, PDF page 1; 9 image tiles.]

Most websites provide some sort of login functionality. This is a form of authentication, the process of identifying users when they return to your website. Authenticating your users allows them to have an identity in an online community where they can contribute content, send messages to others, make purchases, and so on.

Nowadays, internet users are comfortable with signing up to a site with a username and password, and logging back in when they next want to use it. This is especially true since browsers and plug-ins help with caching or choosing passwords, and third-party authentication services have become ubiquitous.

There’s a downside to this, however. Getting access to a user’s account is a tantalizing prospect for hackers. In the age of the internet, it has never been easier for hackers to sell hacked credentials on the dark web, hijack social media accounts to spread clickbait, and commit financial fraud.

<!-- Source S9, PDF page 2 -->

In this chapter, you’ll investigate some of the ways that hackers can compromise a user’s account on your site during the login and authentication process. (The next chapter covers the vulnerabilities your users face after they’ve logged in and established a session.) Here, you’ll first see the most common ways websites implement authentication and look at how attackers use brute-force attacks to exploit them. Then you’ll learn how to protect users against these attacks through third-party authentication, single sign-on, and securing your own authentication system.

### Implementing Authentication

Authentication is part of the HyperText Transfer Protocol. To present an authentication challenge, a web server needs to return a `401` status code in the HTTP response and add a `WWW-Authenticate` header describing the preferred authentication method. (There are two commonly supported authentication methods: basic authentication and digest authentication.) To fulfill this requirement, the user agent—usually a web browser—needs to request a username and password from the user, thus creating the login functionality.

In the basic authentication scheme, the browser concatenates the username and password supplied by the user with a colon (`:`) character between them, generating the string `username``:``password`. It then uses the Base64 algorithm to encode this string and send it back to the server in the `Authorization` header of an HTTP request.

The digest authentication scheme is a little more complex, and requires the browser to generate a hash consisting of the username, password, and URL. A hash is the output of a one-way encryption algorithm that makes it easy to generate a unique “fingerprint” for a set of input data, but makes it difficult to guess the input values if you have only the algorithm’s output. You’ll look at hashing in more depth later in this chapter, when we discuss how to securely store passwords.

### HTTP-Native Authentication

Even though authentication is built into the HyperText Transfer Protocol, popular websites rarely use basic or digest authentication—mostly because of usability considerations. The native web browser authentication prompt is not a thing of beauty. It looks similar to a JavaScript alert dialog, grabbing focus from the browser, and interrupting the experience of using the site, as shown in Figure 9-1.

Because browsers implement the authentication prompt outside HTML, we can’t style the native authentication prompt to match the website. As a native browser window that doesn’t appear in the web page, the browser also can’t autocomplete the user’s credentials. Finally, because HTTP authentication specifies no method of resetting a password if a user forgets it, we’d have to implement a reset feature separately from the login prompt, leading to a confusing user experience.

<!-- Source S9, PDF page 3 -->

> [Figure 9-1: The native Google Chrome login prompt rudely interrupts your browsing session. — image placeholder; source S9, PDF page 3.]

### Non-Native Authentication

Because of this user-hostile design, the built-in HTTP authentication methods tend to be reserved mostly for applications where the user experience simply doesn’t matter that much. Modern websites usually implement their own login forms in HTML, like the one shown in Listing 9-1.

```text
   <form action="/login" method="post">
  [1] <input type="email" name="username" placeholder="Type your email">
  [2] <input type="password" name="password" placeholder="Type your password">

  <input type="submit" name="login" value="Log in">
</form>
```

Listing 9-1: A typical login form in HTML

A typical login form contains an `<input type="text">` element [1] requiring the user to supply a username, and an `<input type="password">` element [2] that replaces typed characters with a `•` character to obscure the password. The supplied username and password are sent to the server as a `POST` request when the user submits the form. If the login is unsuccessful because the user couldn’t be authenticated, the server replies with a `401` status code in the HTTP response. If the login is successful, the server redirects the user to their homepage.

### Brute-Force Attacks

Attackers often attempt to compromise your site at the point of authentication by guessing passwords. Movies usually depict hackers using personal insights about a target to guess their password. While this might be a concern for high-profile targets, hackers usually have more success using brute-force attacks, which use scripts to try thousands of commonly used passwords against a login page. Because previous data breaches have already leaked millions of commonly used passwords, including the ones in Listing 9-2, it’s easy for an attacker to determine which passwords they should try first.

<!-- Source S9, PDF page 4 -->

```text
1. 123456
2. password
3. 12345678
4. qwerty
5. 12345
6. 123456789
7. letmein
8. 1234567
9. football
10. iloveyou
```

Listing 9-2: Security researchers publish a list of the most commonly used passwords each year; they change very little year to year. (This list is provided by the internet security firm SplashData.)

Let’s look at a few ways you can implement and secure your authentication against this type of threat.

### Mitigation 1: Use Third-Party Authentication

The most secure authentication system is the one you don’t have to write yourself. Instead of implementing your own authentication system, consider using a third-party service like Facebook Login, which allows users to authenticate to your website with their social media credentials. This is convenient for them, and relieves you of the burden of ever having to store user passwords.

Large tech companies provide other similar authentication services. Most of them are based on the open authentication (OAuth) or OpenID standards—commonly implemented protocols for delegating authentication to a third party. You can always mix and match authentication systems. They’re typically straightforward to integrate with, so pick one or more that make sense with your userbase. If you’re providing email-related services, you can integrate with Google OAuth to ask your users for access to their Gmail accounts. If you’re providing technical services, use something like GitHub OAuth. Twitter, Microsoft, LinkedIn, Reddit, and Tumblr all offer authentication options, as do hundreds of other websites.

### Mitigation 2: Integrate with Single Sign-On

If you integrate with an OAuth or OpenID identity provider, your users will usually use their personal email addresses as usernames. However, if your website’s target audience is business users, consider integrating with a single sign-on (SSO) identity provider like Okta, OneLogin, or Centrify, which centralizes authentication across enterprise systems so employees can log in seamlessly to third-party applications under their business email. Company administrators retain ultimate control over which employees can access what sites, and user credentials are stored securely on the company’s servers.

<!-- Source S9, PDF page 5 -->

To integrate with a single sign-on provider, you’ll usually have to use Security Assertion Markup Language (SAML), which is an older (and less friendly) standard than OAuth or OpenID, though most programming languages have mature SAML libraries you can use.

### Mitigation 3: Secure Your Own Authentication System

Although third-party authentication will usually be more secure than your own system, having only third-party authentication could somewhat limit your userbase because not everyone has a social media presence or Gmail account. For everyone else, you’ll need to create a way for them to sign up and manually choose a username and password. This means creating separate pages on your website where users can sign up, log in, and log out; plus writing code to store and update credentials in your database, and to check that the credentials are correct when a user reenters them. More than likely, you will need to have a mechanism for a user to change their password too.

That’s a lot of functionality to implement! Before you start writing code, you’ll need to make a few design decisions. Let’s look at the key things you need to get right in order to have a secure authentication system.

### Requiring Usernames, Email Address, or Both

Your users will need to choose a username and password when they sign up. Most websites will also require a user to submit a valid email address when they sign up, which allows them to send password-reset emails when users forget their credentials.

For many sites, a user’s email address is their username. By necessity, each email address has to be unique to an account, so choosing a separate username would generally be redundant. The exception to this is when users have a visible presence on the site; for example, when a user has a public profile, or interacts with other users in comment sections. These types of sites require users to choose a separate display name. Using email addresses as display names is bad practice, since it invites harassment and spam.

### Validating Email Addresses

If you intend to send email from your site—for instance, to allow users to reset their password—you need to validate that every user’s email address corresponds to a working email account. Emails that a website generates are called transactional emails, because the website sends them in response to a user action. Sending transactional emails to unverified addresses will quickly get you blacklisted by your email service provider, since they’re wary of enabling spammers.

First, verify that the user’s email address appears valid on its face. This means validating that the email contains only valid characters: letters, numbers, or any of the special characters (``!#$%&'*+-/=?^_`{|}~;.``).

<!-- Source S9, PDF page 6 -->

The address must contain an @ sign, and to the right of that, a valid internet domain. Usually, but not always, this domain should correspond to a website, like @gmail.com addresses that correspond to www.gmail.com. At a minimum, the internet’s Domain Name System (DNS), which we discussed in Chapter 2, must contain a mail exchange (MX) record for that domain that tells software where to route emails. It’s possible to look up the MX record as part of your verification process, as shown in Listing 9-3.

```text
import dns.resolver
def email_domain_is_valid(domain):
  for _ in dns.resolver.query(domain, 'MX'):
    return True
  return False
```

Listing 9-3: Validating that a domain is capable of receiving email in Python by using the `dnsresolver` library

However, the only 100 percent reliable way to validate that an address corresponds to a working email account is to send an email message and check that it’s received. This means you’ll have to send each user an email that contains an email verification link that links back to your website and contains a validation token—a large, randomly generated string you store in your database against their email address. When the user clicks the link to verify ownership of their email address, you can check that the validation token is the one you sent out, and confirm that they do indeed have access to the email account.

Many sites force users to validate their email before they can complete the sign-up process. Other sites allow the user to use a limited number of features on the site while they’re in an unvalidated state, in order to make the sign-up process less onerous. You should never assume a user has access to an email account until you’ve validated them. Until then, don’t send any other types of transactional email or sign the user up to mailing lists!

### Banning Disposable Email Accounts

Some users are reluctant to sign up with an email address they commonly use, and will sign up to your site using a temporary email account generated by services like 10 Minute Mail or Mailinator or the one shown in Figure 9-2. These types of services generate a disposable email account that’s good for receiving a handful of messages before shutting down. If a user uses this type of service, it usually means they’re wary of being signed up to mailing lists (quite a reasonable consideration, given the relentless approach of email marketers).

You may need to ban users from signing up with disposable email addresses if, for instance, some of your users are generating temporary accounts to harass others. If so, you can use well-maintained blacklists of disposable email providers to detect, reject, and ban disposable email domains during the sign-up process.

<!-- Source S9, PDF page 7 -->

> [Figure 9-2: Want a temporary email address? Come get it at https://www.sharklasers.com/. (Yes, this is a real website. Pew pew pew.) — image placeholder; source S9, PDF page 7.]

### Securing Password Resets

Having a validated email address for each of your users allows you to handle the (inevitable) scenario when a user forgets their password. Simply send them an email with a password-reset link, containing a fresh validation token. When the forgetful user opens the email and clicks the link, you can validate the incoming token, and allow the user to choose a new password for their account.

Password-reset links should be short-lived, and should expire after the user uses them. A good rule of thumb is to expire reset tokens after 30 minutes to prevent an attacker from abusing stale reset links. If an attacker hacks a user’s email account, you can’t let them search for emails containing reset links and then use those links to access your site under the victim’s account.

### Requiring Complex Passwords

Complex passwords are generally harder to guess, so you should require users to meet certain password complexity standards when they choose a password, for their own protection. Complex passwords include numbers and symbols as well as letters, have a mix of uppercase and lowercase characters, and are long rather than short. At the very least, you should enforce a minimum length of eight characters for passwords, but the longer the better. (Studies have shown that password length is more important than mixing in unusual characters.)

<!-- Source S9, PDF page 8 -->

However, users often have trouble remembering complex passwords, so if you enforce overly strict password complexity requirements, a user will usually reuse a password they previously entered on another website. Some secure sites prevent a user from reusing a password they previously used to force them to choose a new, unique password each time, pushing them away from lazy habits. Unfortunately, most users will simply cycle passwords by adding a number at the end of a password they commonly use, which doesn’t make for a significantly less guessable password.

Ultimately, each user is responsible for their own security online, so it’s generally better to nudge your users toward strong password choices rather than forcing them to jump through hoops. Some JavaScript libraries, like the `password-strength-calculator` library, can be used to rate a user’s password’s complexity as they type it and to call out commonly used passwords, which you can use on sign-up and password-reset screens to push users toward a more secure password.

### Securely Storing Passwords

After a user chooses a password, you need to record it in some form in your database against their username, so you can revalidate their credentials when they log in again. Do not simply store the password as is—we call this cleartext storage, and it’s a big security no-no. If an attacker accesses a database that stores passwords in cleartext form, they can compromise every user account, as well as accounts those users have on other websites under the same credentials. Luckily, there is a way of storing passwords in a secure fashion that makes them unreadable in the database, but allows you to check they have been reentered correctly by a user at a later date.

### Hashing Passwords

Passwords should be processed with a cryptographic hash algorithm before being stored in your database. This will convert the raw string of input text into a bit string of fixed length in such a way that makes it computationally unfeasible to reverse the process. You should then store the output values of that algorithm—the hashed values—alongside each username.

Hashing algorithms are a type of one-way mathematical function. The only practical way to guess the input string that generated a given hashed output (or hash, for short) is to try every possible input string one after the other. By storing a hash of a user’s password, you can recalculate the hash when a user reenters their password and compare the new and old hash values to see if they’ve entered the correct password.

Numerous cryptographic hash algorithms exist, each with varying implementations and strengths. A good hashing algorithm should be quick to calculate, but not too quick. Otherwise, as computation speeds increase, brute-force attempts to crack the password by enumerating all possible inputs become feasible. For this reason, a good algorithm to use is bcrypt, shown in Listing 9-4, which allows you to add extra iterations to the hashing function as the years go by to make it stronger and more time-consuming as computation power gets cheaper.

<!-- Source S9, PDF page 9 -->

```text
import bcrypt
password = "super secret password"

# Hash a password for the first time, with a randomly-generated salt
hashed = bcrypt.hashpw(password, bcrypt.gensalt(rounds=14[1]))

# Check that an unhashed password matches one that has previously been hashed
if bcrypt.checkpw(password, hashed):
    print("It matches!")
else:
    print("It does not match :(")
```

Listing 9-4: Hashing and then testing a password using the `bcrypt` algorithm in Python

The `rounds` parameter at [1] can be incremented to make the password hashes even stronger. Storing hashed passwords rather than cleartext passwords is much more secure. No one who accesses the database, including you, can directly decipher the passwords, but your website can still determine whether a user has correctly reentered their password. This relieves you of a security burden—even if an attacker hacks your database, they can’t do much with the hashed passwords.

### Salting Hashes

Hashing passwords makes your site more secure, but users are frequently unimaginative in their password choice. When cracking password lists— reverse engineering passwords for a list of leaked password hashes—hackers frequently use rainbow tables, which are lists of commonly used passwords that have been put through a known hashing algorithm. Matching hashes against precalculated values yield a very good return for an attacker, allowing them to determine the password for many, if not most, of the hashes.

To protect against rainbow table attacks, you need to salt your password hashes, which means adding an element of randomness to the hashing algorithm so the input password doesn’t solely determine the generated hash. You can store the salt input value in your configuration, or better yet, generate a salt input value separately for each user and store it alongside their password hash. This makes rainbow table attacks unfeasible, since an attacker has to regenerate the entire rainbow table for each salt value you use, which is computationally prohibitive and thus takes too long.

### Requiring Multifactor Authentication

No matter how securely you store passwords, password-based authentication systems are always vulnerable to brute-force password-guessing attacks. To really secure your website, consider adding an extra layer of security by requiring multifactor authentication (MFA), which requires a returning user to identify themselves with at least two of the following three categories of information: something they know, something they have, and something they are. One example of multifactor authentication is a bank ATM, which requires the account holder’s PIN (the thing they know) and their bank

<!-- Source S9, PDF page 10 -->

card (the thing they have). Another example would be devices that use biometrics to identify individuals, like fingerprint scanning on smartphones (the thing they are).

For websites, multifactor authentication generally boils down to requiring a username and password (the thing the user knows), and confirming that the user has an authenticator installed on their smartphone (the thing they have). Each user will need to sync the authenticator app with the website during sign up (usually by taking a photograph of a QR code onscreen.) Thereafter, the app generates a six-digit random number that they need to supply at login time for the user to log in successfully, like the one shown in Figure 9-3.

> [Figure 9-3: Your users will come to love typing in six-digit numbers. — image placeholder; source S9, PDF page 10.]

This forces an attacker to have knowledge of a victim’s credentials and access to the victim’s smartphone in order to compromise their account, which is a highly unlikely combination. Support for multifactor authentication is increasingly becoming the norm, given the ubiquity of smartphones. If your website does any type of financial processing, you should definitely implement multifactor authentication. Thankfully, many code libraries make integrating it relatively easy.

### Implementing and Securing the Logout Function

If you authenticate users on your site, don’t forget to add a function that lets them log out of your site too. This might seem like an anachronism, given that users seem to stay perpetually logged in to social media, but having a logout function is a key security consideration for users who log in on shared devices. Plenty of families share a laptop or iPad, and companies often reuse computers and portable devices, so make sure to let your users log out!

Your logout function should clear the session cookie in the browser, and invalidate the session identifier if you are storing it on the server side. This

<!-- Source S9, PDF page 11 -->

protects against attackers who manage to intercept session cookies after the fact and attempt to reestablish a session using a stolen cookie. Clearing the session cookie is as simple as sending back an HTTP response containing a `Set-Cookie` header with a blank value for your session parameter.

### Preventing User Enumeration

You can cut down the risk of an attacker compromising your authentication system if they can’t enumerate users, which means testing each username from a list to see whether it exists on your website. Attackers frequently use leaked credentials from prior hacks and attempt to verify whether any of these usernames exist on a target website. After they narrow down the list, they then proceed to guess passwords for usernames that matched.

### Preventing Potential Enumeration Vulnerabilities

Login pages often allow an attacker to determine whether a username is taken on a site. If the page shows an error message for an incorrect password that differs from the error message for an unknown user, then an attacker can infer from the responses whether certain usernames correspond to accounts that exist on your site. It’s important to keep the error messages generic to avoid leaking this type of information. For example, simply use the error message `an incorrect username or password was entered` whenever the username is unrecognized or the password is incorrect.

Attackers may also use timing attacks to enumerate users by measuring HTTP response times. Hashing a password is a time-consuming operation; though it typically takes less than a second, it’s still a measurable amount of time. If your site calculates password hashes only when a user enters a valid username, an attacker can measure the slightly slower response time to infer which accounts exist on the site. Make sure your site calculates password hashes during authentication even for invalid usernames.

You should prevent your password-reset screen from revealing that a username exists, too. If an attacker clicks a “Forgotten password” link and types in an email address to request a password-reset link, the response message on the page shouldn’t reveal whether a reset email was sent. This prevents the attacker from knowing whether that email address is tied to an account on your site. Keep the message neutral: something like `Check your inbox`.

### Implementing CAPTCHA

You can also defuse user enumeration attacks by implementing a CAPTCHA (Completely Automated Public Turing test to tell Computers and Humans Apart), which asks web users to perform various image recognition tasks that are trivial for humans but tricky for computers. CAPTCHAs, like the one shown in Figure 9-4, make it impractical for attackers to abuse a web page via hacking scripts.

CAPTCHAs aren’t perfect. Attackers can defeat them by using sophisticated machine learning techniques, or by paying human users to complete a task in their stead. However, they are generally reliable enough to

<!-- Source S9, PDF page 12 -->

deter most hacking attempts, and you can easily add them to a website. For example, Google implements a CAPTCHA widget called reCAPTCHA that you can install on your site with a few lines of code.

> [Figure 9-4: Some tasks are simply too hard for a computer to complete successfully. — image placeholder; source S9, PDF page 12.]

### Summary

Hackers often attempt to attack your authentication system in an effort to steal your users’ credentials. To secure your website, you can use a third-party authentication system like Facebook Login or a single sign-on identity provider.

If you’re implementing your own authentication system, you’ll need to have users choose a username and password upon sign-up. You should also store and validate an email address for each user. It makes sense to use this email as a username, unless you need users to have a visible display name.

The only reliable way to validate an email address is to send it an email containing a link with a unique, temporary validation token that your site can check when the user clicks it. Your password-reset mechanism for users who have forgotten their password should work in the same way. Passwordreset emails and the initial validation email should time out after a period of time, and after they’re used for the first time.

You should process passwords with a cryptographic hash algorithm before storing them. You should also salt your password hashes to prevent rainbow table attacks.

Consider adding multifactor authentication if your site hosts sensitive data. Make sure to include a logout function somewhere on your site. Keep login failure messages generic, to prevent hackers from enumerating usernames on your site.

In the next chapter, you will investigate ways that users on your site can have their account compromised after they log in, by having their session stolen by an attacker.
