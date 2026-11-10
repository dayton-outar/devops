# Chapter 13

## Designing Secure Software-2021

Source: [Designing.Secure.Software-2021-13.pdf](Designing.Secure.Software-2021-13.pdf) — 12 PDF pages.

<!-- Source S13, PDF page 1 -->

### Secure Development Best Practices

### Secure Development Best Practices

They say that nobody is perfect. Then they tell you practice makes perfect. I wish they'd make up their minds.

—Winston Churchill

> [Decorative chapter-opening artwork placeholder — source S13, PDF page 1.]

So far in Part III, we have surveyed a collection of security vulnerabilities that arise in the development phase. In this chapter, we’ll focus on how aspects of the development process itself relate to security and can go wrong. We’ll begin by discussing code quality: the value of good code hygiene, thorough error and exception handling, documenting security properties, and the role of code reviews in promoting security. Second, we’ll look at dealing with dependencies: specifically, how they introduce vulnerabilities into systems. The third area we’ll cover is bug triage—a critical skill for balancing security against other exigencies. Finally, secure development depends on maintaining a secure working environment, so I provide some basic tips on what you need to do to avoid being compromised.

For practical reasons, the guidance that follows is generic. Readers should be able to apply it to their own development practices. Many other effective

<!-- Source S13, PDF page 2 -->

techniques are specific to programming languages, operating systems, and other particulars of a given system. For this reason, it’s important that you recognize the big patterns in the following discussion, but also be alert to additional security-related issues and opportunities that arise in your own work.

### Code Quality

Quality is always in style.

—Robert Genn

The earlier chapters in Part III explained many of the ways that vulnerabilities slip into code, but here I want to focus on the relationship of bugs in general to security. If you can raise the quality of your code, you’ll make it more secure in the long run, whether you recognize this or not. All vulnerabilities are bugs, so fewer bugs means fewer vulnerabilities and vulnerability chains. But of course, diminishing returns kick in long before you eliminate all bugs, so it’s best to take a balanced approach.

The following discussion covers some of the key areas to focus on in the name of security.

### Code Hygiene

Programmers usually have a good sense of the quality of the code they’re working with, but for various reasons, they often choose to accept known flaws instead of making needed improvements. Code smells, spaghetti code, and postponed “TODO” comments that mark further work needed all tend to be fertile ground for vulnerabilities. At least in areas where security is of special concern, identifying and smoothing out these rough edges can be one of the best ways to avoid vulnerabilities without needing to do any security analysis in order to see how bugs may be exploitable.

In addition to your native sense of the condition of the code, use tools to flag these issues. Compile your code with full warnings and then fix the code to resolve significant issues. Some of these automated warnings, such as misleading indentation or unused code for which there is no execution path, would have identified the GotoFail vulnerability we talked about in Chapter 8, and security tested in Chapter 12. Lint and other static code analysis tools offer even richer scrutiny of the code, providing tips that sometimes reveal bugs and vulnerabilities.

Code analysis doesn’t always identify security bugs as such, so you’ll have to cast a broader net. Use these tools frequently during development to lower the overall number of potential bugs. This way, if a tool’s output changes significantly you’ll have a better chance of noticing it, because the new content won’t get lost in a torrent of older messages.

Fix all warnings if it’s easy to do so, or when you see that an issue could be serious. For example, unreachable code suggests that although somebody wrote the code for a reason, it’s now out of the picture, and that can’t be right. On the other hand, warnings about variable naming conventions, while being good suggestions, probably won’t relate to any security vulnerability.

<!-- Source S13, PDF page 3 -->

Finding time to do this kind of cleanup is always challenging. Take an incremental approach; even an hour or two a week will make a big difference over time, and the process is a good way to become familiar with a big codebase. If all the warnings are too much to deal with, start with the most promising ones (for example, GCC’s `-Wmisleading-indentation`), then fix what gets flagged.

### Exception and Error Handling

The 1996 Ariane 5 Flight 501 Failure Report painfully details the consequences of poor exception handling. While the calamitous bug was purely self-inflicted, involving no malicious actor, it stands as an example of how an attacker might exploit the resulting behavior to compromise a system.

