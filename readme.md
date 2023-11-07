# The HTML First Manifesto

HTML first is a philosophy that aims to make building web software **easier**, **faster** and more **inclusive**. It does this by...

1. Leveraging the default capabilities of modern web browsers.
2. Leveraging the extreme simplicity of HTML's syntax.
3. Leveraging the power of **copy-paste-able** code and code snippets.

# Goals
The main goal of HTML First is to **substantially widen the pool of people who can work on web software codebases**. This is good from an individual perspective because it allows a greater number of people to become web programmers, to build great web software, and increase their income. It's also good from a business perspective as it decreases the cost of building software, and decreases the amount of resources required to hire - a notoriously resource intensive process. 

A second goal of HTML First is to make it more <ins>enjoyable</ins> and <ins>seamless</ins> to build web software. Most web programmers are familiar with the excitement of seeing their product come together rapidly as they transition smoothly between the text editor and the browser, with very few unexpected potholes or context switches. But today it takes several years of mastering tools and frameworks to get to that stage. HTML First principles should allow people to unlock that feeling, and level of mastery, much earlier on in their coding journey.

The way we achieve these goals is by acknowledging that [HTML is very easy to understand](https://new.tonyennis.com/blog/M3WoiPA5P-comparing-the-readability-and-learning-curve-of-html), and thus using HTML as the bedrock of our product - not only to define content and structure, but also to set styling and behaviours.

# Principles

- <a class="anchor-link" href="#vanilla-approaches">Prefer Vanilla approaches</a>
- <a class="anchor-link" href="#attributes-for-styling-behaviour">Use HTML attributes for styling and behaviour</a>
- <a class="anchor-link" href="#attributes-for-libraries">Use libraries that leverage HTML attributes</a>
- <a class="anchor-link" href="#build-steps">Avoid Build Steps</a>
- <a class="anchor-link" href="#view-source">Be View-Source Friendly</a>
- <a class="anchor-link" href="#naked-html">Prefer Naked HTML</a>


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
## Where possible, default to defining <ins>`style`</ins> and <ins>`behaviour`</ins> with inline HTML attributes

For styling this can be enabled with an SPC library like [Tailwind](https://github.com/tonyennis145/dumb-tailwind) or [Tachyons](http://tachyons.io/). For behaviour, you can use libraries like [hyperscript](https://hyperscript.org/), [Alpine](https://alpinejs.dev/), or similar. Yes, this does mean your HTML will *look* busy. But it also means it will be easier for other developers to find and understand behaviour, navigate it, and make changes to it.

**Encouraged**

```html
<div class="bg-green" onlick="this.classList.add('green')">
  Click Me
</div>
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
var resultsPane = document.getElementById("myDiv");
resultsPane.addEventListener("click", function() {
    this.classList.add("active");
});
```

You may notice that this approach violates [Separation of Concerns](https://en.wikipedia.org/wiki/Separation_of_concerns). One day, I'll write about why an all-or-nothing approach to SOC is not useful. In the mean time, you can read HTMX's article on the [Locality of Behaviour](https://htmx.org/essays/locality-of-behaviour/) principle, or [Adam Wathan's article on separation of styling concerns](https://adamwathan.me/css-utility-classes-and-separation-of-concerns/).

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

Libraries that require transforming your files from one format to another add significant maintenance overhead, reduce or remove copy-paste-ability, and usually dictate that developers learn new tooling in order to use them. Additionally, given that when we use attribute-based libraries like htmx and hyperscript, there simply is not that much javascript to be bundled anyway.

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

The beauty of the early web was that it was always possible to "peek behind the curtains" and see the code that was responsible for a given piece of any web page. This was a gift to aspiring developers, as it allowed us to bridge the gap between the theoretical (reading about how html works) and the practical - seeing both code and interface alongside each other. In the time since, the industry has adopted several "improvements" which have made this increasingly difficult. We can technically see the code, but it has become much more difficult to decipher what's going on. 



