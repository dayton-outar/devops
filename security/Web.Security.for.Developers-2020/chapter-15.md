# Chapter 15

## Web Security for Developers-2020

Source: [Web.Security.for.Developers-2020-15.pdf](Web.Security.for.Developers-2020-15.pdf) — 8 PDF pages.

<!-- Source S15, PDF page 1 -->

### XML Attacks

> [Decorative chapter-opening artwork placeholder — source S15, PDF page 1; 9 image tiles.]

With the explosive growth of the internet in the ’90s, organizations began sharing data with each other over the web. Sharing data between computers meant agreeing on a shared data format. Human-readable documents on the web were being marked up with HyperText Markup Language (HTML). Machine-readable files were often stored in an analogous data format called Extensible Markup Language (XML).

XML can be thought of as a more general implementation of HTML: in this form of markup, the tag and attribute names can be chosen by the document author rather than being fixed, as they are in the HTML specification. In Listing 15-1, you can see an XML file describing a catalog of books, using tags like `<catalog>`, `<book>`, and `<author>`.

<!-- Source S15, PDF page 2 -->

```text
<?xml version="1.0"?>
<catalog>
   <book id="7991728882998">
      <author>Sponden, Phillis</author>
      <title>The Evil Horse That Knew Karate</title>
      <genre>Young Adult Fiction</genre>
      <description>Three teenagers with very different personalities
team up to defeat a surprising villain.</description>
   </book>
   <book id="28299171927772">
      <author>Chenoworth, Dr. Sebastian</author>
      <title>Medical Encyclopedia of Elbows, 12th Edition</title>
      <genre>Medical</genre>
      <description>The world's foremost forearm expert gives detailed diagnostic
and clinical advice on maintaining everyone's favorite joint.</description>
   </book>
</catalog>
```

Listing 15-1: An XML document describing a catalog of books

The popularity of this data format, especially in the early days of the web, means that XML parsing—the process of turning an XML file into in-memory code objects—has been implemented in every browser and web server of the past few decades. Unfortunately, XML parsers are a common target for hackers. Even if your site doesn’t handle XML by design, your web server may parse the data format by default. This chapter shows how XML parsers can be attacked and how to defuse these attacks.

### The Uses of XML

Much like HTML, XML encloses data items between tags and allows tags to be embedded within one another. The author of an XML document can choose semantically meaningful tag names so that the XML document is self-describing. Because XML is very readable, the data format was widely adopted to encode data for consumption by other applications.

The uses of XML are many. Application programming interfaces (APIs) that allow client software to call functions over the internet frequently accept and respond using XML. JavaScript code in web pages that communicates asynchronously back to the server often uses XML. Many types of applications—web servers included—use XML-based configuration files.

In the past decade, some of these applications have started using bettersuited, less verbose data formats than XML. For example, JSON is a more natural method of encoding data in JavaScript and other scripting languages. The YAML language uses meaningful indentation, making it a simpler format for configuration files. Nevertheless, every web server implements XML parsing in some fashion and needs to be secured against XML attacks.

XML vulnerabilities generally occur during the validation process. Let’s take a minute to discuss what validation means in the context of parsing an XML document.

<!-- Source S15, PDF page 3 -->

### Validating XML

Since the author of an XML file is able to choose which tag names are used in the document, any application reading the data needs to know which tags to expect and in what order they will appear. The expected structure of an XML document is often described by a formal grammar against which the document can be validated.

A grammar file dictates to a parser which sequences of characters are valid expressions within the language. A programming language grammar might specify, for instance, that variable names can contain only alphanumeric characters, and that certain operators like `+` require two inputs.

XML has two major ways of describing the expected structure of an XML document. A document type definition (DTD) file resembles the Bachus–Naur Form (BNF) notation often used to describe programming language grammars. An XML Schema Definition (XSD) file is a more modern, more expressive alternative, capable of describing a wider set of XML documents; in this case, the grammar itself is described in an XML file. Both methods of XML validation are widely supported by XML parsers. However, DTDs contain a couple of features that can expose the parser to attack, so that’s what we’ll focus on.