Soon after the Ariane 5 spacecraft’s launch, a floating point to integer conversion in a calculation caused an exception. An exception-handling mechanism triggered, but as the conversion error was unanticipated, the exception handler code had no contingency for the situation. The code shut down the engine, resulting in catastrophic failure after 36.7 seconds of flight.

Defending against such problems begins with recognizing the risks of slapdash exception handling and then thinking through the right response for even the most unlikely exceptions. Generally speaking, it’s best to handle exceptions as close to the source as possible, where there is the most context for it and the shortest window of time for further complications to arise.

That said, large systems may need a top-level handler to field any unhandled exceptions that bubble up. One good way to do this is to identify a unit of action and fail that in its entirety. For example, a web server might catch exceptions during an HTTP request and return a generic 500 (server error) response. Typically, web applications should handle state-changing requests as transactions so that any error always results in no state change. This avoids partial changes that may leave the system in a fragile state.

Much of the reasoning that connects sloppy exception handling to potential vulnerabilities also applies to error handling in general. Like exceptions, error cases may occur infrequently, so it’s easy for developers to forget them, leaving them incomplete or untested. A common trick attackers use to discover exploits is to try causing some kind of error and then observe what the code does in hopes of discovering weaknesses. Therefore, the best defense is to implement solid error handling from the start. This is a classic example of one way that security vulnerabilities are different from other bugs: in normal use, some error might be exceedingly rare, but in the context of a concerted attack, invoking an error might be an explicit goal.

Solid testing is important in order to get error and exception handling right. Ensure that there is test coverage on all code paths, especially the less common ones. Monitor logs of exceptions in production and track down their causes to make sure that exception recovery works correctly. Aggressively investigate and fix intermittent exceptions, because if a smart attacker learns how to trigger one, they may be able to fine-tune it into a malicious exploit from there.

<!-- Source S13, PDF page 4 -->

### Documenting Security

When you’re writing code with important security consequences, how much do you need to explain your decisions in comments, so others (or your own forgetful self, months or years later) don’t accidentally break it?

For critical code, or wherever the security implications deserve explanation, commenting is important, as it allows anyone who is contemplating changing the code to understand the stakes. When you write comments about security, explain the security implications and be specific: simply writing `// Beware: security consequences` isn’t an explanation. Be clear and stick to the point: include too much verbiage and people will either tune it out or give up. Recalling the Heartbleed bug we discussed in Chapter 9, and security tested in Chapter 12, a good comment would explain that rejecting invalid requests with byte counts exceeding the actual data provided is crucial because it could result in disclosing private data beyond the extent of the buffer. If the security analysis becomes too complex to explain in the comments, write up the details in a separate document, then provide a reference to that document.

This does not mean that you should attempt to flag all code that security depends on. Instead, aim to warn readers about the less-than-obvious issues that might be easily overlooked in the future. Ultimately, comments cannot fully substitute for knowledgeable coders who are constantly vigilant of security implications, which is why this stuff is not easy.

Writing a good security test case (as discussed in Chapter 12) is an ideal way to back up the documentation with a mechanism to prevent others from unwittingly breaking security with future changes. As a working mock-up of what an attack looks like, such a test not only guards against accidental adverse changes, but also serves to show exactly how the code might go wrong.

### Security Code Reviews

The professional software development process includes peer code reviews as standard practice, and I want to make the case for explicitly including security in those reviews. Usually this is best done as one step within the code review workflow, along with the checklist of potential issues that reviewers should be on the lookout for, including code correctness, readability, style, and so forth.

I recommend that the same code reviewer add an explicit step to consider security, typically after a first pass reading the code, going through it again with their “security hat” on. If the reviewer doesn’t feel up to covering security, they should delegate that part to someone capable. Of course, you can skip this step for code changes that are clearly without security implications.

Reviewing code changes for security differs from an SDR (the topic of Chapter 7) in that you are looking at a narrow subset of the system without the big-picture view you get when reviewing a whole design. Be sure you consider how the code handles a range of untrusted inputs, check that any input validation is robust, and avoid potential Confused Deputy problems. Naturally, code that is crucial to security should get extra attention, and usually merits a higher threshold of quality. The opportunity to focus an

<!-- Source S13, PDF page 5 -->

extra pair of eyes on the security of the code has great potential for improving the system as a whole.

