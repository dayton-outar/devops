# Chapter 17

## Web Security for Developers-2020

Source: [Web.Security.for.Developers-2020-17.pdf](Web.Security.for.Developers-2020-17.pdf) — 6 PDF pages.

<!-- Source S17, PDF page 1 -->

### Denial-of-Service Attacks

![Figure 17-1: Chapter-opening artwork](/.attachments/17-1-Web.Security.for.Developers-2020-17.png)

*Figure 17-1: Chapter-opening artwork*

<!-- Source: Web.Security.for.Developers-2020-17.pdf, PDF page 1. -->

On October 21, 2016, internet users woke up and found that many of their favorite websites were inaccessible: Twitter, Spotify, Netflix, GitHub, Amazon, and many others all appeared to be offline. The root cause was an attack against a DNS provider. A massive wave of DNS lookup

requests had brought the popular DNS provider Dyn to its knees. It took most of the day—during which two more huge waves of DNS lookups occurred—before services were fully restored.

The scale and impact of the outage were unprecedented. (The only incident of comparable impact occurred when a shark chomped through an undersea internet cable and the whole of Vietnam went offline for a while.) It was, however, just the latest incarnation of the common and increasingly dangerous denial-of-service (DoS) attack.

A denial-of-service attack is different from most types of vulnerabilities discussed in this book, as the intent of the attack isn’t to compromise a system or website: the intent is to simply make it unavailable to other users. Generally, this is achieved by flooding the site with inbound traffic, so all

<!-- Source S17, PDF page 2 -->

server resources are exhausted. This chapter breaks down some of the more common techniques used in denial-of-service attacks and presents various ways to defend against them.

### Denial-of-Service Attack Types

Responding to a network request generally requires more processing power than sending one. When a web server handles an HTTP request, for example, it has to parse the request, run database queries, write data to the logs, and construct the HTML to be returned. The user agent simply has to generate the request containing three pieces of information: the HTTP verb, the IP address it is being sent to, and the URL. Hackers use this asymmetry to overwhelm servers with network requests so they are unable to respond to legitimate users.

Hackers have discovered ways to launch denial-of-service attacks at every level of the network stack, not just over HTTP. Given how successful they have been in the past, many more methods will likely be discovered in the future. Let’s look at some of the tools in an attacker’s toolkit.

### Internet Control Message Protocol Attacks

The Internet Control Message Protocol (ICMP) is used by servers, routers, and command line tools to check whether a network address is online. The protocol is simple: a request is transmitted to an IP address, and if the responding server is online, it will send back a confirmation that it is online. If you have ever used the `ping` utility to check whether a server is accessible, you have used ICMP under the hood.

ICMP is the simplest of the internet protocols, so inevitably, it was the first to be used in malicious ways. A ping flood attempts to overwhelm a server by sending an endless stream of ICMP requests, and can be initiated simply by a few lines of code. A slightly more sophisticated attack is the ping of death attack, which sends corrupt ICMP packets in an attempt to crash a server. This type of attack takes advantage of older software that does not correctly do bounds checking in incoming ICMP packets.

### Transmission Control Protocol Attacks

Most ICMP-based attacks can be defused by modern network interfaces, so attackers have moved higher up the network stack to the TCP, which underpins most internet communication.

A TCP conversation begins with the TCP client sending a `SYN` (synchronize) message to the server, which is then expected to reply with a `SYN-ACK` (synchronize acknowledgement) response. The client should then complete the handshake by sending a final `ACK` message to the server. By flooding a server with `SYN` messages—a SYN flood—without completing the TCP handshake, hacking tools leave a server with a large number of “half-open” connections, exhausting the connection pool for legitimate clients. Then, when a legitimate client attempts to connect, the server rejects the connection.

<!-- Source S17, PDF page 3 -->

### Application Layer Attacks

Application layer attacks against a web server abuse the HTTP protocol. The Slowloris attack opens many HTTP connections to a server, and keeps those connections open by periodically sending partial HTTP requests, thus exhausting the server’s connection pool. The R-U-Dead-Yet? (RUDY) attack sends never-ending `POST` requests to a server, with arbitrarily long `Content-Length` header values, to keep the server busy reading meaningless data.

