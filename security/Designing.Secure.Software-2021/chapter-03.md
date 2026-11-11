# Chapter 3

![Figure 3-1: Chapter-opening artwork](/.attachments/3-1-Designing.Secure.Software-2021-3.png)

*Figure 3-1: Chapter-opening artwork*

<!-- Source: Designing.Secure.Software-2021-3.pdf, PDF page 1. -->

### Mitigation

>_Everything is possible to mitigate through art and diligence._

—Gaius Plinius Caecilius Secundus (Pliny the Younger)

This chapter focuses on the third of the Four Questions from Chapter 2: “What are we going to do about it?” Anticipating threats, then protecting against potential vulnerabilities, is how security thinking turns into effective action. This proactive response is called mitigation—reducing the severity, extent, or impact of problems—and as you saw in the previous chapter, it’s something we all do all the time. Bibs to catch the inevitable spills when feeding an infant, seat belts, speed limits, fire alarms, food safety practices, public health measures, and industrial safety regulations are just a few examples of mitigations. The common thread among these is that they take proactive measures to avoid, or lessen, anticipated harms in the face of risk. This is much of what we do to make software more secure.

<!-- Source S3, PDF page 2 -->

It’s important to bear in mind that mitigations reduce risk but don’t eliminate it. To be clear, if you can eliminate a risk somehow—say, by removing a legacy feature that is known to be insecure—by all means do that, but I would not call it a mitigation. Instead, mitigations focus on making attacks less likely, more difficult, or less harmful when they do occur. Even measures that make exploits more detectable are mitigations, analogous to tamper-evident packaging, if they lead to a faster response and remediation. Every small effort ratchets up the security of the system as a whole, and even modest wins can collectively add up to significantly better protection.

This chapter begins with a conceptual discussion of mitigation, and from there presents a number of general techniques. The focus here is on structural mitigations based on the perspective gained through threat modeling that can be useful for securing almost any system design. Subsequent chapters will build on these ideas to provide more detailed methods, drilling down into specific technologies and threats.

The rest of the chapter provides guidance for recurrent security challenges encountered in software design: instituting an access policy and access controls, designing interfaces, and protecting communications and storage. Together, these discussions form a playbook for addressing common security needs that will be fleshed out over the remainder of the book.

### Addressing Threats

Threat modeling reveals what can go wrong, and in doing so, focuses our security attention where it counts. But believing we can always eliminate vulnerabilities would be naive. Points of risk—critical events or decision thresholds—are great opportunities for mitigation.

As you learned in the previous chapter, you should always address the biggest threats first, limiting them as best you can. For systems that process sensitive personal information, as one example, the threat of unauthorized disclosure inevitably looms large. For this major risk, consider any or all of the following: minimizing access to the data, reducing the amount of information collected, actively deleting old data when no longer needed, auditing for early detection in the event of compromise, and taking measures to reduce an attacker’s ability to exfiltrate data. After securing the highest-priority risks, opportunistically mitigate lesser risks where it is easy to do so without adding much overhead or complexity to the design.

A good example of a smart mitigation is the best practice of checking the password submitted with each login attempt against a salted hash, instead of the actual password in plaintext. Protecting passwords is critical because disclosure threatens the fundamental authentication mechanism. Comparing hashes only requires slightly more work than comparing directly, yet it’s a big win as it eliminates the need to store plaintext passwords. This means that even if attackers somehow breach the system, they won’t learn actual passwords as easily.

<!-- Source S3, PDF page 3 -->

This example illustrates the idea of harm reduction but is quite specific to password checking. Now let’s consider mitigation strategies that are more widely applicable.

### Structural Mitigation Strategies

Mitigations often amount to common sense: reducing risk where there are opportunities to do so. Threat modeling helps us see potential vulnerabilities in terms of attack surfaces, trust boundaries, and assets (targets needing protection). Structural mitigations generally apply to these very features of the model, but their realization depends on the specifics of the design. The subsections that follow discuss techniques that should be widely applicable because they operate at the model level of abstraction.

### Minimize Attack Surfaces