Code reviews are also an excellent opportunity to ensure that the security test cases that have been created (as described in Chapter 12) are sufficient. As a reviewer, if you hypothesize that certain inputs might be problematic, write a security test case and see what happens, rather than guessing. Should your exploratory test case reveal a vulnerability, raise the issue and also contribute the test case to ensure it gets fixed.

### Dependencies

Dependence leads to subservience.

—Thomas Jefferson

Modern systems tend to build on large stacks of external components. These dependencies are problematic in more ways than one. Many platforms, such as `npm`, automatically pull in numerous dependencies that are difficult to track. And using old versions of external code with known vulnerabilities is one of the biggest ongoing threats the industry has yet to systematically eliminate. In addition, there is risk of picking up malicious components in your software supply chain. This can happen in several ways; for example, packages created with similar names to well-known ones may get selected by mistake, and you can get malware indirectly via other components through their dependencies.

Adding components to a system can potentially harm security even if those components are intended to strengthen it. You must trust not only the component’s source, but everything the source trusts as well. In addition to the inevitable risks of extra code that adds bugs and overall complexity, components can expand the attack surface in unexpected new ways. Binary distributions are virtually opaque, but even with source code and documentation, it’s often infeasible to carefully review and understand everything you get inside the package, so it often boils down to blind trust. Antivirus software can detect and block malware, but it also uses pervasive hooks that go deep into the system, needs superuser access, and potentially increases the attack surface, such as when it phones home to get the latest database of malware and report findings. The ill-advised choice of a vulnerable component can end up degrading security, even if your intention was to add an extra layer of defense.

### Choosing Secure Components

For the system as a whole to be secure, each of its components must be secure. In addition, the interfaces between them must be secure. Here are some basic factors to consider when choosing secure components:

• What is the security track record of the component in question, and of its maker? • Is the component’s interface proprietary, or are there compatible alternatives? (More choices may provide more secure alternatives.)

<!-- Source S13, PDF page 6 -->

• When (not if) security vulnerabilities are found in the component, are you confident its developers will respond quickly and release a fix? • What are the operational costs (in other words, effort, downtime, and expenses) of keeping the component up to date?

It’s important to select components with a security perspective in mind. A component used to process private data should provide guarantees against information disclosure. If, as a side effect of processing data, it will be logging the content or storing it in unsecured storage, that constitutes a potential leak. Don’t repurpose software written to handle, say, ocean temperatures, which have no privacy concerns at all, for use with sensitive medical data. Also avoid prototype components, or anything other than high-quality production releases.

### Securing Interfaces

A well-documented interface should explicitly specify its security and privacy properties, but in practice this often doesn’t happen. In the interest of efficiency, it’s easy for programmers to omit input validation, especially when they assume that validation will have already been handled. On the other hand, making every interface perform redundant input validation is indeed wasteful. When unsure, test to find out how the interface behaves if you can, and if still in doubt, add a layer of input validation in front of the interface for good measure.

Avoid using deprecated APIs, because they often mask potential security issues. API makers commonly deprecate, rather than entirely remove, APIs that include insecure features. This discourages others from using the vulnerable code while maintaining backward compatibility for existing API consumers. Of course, deprecation happens for other reasons as well, but as an API consumer, it’s important to investigate whether the reason for the deprecation has security implications. Remember that attackers may be tracking API deprecations as well, and may be readying an attack.

Beyond these basic examples, take extra care whenever an interface exposes its internals, because these often get used in unintended ways that can easily create vulnerabilities. Consider “The Most Dangerous Code in the World” (Georgiev et al., 2012), a great case study of a widely used SSL library that researchers found was repeatedly used unsafely, completely undermining the security properties it was meant to provide. The authors found that “the root cause of most of these vulnerabilities is the terrible design of the APIs to the underlying SSL libraries.”

Also be wary of APIs with complicated configuration options, particularly if security depends on them. When designing your own APIs, honor the Secure by Default pattern, document how to securely configure your system, and where appropriate provide a helper method that ensures proper configuration. When you must expose potentially insecure functionality, do everything possible to ensure that nobody can plausibly use it without knowing exactly what they are doing.

<!-- Source S13, PDF page 7 -->

### Don’t Reinvent Security Wheels