### Document Type Definitions

A DTD file describes the structure of an XML file by specifying the tags, subtags, and types of data expected in a document. Listing 15-2 shows a DTD file describing the expected structure of the `<catalog>` and `<book>` tags in Listing 15-1.

```text
<!DOCTYPE catalog [
  <!ELEMENT catalog     (book+)>
  <!ELEMENT book        (author,title,genre,description)>
  <!ENTITY  author      (#PCDATA)>
  <!ENTITY  title       (#PCDATA)>
  <!ENTITY  genre       (#PCDATA)>
  <!ENTITY  description (#PCDATA)>
  <!ATTLIST book id CDATA>
]>
```

Listing 15-2: A DTD file describing the format of the XML in Listing 15-1

This DTD describes that the top-level `<catalog>` tag is expected to contain zero or more `<book>` tags (the quantity is denoted by the `+` sign), and that each `<book>` tag is expected to contain tags describing the `author`, `title`, `genre`, and `description`, plus an `id` attribute. The tags and attribute are expected to contain parsed character data (`#PCDATA`) or character data (`CDATA`)—that is, text rather than tags.

DTDs can be included within an XML document to make the document self-validating. However, a parser that supports such inline DTDs is vulnerable to attack—because a malicious user uploading such an XML document has control over the contents of the DTD, rather than it being

<!-- Source S15, PDF page 4 -->

supplied by the parser itself. Hackers have used inline DTDs to exponentially increase the amount of server memory a document consumes during parsing (an XML bomb), and access to other files on the server (an XML external entity attack). Let’s see how these attacks work.

### XML Bombs

An XML bomb uses an inline DTD to explode the memory usage of an XML parser. This will take a web server offline by exhausting all the memory available to the server and causing it to crash.

XML bombs take advantage of the fact that DTDs can specify simple string substitution macros that are expanded at parse time, called internal entity declarations. If a snippet of text is frequently used in an XML file, you can declare it in the DTD as an internal entity. That way, you don’t have to type it out every time you need it in the document—you just type the entity name as a shorthand. In Listing 15-3, an XML file containing employee records specifies the company name in the DTD by using an internal entity declaration.

```text
<?xml version="1.0"?>
<!DOCTYPE employees [
  <!ELEMENT employees (employee)*>
  <!ELEMENT employee (#PCDATA)>
  <!ENTITY company "Rock and Gravel Company"[1]>
]>
<employees>
  <employee>
    Fred Flintstone, &company;[2]
  </employee>
  <employee>
    Barney Rubble, &company;[3]
  </employee>
</employees>
```

Listing 15-3: An internal entity declaration

The string `&company;` [2][3] acts as a placeholder for the value `Rock and` `Gravel Company` [1]. When the document is parsed, the parser replaces all instances of `&company;` with `Rock and Gravel Company` and produces the final document shown in Listing 15-4.

```text
<?xml version="1.0"?>
<employees>
  <employee>
    Fred Flintstone, Rock and Gravel Company
  </employee>
  <employee>
    Barney Rubble, Rock and Gravel Company
  </employee>
</employees>
```

Listing 15-4: The XML document after the parser processes the DTD

<!-- Source S15, PDF page 5 -->

Internal entity declarations are useful, if seldom used. Problems occur when internal entity declarations refer to other internal entity declarations. Listing 15-5 shows a nested series of entity declarations that constitute an XML bomb.

