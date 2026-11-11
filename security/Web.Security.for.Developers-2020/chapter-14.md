# Chapter 14

## Web Security for Developers-2020

Source: [Web.Security.for.Developers-2020-14.pdf](Web.Security.for.Developers-2020-14.pdf) — 14 PDF pages.

<!-- Source S14, PDF page 1 -->

### Third-Party Code

![Figure 14-1: Chapter-opening artwork](/.attachments/14-1-Web.Security.for.Developers-2020-14.png)

*Figure 14-1: Chapter-opening artwork*

<!-- Source: Web.Security.for.Developers-2020-14.pdf, PDF page 1. -->

Nobody builds software from scratch nowadays, least of all web developers. Most of the code powering your website—from the operating system, to the web server, to the programming language libraries you use—will be written by others. So how do you manage vulnerabilities in other people’s code?

Hackers often target known vulnerabilities in popular software components, so it is important to secure third-party code. It is far more efficient for a hacker to scan the web for insecure WordPress instances, for example, than to pick a particular website and try to figure out how it might be vulnerable. So, it’s important that you stay up-to-date with the latest security patches in order to avoid being picked up by a malicious scan.

This chapter discusses three approaches to securing third-party code. You’ll learn how to stay ahead of security advisories for your dependencies, the software components you use. Next, you’ll delve into the importance of configuring these dependencies correctly, so they do not accidentally leave

<!-- Source S14, PDF page 2 -->

open backdoors that hackers can take advantage of. Finally, you’ll see the security risks associated with third-party services—code running on other people’s servers that is either called by your web server or loaded into your web pages via JavaScript imports. In particular, you will look at the alarmingly popular strategy of deploying malware through ad networks— so-called malvertising—and examine ways to protect your users if your site includes advertising.

### Securing Dependencies

In April 2014, the authors of OpenSSL, the open source C library that implements TLS for most versions of Linux (and other operating systems), disclosed the existence of the Heartbleed bug: using a buffer over-read, an attacker could read arbitrary chunks of memory from a server using the vulnerable library, and thereby steal encryption keys, usernames, passwords, and other sensitive data. The two most popular web servers on the internet—Apache and Nginx—use OpenSSL to secure communication, and researchers working for the security firm AVG estimated that more than half a million websites were revealed to be vulnerable to attack overnight. Because of the sheer number of websites affected, the Heartbleed vulnerability has been called the most dangerous bug of all time.

A new version of OpenSSL that patched the bug was released the same day that the vulnerability was disclosed, but unpatched web servers were still common on the internet for months afterward. This was a dangerous time to run an unpatched web server: hackers had time to find the best methods of exploiting the vulnerability, and the dwindling pool of vulnerable sites made the remaining web servers a more likely target.

All websites use third-party code, and all third-party libraries—even those written by security experts, like OpenSSL—are liable to have security issues. If you want to stay ahead of these vulnerabilities, you need to be aware of security issues as soon as they are made public and to patch software promptly. There are three aspects to this: knowing precisely what dependencies you are running, being able to update your dependencies quickly, and staying alert to security issues for your dependencies. Let’s discuss each in turn.

### Know What Code You Are Running

The first step to securing your dependencies is knowing what they are. This might sound obvious, but modern software stacks are intricate and multilayered, making it easy to add new libraries during the development phase of the software development life cycle that you may forget about later. There are numerous tools you really ought to be using to organize your dependencies.

### Dependency Management Tools

Most programming languages come with a dependency manager that allows a development team to specify third-party dependencies in a configuration

<!-- Source S14, PDF page 3 -->

file. The described software libraries will be downloaded on demand as part of the build process. Dependency managers make it easy to grab new dependencies and to rebuild the software stack in a new environment—for instance, when you deploy to a server.