Hackers have also found ways to take web servers offline by exploiting particular HTTP endpoints. Uploading zip bombs—corrupt archive files that grow exponentially in size when expanded—to a file upload function can exhaust the server’s available disk space. Any URL that performs deserialization—converting the contents of HTTP requests to in-memory code objects—is potentially vulnerable too. One example of this type of attack is an XML bomb, which you looked at in Chapter 15.

### Reflected and Amplified Attacks

One difficulty in launching an effective denial-of-service attack is finding enough computing power to generate malicious traffic. Hackers overcome this limitation by using a third-party service to generate the traffic for them. By sending malicious requests to a third party, with a spoofed return address belonging to their intended victim, hackers reflect the responses to their target, potentially overwhelming the server responding to traffic at that address. Reflected attacks also disguise the original source of the attack, making them harder to pin down. If the third-party service replies with larger or more numerous responses than the initial request, the larger responses amplify the attack power.

One of the largest denial-of-service attacks to date was committed using reflection. A single attacker was able to generate 1.3 terabytes of data per second and point it at the GitHub website in 2018. The hacker achieved this by locating a large number of insecure Memcached servers and sending them User Datagram Protocol (UDP) requests signed with the IP address of the GitHub servers. Each response was around 50 times larger than the original request, effectively multiplying the attacker’s computing power by the same factor.

### Distributed Denial-of-Service Attacks

If a denial-of-service attack is launched from a single IP address, it is relatively easy to blacklist traffic from that IP and stop the attack. Modern denial-of-service attacks, such as the 2018 attack on GitHub, come from a multitude of cooperating sources—a distributed denial-of-service (DDoS) attack. In addition to using reflection, these attacks are usually launched from a botnet, a network of malware bots that have infected various computers and internet-connected devices, and that can be controlled by an attacker. Because many types of devices connect to the internet these days—thermostats, refrigerators, cars, doorbells, hairbrushes—and are prone to having security vulnerabilities, there are a lot of places for these bots to hide.

<!-- Source S17, PDF page 4 -->

### Unintentional Denial-of-Service Attacks

Not all surges in internet traffic are malicious. It is common to see a website go viral and experience an unexpectedly large number of visitors in a short time, effectively taking it offline for a while because it wasn’t built to handle such a high volume of traffic. The Reddit hug of death frequently takes smaller websites offline when they manage to reach the front page of the social news site.

### Denial-of-Service Attack Mitigation

Defending yourself against a major denial-of-service attack is expensive and time-consuming. Fortunately, you are unlikely to be the target of an attack the size of the one that took Dyn offline in 2016. Such attacks require extensive planning, and only a handful of adversaries would be able to pull them off. You are unlikely to see terabytes of data a second hitting your recipe blog!

However, smaller denial-of-service attacks combined with extortion requests do happen, so it pays to put in some safeguards. The following sections describe some of the countermeasures you should consider using: firewalls and intrusion prevention systems, DDoS prevention services, and highly scalable website technologies.

### Firewalls and Intrusion Prevention Systems

All modern server operating systems come with a firewall—software that monitors and controls incoming and outgoing network traffic based on predetermined security rules. Firewalls allow you to determine which ports should be open to incoming traffic, and to filter out traffic from IP addresses via access control rules. Firewalls are placed at the perimeter of an organization’s network, to filter out bad traffic before it hits internal servers. Modern firewalls block most ICMP-based attacks and can be used to blacklist individual IP addresses, an effective way of shutting down traffic from a single source.

Application firewalls operate at a higher level of the network stack, acting as proxies that scan HTTP and other internet traffic before it passes to the rest of the network. An application firewall scans incoming traffic for corrupted or malicious requests, and rejects anything that matches a malicious signature. Because signatures are kept up-to-date by vendors, this approach can block many types of hacking attempts (for example, attempts to perform SQL injection), as well as mitigating denial-of-service attacks. In addition to open source implementations such as ModSecurity, commercial application firewall vendors exist (for example, Norton and Barracuda Networks), some of which sell hardware-based solutions.

Intrusion prevention systems (IPSs) take a more holistic approach to protecting a network: in addition to implementing firewalls and matching signatures, they look for statistical anomalies in network traffic and scan files on disk for unusual changes. An IPS is usually a serious investment but can protect you very effectively.

