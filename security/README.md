# Security

Cybersecurity is a vast and evolving field dedicated to protecting information systems, networks, and data from unauthorized access, damage, or disruption. As digital transformation touches every aspect of society, the scope of cybersecurity has expanded to encompass a wide range of areas, including data protection, network security, and system integrity.

**Core Areas of Cybersecurity**  
At its foundation, cybersecurity focuses on safeguarding confidentiality, integrity, and availability (CIA) of data and systems. It includes protecting against external attacks like hacking, malware, or phishing, as well as insider threats, where employees may inadvertently or maliciously compromise security. Encryption, authentication, and access control are fundamental techniques used to secure sensitive data.

**Critical Infrastructure and Industries**  
Cybersecurity plays a critical role in protecting national infrastructure—such as energy grids, healthcare systems, transportation, and finance. The rise of Industrial Control Systems (ICS) and Internet of Things (IoT) devices means that more sectors are vulnerable to cyberattacks. Securing these interconnected systems is vital to preventing large-scale disruptions, particularly in sectors like banking, healthcare, and manufacturing, where the stakes are exceptionally high.

**Emerging Threats and Challenges**  
The growing sophistication of cyber threats—including advanced persistent threats (APTs), ransomware, and state-sponsored cyber warfare—requires constant innovation in defense mechanisms. The introduction of artificial intelligence (AI) and machine learning (ML) into both attacks and defense strategies has added complexity, as cybersecurity professionals must not only fend off human attackers but also increasingly automated, AI-driven systems.

**Governance, Compliance, and Ethics**  
Cybersecurity also involves regulatory and compliance aspects. Many industries must adhere to data protection laws such as the GDPR in Europe or HIPAA in healthcare, which mandate strict guidelines on how organizations handle personal data. As privacy becomes a global concern, ethical considerations around surveillance, data ownership, and user rights are shaping cybersecurity policies and strategies.

**Workforce and Skills**  
With the global shift to digital, the demand for cybersecurity professionals has surged, but there is a skills gap. Organizations require not only technical experts but also those versed in legal, ethical, and policy-related aspects of cybersecurity.

In essence, cybersecurity is a multidisciplinary field that now touches almost every aspect of modern life. Its scope will only continue to grow as technology evolves and new risks emerge.

## Web Security Checklist

Some of the major items to be diligent in addressing involves,
   - **HTTPS**: Ensure that the entire app uses HTTPS.
   - **CORS**: Configure CORS properly (if API and frontend are hosted separately).
   - **Content Security Policy (CSP)**: Set a strong CSP header to prevent XSS.
   - **Rate Limiting**: Use rate-limiting on authentication endpoints.
   - **Brute-Force Protection**: Implement account lockout after several failed sign-in attempts.
   - **SQL Injection Protection**: Use ORM (Doctrine, Prisma, etc.) to prevent SQL injection.
   - **Input Validation**: Validate all input fields, especially for forms (use `zod`, Yup, etc.).
   - **CSRF Protection**: Use anti-CSRF tokens for state-changing requests.

See below the web security checklist,

- [ ] Sanitize all url and query string parameters
- [ ] Sanitize all form inputs
- [ ] Remove all token cookies upon authentication
- [ ] Reset all token cookies upon authentication
- [ ] Remove all token cookies upon signing out
- [ ] Should administrative portal be publicly accessible?
- [ ] Restrict access to unauthorized resources
- [ ] Track changes
- [ ] Track important user events
- [ ] Is multi-factor authentication needed?
- [ ] Reset token cookies (or session id) after password change
- [ ] Reset token cookies (or session id) after profile change
- [ ] Reset token cookies (or session id) after permission set change
- [ ] Secure cookies for HTTP Only to secure token from client tampering
- [ ] Limit server information in HTTP responses
- [ ] Prevent directory structure exposure
- [ ] Invalidate cache after signing out. Set headers to prevent caching (Cache-Control: no-cache, private)
- [ ] Force HTTP to HTTPS in browsers (HTTP Strict Transport Security)

