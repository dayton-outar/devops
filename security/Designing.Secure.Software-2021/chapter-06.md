# Chapter 6

## Designing Secure Software-2021

Source: [Designing.Secure.Software-2021-6.pdf](Designing.Secure.Software-2021-6.pdf) — 14 PDF pages.

<!-- Source S6, PDF page 1 -->

### Secure Design

Overload, clutter, and confusion are not attributes of

information, they are failures of design.

—Edward Tufte

![Figure 6-1: Chapter-opening artwork](/.attachments/6-1-Designing.Secure.Software-2021-6.png)

*Figure 6-1: Chapter-opening artwork*

<!-- Source: Designing.Secure.Software-2021-6.pdf, PDF page 1. -->

Once you have a solid understanding of security principles, patterns, and mitigations, the practice of integrating security into your software designs becomes relatively straightforward. As you discern threats to your design, you can apply these tools as needed and explore better design alternatives that reduce risk organically.

This chapter focuses on secure software design. It serves as a companion to Chapter 7, which covers security design reviews. These two topics are aspects of the same activity, viewed from different perspectives. Software designers should be considering the concepts discussed in this chapter and applying these methods throughout the design process; they shouldn’t leave the system’s security for a reviewer to patch up later. In turn, reviewers should look at designs through the lens of threats and mitigations as an additional layer of security assessment. The secure design process is integrative, and the security design review is analytic—used synergistically, they produce better designs with security baked in.

<!-- Source S6, PDF page 2 -->

Software design is an art, and this chapter focuses on just the security aspect. Whether you design according to a formal process or do it all in your head, you don’t have to change how you work to incorporate the ideas presented here. Threat modeling and a security perspective do not need to drive design, but they should inform it.

The secure design practice described here follows a process typical of a large enterprise, but you can adapt these techniques to however you work. Smaller organizations will operate much more informally, and the designer and reviewer may be the same person. The techniques presented approach the problem in a general way so as to be easily applicable to however you like to do software design.

### Secure Design

Design is a creative process that’s not reducible to “how to” steps, so I wanted to provide a complete example of a design document to demonstrate how to apply the concepts presented in this book. The sample in Appendix A illustrates how to bake in security right from the start. It’s not intended to be a perfect example of masterful design, but rather a first draft of a work in progress with enough meat on its bones for you to get a feel for the end result. For brevity, parts of the design unimportant to our purposes are omitted and parts are presented unpolished, with some warts and rough spots, because most real designs are like that.

The sample design document envisions a logging tool designed to facilitate auditing while minimizing disclosure of private information, and the intention is that this might be a useful component to actually use. This kind of tool could be a practical mitigation in the context of a larger system processing sensitive data, and you’re welcome to flesh out the design and build it if you like. Regardless, I strongly recommend that you take a look at this example, as seeing how the guidance in this chapter actually materializes in a design document will help you better understand how secure design works.

### Integrating Security in Design

I will contend that conceptual integrity is the most important consideration in system design.

—Fred Brooks (from The Mythical Man-Month)

The design stage provides a golden opportunity for building security principles and patterns into a software project. During this early phase, you can easily explore alternatives before investing in an implementation and getting tied down by past decisions.

<!-- Source S6, PDF page 3 -->

In the design stage, developers should create design documents to capture the important high-level characteristics of a software project, analogous to architectural blueprint drawings for structures. I highly recommend investing effort into documenting your designs because it helps ensure rigor and also creates a valuable artifact that allows others to understand the decisions you’ve made—especially when it comes to balancing threats with mitigations and the trade-offs involved.

Design documents typically consist of a functional description (how the software works when viewed from the outside) and a technical specification (how it works when viewed from the inside). More formal designs are especially valuable when there are competing stakeholders, when coordinating a larger effort, when the designs must comply with a formal requirements specification or strict compatibility demands, when faced with difficult trade-offs, and so forth.