```text
<?xml version="1.0"?>
<!DOCTYPE lolz [
  <!ENTITY lol "lol">
  <!ENTITY lol2 "&lol;&lol;&lol;&lol;&lol;&lol;&lol;&lol;&lol;&lol;">
  <!ENTITY lol3 "&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;">
  <!ENTITY lol4 "&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;">
  <!ENTITY lol5 "&lol4;&lol4;&lol4;&lol4;&lol4;&lol4;&lol4;&lol4;&lol4;&lol4;">
  <!ENTITY lol6 "&lol5;&lol5;&lol5;&lol5;&lol5;&lol5;&lol5;&lol5;&lol5;&lol5;">
  <!ENTITY lol7 "&lol6;&lol6;&lol6;&lol6;&lol6;&lol6;&lol6;&lol6;&lol6;&lol6;">
  <!ENTITY lol8 "&lol7;&lol7;&lol7;&lol7;&lol7;&lol7;&lol7;&lol7;&lol7;&lol7;">
  <!ENTITY lol9 "&lol8;&lol8;&lol8;&lol8;&lol8;&lol8;&lol8;&lol8;&lol8;&lol8;">
]>
<lolz>&lol9;</lolz>
```

Listing 15-5: A type of XML bomb known as the billion laughs attack

When this XML file is parsed, the `&lol9;` string is replaced with 10 occurrences of the string `&lol8;`. Then each occurrence of `&lol8;` is replaced with 10 occurrences of the string `&lol7;`. The final form of the XML file consists of a `<lolz>` tag containing over a billion occurrences of the string `lol`. This simple XML file will take up over 3GB of memory when the DTD is fully expanded, enough to crash the XML parser!

Exhausting the memory available to the XML parser will take your web server offline, which makes XML bombs an effective way for a hacker to launch a denial-of-service attack. All an attacker needs to do is to find a URL on your site that accepts XML uploads, and they can take you offline with a click of a button.

XML parsers that accept inline DTDs are also vulnerable to a sneakier type of attack that takes advantage of entity definitions in a different manner.

### XML External Entity Attacks

DTDs can include content from external files. If an XML parser is configured to process inline DTDs, an attacker can use these external entity declarations to explore the local filesystem or to trigger network requests from the web server itself.

A typical external entity looks like Listing 15-6.

```text
<?xml version="1.0" standalone="no"?>
<!DOCTYPE copyright [
  <!ELEMENT copyright (#PCDATA)>
  <!ENTITY copy PUBLIC "http://www.w3.org/xmlspec/copyright.xml"[1]>
]>
<copyright>&copy;[2] </copyright>
```

Listing 15-6: Using an external entity to include boilerplate copyright text in an XML file

<!-- Source S15, PDF page 6 -->

According to the XML 1.0 specification, a parser is expected to read the contents of the file specified in the external entity and insert that data into the XML document wherever the entity is referenced. In this example, the data hosted at http://www.w3.org/xmlspec/copyright.xml [1] would be inserted into the XML document wherever the text `&copy;` [2] appears.

The URL referenced by the external entity declaration can use various network protocols, depending on the prefix. Our example DTD uses the http:// prefix, which will cause the parser to make an HTTP request. The XML specification also supports reading local files on disk, using the file:// prefix. For this reason, external entity definitions are a security disaster.

### How Hackers Exploit External Entities

When an XML parser throws an error, the error message will often include the contents of the XML document being parsed. Knowing this, hackers use external entity declarations to read files on a server. A maliciously crafted XML file might include a reference to a file such as file://etc/passwd on a Linux system, for instance. When this external file is inserted into the XML document by the parser, the XML becomes malformed—so parsing fails. The parser then dutifully includes the contents of the file in the error response, allowing the hacker to view the sensitive data within the referenced file. Using this technique, hackers can read sensitive files on a vulnerable web server that contain passwords and other confidential information.

External entities can also be used to commit server-side request forgery (SSRF) attacks, whereby an attacker triggers malicious HTTP requests from your server. A naïvely configured XML parser will make a network request whenever it encounters an external entity URL with a network protocol prefix. Being able to trick your web server into making a network request on a URL of their choosing is a boon for an attacker! Hackers have used this feature to probe internal networks, to launch denial-of-service attacks on third parties, and to disguise malicious URL calls. You will learn more about the risks around SSRF attacks in the next chapter.