Use a standard, high-quality library for your basic security functionality when possible. Every time someone attempts to mitigate, say, an XSS attack in query parameters from scratch, they risk missing an obscure form of attack, even if they know HTML syntax inside out.

If a good solution isn’t available, consider creating a library for use throughout your codebase to address a particular potential flaw, and be sure to test it thoroughly. In some cases, automated tools can help find specific flaws in code that often become vulnerabilities. For example, scan C code for the older “unsafe” string functions (such as `strcpy`) and replace them with the newer “safe” versions (`strlcpy`) of the same functionality.

If you are writing a library or framework, look carefully for security foibles so they get handled properly, once and for all. Then follow through and explicitly document what protections are and aren’t provided. It isn’t helpful to just advertise: “Use this library and your security worries will all be solved.” If I am relying on your code, how do I know what exactly is or is not being handled? For example, a web framework should describe how it uses cookies to manage sessions, prevents XSS, provides nonces for CSRF, uses HTTPS exclusively, and so forth.

While it may feel like putting all your eggs in one basket, solving a potential security problem once with a library or framework is usually best. The consistent use of such a layer provides a natural bottleneck, addressing all instances of the potential problem. When you find a new vulnerability later, you can make a single change to the common code, which is easy to fix and test and should catch all usages.

Security-aware libraries must sometimes provide raw access to underlying features that cannot be fully protected. For example, an HTML framework template might let applications inject arbitrary HTML. When this is necessary, thoroughly document wherever the usual protections cease to apply, and explain the responsibilities of the API users. Ideally, name the API in a way that provides an unmistakable hint about the risk, such as `unsafe_raw_html`.

The bottom line is that security vulnerabilities can be subtle, possible attacks are many, and it only takes one to succeed—so it’s wise to avoid tackling such challenges on your own. For the same reasons, once someone has successfully solved a problem, it’s smart to reuse that as a general solution. Human error is the attacker’s friend, so using solutions that make it easy to do things the secure way is best.

### Contending with Legacy Security

Digital technology evolves quickly, but security tools tend to lag behind for a number of reasons. This represents an important ongoing challenge. Like the proverbial frog in hot water, legacy security methods often remain in use for far too long unless someone takes a hard look at them, explicitly points out the risk, and proposes a more secure solution and a transition plan.

<!-- Source S13, PDF page 8 -->

To be clear, I’m not saying that existing security methods are necessarily weak, just that almost everything has a “best before” date. Plus, we need to periodically re-evaluate existing systems in the context of the evolving threat landscape. Password-based authentication may need shoring up with a second factor if it becomes susceptible to phishing attacks. Crypto implementations are based on modern hardware cost and capability assessments, and as Moore’s law tells us, this is a moving target; as quantum computing matures, high-security systems are already moving on to postquantum algorithms thought to be resistant to the new technology.

Weak security often persists well past its expiration date for a few reasons. First, inertia is a powerful force. Since systems typically evolve by increments, nobody questions the way authentication or authorization is currently done. Second, enterprise security architecture typically requires all subsystems to be compatible, so any changes will mean modifying every component to interoperate in a new way. That often feels like a huge job and thus raises powerful resistance.

Also, older subcomponents can be problematic, as legacy hardware or software may not support more modern security technologies. In addition, there is the easy counterargument that the current security has worked so far, so there’s no need to fix what isn’t broken. On top of all this, whoever designed the legacy security may no longer be around, and nobody else may fully understand it. Or, if the original designer is around, they may be defensive of their work.

No simple answer can address all of these concerns, but threat modeling may identify specific issues with weak legacy security that should make the risk it represents evident.

Once you’ve identified the need to phase out the legacy code, you need to plan the change. Integrating a new component with a compatible interface into the codebase makes the job easier, but sometimes this isn’t possible. In some cases, a good approach is to implement better security incrementally: parts of the system can convert to the new implementation piecewise, until you can remove legacy code when it is no longer needed.

### Vulnerability Triage

The term “triage” normally means deciding who gets attention first.

—Bill Dedman

Most security issues, once identified, are straightforward to fix, and your team will easily reach consensus on how to do so. Occasionally, however, differences of opinion about security issues do happen, particularly in the middle ground where the exploitability of a bug is unclear or the fix is difficult. Unless there are significant constraints that compel expediency, it’s generally wise to fix any bug if there is any chance that it might be vulnerable to exploit. Bear in mind how vulnerability chains can arise when several minor bugs combine to create major vulnerabilities, as we saw in Chapter 8. And always remember that just because you can’t see how to exploit a bug, that by no means proves that a determined attacker won’t.