To be absolutely sure you know which versions of each dependency you are running, you should get in the habit of specifying explicit version numbers for each dependency in your dependency list. Packages available in a dependency management system are hosted in a remote repository on the internet. As package authors release new versions of a package, they will be added to the repository with a new version number. By default, most dependency managers grab the latest version of each dependency when you first run a build in a new environment. This is a sensible default behavior during initial development, but by the time you are releasing code, your dependency configuration file should explicitly list version numbers. Security advisories will disclose which versions of a dependency are vulnerable, so pinning down the versions you are running in each environment will tell you what needs to be patched.

Be aware, too, that the dependencies you declare likely have dependencies themselves—and your dependency manager will helpfully fetch those libraries too. For this reason, we talk about the dependency tree, since each dependency has branches that are other dependencies. Be sure to consider the whole dependency tree when assessing security risks. Your dependency manager will be able to output the whole tree (including dependencies of dependencies) on the command line. Listing 14-1 shows the dependency tree for a Node.js project, illustrating how the `@blueprintjs/core` library has the `popper.js` library as a subdependency.

```text
my_project@0.0.0 /usr/code/my_project
├─┬ @blueprintjs/core@3.10.0
│ ├─┬ @blueprintjs/icons@3.4.0
│ │ ├── classnames@2.2.6 deduped
│ │ └── tslib@1.9.3 deduped
│ ├── @types/dom4@2.0.1
│ ├── classnames@2.2.6 deduped
│ ├── dom4@2.1.4
│ ├── normalize.css@8.0.1
│ ├── popper.js@1.14.6
│ ├── react-popper@1.3.3 deduped
```

Listing 14-1: The command `npm list` shows the whole dependency tree in the Node Package Manager.

### Operating System Patches

In addition to tracking your programming language dependencies, you also need to keep track of software packages deployed at the operating system level. Operating system vendors (for example, Red Hat and Microsoft) frequently issue security patches, so you should track the version of each operating system library you are using in any given environment, and have a strategy for upgrading servers in a timely fashion. If you have physical

<!-- Source S14, PDF page 4 -->

servers running in a data center, your company likely has dedicated system administrators to take care of this. If you run your software on virtualized servers in the cloud (for instance, on Amazon EC2), you should update the version of the operating system regularly as part of deployment. Using Docker for containerization is a great way of tracking operating system dependencies, too, since the Docker configuration file will explicitly list what software is to be installed when the container is instantiated.

### Integrity Checks

One final consideration: you need to ensure that the code you think you are running is the code you are actually running. Dependency managers and patching tools will help here. They ensure that software components are delivered uncorrupted by using checksums—digital fingerprints that are calculated when the dependency is uploaded to the repository, and that can be recalculated and verified when the dependency is downloaded for use. You should strive to provide the same guarantees when deploying JavaScript code and other resources to the browser.

Modern browsers allow you to do this by adding subresource integrity checks to `<script>` and `<style>` tags in your HTML. Your build process should generate a checksum for each resource file you intend to import on the client side, and assign that checksum to the `integrity` attribute of each import tag. Listing 14-2 shows how to use the `openssl` utility to generate a checksum.

```text
cat FILENAME.js | openssl dgst -sha384 -binary | openssl base64 -A
```

Listing 14-2: To generate a checksum in Unix, pipe the JavaScript file FILENAME.js to `openssl` to generate a digest and encode it in Base64.

The browser will compare the script to the expected checksum and verify that there’s a match before executing the imported code. This makes it much harder for hackers who gain access to your server to replace JavaScript files with malicious code, because they would also have to gain access to and change the code that generates the `<script>` tags, like the one shown in Listing 14-3.

```text
<script src="https://example.com/example-framework.js"
        integrity="sha384-oqVuAfXRKap7fdgcCY5uykM6+R9GqQ8K/uxy9rx7HNQlG"
        crossorigin="anonymous"></script>
```

Listing 14-3: Ensure the integrity of an imported JavaScript file by calculating a checksum of the file and adding it to the `integrity` attribute of the HTML tag that imports the script.

### Be Able to Deploy New Versions Quickly

