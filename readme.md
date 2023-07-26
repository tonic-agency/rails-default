# Easy Rails

This repository is designed to be the absolute *simplest* way to build web interfaces or applications as someone with limited experience. The documentation below will assume you have no knowledge of Ruby on Rails, and moderate/basic knowledge of HTML and CSS.

#### Write Code. Not too much. Mostly HTML. 

Conceptually, basic HTML is as low on the difficulty scale as you can get when it comes to building web software. This codebase, while built on top of Ruby on Rails, is designed primarily to be a container for html. We provide a few helper libraries to add some minor additional functionality to html, and a collection of cheat sheets with one-liners and examples, all centered around html, which should unlock 95%+ of the use cases you're likely to encounter.

**For when the platform falls short...**

While we believe in **minimising** external libraries and relying on pure HTML as much as possible, there are a few places that we've added (small, simple) enhancements to plain 'ol html/css.

- Single-purpose CSS classes make it substantially easier to write and maintain CSS, by providing a-single-way-to-do-things (reducing the amount of decisions to be made). They are super quick to write, very readable, and that won't be accidentally broken later on. We use Tailwind for this. You can browse the classes that are available to you by default here.
- One shortcoming of plain HTML is that it doesn't provide a way to easily update a **part** of a webpage or screen when a user clicks on or interacts with another part of it. Instead it requires the page undergo a full reload to load in new content. This can make interfaces feel slow, and falls short of the expectations of the average internet software user. We use htmx to fill this gap.
- Performance: As your screens grow in size, the load speed of your page can get slower. Google page speed insights tells you how fast your pages are, and lists a number of ways to keep your application snappy on mobile and slower connections. Some of these patterns use non-standard ways of writing HTML but are important to keep your app fast. Two examples in this codebase are working with icons and loading in CSS and javascript files.

#### Core Patterns



#### Modals



## For Technical People

Setup
- `bundle install`
- `curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash`
- `nvm install --lts`
- `npm install -D tailwindcss`

Refreshing the purged CSS 

```
npx tailwindcss -o ./public/stylesheets/purged.css
```