When you look at a prospective software design, put on your “security hat.” Then, before coding begins, you can threat model, identify attack surfaces, map out data flows, and more. If the proposed design makes securing the system structurally challenging, now is the perfect time to consider alternatives that would be inherently more secure. You should also point out important security mitigations in the design document so that implementers will see the need for these in advance.

More experienced designers will incorporate security into the design from the start. If this seems daunting, it’s fine to start with a “featurecomplete” draft design and make a second pass through it with a focus on security, but that’s a lot more work. Major changes are most easily made if caught earlier in the process, avoiding the wasted effort of redoing after the fact. Explore new architectures and play with basic requirements sooner rather than later, when it’s more easily done. As Josh Bloch once quipped: “A week of coding can often save an hour of thought.”

### Making Design Assumptions Explicit

In the mid-1980s, I worked for a company that designed and built what was then a powerful computer from the ground up: both the hardware and the software. After years of development, the work of both teams came together when the operating system was loaded into the prototype hardware at last. . . and immediately tanked. It turned out that the hardware team had largely come from IBM, where they use big-endian architecture, and the software team mostly came from HP, which traditionally used little-endian, so “bit 0” meant the high-order bit on the hardware but the low-order bit on the software. Throughout years of planning and meetings and prototyping, everybody had just assumed the endianness of the company culture they came from. (And of course, it was the software team that had to make the necessary changes once they figured this out.)

Unwritten assumptions can undermine the effectiveness of security design reviews, so designers should endeavor to document them (and reviewers should ask about anything that is unclear). A good place to capture these explicit assumptions is in a “background” section of the design document, preceding the body of the design itself.

<!-- Source S6, PDF page 4 -->

One way to think about documenting assumptions is to anticipate serious misunderstandings, so you never hear anyone say, “But I thought. . .” Here is a list of some common assumptions that are important to document, but easily omitted in designs:

• Budget, resource, and time constraints limiting the design space • Whether the system is likely to be a target of attack • Non-negotiable requirements, such as compatibility with legacy systems • Expectations about the level of security to which the system must perform • Sensitivity of data and the importance of protecting it securely • Anticipated needs for future changes to the system • Specific performance or efficiency benchmarks the system must achieve

Clarification of assumptions is important to security because misunderstandings are often the root cause of a weak interface design or mismatched interaction between components that attackers can exploit. In addition, it ensures that the design reviewer has a clear and consistent view of the project.

Often within an enterprise, or any set of related projects, many of these assumptions will remain the same across a set of designs, in which case you can compile a list in a shared document that provides common background. Individual designs then need only reference this common base and detail any exceptions where the applicable assumptions vary. For example, a billing system may be subject to higher security standards and need to conform with specific financial regulations for a credit card processing component than the rest of the enterprise applications.

### Defining the Scope

It’s impossible to do a good review of the security of a design if there is uncertainty about the scope of the review. Clarifying the scope is also vital to answering the first of the Four Questions from Chapter 2: “What are we working on?” To see why this is, consider the design for a new customer billing system. Does the design include the web app used for collecting reports of billable hours, or is that a separate design? What about the existing databases it relies on—is the security of those systems in scope or not? And should the review include the design of the new web-based API you’ll be using to report to the corporate accounting system?

Usually, the designer makes a strategic decision about how to define the scope, choosing how much to bite off. When it’s defined by others, the designer must understand the prescribed scope and the reasons for it. You can define the scope of the design as the code running in a process, specific components of a system represented in a block diagram, the code in a library, a division of a source repository, or whatever else makes the most sense, so long as it’s clear to everyone involved. The billing system design I mentioned in the previous paragraph probably should include the new API,

<!-- Source S6, PDF page 5 -->

since it’s an extension of the same design. Conversely, the existing databases are probably out of scope, provided they aren’t being used in a fundamentally new way and have already received sufficient security attention.

