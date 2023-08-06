# HTML First Rails

This repository is designed to be the absolute simplest way to build web applications. The documentation will assume you have basic/beginner knowledge of HTML and CSS, and little-to-no knowledge of Ruby on Rails.

#### Novice Friendliness as a core Design Principle

I've written more about this in my blog [here](https://new.tonyennis.com/blog/f_8e9B0u6-nfacdp). The main idea behind the way we approach this codebase If the "learn-ability" of a codebase rises in step with each new concept added, then we should start with a few very simple concepts (html tags and properties), defer introducing more difficult concepts (and skills) until later, and not add new concepts to our codebase that will reduce it's learn-ability unless absolutely necessary. 

#### Write Code. Not too much. Mostly HTML. 

Conceptually, basic HTML is as low on the difficulty scale as you can get when building web software. And for most interfaces, it's sufficient. We use Rails for the things that plain HTML can't do - creating routes and templates, communicating with a database, and a few other small utilities. But we intentionally don't use many of the "Rails Way" patterns and libraries in places where limited value is offered over a plain HTML approach, and/or where an entirely new set of concepts/patterns needs to be learned.

#### For when the platform falls short...

If it wasn't clear from the title of the repository, we believe in **minimising** external libraries, concepts and patterns, and relying on plain HTML as much as possible. That said, there are a few areas where this approach falls short when it comes to UX and maintainability. To address these shortcomings, we've added a few (small, easy to learn) helpers and utilities to the codebase, along with examples of how to use them.

- CSS is a powerful language, but it's cascading nature can make it difficult to debug (figure out why it's not behaving as expected), and maintain (add new styles without breaking existing styles) over time. Because of this, it's one of the most common places that novice developers get stuck when starting out. [Single-purpose CSS classes](https://tailwindcss.com/docs/utility-first) address this, by providing a-single-way-to-do-styling which prevents collisions and makes it very obvious where a style is being applied. We use [Tailwind](https://tailwindcss.com/) for this. You can browse the classes that are available to you by default here.
- Another shortcoming of plain HTML is that it doesn't provide a way to easily update a **part** of a webpage or screen when a user clicks on or interacts with another part of it. Instead it requires the page undergo a full reload to load in new content. This can make interfaces feel slow, and falls short of the expectations of the average internet software user. We use [htmx](https://htmx.org/) to fill this gap.


## Principles

#### Codebase Accessibility (Pothole Removal)
- 

#### Locality Of Behaviour 
  - Aka No Separation without Strong Justification

#### Use the Platform
- Why? Future-proof codebase. Will run with browsers in 10+ years 


#### No Obfuscation without Strong Justification
  - What's obfuscation?
    - Type A: Obfuscation by separation
      - Aka "Working Memory obfuscation" aka "Frontend Separation of concerns"
    - Type B: Obfuscation as Translation
  - Good reasons to obfuscate
    - Security    
      - ActiveRecord
    - Readability/Ergonomics
      - This is targeted at SQL. While widespread - it is, quite frankly, 
  - Bad reasons to obfuscate
    - Because 
    - "Because there's a gem for it"
      - E.g. adding gems to add other libraries. Just add the library directly
    - Code aesthetics
      - This is tricky and often subjective - particularly the lines between aesthetics and readability. 
  - Notes
    - On rest APIs: In my experience it's almost always to use a rest API directly (with something like HTTParty), than via a wrapper or SDK. With the latter, you ultimately need to understand two syntaxes for the same thing (it's rare to not need to read the underlying API docs anywaay)
### Order of operations
  - HTML
    - 
  - CSS
    - Inline Tailwind
    - Inline CSS
    - custom.css
  - JS
    - 
-



## For Technical People

Setup
- `bundle install`
- `curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash`
- `nvm install --lts`
- `npm install -D tailwindcss`

Refreshing the purged CSS 

```
npx tailwindcss -o ./public/stylesheets/tailwind-trimmed.css
```