Once you have identified the attack surfaces of a system, you know where exploits are most likely to originate, so anything you can do to harden the system’s “outer shell” will be a significant win. A good way to think about attack surface reduction is in terms of how much code and data are touched downstream of each point of entry. Systems that provide multiple interfaces to perform the same function may benefit from unifying these interfaces because that means less code that might contain vulnerabilities. Here are a few examples of this commonly used technique:

• In a client/server system, you can reduce the attack surface of the server by pushing functionality out to the client. Any operation that requires a server request represents an additional attack surface that a malformed request or forged credentials might be able to exploit. By contrast, if the necessary information and compute power exist on the client side, that reduces both the load on and the attack surface of the server. • Moving functionality from a publicly exposed API that anyone can invoke anonymously to an authenticated API can effectively reduce your attack surface. The added friction of account creation slows down attacks, and also helps trace attackers and enforce rate limiting. • Libraries and drivers that use kernel services can reduce the attack surface by minimizing interfaces to, and code within, the kernel. Not only are there fewer kernel transitions to attack that way, but userland code will be incapable of doing as much damage even if an attack is successful. • Deployment and operations offer many attack surface reduction opportunities. For an enterprise network, moving anything you can behind a firewall is an easy win. • A configuration setting that enables remote administration over the network is another good example: this feature may be convenient, but if it’s rarely used, consider disabling it and use wired access instead when necessary.

<!-- Source S3, PDF page 4 -->

These are just some of the most common scenarios where attack surface reduction works. For particular systems, you might find much more creative customized opportunities. Keep thinking of ways to reduce external access, minimize functionality and interfaces, and protect any services that are needlessly exposed. The better you understand where and how a feature is actually used, the more of these mitigations you’ll be able to find.

### Narrow Windows of Vulnerability

This mitigation technique is similar to attack surface reduction, but instead of metaphorical surface area, it reduces the effective time interval in which a vulnerability can occur. Also based on common sense, this is why hunters only disengage the safety just before firing and reengage it soon after.

We usually apply this mitigation to trust boundaries, where low-trust data or requests interact with high-trust code. To best isolate the high-trust code, minimize the processing that it needs to do. For example, when possible, perform error checking ahead of invoking the high-trust code so it can do its work and exit quickly.

Code Access Security (CAS), a security model that is rarely used today, is a perfect illustration of this mitigation because it provides fine-grained control over code’s effective privileges. (Full disclosure: I was the program manager for security in .NET Framework version 1.0, which prominently featured CAS as a major security feature.)

The CAS runtime grants different permissions to different units of code based on trust. The following pseudocode example illustrates a common idiom for a generic `permission`, which could grant access to certain files, to the clipboard, and so on. In effect, CAS ensures that high-trust code inherits the lower privileges of the code invoking it, but when necessary, it can temporarily assert its higher privileges. Here’s how such an assertion of privilege works:

```text
Worker(parameters) {
  // When invoked from a low-trust caller, privileges are reduced.
  DoSetup();
  permission.Assert();
  // Following assertion, the designated permission can now be used.
  DoWorkRequiringPrivilege();
  CodeAccessPermission.RevertAssert();
  // Reverting the assertion undoes its effect.
  DoCleanup();
}
```

The code in this example has powerful privileges, but it may be called by less-trusted code. When invoked by low-trust code, this code initially runs with the reduced privileges of the caller. Technically, the effective privileges are the intersection (that is, the minimum) of the privileges granted to the code, its caller, and its caller’s caller, and so on all the way up the stack. Some of what the `Worker` method does requires higher privileges than its callers may have, so after doing the setup, it asserts the necessary permission before invoking `DoWorkRequiringPrivilege`, which must also have

<!-- Source S3, PDF page 5 -->

that permission. Having done that portion of its work, it immediately drops the special permission by calling `RevertAssert`, before doing whatever is left that needs no special permissions and returning. In the CAS model, time window minimization provides for such assertions of privilege to be used when necessary and reverted as soon as they are no longer needed.