If the scope of a design is vague, the reviewer might assume some important aspect of security is out of scope, while the designer might be unaware of the issue. By omission, it could fall through the cracks. For example, nearly every software design will involve some storage of data. Unless the data is expendable, which is rare, maintaining good backups is an obvious mitigation to the possible loss of integrity due to various threats (both malicious and accidental). Designers often omit such self-evident points, but without a clear statement of design scope, everyone might assume someone else regularly performs backups for all storage in the production system, resulting in this task falling by the wayside—until the first instance of failure, when the lesson is learned all too painfully.

Don’t let excluding part of the design’s ecosystem from the scope result in it falling between the cracks. When you have inherited a legacy system, your first efforts to understand it should focus on its most sensitive parts, those most fundamental to security, or perhaps the most obvious target of attack. Then judiciously undertake reviews of additional parts of the system that constitute independent components until you have covered everything.

You can handle design iterations, sprints, and major revisions of existing systems by defining a narrow scope that corresponds to where redesign happens. Once you have carved out boundaries for the new design work, there are clear preconditions defined by the design that are outside that scope, and you are free to redo everything anew on the inside. Existing design documentation makes this work much easier and more reliable, and the updated design should drive tracked changes to the document.

It’s common, and often a good thing, for redesign to creep outside of its intended bounds, and when it does, you should adjust the scope as needed. For example, an incremental design change may require the modification of existing interfaces or data formats, and if the change involves handling more sensitive data, you may need to make changes on the other side of the interface due to the new security assumptions.

Few software designs exist in a vacuum; they depend on existing systems, processes, and components. Ensuring that the design works well with its dependencies is critical. In particular, matching security expectations is key, because you cannot build a secure application out of insecure components. And it’s important to note that secure/insecure is not a binary choice; it’s a continuum, where the assumptions and expectations need to align. Read up on security design review reports for peer systems and dependencies to substantiate your security expectations for them.

### Setting Security Requirements

Security requirements largely derive from the second of the Four Questions: “What can go wrong?” The C-I-A triad is a useful starting point: describe the need to protect private data from unauthorized disclosure (confidentiality), the importance of securing and backing up data (integrity), and the extent

<!-- Source S6, PDF page 6 -->

to which the system needs to be robust and reliable (availability). The security requirements of many software systems are straightforward, but it’s still well worth detailing them for completeness and to convey priorities. What may be entirely obvious to you may not be to others, so it’s a good idea to articulate the desired security stance.

One extreme to note is when security doesn’t matter—or at least, when someone thinks it doesn’t. That’s an important assumption to call out, because someone else on the team might be thinking that it certainly does matter (and you can imagine the circumstances under which such mismatched expectations will eventually come to light). If you are designing a prototype to process artificial dummy data, you can skip the security review, but document it so the code isn’t repurposed and used later with personal information. Another example of a low-security application might be the collection of weather data shared by several research groups: temperatures and other atmospheric conditions are free for anyone to measure, and disclosure is harmless.

At the other extreme, security-critical software deserves extra attention and a careful enumeration of its security-related requirements. These will provide a focus for threat modeling, security review, and testing to ensure the highest level of quality. See the sample design document (Appendix A) for a basic example of how security requirements inform the design. Large systems subject to complex regulations may have tightly prescribed security requirements to ensure high levels of compliance, but that’s a specialized undertaking, out of scope for our purposes.

For software designs with critical or unusual security requirements, consider the following general guidelines:

• Express security requirements as end goals without dictating “how to.” • Consider all stakeholder needs. In particular, where these may be in conflict, it will be necessary to find a good balance. • Acknowledge acceptable costs and trade-offs for critical mitigations. • When there are unusual requirements, explain the motivation for them as well as their goals. • Set security goals that are achievable, not mandates for perfection.

The following extreme examples illustrate what requirements statements for systems with significant security needs might look like:

At the National Security Agency, to protect the nation’s most sensitive secrets

System administrators will have extraordinary access to an enormous trove of top-secret documents, and given the threat to national security this represents, we must mitigate insider attacks to the highest degree possible. Specifically, an administrator capable of impersonating highranking officers with broad access authority could potentially exfiltrate many files, covering their tracks by making it look like numerous independent access events by many different principals. (Unofficial accounts of Edward Snowden’s tactics for exfiltrating NSA internal documents suggest that he used this sort of technique.)