<!-- Source S17, PDF page 5 -->

### Distributed Denial-of-Service Protection Services

Network packets in a sophisticated denial-of-service attack will usually be indistinguishable from regular packets. The traffic is valid; only the intent and volume of traffic is malicious. This means firewalls cannot filter out the packets.

Numerous companies offer protection against distributed denial-ofservice attacks, usually at a significant cost. When you integrate with a DDoS solutions provider, you route all incoming traffic through its data centers, where it scans and blocks anything that looks malicious. Because the solutions provider has a global view of malicious internet activity and a massive amount of available bandwidth, it can use heuristics to prevent any harmful traffic from reaching you.

DDoS protection is often offered by CDNs, because they have geographically dispersed data centers and often already host static content for their clients. If the bulk of your requests are already being served by content hosted on a CDN, it doesn’t take too much extra effort to route the remainder of your traffic through its data centers.

### Building for Scale

In many ways, being the target of a denial-of-service attack is indistinguishable from having many visitors on your website at once. You can protect yourself against many attempted denial-of-service attacks by being ready to handle large surges in traffic. Building for scale is a big subject—whole books have been written on the topic, and it’s an active area of research. Some of the most impactful approaches you should look into are offloading static content, caching database queries, using asynchronous processing for long-running tasks, and deploying to multiple web servers.

CDNs offload the burden of serving static content—such as images and font files—to a third party. Using a CDN significantly improves the responsiveness of your site and reduces the load on your server. CDNs are easy to integrate, cost-efficient for most websites, and will significantly reduce the amount of network requests your web servers have to handle.

Once you offload static content, database access calls typically become the next bottleneck. Effective caching can prevent your database from becoming overloaded in the event of a traffic surge. Cached data can be stored on disk, in memory, or in a shared memory cache like Redis or Memcached. Even the browser can help with caching: setting a `Cache-Control` header on a resource (for example, an image) tells the browser to store a local copy of the resource and not request it again until a configurable future date.

Offloading long-running tasks to a job queue will help your web server respond quickly when traffic ramps up. This is an approach to web architecture that moves long-running jobs (such as generating large download files or sending email) to background worker processes. These workers are deployed separately from the web server, which creates the jobs and puts them on the queue. The workers take jobs off the queue and handle them one at a time, notifying the web server when the job is completed. Have a

<!-- Source S17, PDF page 6 -->

look at the Netflix technology blog (https://medium.com/@NetflixTechBlog/) for an example of a massively scalable system built on this type of principle.

Finally, you should have a deployment strategy that allows you to scale out the number of web servers relatively quickly, so you can ramp up your computing power during busy periods. An Infrastructure as a Service (IaaS) provider like Amazon Web Services (AWS) makes it easy to deploy the same server image multiple times behind a load balancer. Platforms like Heroku make it as simple as moving a slider on their web dashboard! Your hosting provider will have some method of monitoring traffic volume, and tools like Google Analytics can be used to track when and how many sessions are open on your site. Then you need only to increase the number of servers when monitoring thresholds are hit.

### Summary

Attackers use denial-of-service attacks to make a site unavailable to legitimate users by flooding it with a large volume of traffic. Denial-of-service attacks can happen at any layer of the network stack, and can be reflected or amplified by third-party services. Frequently, they are launched as a distributed attack from a botnet controlled by the attacker.

Simple denial-of-service attacks can be defused by sensible firewall settings. Application firewalls and intrusion prevention systems help protect you against more-sophisticated attacks. The most comprehensive (and hence most expensive) protection comes from distributed denial-of-service attack solution providers, which will filter out all bad traffic before it hits your network.

All types of denial-of-service attacks—including inadvertent ones, when you suddenly see a surge of new visitors—can be mitigated by building your site to scale well. Content delivery networks alleviate the burden of serving static content from your site, and effective caching prevents your database from being a bottleneck. Moving long-running processes to a job queue will keep your web servers running efficiently at full capacity. Active traffic monitoring, and the ability to easily scale up the number of web servers, will prepare you well for busy periods.

That concludes all the individual vulnerabilities you will be looking at in this book! The final chapter summarizes the major security principles covered over the course of the book and recaps the individual vulnerabilities and how to protect against them.