Consider this application of narrowing windows of vulnerability in a different way. Online banking offers convenience and speed, and mobile devices allow us to bank from anywhere. But storing your banking credentials in your phone is risky—you don’t want someone emptying out your bank account if you lose it, which is much more likely with a mobile device. A great mitigation that I would like to see implemented across the banking industry would be the ability to configure the privilege level you are comfortable with for each device. A cautious customer might restrict the mobile app to checking balances and a modest daily transaction dollar limit. The customer would then be able to bank by phone with confidence. Further useful limits might include windows of time, geolocation, domestic currency only, and so on. All of these mitigations help because they limit the worst-case scenario in the event of any kind of compromise.

### Minimize Data Exposure

Another structural mitigation to data disclosure risk is limiting the lifetime of sensitive data in memory. This is much like the preceding technique, but here you’re minimizing the duration for which sensitive data is accessible and potentially exposed instead of the duration for which code is running at high privilege. Recall that intraprocess access is hard to control, so the mere presence of data in memory puts it at risk. When the stakes are high, such as handling extremely sensitive data, you can think of it as “the meter is running.” For the most critical information—data such as private encryption keys, or authentication credentials such as passwords—it may be worth overwriting any in-memory copies as soon as they are no longer needed. This reduces the time during which a leak is conceivably possible through any means. As we shall see in Chapter 9, the Heartbleed vulnerability threatened security for much of the web, exposing all kinds of sensitive data lying around in memory. Limiting how long such data was retained probably would have been a useful mitigation (“stanching the blood flow,” if you will), even without foreknowledge of the exploit.

You can apply this technique to data storage design as well. When a user deletes their account in the system, that typically causes their data to be destroyed, but the system often offers a provision for a manual restore of the account in case of accidental or malicious closure. The easy way to implement this is to mark closed accounts as to-be-deleted but keep the data in place for, say, 30 days (after the manual restore period has passed) before the system finally deletes everything. To make this work, lots of code needs to check if the account is scheduled for deletion, lest it accidentally access the account data that the user directed to be destroyed. If a bulk mail job forgets to check, it could errantly send the user some notice that, to the user, would appear to be a violation of their intentions after they

<!-- Source S3, PDF page 6 -->

closed the account. This mitigation suggests a better option: after the user deletes the account, the system should push its contents to an offline backup and promptly delete the data. The rare case where a manual restore is needed can still be accomplished using the backup data, and now there is no way for a bug to possibly result in that kind of error.

Generally speaking, proactively wiping copies of data is an extreme measure that’s appropriate only for the most sensitive data, or important actions such as account closure. Some languages and libraries help do this automatically, and except where performance is a concern, a simple wrapper function can wipe the contents of memory clean before it is recycled.

### Access Policy and Access Controls

Standard operating system permissions provide very rudimentary file access controls. These control read (confidentiality) or write (integrity) access on an all-or-nothing basis for individual files based on the user and group ownership of a process. Given this functionality, it’s all too easy to think in the same limited terms when designing protections for assets and resources— but the right access policy might be more granular and depend on many other factors.

First, consider how ill-suited traditional access controls are for many modern systems. Web services and microservices are designed to work on behalf of principals that usually do not correspond to the process owner. In this case, one process services all authenticated requests, requiring permission to access all client data all the time. This means that in the presence of a vulnerability, all client data is potentially at risk.

Defining an efficacious access policy is an important mitigation, as it closes the gap between what accesses should be allowed and what access controls the system happens to offer. Rather than start with the available operating system access controls, think through the needs of the various principals acting through the system and define an ideal access policy that expresses an accurate description of what constitutes proper access. A granular access policy potentially offers a wealth of options: you can cap the number of accesses per minute or hour or day, or enforce a maximum data volume, time-based limits corresponding to working hours, or variable access limits based on activity by peers or historical rates (to name a few obvious mechanisms).

Determining safe access limitations is hard work but worthwhile because it helps you understand the application’s security requirements. Even if the policy is not fully implemented in code, it will at least provide guidance for effective auditing. Given the right set of controls, you can start with lenient restrictions to gauge what real usage looks like and then, over time, narrow the policy as you learn how the system is used in practice.

For example, consider a hypothetical system that serves a team of customer service agents. Agents need access to the records of any customer who might contact them, but they only interact with a limited number of customers on a given day. A reasonable access policy might limit each agent