<!-- Source S6, PDF page 7 -->

The authentication server for a large financial institution

Compromise of the server’s private encryption key would completely undermine the security of all our internet-facing systems. While insider attacks are unlikely, operations personnel must not have plausible deniability. Requirements might include storing the key in a tamper-evident hardware device kept in a physically guarded location, and formal ceremonies for the creation and rotation of keys, with all accesses attended by at least two trusted persons. (Note: this includes “how to” as the most direct way of illustrating distribution of trust and the combination of overlapping physical and logical security.)

Data integrity for an expensive scientific experiment

We plan to do this experiment only once, and the funding required for it will not likely be available again for years, so we cannot afford to lose the information our instruments collect. Streaming data must be instantly replicated and stored redundantly on different storage media, while simultaneously being communicated over two distinct networks to physically separated remote storage systems as additional backup.

### Threat Modeling

One of the best ways to improve the security of your software architecture is to incorporate threat modeling into the design process. Designing software involves creatively juggling competing requirements and strategies, iteratively deciding on some aspects of the system, and, at times, reversing course to progress toward a complete vision. Viewing the process through the lens of threat modeling can illuminate design trade-offs, so it has great potential to lead the designer in the right direction—but figuring out exactly how to achieve improved outcomes requires some trial and error.

First, there is the simplistic method for integrating threat modeling into software design. This involves concocting a series of potential designs, threat modeling each one in turn, scoring them by some kind of summary assessment, and then choosing the best one. In practice, these securityfocused assessments inform other important factors, including usability, performance, and development cost. But since the effort involved in producing multiple designs and then threat modeling each one individually is prohibitive, designers often need to intuit which trade-offs offer promising possibilities, then compare the design alternatives by analyzing their differences rather than reassessing each from scratch.

In the early stages of software system design, pay careful attention to trust boundaries and attack surfaces, as these are critical for establishing an architecture amenable to security. Data flows of sensitive information should, as much as possible, be kept away from the most exposed parts of the topology. For example, consider an application for traveling sales staff who need offline access to customer contact information in order to make sales calls on the road. Putting the entire customer database in each mobile device would represent a huge risk of exposure, yet arguably would

<!-- Source S6, PDF page 8 -->

be necessary if staff travel to remote locations without good connectivity. Threat modeling would highlight this risk, spurring you to evaluate alternatives. Perhaps only regional subsets of the database would suffice, dynamically updated as the reps change location or based on travel schedule; or, instead of supplying customer phone numbers, each salesperson might get a code for each customer that they can use together with a unique PIN to place calls via a forwarding service, so there is no need for them to have access to the phone numbers at all.

Designers should also consider the essential threat model of the software they are building as a kind of baseline from which to gauge alternative designs. By this I mean a model of the security risk inherent in the idealized design, no matter how it’s built. For example, if a client/server system is collecting personally identifiable information (PII) from the client, there is an unavoidable security risk of that information being exposed by the client, in transit, or on the server that processes the data. No design magic will make any of those risks disappear, though they often call for suitable mitigations.

When the inherent security risk is high, designers should consider alternatives whenever possible. Continuing with the PII example, is it really necessary to collect all (or any) of that information for all use cases? If not, then it may well be worth the effort of supporting subcases that avoid some of the information collection at the source.

Another way that an essential threat model guides design is by highlighting sources of additional risk that arise out of design decisions. An example of such an effect might be choosing to add a caching layer for sensitive data in an attempt to improve response time. The additional storing of data (potentially an asset that attackers would target) necessarily adds new risk, especially if the cache store is near an attack surface. This illustrates how changes to the design always modify the threat model—for better or for worse—and with an understanding of the security impact, designers can weigh the merits of alternatives wisely.

Good software design, in the end, depends on subjective judgments. These balance the various factors involved to find, if not the best, then at least a satisfactory result. As important as security is, it isn’t everything, so difficult decisions are inevitable. Over the years I have found that, as scary as it may be at times, it’s much more productive to remain open to discussions of compromise rather than declare security concerns preeminent.

