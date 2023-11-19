# HTML First

HTML First is a set of principles that aims to make building web software **easier**, **faster**, more **inclusive**, and more **maintainable** by...

1. Leveraging the default capabilities of modern web browsers.
2. Leveraging the extreme simplicity of HTML's attribute syntax.
3. Leveraging the web's ViewSource affordance.

# Goals
The main goal of HTML First is to **substantially widen the pool of people who can work on web software codebases**. This is good from an individual perspective because it allows a greater number of people to become web programmers, to build great web software, and increase their income. It's also good from a business perspective as it decreases the cost of building software, and decreases the amount of resources required to hire - a notoriously resource intensive process. 

A second goal of HTML First is to make it more <ins>enjoyable</ins> and <ins>seamless</ins> to build web software. Most web programmers are familiar with the excitement of seeing their product come together rapidly as they transition smoothly between the text editor and the browser, with very few unexpected potholes or context switches. But today it takes several years of mastering tools and frameworks to get to that stage. HTML First principles should allow people to unlock that feeling, and level of mastery, much earlier on in their coding journey.

The way we achieve these goals is by acknowledging that [HTML is very easy to understand](https://new.tonyennis.com/blog/M3WoiPA5P-comparing-the-readability-and-learning-curve-of-html), and thus using HTML as the bedrock of our product - not only to define content and structure, but also to set styling and behaviours.

# Principles

- <a class="anchor-link" href="#vanilla-approaches">Prefer Vanilla approaches</a>
- <a class="anchor-link" href="#attributes-for-styling-behaviour">Use HTML attributes for styling and behaviour</a>
- <a class="anchor-link" href="#attributes-for-libraries">Use libraries that leverage HTML attributes</a>
- <a class="anchor-link" href="#build-steps">Avoid Build Steps</a>
- <a class="anchor-link" href="#naked-html">Prefer Naked HTML</a>
- <a class="anchor-link" href="#view-source">Be View-Source Friendly</a>


<div id="vanilla-approaches"></div>
## **Use "vanilla" approaches to achieve desired functionality over external frameworks**
The range of things that browsers support out of the box is large, and growing. Before adding a library or framework to your codebase, check whether you can achieve it using plain old html/css.
**Encouraged**

```html
<details>
  <summary>Click to toggle content</summary>
  <p>This is the full content that is revealed when a user clicks on the summary</p>
</details>    
```

**Discouraged**

```javascript
import React, { useState } from 'react';

const DetailsComponent = () => {
  const [isContentVisible, setContentVisible] = useState(false);

  const toggleContent = () => {
    setContentVisible(!isContentVisible);
  };

  return (
    <details>
      <summary onClick={toggleContent}>Click to toggle content</summary>
      {isContentVisible && <p>This is the full content that is revealed when a user clicks on the summary</p>}
    </details>
  );
};

export default DetailsComponent;
```

<div id="attributes-for-styling-behaviour"></div>
## Where possible, default to defining style and behaviour with inline HTML attributes

For styling this can be enabled with an SPC library like [Tailwind](https://github.com/tonyennis145/dumb-tailwind) or [Tachyons](http://tachyons.io/). For behaviour, you can use libraries like [hyperscript](https://hyperscript.org/), [Alpine](https://alpinejs.dev/), or similar. Yes, this does mean your HTML will *look* busy. But it also means it will be easier for other developers to find and understand behaviour, navigate it, and make changes to it.

**Encouraged**

```html
<button onclick="this.classList.add('bg-green')">
  Click Me
</button>
```

**Discouraged**

```html
<div id="results-pane">
  Click Me
</div>
```

```css
#results-pane.active {
  background-color: green;
}
```
```javascript
var resultsPane = document.getElementById("results-pane");
resultsPane.addEventListener("click", function() {
    this.classList.add("active");
});
```

You may notice that this approach seems to violate [Separation of Concerns](https://en.wikipedia.org/wiki/Separation_of_concerns) - one of the most commonly-touted software design principles. We believe an all-or-nothing approach to SoC is flawed, and instead advocate an approach that accounts for Locality of Behaviour and acknoweldges the trade-offs between the two.   

- [HTMX on The Locality of Behaviour Principle](https://htmx.org/essays/locality-of-behaviour/)
- [Adam Wathan on separation of styling concerns](https://adamwathan.me/css-utility-classes-and-separation-of-concerns/).

<div id="attributes-for-libraries"></div>
## **Where libraries are necessary, use libraries that leverage html attributes over libraries built around javascript or custom syntax**
**Encouraged**

```html
<script src="https://unpkg.com/hyperscript@0.0.7/dist/hyperscript.min.js"></script>
<div>
  <input type="text" _="on input put me into #output">
  <div id="output"></div>
</div>
```

**Discouraged**

```html

<script src="https://cdn.jsdelivr.net/npm/stimulus@2.0.0/dist/stimulus.umd.js"></script>

<div data-controller="echo">
  <input type="text" data-echo-target="source" data-action="input->echo#update">
  <div data-echo-target="output"></div>
</div>

<script>
  const application = Stimulus.Application.start();

  application.register("echo", class extends Stimulus.Controller {
      static targets = ["source", "output"]

      update() {
          this.outputTarget.textContent = this.sourceTarget.value;
      }
  });
</script>
```

<div id="build-steps"></div>
      
## Steer Clear of Build Steps

Libraries that require transforming your files from one format to another add significant maintenance overhead, remove or heavily impair the ViewSource affordance , and usually dictate that developers learn new tooling in order to use them. [Modern browsers don't have the same performance constraints](https://stackoverflow.com/questions/36517829/what-does-multiplexing-mean-in-http-2/36519379#36519379) that they did when these practices were introduced. And if we use HTML First libraries like static tailwind or htmx, the amount of additional CSS and JS needed is usually minimal.

**Encouraged**

```html
<link rel="stylesheet" href="/styles.css">
```

**Discouraged**

```html
<link href="/dist/output.css" rel="stylesheet">
```
```shell
npx css-compile -i ./src/input.css -o ./dist/output.css --watch
```

Aside: The build step practice is so deeply ingrained that even one year ago this opinion was considered [extremely fringe](https://twitter.com/tonyennis/status/1579610085499998208). But in the last year has begun to gain significant steam. Some recent examples:

- [@dhh - "We've gone #NoBuild on CSS with 37signals"](https://twitter.com/dhh/status/1719041666412347651)
- [Are build tools an anti-pattern by Chris Ferdinandi](https://gomakethings.com/are-build-tools-an-anti-pattern/)
- [How do build tools break backwards compatibility](https://gomakethings.com/how-do-build-tools-break-backwards-compatibility/)
- [Blake Watson - "There has never been a better time to ditch build steps"](https://social.lol/@bw/111293266036805485)

<div id="naked-html"></div>


## Prefer "naked" HTML to obfuscation layers that compile down to HTML

This principle is most applicable to backend implementation. The underlying idea again here is readability. If a developer who has familiarity with HTML but not with your backend framework looks through your view files, they should still be able to understand 90%+ of what they see. As with above, this means sacrificing brevity for understandability. 

**Encouraged**

```html
<form action="<%= new_signup_path %>" method="post">
  <div class="field">
    <label for="first_name">First Name</label>
    <input id="first_name" type="text" value="<%= @signup&.first_name %>" />
  </div>
  <div class="field">
    <label for="last_name">Last Name</label>
    <input id="last_name" type="text" value="<%= @signup&.last_name %>" />
  </div>
  <div class="field">
    <label for="email">Last Name</label>
    <input id="email" type="text" value="<%= @signup&.email %>" />
  </div>
</form>
```

**Discouraged**

```erb
<%= form_with url: "#", local: true do |form| %>
  <div class="field">
    <%= form.label :first_name %>
    <%= form.text_field :first_name %>
  </div>

  <div class="field">
    <%= form.label :last_name %>
    <%= form.text_field :last_name %>
  </div>

  <div class="field">
    <%= form.label :email %>
    <%= form.email_field :email %>
  </div>

  <div class="actions">
    <%= form.submit %>
  </div>
<% end %>
```


<div id="view-source"></div>


## Where possible, maintain the right-click-view-source affordance

The beauty of the early web was that it was always possible to "peek behind the curtains" and see the code that was responsible for any part of any web page. This was a gift to aspiring developers, as it allowed us to bridge the gap between the theoretical (reading about how code works) and the practical - seeing both code and interface alongside each other. For many sites, we could copy and paste the html or css and run it in ourselves to get a close-to-identical replica. "Remixing" existing snippets was not only a way to learn, but often formed the basis of our new creations.

In the time since, the industry has adopted several "improvements" which have made this practice much rarer. For example, if we use React - the most popular frontend framework, we cannot hit "View Source", copy the code, and remix it, because 1. React has a build step, meaning the code we see in the developer tools is different to the code that the developer wrote, and 2. React code snippets must be wrapped in a react application in order for them to work.

For sites that follow HTML First principles, we regain the ViewSource affordance again. In fact, HTML First sites often go one step further. Because if you define your **UI interactions** using HTML attributes, you can now also preserve these interactions when copy pasting into a new codebase, (provided your destination file includes the same js library). At some point we intend to levearge this to build an HTML First code snippet library. 

- [HTMX.org on the ViewSource affordance](https://htmx.org/essays/right-click-view-source/)

## Wrapping Up

The practices and principles described on this site are still considered niche in the industry as a whole, and the community of people using them small. One of my hopes with creating this site is to act as a Honeypot to find and connect like minded people with whom we can discuss and sharpen these ideas. If any of this resonates with you, I'd love to [hear from you](https://twitter.com/tonyennis).