Responding to security issues requires you to be able to deploy patches quickly, which means, in turn, having an orderly and scripted release process. Chapter 5 covered much of this: your release process should be reliable, reproducible, and revertible, and releases should be tied to code branches in a source control system. The configuration file used by your

<!-- Source S14, PDF page 5 -->

dependency manager should be kept under source control, so you can track which versions of each dependency were deployed with each release.

You will often deploy security patches for third-party components in isolation—upgrading dependency versions without releasing any changes to your own code. A release that contains only third-party code changes still requires you to regression test your website: in other words, to ensure that the upgraded dependencies do not break any existing functionality on the site. Regression testing becomes much more of a formality if you have good coverage in your unit tests. The more lines of your codebase that are executed during unit test runs, the less manual testing you will need to do. Investing some time in writing good unit tests will make deploying security patches quicker and easier.

### Stay Alert to Security Issues

With carefully managed dependencies and a reliable release process, you are in a good position to secure the third-party code you use. The final piece of the puzzle is staying in the loop when security issues are disclosed. Thanks to the internet, you have a lot of ways to keep track.

### Social Media

Security advisories spread quickly through social media and news sites like Twitter, Reddit, and Hacker News (https://news.ycombinator.com/), so these sites are a great way to get security news quickly. Big software vulnerabilities will be discussed in subreddits like https://www.reddit.com/r/programming/ and /r/technology, and will usually hit the front page of Hacker News.

If you make time to follow technology pundits and software authors on Twitter, security issues will often be the topic of the day. It’s also a great way to keep abreast of new developments in the software world.

### Mailing Lists and Blogs

Programming languages often have mailing lists and channels that publish big news. The Python Software Foundation publishes a weekly newsletter and has its own Slack channel, for instance. Make sure to subscribe to anything relevant to your technology stack.

A huge number of blogs exist on the topic of information security. Check out Brian Krebs (https://krebsonsecurity.com/) and Bruce Schneier (https://www.schneier.com/) for insightful commentary on the security issues of the day.

### Official Advisories

Pay attention to security alerts from your hosting provider and software vendors. When major security issues on the scale of Heartbleed occur, hosting companies will engage with their customers and guide them through the patching process. Microsoft famously issues new patches every Tuesday (patch Tuesday) so make sure to sign up to its newsletter if you use Microsoft technology.

<!-- Source S14, PDF page 6 -->

### Software Tools

In addition to keeping your ear to the ground, automated tools can check your dependencies for known vulnerabilities. Node.js leads the way here, as the Node Package Manager (NPM) now incorporates the `npm audit` command that can be used to cross-check your dependency versions against an open source database of vulnerabilities. The equivalent tool for Ruby is the `bundler-audit` gem; for Java and .NET, the Open Web Application Security Project (OWASP) publishes a command line tool called `dependency-check`. Incorporating these tools into your build process will alert you of any potential vulnerabilities whenever your code is built and will allow you to assess the risks around each vulnerability.

Your source code repository can also help. GitHub automatically scans code hosted on their site, and will issue security alerts whenever vulnerable dependencies are found.

### Know When to Upgrade

It’s important to note that not all security issues merit equal priority! Constantly upgrading your dependencies can be time-consuming, especially since many of the security concerns in a particular advisory may be mitigated in your system by other factors. Large organizations have formal processes for reviewing security alerts, prioritizing them, and then choosing the appropriate action. It’s perfectly acceptable to fold in minor security upgrades at the next scheduled release, as long as your team has assessed the risks involved.

### Securing Configuration

Software is only as secure as it is configured to be. This is particularly true of third-party software: if you install a new database and start running with the default user account and password, you will quickly run into trouble. Hackers frequently scan the internet for software components running with their default settings, since they know that many site owners will neglect to customize their configurations when installing software.

If you are running software with an unsecured configuration, you are probably advertising this fact to the world. The information security consulting group Offensive Security hosts the Google Hacking Database, a listing of insecure software you can find via a simple Google search. The Google search spider does a thorough job of indexing pages on the web and offers a powerful set of tools for refining searches based on this information. For example, googling index of /etc/certs will list millions of web servers that expose their digital certificate directories to the world— a major security flaw!

Deploying your dependencies with a secure configuration is absolutely key to not getting hacked. A secure configuration requires setting up your services with strong credentials, storing your configuration information securely, and limiting the damage an attacker can do if they gain access to one part of your environment. Let’s see how.

<!-- Source S14, PDF page 7 -->

### Disable Default Credentials

Many software packages come with default login credentials to make them easy for a first-time user to get up and running. Make sure you disable these credentials before deploying the software to test or production environments. If your database, web server, or content management system is deployed with, for example, an `admin` account, it will be quickly detected by bots scanning the internet for vulnerable software.

### Disable Open Directory Listings

Web servers tend to overshare. Older versions of the Apache web server, for instance, map URL paths to files, and will helpfully list the files a directory contains if the filename was omitted in the URL. Open directory listings invite hackers to explore your filesystem, allowing them to search for sensitive data files and security keys. Make sure to disable directory listings in your web server configuration. Listing 14-4 shows how this is done in the Apache web server.

```text
<Directory /var/www/>
   Options Indexes FollowSymLinks
   AllowOverride None
   Require all granted
</Directory>
```

Listing 14-4: Remove the keyword `Indexes` to prevent this Apache configuration file from generating open directory listings.

### Protect Your Configuration Information

Your web server configuration will likely contain sensitive information, such as database credentials and API keys. Many development teams store configuration files in source control, to make deployment easier. However, consider what a hacker could do with access to your source control system: this type of sensitive information is the first thing hackers will search for. Database credentials, API keys, private encryption keys, certificates, and other sensitive configuration details need to be kept externally from source control.

One common approach is to record sensitive configuration in environmental variables at the operating system level, and have your configuration code initialize itself from these environmental variables when it starts up. These environmental variables can be initialized by configuration files stored locally on the server.

Another approach is to use a dedicated configuration store. Amazon Web Services (AWS) allows you to store configuration securely in its Systems Manager Parameter Store. Microsoft servers frequently store credentials in Active Directory, which allows for fine-grained permissions. Storing configuration in a database table is another option, though you should consider how an attacker may be able to escalate an attack if they gain access to your database. (Your web server will also have to access your database credentials before it can load the rest of the configuration!)

<!-- Source S14, PDF page 8 -->

One surefire way to secure configuration information is to store it in encrypted form, encrypted with an algorithm such as AES-128. This approach means that a hacker will have to compromise your configuration data and your decryption key before they can steal your credentials. Just remember to store the decryption key in a different location from the configuration files, or the security benefit is neglible.

### Harden Test Environments

Preproduction environments typically have the same software installed as their production counterparts but are frequently less secure. If your test environment contains sensitive data—for instance, if you ever copy data from the production environment to help with testing—you need to configure your test environments to be just as secure as your production environment. Crucially, production and nonproduction should not share credentials or API keys; it’s important that you limit the damage a hacker can do if they manage to compromise your test server.

### Secure Administrative Frontends

Some software components come with administrative tools that are available over the internet. Administrative interfaces are a favorite target for hackers. You will often encounter malicious bots probing for unsecured WordPress instances by testing for the presence of a /wp-login.php page, for instance.

If you don’t intend to use these administrative frontends, disable them in your configuration. If you do intend to use them, make sure to remove any default login credentials, and, if possible, restrict the IP range that can access them. Consult the documentation for your software stack or do a quick search on Stack Overflow (https://stackoverflow.com/) to find out how.

Now that you have learned how to secure third-party code running on your servers, let’s look at how to securely integrate with code running on other people’s servers.

### Securing the Services That You Use

Third-party services are widely used in modern web development. You might be using Facebook Login for authentication, Google AdSense to place advertisements on your site, Akamai for hosting static content, SendGrid for sending transactional email, and Stripe for processing payments.

Integrating these kinds of services into your website generally means creating an account with the service provider, being supplied secret access credentials, and altering your website code to make use of the service. Two security considerations arise here. First, hackers will often attempt to steal your access credentials in order to access your account with these services. This will allow them to mine information about your users, for instance, or even to initiate financial transactions in the case of payment processors. Second, every third-party service is a potential attack vector to your site,

<!-- Source S14, PDF page 9 -->

because hackers try to compromise service providers in order to get access to a broad range of targets.

Let’s start with the first consideration: learning how to safely store your access credentials.

### Protect Your API Keys

Many third-party services issue you an application programming interface (API) key when you sign up, and your code must present the key as an access token when it interacts with the API. API keys need to be stored safely. Generally, this means storing the API key securely in the configuration on the server, as discussed in the previous section.

Some APIs issue two API keys: a public key that can be safely passed to the browser, used to make API calls from JavaScript; and a private key that must be kept securely on the server, used to make private API calls from the server side for more-sensitive actions. The public key has fewer privileges associated with it. Audit your code to make sure these keys don’t get mixed up! You don’t want to accidentally send the higher-privilege private key to the client. Even something as simple as naming your configuration variables `SECRET_KEY` will remind your development team of the risks.

Other services allow you to generate a temporary access token that can be passed to the client. Typically, these tokens can be used only once, or within a limited time window, to prevent abuse by a malicious user. These access tokens protect against replay attacks, whereby an attacker resends HTTP requests in an attempt to repeat an action (for instance, to duplicate a payment). Make sure your code generates access tokens only when a user has already authenticated themselves, or an attacker may be able generate new access tokens on demand.

### Secure Your Webhooks

Most API integrations involve making HTTPS calls from your web server or the browser, to the service provider’s API. When a service provider needs to make calls in the opposite direction (for instance, to send you notifications), it may ask you to implement a webhook. This is a simple “reverse API” on your website that the service provider will send HTTPS requests to when an event happens. You might, for instance, get webhook calls when a user opens an email you sent or when your payment processor initiates a payment.

Since they are public URLs, webhooks can be called by anyone on the internet, not just the service provider. If the service provider supports sending credentials with a webhook invocation, you should verify that these credentials are correct before processing the webhook call.

If a webhook invocation is purely informational and contains no sensitive data, it may be sent with no credentials attached whatsoever. In this scenario, an attacker can easily spoof such webhook calls. Be prepared to verify the notification with a further callback to the service provider’s API before doing any further processing.

<!-- Source S14, PDF page 10 -->

### Secure Content Served by Third Parties

Finding a way to serve malicious content under someone else’s domain is a favorite trick of hackers; victims can be lulled into a false sense of security by the sites they trust. Users have been conditioned to trust the padlock icon in the browser, so if a hacker can find a way to deploy malware under the security certificate of a large company, they will be able to trick more victims into downloading it.

Many websites use content delivery networks (CDNs) or cloud-based storage—such as Amazon S3—to serve frequently accessed content. When web developers integrate with this type of service, they often route traffic from their domain to the service by making DNS changes—for instance, by redirecting traffic on a subdomain such as subdomain.example.com to the service. This allows content served by the third party to be encrypted with the site’s security certificate.

Hackers frequently attempt subdomain takeovers by scanning the internet for DNS entries describing subdomains that point to IP addresses for uninitialized or deactivated services. They will then register with the service provider and squat on one of the listed IP addresses. This will allow them to create links to their malicious content by using the domain of the victim.

If your website serves content hosted by a CDN or cloud-based storage, you need to be careful that your DNS entries point to only live IP addresses. Make DNS changes only after you have verified that the service is up and running under your control, and revoke DNS changes promptly if you change service providers.

Now that you know how to protect your integrations with service providers, let’s look at threats in the other direction.

### Services as an Attack Vector

Third-party services are potentially a vector for malicious attacks against your website. This is particularly true of services you integrate on the client side, because any JavaScript you import from a third-party domain comes with security risks.

Let’s use Google Analytics as an example. When you add the Google Analytics tool to your site, you register for an account with Google to get a tracking ID and then import external JavaScript on pages where you wish to track user activity, as shown in Listing 14-5.

```text
<script src="https://www.googletagmanager.com/gtag/js?id=GA_TRACKING_ID"></script>
```

Listing 14-5: The recipe for adding Google Analytics to your web pages

The imported code can read anything in the page’s DOM, including sensitive data the user types in. It will also be able to make changes to the DOM in potentially misleading ways; for example, in order to trick the user into entering their credentials. It’s important to consider these risks as you add client-side services. Malicious code can be served by the third-party service itself or by an attacker that has compromised the service. (In case

<!-- Source S14, PDF page 11 -->

you are wondering: Google Analytics has never been compromised by an attacker. I am simply using it as an example here!)

Unfortunately, the browser security model is not currently very sophisticated when considering how to run client-side code imported from third parties. JavaScript code within a browser runs in a sandbox, meaning it is isolated from the underlying operating system and can’t access files on disk, but JavaScript files imported from different sources on a web page all play in the same sandbox.

The upcoming web components specification (https://www.webcomponents .org/), currently being developed by the HTML standards committee, defines more-granular permissions for code and page elements. While these details are being finalized and implemented, however, you should implement sensible security precautions on your site. Let’s discuss how to secure your client-side integrations, by looking at what is (by far) the most common vector for attacks via a third-party channel: malvertising.

### Be Wary of Malvertising

Advertising is a major part of the modern web: much of the content on the internet is funded by advertising revenue, and companies spend more than $100 billion annually on online advertisements. Advertisements are usually placed on websites by third-party ad platforms. A site owner (referred to as a publisher in the online advertising world) will subscribe to the ad platform and then demarcate various areas of their site as places advertisements should appear. The ad platform will populate these spaces as the site loads, using JavaScript imported directly on each page.

Major ad platforms such as Google AdSense use analytics to identify the type of content a publisher is hosting, and the type of people who visit the site, in order to determine the types of advertising to place. Publishers sometimes deal with advertisers directly, or have their ad spaces placed on an exchange, whereby ad buyers purchase blocks of ads. (An ad buyer might purchase 1,000 ad impressions for a particular demographic such as men aged 18–25 who visit sneaker sites.)

As a publisher, you have some control over the advertisements you carry, but generally do not get to approve each one beforehand. Google AdSense, for example, allows publishers to block categories of ads or specific web domains, or to reject specific ads after they have already begun to be shown to users.

This is a security risk because hackers frequently use ad platforms as an attack vector. Malicious ads—malvertising—allow an attacker to target many sites at once with malware. Malvertising is an increasingly common threat on the internet that can embarrass publishers and ad networks, and make victims out of their users.

### Avoid Malware Delivery

Malware in advertising is typically delivered via exploit kits, which determine whether a particular browser and operating system is vulnerable before delivering the actual malicious code: the payload. Payloads can include

<!-- Source S14, PDF page 12 -->

scripts that redirect or lock the browser, viruses or ransomware delivered via vulnerabilities in plug-ins, or even JavaScript code that mines cryptocurrency in the user’s browser.

Exploit kit authors are in an arms race with security researchers. To avoid detection, exploit kits are hosted at dynamically generated URLs and avoid automated scans by triggering only sporadically. Exploit kits have even been observed trying to prevent malware analysis by detecting when they are running in a virtual machine (malware researchers often use virtual machines to quarantine harmful code as they analyze it).

If your users are being hit by malware delivered through ads on your site, you are putting them in danger. You can protect them by making sure you partner with only trustworthy ad platforms, deploying ads in secure frames in your web pages, and continually being on the lookout for malicious ads.

### Use a Reputable Ad Platform

For the most part, defending against malvertising is the responsibility of the ad platform. They are the ones who have the relationship with the ad buyers, and only they have enough visibility across those advertisers to spot malicious actors.

Google is (by far) the biggest player in the advertising space. Google permits smaller publishers to monetize their sites by using the self-service AdSense platform. Larger publishers are granted access to AdX, a platform that allows a publisher to specify their advertising partners and set their own prices. Both platforms take ads from third-party advertising networks.

Google is remarkably on the ball about defending against malicious ads, since so much of their revenue depends on their advertising platform. To take advantage of this, you should make AdSense or AdX your first choice when choosing an ad platform.

Google chooses not to work with some types of sites, however, for reputational reasons. You will have a hard time getting approved for AdSense if you host adult-themed or violent content, for instance. In this scenario, you may have to work with a smaller advertising platform that will likely have fewer resources and less inclination to secure you against malware. Do your research before picking a platform.

### Use SafeFrame

The most effective way of isolating third-party content in a web page is to host that content inside an `<iframe>` tag. JavaScript code loaded inside an iframe (inline frame) cannot access the DOM of the containing page. HTML5 adds even more granular controls by adding the `sandbox` attribute to the `<iframe>` tag. This attribute allows the frame to specify whether the contained content can, for example, submit `POST` requests or open new windows.

The advertising industry has adopted a standard called SafeFrame, which allows publishers to specify that ads must be run in an iframe. The SafeFrame standard uses `<iframe>` tags, and adds a JavaScript API that allows the advertiser to overcome some of the native limitations of iframes. The

<!-- Source S14, PDF page 13 -->

API permits advertising scripts to know when the frame is visible and to respond to size changes, for instance.

Your advertising platform will have an option to show only SafeFramecompliant ads, and you should choose that option. This will stop any malicious ad scripts that attempt to interfere with the web page as it is rendered.

### Tailor Your Ad Preferences

Most advertising platforms allow you to customize the type of ad content you show to users. If you use Google AdSense, make sure you show content from only Google certified ad networks. Hackers have been known to buy expired domains for smaller, defunct ad networks in order to deliver malware.

Take stock of what categories of ads you are showing too. You probably want to block advertisements for get-rich-quick schemes and multilevel marketing campaigns, as well as anything that describes itself as a downloadable utility.

### Review and Report Suspicious Ads

Periodically review the ads being shown on your site from within your ad platform dashboard. (Remember: ads are tailored to the visitor, so simply visiting your site in a browser won’t show you the full range of ads being shown.) Report and block anything that looks suspicious. It is also a good idea to log outgoing URLs as users leave your site, so you can track whether any ads you are hosting are taking users to suspicious sites.

### Summary

Vulnerabilities in third-party code are a threat to your website. Use a dependency manager to keep track of what third-party dependencies you use, keep your dependency inventory under source control, and name explicit dependency versions. Make sure your build and deployment processes are scripted, so it is easy to upgrade your dependencies when security advisories are issued. (This should include operating system patches.) Stay engaged with social media and news sites so you know when security advisories are issued. Use auditing tools to detect vulnerable software components in your dependency tree. Use the `integrity` attribute when importing JavaScript on your web pages so these files can be validated by the browser.

Make sure you are not running with an insecure configuration; hackers will discover insecure software components by using simple Google searches. Disable any default credentials for your system, and disable open directory listings in your web server configuration. Keep sensitive configuration details (for example, database access credentials or API keys) out of source control; instead, keep them in a dedicated configuration store and load them at startup. Take care to secure configuration for test environments and administrative frontends, since they are common targets for hackers.

<!-- Source S14, PDF page 14 -->

Be careful not to pass sensitive API keys or access tokens to the client. Secure any webhooks against spoofing attacks. If you serve content hosted from other locations under your domain—say, by hosting it on a content delivery network or in cloud storage—make sure an attacker is not able to put malware on those systems and serve it under your security certificate.

Know the risks around malware delivered by any ads you host on your site. Use a reputable ad network and take advantage of all the SafeFramebased security settings it permits. Periodically review the ads being placed on your site. Report any ads you find suspicious and blacklist them.

In the next chapter, you will look at vulnerabilities related to XML parsing. XML is a ubiquitous part of the modern internet and a common target for hackers looking to compromise your system.