When the costs of maximizing security are low, it’s easy to push for doing so—but this isn’t always the case. When compromise is necessary, here are some good strategies to keep in mind:

• Design for flexibility so that adding security protections later will be easy to do (that is, don’t paint yourself into an insecure corner). • If there are specific attacks that are of special concern, instrument the system to facilitate monitoring for instances of attempted abuse.

<!-- Source S6, PDF page 9 -->

• When usability conflicts with security, explore user interface alternatives. Also, prototype and measure usability under realistic situations; sometimes usability concerns are imaginary and do not manifest in practice. • Explain security risks with potential scenarios (derived from threat models) that illustrate major possible downsides of certain designs, and use these to demonstrate the cost of not implementing mitigations.

### Building in Mitigations

After you’ve defined the software system’s scope and security requirements, answering the first two of the Four Questions, it’s time to consider the third: “What are we going to do about it?” This question guides the designer to incorporate the needed protections and mitigations into the design. In the following subsections we will examine how to do this for interfaces and for data, two of the most common recurring themes in software design. The discussion and examples that follow only scratch the surface of possibilities for mitigations in design. All of the ideas in the preceding three chapters can be applied according to the needs of a particular design.

### Designing Interfaces

Interfaces define the boundaries of the system, delineating the limits of the design or of its constituent components. They may include system calls, libraries, networks (client/server or peer-to-peer), inter- and intraprocess APIs, shared data structures in common datastores, and more. Complex interfaces, such as secure communication protocols, often deserve their own design.

Define all interfaces within the scope of the design, making sure you have a clear understanding of the security responsibilities of the components that share it. Document whether inputs are reliably validated or should be treated as untrusted data. If there is a trust boundary, explain how to handle authentication and authorization for crossing it.

Interfaces to external components (those scoped outside of the design) should conform to the existing design specifications for those components. If no such information is available, either document your assumptions or consider defensive tactics to compensate for the uncertainty. For example, assume untrusted inputs if you cannot ascertain whether the input is being validated.

To design secure interfaces, begin with a solid description of how they work, including their necessary security properties (that is, C-I-A, Gold Standard, or privacy requirements). Reviewing the security of the interfaces amounts to verifying that they will function properly and remain robust against potential threats. Unless the designer is clear about the security

<!-- Source S6, PDF page 10 -->

requirements, the security reviewer (and developers using the interface later) will have to guess at the designer’s intentions, and there will be confusion if they either under- or overestimate the requirements.

Sometimes, you are stuck using existing components that weren’t designed with security in mind or are not sufficiently secure for your requirements—or you just don’t know how secure the components are. Flag this as an issue if you have no choice in the matter and, if possible, do research to find out what you can about the components’ security properties (this might include trying to attack a test mock-up). Another option in some cases is to wrap the interface to add security protection. For example, given a storage component that is vulnerable to data leaks, you could design an extra layer of software that provides encryption and decryption, ensuring that the component stores only encrypted data, which is harmless if disclosed.

### Designing Data Handling

Data handling is central to virtually all designs, so securing it is an important step. A good starting point for secure data handling is outlining your data protection goals. When a particular subset of data requires extra protection, make that explicit, and ensure it’s handled consistently throughout the design. For example, in an online shopping application, apply additional safeguards to credit card information.

Limit the need to move sensitive data around. This is a key opportunity to reduce your risk exposure in a significant way at the design level (see the “Least Information” pattern in Chapter 4) that often isn’t possible to do later in implementation. One way to reduce the need to pass data around is to associate it with an opaque identifier, then use the identifier as a handle that, when necessary, you can convert into the actual data. For example, as in the sample design in Appendix A, you can log transactions using such an identifier to keep customer details out of system logs. In the rare case that a log entry needs investigation, an auditor can look up those details.

