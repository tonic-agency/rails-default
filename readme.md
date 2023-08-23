# HTML First Rails

This repository is designed to be the absolute simplest way to build web applications. The documentation will assume you have basic/beginner knowledge of HTML and CSS, and little-to-no knowledge of Ruby on Rails.

#### For when the platform falls short...

Whilst we believe in **minimising** external libraries, concepts and patterns and relying on plain HTML as much as possible, there are a few areas where this approach falls short when it comes to UX and maintainability. To address these shortcomings, we've added a few (small, easy to learn) helpers and utilities to the codebase, along with examples of how to use them.

- CSS is a powerful language, but it's cascading nature can make it difficult to debug (figure out why it's not behaving as expected), and maintain (add new styles without breaking existing styles) over time. Because of this, CSS is one of the most common places that novice developers get stuck when starting out. [Single-purpose CSS classes](https://tailwindcss.com/docs/utility-first) address this, by providing a-single-way-to-do-styling which wrprevents collisions and makes it very obvious where a style is being applied. We use [Tailwind](https://tailwindcss.com/) for this. You can browse the classes that are available to you by default here.
- Another shortcoming of plain HTML is that it doesn't provide a way to easily update a **part** of a webpage or screen when a user clicks on or interacts with another part of it. Instead it requires the page undergo a full reload to load in new content. This can make interfaces feel slow, and falls short of the expectations of the average internet software user. We use [htmx](https://htmx.org/) to fill this gap.