<!-- Source S13, PDF page 9 -->

### DREAD Assessments

In the rare case that your team does not quickly reach consensus on fixing a bug, make a structured assessment of the risk it represents. The DREAD model, originally conceived by Jason Taylor and evangelized by both of us at Microsoft, is a simple tool for evaluating the risk of a specific threat. DREAD enumerates five aspects of the risk that a vulnerability exposes:

Damage potential

If exploited, how harmful could it be?

Reproducibility

Will attacks succeed every time, some of the time, or only rarely?

Exploitability

How hard, in terms of technical difficulty, effort, and cost, is the vulnerability to exploit? How long is the attack path?

Affected users

Will all, some, or only a few users be impacted? Can specific targets be easily attacked, or are the victims arbitrary?

Discoverability

How likely is it that attackers will find the vulnerability?

In my experience, it works best to think of DREAD ratings in terms of five independent dimensions. Personally, I do not recommend assigning a numerical score to each, because severity is not very linear. My preferred method is to use T-shirt sizes (S, M, L, XL) to represent subjective magnitudes, as the following example illustrates. If you do use numerical scores, I would specifically discourage adding up the five scores to get a total to use for ranking one threat against another, as this is essentially comparing apples to oranges. Unless several of the factors have fairly low DREAD scores, consider the threat a significant one likely worth mitigating.

If the issue requires a triage meeting to resolve, use DREAD to present your case. Discuss the individual factors as needed to get a clear view of the consequences of the vulnerability. Often, when one component scores low, the debate will focus on what that means to the overall impact.

Let’s see how DREAD works in practice. Pretend we’ve just discovered the Heartbleed bug and want to make a DREAD rating for it. Recall that this vulnerability lets anonymous attackers send malicious Heartbeat requests and receive back large chunks of the web server’s memory.

Here is a quick DREAD scoring of the information leakage threat:

Damage potential: XL

Internal memory of the server potentially discloses secret keys.

Reproducibility: M

Leaked memory contents will vary due to many factors and will be innocuous in some cases, but unpredictable.

<!-- Source S13, PDF page 10 -->

Exploitability: L

An anonymous attacker needs only send a simple request packet; extracting useful secrets takes a little expertise and then some luck.

Affected users: XL

The server and all users are at risk.

Discoverability: L

It depends on whether the idea occurs to an attacker (obvious once publicly announced); it’s easily tried and confirmed.

This DREAD rating is subjective because in our scenario, there has not been time to investigate the vulnerability much beyond a quick confirmation of the bug. Suppose that we have seen a server key disclosed (hence, Damage potential is XL), but that in repeated tests the memory contents varied greatly, suggesting the M Reproducibility rating. Discoverability is particularly tricky: How do you measure the likelihood of someone thinking to even try this? I would argue that if you’ve thought of this, then it’s best to assume others will too before long.

Discussions of DREAD scores are a great way to tease out the nuances of these judgments. When you get into a discussion, listen carefully and give due consideration to other opinions. Heartbleed is among the worst vulnerabilities in history, yet we didn’t rate all of its DREAD factors at the maximum, serving as a good demonstration of why ratings must be carefully interpreted. Since this flaw occurred in code running on millions of web servers and undermined the security of HTTPS, you could say that the Damage potential and Affected users scores were actually off the charts (say, XXXXXXXL), more than making up for the few moderate ratings. The value of DREAD ratings is in revealing the relative importance of different aspects of a vulnerability, providing a clear view of the risk it represents.

### Crafting Working Exploits

Constructing a working proof-of-concept attack is the strongest way to make the case to fix a vulnerability. For some bugs the attack is obvious, and when it’s easy to code up the exploit, that seals the deal. However, in my opinion this is rarely necessary, for a couple of reasons. For starters, crafting a demonstration exploit usually involves a lot of work. Actual working exploits often require a lot of refinement after you’ve identified the underlying vulnerability. More importantly, even if you are an experienced penetration tester, just because you fail to create a functional exploit, that is by no means proof that the vulnerability is not exploitable.

