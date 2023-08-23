## Novice Friendliness as a core Design Principle

I've written more about this in my blog [here](https://new.tonyennis.com/blog/f_8e9B0u6-nfacdp). 


The main idea behind the way we approach this codebase is: If the "learn-ability" of a codebase rises in step with each new concept added, then we should start with a few very simple concepts (html elements and properties), defer introducing more difficult concepts (and skills) until later, and not add new concepts to our codebase that will reduce it's learn-ability unless absolutely necessary. 

## Write Code. Not too much. Mostly HTML. 

Given that 1. There are orders of magnitude more people who understand HTML than who understand {insert library here}, and 2. HTML conceptually has a very low learning curve, our goal is to make our codebase readable and modifiable by as wide an audience as possible. 

We use Rails for the things that plain HTML can't do - creating routes and templates, communicating with a database, and a few other small utilities. But we intentionally don't use many of the "Rails Way" patterns and libraries in places where limited value is offered over a plain HTML approach, and/or where an entirely new set of concepts/patterns needs to be learned.

## Make behaviour obvious


## Beware unnecessary obfuscation