Before releasing an application into production, ensuring its security is critical to protect users, the organisation, and data integrity. Penetration testing (pen-testing) is a vital part of this process, simulating real-world attacks to identify vulnerabilities that could be exploited by malicious actors. By testing the robustness of the application, organisations can mitigate potential threats, improving both security and reliability. Here are some key aspects to consider during penetration testing:

### 1\. Validation, Sanitization: Improper Input Validation

Input validation is crucial to prevent injection attacks, where attackers exploit poorly validated input fields to execute malicious code. Improper input validation can allow attackers to inject SQL commands, modify queries, or execute arbitrary code. Penetration testing helps identify weak validation mechanisms and ensures that all user inputs are properly sanitised to avoid such risks.

### 2\. Validation, Sanitization: Handling XSS (Cross-Site Scripting)

Cross-Site Scripting (XSS) is a type of attack where an attacker injects malicious scripts into web pages viewed by other users. This can lead to session hijacking, defacement, and other security breaches. Pen-testing is vital in detecting XSS vulnerabilities by analysing how the application handles input and output, especially when rendering user-provided data on a webpage. Ensuring proper validation and sanitization of input is key to mitigating XSS attacks.

### 3\. Session Management: Session Fixation Vulnerability

Session fixation occurs when an attacker is able to set or hijack a user's session ID before they log in, allowing the attacker to take over the session once authentication is complete. Penetration testing evaluates the application’s session management mechanisms, ensuring that session IDs are regenerated after successful authentication and that sessions are properly invalidated on logout.

### 4\. Business Logic: External-Facing Administrative Portal

Applications often have administrative portals that must be restricted to authorised personnel. A common vulnerability is an external-facing administrative portal with weak access controls. Penetration testing can identify gaps in business logic that might allow unauthorised access to administrative features, exposing critical controls and data to attackers. Proper testing ensures that only authenticated and authorised users have access to sensitive administrative areas.

### 5\. Access Controls: Insecure Design and Implementation

Insecure access control mechanisms can lead to unauthorised data access or privilege escalation attacks. Penetration testing evaluates the security design and implementation of access controls, ensuring that users only have access to the resources necessary for their roles. It verifies that higher-privilege areas, such as administrative portals, are protected and not easily breached through insecure design.

### 6\. Access Controls: Privilege Escalation of Administration Portal

Privilege escalation occurs when an attacker gains higher-level access than what they are authorised for. Testing for privilege escalation ensures that even authenticated users cannot elevate their privileges to administrative levels without proper authorization. This protects sensitive features, data, and functionalities from unauthorised access and misuse.

### 7\. Auditing and Logging: Insufficient Logging and Monitoring

Logging and monitoring are essential for detecting and responding to security incidents. Insufficient logging and monitoring can prevent administrators from identifying security breaches in a timely manner. Penetration testing helps assess the adequacy of audit trails, ensuring that suspicious activities are logged and that proper alerts are generated for monitoring possible attacks.

### 8\. Authentication: Insufficient Verification of Account

Weak authentication mechanisms can expose an application to brute-force attacks, credential stuffing, and unauthorised access. Penetration testing validates the robustness of authentication mechanisms, ensuring multi-factor authentication (MFA) is in place and that proper account verification methods are implemented. It ensures that user accounts are not easily compromised due to weak or insufficient authentication procedures.

### 9\. Session Management: Session ID Doesn't Change

A common security issue is the failure to regenerate session IDs after login or significant events, such as password changes. Without session ID regeneration, an attacker could exploit the existing session to hijack a user’s session after authentication. Pen-testing evaluates how the application manages session IDs, ensuring that they are securely generated, rotated, and invalidated to prevent hijacking.

### 10\. Configuration: Weak Password Change Controls