This is a controversial topic, but my take is that for all these reasons it’s difficult to justify the effort of creating a working exploit for the purpose of addressing a security vulnerability. That said, by all means write a regression test (as discussed in Chapter 12) that will trigger the bug directly, even if it isn’t a full-fledged working attack.

<!-- Source S13, PDF page 11 -->

### Making Triage Decisions

When using DREAD, or doing any vulnerability assessment for that matter, bear in mind that it’s far easier to underestimate, rather than overestimate, actual threats. Noticing a potential vulnerability and taking no action can be a tragic mistake, and one that’s obviously best avoided. I’ve lost a few of those battles and can assure you that there is no satisfaction in saying “I told you so” after the fact. Failing to fix significant flaws is a Russian roulette game not worth playing: “just fix it” is a great standing policy.

Here are some general rules of thumb for making better security triage decisions:

• Bugs in privileged code, or code that accesses valuable assets, should be fixed and then carefully tested to guard against the introduction of new bugs. • Bugs that are well isolated from any attack surface and seem harmless are usually safe to defer. • Carefully confirm claims that a bug is harmless: it may be easier to fix the bug than to accurately assess its full potential impact. • Aggressively fix bugs that could be part of vulnerability chains (discussed in Chapter 8). • Finally, when it’s a toss-up, I always advise fixing the issue: better safe than sorry.

When more research is needed, assign someone to investigate the issue and report back with a proposal; don’t waste time debating hypotheticals. In discussions, focus on understanding other perspectives rather than trying to change minds. Trust your intuition. With practice, when you know what to focus on, this will quickly become easier.

### Maintaining a Secure Development Environment

The secret of landscapes isn’t creation. . . .It’s maintenance.

—Michael Dolan

Good hygiene is a useful analogy: to produce a safe food product, manufacturers need fresh ingredients from trustworthy suppliers, a sanitary working environment, sterilized tools, and so forth. Similarly, good security practices must be observed throughout the entire development process for the resulting product to be secure.

Malicious code can slip into the product due to even a one-time lapse during development, a fact which should give you pause. The last thing that developers want is for their software to become a vector for malware.

### Separating Development from Production

Strictly separate your development and production environments, if you aren’t doing this already. The core idea is to provide a “wall” between the two, typically consisting of separate subnetworks, or at least mutually exclusive access permission regimes. That is, when developing software, the programmer

<!-- Source S13, PDF page 12 -->

should not have access to production data. Nor should production machines and operations staff have access to the development environment and source code (write access). In smaller shops, where one person handles both production and development, you can switch between user accounts. The inconvenience of switching is more than compensated for by saving the product from even a single mistake. Plus, it provides peace of mind.

### Securing Development Tools

Carefully vet development tools and library code before installing and using them. Some minor utility downloaded from “somewhere,” even for a one-time use, could bring more trouble than it’s worth. Consider setting up a safely isolated sandbox for experiments or odd jobs not part of the core development process. This is easily done with a virtual machine.

All computers involved in development must be secure if the result is to be secure. So must all source code repositories and other services, as these are all potential openings for vulnerabilities to creep into the final product. In fact, it goes deeper: all operating systems, compilers, and libraries involved in the process of development must also be secure. It’s a daunting challenge, and it may sound almost impossible, but fortunately perfection is not the goal. You must recognize these risks first, then find opportunities to make incremental improvements.

The best way to mitigate these risks is by threat modeling the development environment and processes. Analyze the attack surface for a range of threats, treating the source code as your primary asset. Basic mitigations for typical development work include:

• Securely configure and regularly update development computers. • Restrict personal use of computers used for development. • Systematically review new components and dependencies. • Securely administer computers used for the build and release processes. • Securely manage secrets (such as code signing keys). • Secure login credential management with strong authentication. • Regularly audit source change commits for anomalous activity. • Keep secure backup copies of source code and the build environment.

### Releasing the Product

Use a formal release process to bridge development and production. This can happen through a shared repository that only development staff can modify, and that operations staff can only read. This Separation of Duty ensures that the responsibilities of the respective parties are not only clear but enforced, essentially rendering impossible solo “cowboy” efforts to make quick code changes and then push the new version into production, where security flaws are easily introduced, without going through approved channels.

### Secure Development Best Practices