Identify public information, or data otherwise exempt from any confidentiality requirement. This forms an important exception to data handling requirements, allowing you to relax protections where that makes sense. In applying such an approach, remember that data is context-sensitive, so public data paired with other information might well be sensitive. For example, the addresses of most businesses and the names of their chief executives are usually public information. However, exactly when named persons are on the premises should be kept private.

Always treat personal information as sensitive in the absence of an explicit decision otherwise, and only collect such data in the first place if there is a specific use for it. Storing sensitive data indefinitely creates an endless obligation to protect it. You can best avoid this by destroying disused information when possible (after a number of years of inactivity, for example). Designs should anticipate the need to eventually remove private data from the system when no longer needed and specify what conditions will trigger deletion, including of backup copies.

<!-- Source S6, PDF page 11 -->

### Integrating Privacy into Design

Failures to protect private information make headlines routinely. I believe that integrating information privacy considerations into software design is an important way companies can do better. Privacy issues concern the human implications of data protection, involving not only legal and regulatory issues, but also customer expectations and the potential impact of unauthorized disclosures. Getting this right requires special expertise and subjective judgment. But part of the problem hinges on granting third parties the authorization to use data, which requires allowing access. To that extent, good software design can institute controls to minimize missteps.

As a starting point, designers should be familiar with all applicable private policies and understand how these relate to the design. Ask questions and ideally get answers in writing from the privacy policy owner so that the requirements are clear. This includes any third-party privacy policy obligations that might apply to data acquired via partners. These privacy policies govern data collection, use, storage, and sharing, so if these activities happen within the design, the policy stipulations imply requirements. If the public-facing privacy policy is short on details, consider developing an internal version that describes necessary details.

Privacy lapses tend to happen when people or processes misinterpret the promises in the policy, or simply fail to consider them. Data security protections offer opportunities to build limitations into a design to ensure compliance. Start by considering clear promises the privacy policy makes, then ensure that the design enforces them if possible. For example, if the policy says, “We do not share your data,” then be wary of using a cloud storage service that makes sharing easy unless other provisions are in place to ensure that misconfigurations won’t expose the data.

Auditing is an important tool for privacy stewardship, if only to reliably document proper access to sensitive data. With careful monitoring of accesses, problematic access and use can be detected and remedied early. In the aftermath of a leak, if there is no record of who had access to the data in question, it’s very difficult to respond effectively.

Design explicit privacy protections wherever possible. In instances where you cannot make the judgment about privacy compliance, get the officer responsible for the privacy policy to sign off on the design. Some common techniques for integrating privacy in software design include:

• Identify the collection of new types of data, and ensure its privacy policy compliance. • Confirm that policy allows you to use the data for the purpose you intend. • If the design potentially enables unlimited data use, consider limiting access only to staff that are familiar with privacy policy constraints and how to audit for compliance. • If the policy limits the term of data retention, design a system that ensures timely deletion.

<!-- Source S6, PDF page 12 -->

• As the design evolves, if a field in a database becomes disused, consider deleting it in order to reduce the risk of disclosure. • Consider building in an approval process for data sharing to ensure the receiving parties have management approval.

### Planning for the Full Software Life Cycle

Too many software designs implicitly assume that the system will last forever, ignoring the reality that the lifetime of all software is finite. Many aspects of a system’s eventual lifetime—from its first release and deployment, through updates and maintenance, to its eventual decommissioning—have important security implications that are easily missed later on. As wonderful as any software design might be, whether it takes off or fizzles out, it will undergo changes as its environment evolves. The impacts of these changes are best anticipated during the design process and addressed then, or at least noted for posterity. Within an enterprise, many of these issues are generic, and a general treatment of them should cover most systems, with exceptions specified as needed in individual designs.

The end of a system’s life is difficult to imagine when the new design is being created, but most of the implications should be clear, and any design should at least consider the long-term disposition of data. Specific legal or business reasons may require you to retain data for a certain period of time, but you should destroy it when it is no longer needed, including backup copies. Some systems need to go through specific stages when approaching end of life, and good design can make this easy to get right by having suitable structure and configuration options in place from the start. For example, a purchasing system might stop accepting orders but need to continue providing data for payroll and record-keeping purposes for another year, then archive transaction records for long-term retention.