Password change mechanisms need to be secure to prevent attackers from hijacking accounts. Weak password change controls, such as not requiring current password input or not enforcing strong password policies, are common vulnerabilities. Penetration testing assesses the strength of password change workflows, ensuring that users are required to confirm their identity and that password complexity is enforced.

### 11\. Configuration: Cookies Without Secure Flag Set

The secure flag ensures that cookies are only transmitted over HTTPS connections, preventing them from being intercepted over insecure networks. Penetration testing ensures that cookies are properly configured with the secure flag, protecting session data from being stolen during transmission. It also checks for the HttpOnly flag to prevent client-side scripts from accessing cookies.

### 12\. Information Disclosure: Backend Technology Information Disclosure

Leaking information about the underlying backend technology (e.g., database type, software versions) provides attackers with critical information for crafting targeted attacks. Penetration testing helps identify such information disclosure vulnerabilities, ensuring that error messages and headers do not reveal unnecessary technical details that could assist an attacker.

### 13\. Configuration: Prevent Directory Structure Exposure

This vulnerability allows attackers to list directories and file names within certain web servers by exploiting the tilde character in requests. Penetration testing helps identify if the server is vulnerable to directory structure exposure attacks and ensures that directory listings and file names are properly hidden from unauthorised users.

### 14\. Configuration: Sensitive Pages Could Be Cached

If sensitive pages are cached by the browser or intermediary servers, an attacker could access cached content after a user has logged out or left the session. Penetration testing verifies that sensitive pages are configured with appropriate headers to prevent caching (e.g., Cache-Control: no-store), ensuring that confidential data is not left accessible.

### 15\. Configuration: HTTP Strict Transport Security (HSTS) Not Implemented

HSTS forces browsers to only use HTTPS when communicating with a web application, preventing protocol downgrade attacks and cookie hijacking over insecure connections. Penetration testing ensures that HSTS is implemented and configured correctly to provide a robust defence against man-in-the-middle attacks.

### 16\. Configuration: Cookies With Missing, Inconsistent, or Contradictory Properties

Improperly configured cookies can expose the application to various security threats. Penetration testing ensures that cookies have consistent properties and are properly configured with attributes such as Secure, HttpOnly, SameSite, and Path to protect against cross-site attacks and session hijacking.

### Conclusion

Penetration testing is an essential component of an application’s security lifecycle. It enables organisations to identify vulnerabilities, strengthen defences, and reduce the risk of data breaches before deploying an application into production. By addressing critical aspects such as input validation, session management, access controls, and configuration issues, pen-testing enhances the security and resilience of applications, safeguarding both users and organisations against potential threats.

## References

1. [Exploiting a potential ASP.NET web app Session Fixation vulnerability](https://security.stackexchange.com/questions/82562/exploiting-a-potential-asp-net-web-app-session-fixation-vulnerability) - [Stack Exchange: Security](https://security.stackexchange.com/)
2. [Session Fixation — Broken Authentication and Session Management](https://medium.com/@grep_security/session-fixation-broken-authentication-and-session-management-c37ce0111bf5) by [Hari Charan](https://medium.com/@grep_security)
3. [Session Fixation Vulnerability Detection in ASP.Net](https://www.c-sharpcorner.com/UploadFile/ajyadav123/session-fixation-vulnerability-detection-in-Asp-Net/) by [Ajay Yadav](https://www.c-sharpcorner.com/members/ajay-yadav26)
4. [Session Fixation Vulnerability in ASP.NET](https://www.codeproject.com/Articles/210993/Session-Fixation-vulnerability-in-ASP-NET) - [CodeProject](https://www.codeproject.com/)
5. [FormsAuthentication.cs](http://www.dotnetframework.org/default.aspx/DotNET/DotNET/8@0/untmp/whidbey/REDBITS/ndp/fx/src/xsp/System/Web/Security/FormsAuthentication@cs/1/FormsAuthentication@cs) - [dotnetframework.org](http://www.dotnetframework.org/)