<!-- Source S3, PDF page 7 -->

to no more than 100 different customer records in one shift. With access to all records all the time, a dishonest agent could leak a copy of all customer data, whereas the limited policy greatly limits the worst-case daily damage.

Once you have a fine-grained access policy, you face the challenge of setting the right limits. This can be difficult when you must avoid impeding rightful use in extreme edge cases. In the customer service example, for instance, you might restrict agents to accessing the records of up to 100 customers per shift as a way of accommodating seasonal peak demand, even though, on most days, needing even 50 records would be unusual. Why? It would be impractical to adjust the policy configuration throughout the year, and you want to allow for leeway so the limit never impedes work. Also, defining a more specific and detailed policy based on fixed dates might not work well, as there could be unexpected surges in activity at any time.

But is there a way to narrow the gap between normal circumstances and the rare highest-demand case that the system should allow? One great tool to handle this tricky situation is a policy provision for self-declared exceptions to be used in extraordinary circumstances. Such an option allows individual agents to bump up their own limits for a short period of time by providing a rationale. With this kind of “relief valve” in place, the basic access policy can be tightly constrained. When needed, once agents hit the access limit, they can file a quick notice—stating, for example, “high call volume today, I’m working late to finish up”—and receive additional access authorization. Such notices can be audited, and if they become commonplace, management could bump the policy up with the knowledge that demand has legitimately grown and an understanding of why. Such flexible techniques enable you to create access policies with softer limits, rather than hard-and-fast restrictions that tend to be arbitrary.

### Interfaces

Software designs consist of components that correspond to functional parts of the system. You can visualize these designs as block diagrams, with lines representing the connections between the parts. These connections denote interfaces, which are a major focus of security analysis—not only because they reveal data and control flows, but also because they serve as well-defined chokepoints where you can add mitigations. In particular, where there is a trust boundary, the main security focus is on the flow of data and control from the lower- to the higher-trust component, so that is where defensive measures are often needed.

In large systems, there are typically interfaces between networks, between processes, and within processes. Network interfaces provide the strongest isolation because it’s virtually certain that any interactions between the endpoints will occur over the wire, but with the other kinds of interfaces it’s more complicated. Operating systems provide strong isolation at process boundaries, so interprocess communication interfaces are nearly as trustworthy as network interfaces. In both of these cases, it’s generally impossible

<!-- Source S3, PDF page 8 -->

to go around these channels and interact in some other way. The attack surface is cleanly constrained, and hence this is where most of the important trust boundaries are. As a consequence, interprocess communication and network interfaces are the major focal points of threat modeling.

Interfaces also exist within processes, where interaction is relatively unconstrained. Well-written software can still create meaningful security boundaries within a process, but these are only effective if all the code plays together well and stays within the lines. From the attacker’s perspective, intraprocess boundaries are much easier to penetrate. However, since attackers may only gain a limited degree of control via a given vulnerability, any protection you can provide is better than none. By analogy, think of a robber who only has a few seconds to act: even a weak precaution might be enough to prevent a loss.

Any large software design faces the delicate task of structuring components to minimize regions of highly privileged access, as well as restricting sensitive information flow in order to reduce security risk. To the extent that the design restricts information access to a minimal set of components that are well isolated, attackers will have a much harder time getting access to sensitive data. By contrast, in weaker designs, all kinds of data flow all over the place, resulting in greater exposure from a vulnerability anywhere within the component. The architecture of interfaces is a major factor that determines the success systems have at protecting assets.

### Communication

Modern networked systems are so common that standalone computers, detached from any network, have become rare exceptions. The cloud computing model, combined with mobile connectivity, makes network access ubiquitous. As a result, communication is fundamental to almost every software system in use today, be it through internet connections, private networks, or peripheral connections via Bluetooth, USB, and the like.

In order to protect these communications, the channel must be physically secured against wiretapping and snooping, or else the data must be encrypted to ensure its integrity and confidentiality. Reliance on physical security is typically fragile in the sense that if attackers bypass it, they usually gain access to the full data flow, and such incursions are difficult to detect. Modern processors are fast enough that the computational overhead of encryption is usually acceptable, so there is rarely a good reason not to encrypt communications. I cover basic encryption in Chapter 5, and HTTPS for the web specifically in Chapter 11.