### Securing Your XML Parser

This is a simple fix to protect your parser from XML attacks: disable the processing of inline DTDs in your configuration. DTDs are a legacy technology, and inline DTDs are a bad idea, period. In fact, many modern XML parsers are hardened by default, meaning out of the box they disable features that allow the parser to be attacked, so you might be protected already. If you are unsure, you should check what (if any) XML parsing technology you are using.

The following sections describe how to secure your XML parser in some of the major web programming languages. Even if you think your code doesn’t parse XML, the third-party dependencies you use likely use XML in some form. Make sure you analyze your entire dependency tree to see what libraries are loaded into memory when your web server starts up.

<!-- Source S15, PDF page 7 -->

### Python

The `defusedxml` library explicitly rejects inline DTDs and is a drop-in replacement for Python’s standard XML parsing library. Use this module in place of Python’s standard library.

### Ruby

The de facto standard for parsing XML in Ruby is the `Nokogiri` library. This library has been hardened to XML attacks since version 1.5.4, so make sure your code uses that version or higher for parsing.

### Node.js

Node.js has a variety of modules for parsing XML, including `xml2js`, `parse-xml`, and `node-xml`. Most of them omit processing of DTDs by design, so make sure to consult the documentation for the parser you use.

### Java

Java has a variety of methods of parsing XML. Parsers that adhere to Java specifications typically initiate parsing via the class `javax.xml.parsers.Document` `BuilderFactory`. Listing 15-7 illustrates how to configure secure XML parsing in this class wherever it is instantiated, using the `XMLConstants.FEATURE_SECURE` `_PROCESSING` feature.

```text
DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
factory.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
```

Listing 15-7: Securing a Java XML parsing library

### .NET

.NET has a variety of methods of parsing XML, all contained in the `System` `.Xml` namespace. `XmlDictionaryReader`, `XmlNodeReader`, and `XmlReader` are safe by default, as are `System.Xml.Linq.XElement` and `System.Xml.Linq.XDocument`. `System` `.Xml.XmlDocument`, `System.Xml.XmlTextReader`, and `System.Xml.XPath.XPathNavigator` have been secured since .NET version 4.5.2. If you are using an earlier version of .NET, you should switch to a secure parser, or disable the processing of inline DTDs. Listing 15-8 shows how to do this by setting the `ProhibitDtd` attribute flag.

```text
XmlTextReader reader = new XmlTextReader(stream);
reader.ProhibitDtd = true;
```

Listing 15-8: Disabling processing of inline DTDs in .NET

<!-- Source S15, PDF page 8 -->

### Other Considerations

The threat of external entity attacks illustrates the importance of following the principle of least privilege, which states that software components and processes should be granted the minimal set of permissions required to perform their tasks. There is rarely a good reason for an XML parser to make outbound network requests: consider locking down outbound network requests for your web server as a whole. If you do need outbound network access—for example, if your server code calls third-party APIs—you should whitelist the domains of those APIs in your firewall rules.

Similarly, it’s important to restrict the directories on disk that your web server can access. On the Linux operating system, this can be achieved by running your web server process in a `chroot` jail that ignores any attempts by the running process to change its root directory. On the Windows operating system, you should manually whitelist the directories that the web server can access.

### Summary

Extensible Markup Language (XML) is a flexible data format widely used to exchange machine-readable data on the internet. Your XML parser may be vulnerable to attack if it is configured to accept and process inline document type definitions (DTDs). XML bombs use inline DTDs to explode the parser’s memory use, potentially crashing your web server. XML external entity attacks reference local files or network addresses, and can be used to trick the parser into revealing sensitive information or make malicious network requests. Make sure you use a hardened XML parser that disables inline DTD parsing.

The next chapter expands on a concept touched on in this chapter: how security flaws in your web server can be leveraged by hackers to launch attacks on third parties. Even when you aren’t the victim directly, it’s important to be a good internet citizen and stop attacks that use your system.