### Making Trade-offs

Balancing trade-offs when there are no easy choices requires a lot of engineering judgment, while weighing many other considerations. Implementing more security mitigations reduces risk, but only up to the point that complexity leads to more bugs overall—and you should always be wary of increased development effort with diminishing returns. This book will repeatedly advise designers to compromise between competing priorities, but this is easier said than done. This section covers some rules of thumb for striking these important balances.

Anticipate the worst-case scenario: How bad would it be if you were to fail to protect the confidentiality, integrity, or availability of a particular system asset? For each scenario there are degrees of catastrophe to consider: How much of the data could potentially be affected? At what point does a period of unavailability become a serious issue? Major mitigations usually limit the worst case; for example, hourly backups should ensure that at most

<!-- Source S6, PDF page 13 -->

one hour of transaction data is at risk of loss. Note that a loss of confidentiality in the worst case is particularly difficult to cap, because once data has been purloined, there usually is no conceivable way to undo the disclosure (the 2017 Equifax breach is a striking example).

Most design work happens within an enterprise or project community where the level of security needed is usually consistent across a wide range of projects. Where a particular design might deviate—requiring either a higher or lower level of security—that assumption is well worth calling out in the design preface. Some examples will clarify this important point. An online store website should consider setting a higher security bar for the software that handles credit card processing, which is an obvious target of attack and is subject to special requirements because of the enormous financial liability. On the flip side, a web design company might put up an entire website that showcases examples of its design; since this would be for informational purposes only and never collect actual end user data, securing it would reasonably be less important.

The design phase represents the best opportunity to strike the right balance between competing demands on software. To be frank, rarely if ever is security fully supported as a top priority when there are schedule deadlines, constraints of budget and headcount, legacy compatibility issues, and the usual lengthy list of features to deal with—which is to say, nearly always. Designers are in the best position to consider many alternatives, including radical ones, and make foundational changes that would be infeasible to attempt later on.

Striking the right balance between these idealized principles and the pragmatic demands of building a real-world system is at the heart of secure software design. Perfect security is never the goal, and there is a limit to the benefits of additional mitigations. Exactly where the sweet spot lies is never easy to determine, but software designs that make these trade-offs explicit have better chances of finding a sensible compromise.

### Design Simplicity

Simplicity is the ultimate sophistication.

—Leonardo da Vinci

Ironically, as the da Vinci quote suggests, it often takes considerable thought and effort to produce a simple design. Early astronomers developed all manner of complicated calculations for celestial mechanics until Copernicus simplified the model by making the Sun the central reference point instead of the Earth, which in turn allowed Newton to radically simplify the computations by inferring the laws of gravity. My favorite example of brilliant software design is the heart of the *nix operating system, much of which remains in use to this day. The quest to create a beautifully simple design, even if rarely achieved, often directly contributes to better security.

In software design, simplicity appears in many guises, but there are no easy formulations of how to discover the simplest, most elegant design. Several of the patterns discussed in Chapter 4 embrace simplicity, such

<!-- Source S6, PDF page 14 -->

as Economy of Design and Least Common Mechanism. Any time security depends on getting some complicated decision or mechanism just right, be wary: see if there is a simpler way of achieving the same ends.

When intricate functionality interacts with security mechanisms, the result often explodes with complexity. One study concluded that the 1979 failure at the Three Mile Island nuclear facility had no specific cause but was due to the immense complexity of the system, including its many redundant safety measures. Security can get in the way of what you are trying to do, and in turn, making it all secure gets trickier. The solution here is often to separate security from functionality and create a layered model, usually with security on the “outside” as a protective shell and all the functionality separately existing “inside.” However, when you design with a hard shell and “soft insides,” it becomes critical to enforce that separation. It’s relatively easy to design a secure moat around a castle, but in software, it’s easy to inadvertently open up a pathway to the inside that circumvents the outer protective layer.