Even the best encryption is not a magic bullet, though. One remaining threat is that encryption cannot conceal the fact of communication. In other words, if attackers can read the raw data in the channel, even if they’re unable to decipher its contents, they can still see that data is being sent and received on the wire, and roughly estimate the amount of data flow. Furthermore, if attackers can tamper with the communication channel, they might be able to delay or block the transmission entirely.

<!-- Source S3, PDF page 9 -->

### Storage

The security of data storage is much like the security of communications, because storing data is analogous to sending it into the future, at which point you will retrieve it for some purpose. Viewed in this way, just as data that is being communicated is vulnerable on the wire, stored data is vulnerable at rest on the storage medium. Protecting data at rest from potential tampering or disclosure requires either physical security or encryption. Likewise, availability depends on the existence of backup copies or successful physical protection.

Storage is so ubiquitous in system designs that it’s easy to defer the details of data security for operations to deal with, but doing so misses good opportunities for proactively mitigating data loss in the design. For instance, data backup requirements are an important part of software designs, because the demands are by no means obvious, and there are many trade-offs. You could plan for redundant storage systems, designed to protect against data loss in the event of failure, but these can be expensive and incur performance costs. Your backups might be copies of the whole dataset, or they could be incremental, recording transactions that, cumulatively, can be used to rebuild an accurate copy. Either way, they should be reliably stored independently and with specific frequency, within acceptable limits of latency. Cloud architectures can provide redundant data replication in near real-time for perhaps the best continuous backup solution, but at a cost.

All data at rest, including backup copies, is at risk of exposure to unauthorized access, so you must physically secure or encrypt it for protection. The more backup copies you make, the greater the risk is of a leak due to having so many copies. Considering the potential extremes makes this point clear. Photographs are precious memories and irreplaceable pieces of every family’s history, so keeping multiple backup copies is wise—if you don’t have any copies and the original files are lost, damaged, or corrupted, the loss could be devastating. To guard against this, you might send copies of your family photos to as many relatives as possible for safekeeping. But this has a downside too, as it raises the chances that one of them might have the data stolen (via malware, or perhaps a stolen laptop). This could also be catastrophic, as these are private memories, and it would be a violation of privacy to see all those photos publicly spread all over the web (and potentially a greater threat if it allowed strangers to identify children in a way that could lead to exploitation). This is a fundamental trade-off that requires you to weigh the risks of data loss against the risk of leaks—you cannot minimize both at once, but you can balance these concerns to a degree in a few ways.

As a compromise between these threats, you could send your relatives encrypted photos. (This means they would not be able to view them, of course.) However, now you are responsible for keeping the key that you chose not to entrust them with, and if you lose the key, the encrypted copies are worthless.

Preserving photos also raises an important aspect of backing up data, which is the problem of media lifetime and obsolescence. Physical media

<!-- Source S3, PDF page 10 -->

(such as hard disks or DVDs) inevitably degrade over time, and support for legacy media fades away as new hardware evolves (this author recalls long ago personally moving data from dozens of floppy disks, which only antiquated computers can use, onto one USB memory stick, now copied to the cloud). Even if the media and devices still work, new software tends to drop support for older data formats. The choice of data format is thus important, with widely used open standards highly preferred, because proprietary formats must be reverse-engineered once they are officially retired. Over longer time spans, it might be necessary to convert file formats, as software standards evolve and application support for older formats becomes deprecated.

The examples mentioned throughout this chapter have been simplified for explanatory purposes, and while we’ve covered many techniques that can be used to mitigate identified threats, these are just the tip of the iceberg of possibilities. Adapt specific mitigations to the needs of each application, ideally by making them integral to the design. While this sounds simple, effective mitigations are challenging in practice because a panoply of threats must be considered in the context of each system, and you can only do so much. The next chapter presents major patterns with useful security properties, as well as anti-patterns to watch out for, that are useful in crafting these mitigations as part of secure design.
