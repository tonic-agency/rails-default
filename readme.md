# What is HTML First?

HTML first is a philosophy that aims to make building web software **easier**, **faster** and more **inclusive**. It does this by...

1. Leveraging the default capabilities of modern web browsers.
2. Leveraging the extreme simplicity of the HTML syntax.
(`<element property="value">Content</element>`)
3. Leveraging the power of **copy-paste-able** code and code snippets.

# Goals
The main goal of HTML First is to **substantially widen the pool of people who can work on a given codebase**. This is good idealistically because it allows a greater number of people to become web programmers, to build great web software, and increase their income. It's also good from a business perspective as it decreases the cost of building software, and decreases the amount of resources required to hire - a notoriously resource intensive process. 

The way we achieve this is by acknowledging that [HTML is very easy to understand](https://new.tonyennis.com/blog/M3WoiPA5P-comparing-the-readability-and-learning-curve-of-html), and thus using HTML as a place not only to define content and structure, but also to set styling and behaviours.

# Principles

- <a class="anchor-link" href="#vanilla-approaches">Prefer Vanilla approaches</a>
- <a class="anchor-link" href="#attributes-for-styling-behaviour">Use HTML attributes for styling and behaviour</a>
- <a class="anchor-link" href="#attributes-for-libraries">Use libraries that leverage HTML attributes</a>
- <a class="anchor-link" href="#build-steps">Eradicate Build Steps, Reject Minification</a>
- <a class="anchor-link" href="#view-source">Be View-Source Friendly</a>
- <a class="anchor-link" href="#naked-html">Prefer Naked HTML</a>


<div id="vanilla-approaches"></div>
## **Use "vanilla" approaches to achieve desired functionality over external frameworks**
The range of things that browsers support out of the box is large, and growing. Before adding a library or framework to your codebase, check whether you can achieve it using plain old html/css.
**Good**

```html
<details>
  <summary>Click to toggle content</summary>
  <p>This is the full content that is revealed when a user clicks on the summary</p>
</details>    
```

**Bad**

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

For styling this can be enabled with an SPC library like [Tailwind](https://github.com/tonyennis145/dumb-tailwind) or [Tachyons](http://tachyons.io/). For behaviour, you can use libraries like [hyperscript](https://hyperscript.org/), [Alpine](https://alpinejs.dev/), or similar. Yes, this does mean your HTML will *look* busy. But it also means it will be more copy-pasteable, and easier for other developers to navigate, understand and make changes to.

**Good**

```html
<div class="bg-green" onlick="this.classList.add('green')">
  Click Me
</div>
```

**Bad**

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
**Good**

```html
<script src="https://unpkg.com/hyperscript@0.0.7/dist/hyperscript.min.js"></script>
<div>
  <input type="text" _="on input put me into #output">
  <div id="output"></div>
</div>
```

**Bad**

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
      
## Eradicate Build Steps, Reject minification

Libraries that require transforming your files from one format to another add significant maintenance overhead, reduce copy-paste-ability, and usually dictate that developers learn new tooling in order to use them. In our experience the value rarely justifies the additional complexity.

**Good**

```html
<link rel="stylesheet" href="/styles.css">
```

**Bad**

```html
<link href="/dist/output.css" rel="stylesheet">
```
```shell
npx css-compile -i ./src/input.css -o ./dist/output.css --watch
```

Additionally, most...
## Prefer "naked" HTML to obfuscation layers that compile down to HTML

This principle is most applicable to backend implementation. The underlying idea again here is readability. If a developer who has familiarity with HTML but not with your backend framework looks through your view files, they should still be able to understand 90%+ of what they see. As with above, this means sacrificing brevity for understandability. 

**Good**

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

**Bad**

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