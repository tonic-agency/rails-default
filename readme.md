# Tonic Starter

This repository is the place where we collect the patterns and ideas that we use to build software at Tonic. We have an opinionated and somewhat alternative take on how software gets built, which focuses on radical simplicity and understandability. 

### HTML First

[HTML First](https://new.tonyennis.com/blog/c4gAsd-ry-what-is-html-first?) is a set of principles that aim to make building web software **easier**, **faster** and more **inclusive** by...

1. Leveraging the default capabilities of modern web browsers.
2. Leveraging the extreme simplicity of the HTML syntax.
(`<element property="value">Content</element>`)
3. Leveraging the power of **copy-paste-able** code and code snippets.

This codebase follows the HTML First principles, which you can find [here](https://new.tonyennis.com/blog/c4gAsd-ry-what-is-html-first?). In that spirit, it also includes a range of copy-paste-able code snippets that can be used and re-used.
### How we use Rails

We use Rails for the things that  HTML can't do - defining routes, communicating with a database, converting data from one format to other, communicating with APIs, and a few other things. But we intentionally don't use several of the patterns and libraries that Rails includes and recommends, usually where the additional complexity and learning curve isn't worth it. 

Although this is a Rails codebase, it's designed to be as accessible as possible to people with limited Rails experience.

### What's Included

- The gems we find ourselves installing with every new app we build.
- Functionality for identity using Devise.
- HTML-attribute-based libraries for styling (tailwind), and behaviour (htmx, minijs).
- Tonic.css - a collection of utilities for making things look nice by default (forms, common interface patterns external libraries).

