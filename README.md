# Easy Rails

This repository is designed to be the absolute *simplest* way to build web interfaces or applications as someone with limited experience. The documentation below will assume you have no knowledge of Ruby on Rails, and moderate/basic knowledge of HTML and CSS.

### Write Code. Not too much. Mostly HTML. 

Conceptually, basic HTML is as low on the difficulty scale as you can get when it comes to building web software. This codebase, while built on top of Ruby on Rails, is designed primarily to be a container for html. We provide a few helper libraries to add some minor additional functionality to html, and a collection of cheat sheets with one-liners and examples, all centered around html, which should unlock 95%+ of the use cases you're likely to encounter.

**For when the platform falls short...**

While we believe in **minimising** external libraries and relying on pure HTML as much as possible, there are a few places that we've added (small, simple) enhancements to plain 'ol html/css.

- Single-purpose CSS classes make it substantially easier to write and maintain CSS, by providing a-single-way-to-do-things (reducing the amount of decisions to be made). They are super quick to write, very readable, and that won't be accidentally broken later on. We use Tailwind for this. You can browse the classes that are available to you by default here.
- One shortcoming of plain HTML is that it doesn't provide a way to easily update a **part** of a webpage or screen when a user clicks on or interacts with another part of it. Instead it requires the page undergo a full reload to load in new content. This can make interfaces feel slow, and falls short of the expectations of the average internet software user. We use htmx to fill this gap.
- Performance: As your screens grow in size, the load speed of your page can get slower. Google page speed insights tells you how fast your pages are, and lists a number of ways to keep your application snappy on mobile and slower connections. Some of these patterns use non-standard ways of writing HTML but are important to keep your app fast. Two examples in this codebase are working with icons and loading in CSS and javascript files.

## Core Patterns

#### Adding a Screen

**To add a new screen to your application...**

Add a new line to `config/routes.rb`

```ruby
get "/home" => "site#home", as: "home"
```
Create a new view file with the html content you want to show when a visitor visits this route. For example, for the above route, we'd create a file called `/app/views/site/home.html.erb`. Note that it must end with .erb. You can now add whatever html you like into this file, and it will be rendered when a user visits `/home`.

#### Working With Layouts and Templates

**Folder Structure and the Layout file**
While your view files are written primarily in HTML, there are a few things you can do with them that you can't do with normal HTML. First, every new screen you create (as per the directions above) is "wrapped" in the content defined in your layout file, which you can find at `/app/views/layouts/application.html.erb`

<img src="/images/layouts.png" style="max-width:500px" />

**Template Partials**
You can render html files inside other html files by using the `<%= render :partial => "" %>` syntax. For example, imagine you create a file at `/app/views/templates/page_footer.html.erb` with the following content:

```html
<div>
  Copyright 2023 My Website
</div>
```

You can include that block of html in any page you want, using the following pattern: 

```html
<div id="footer">
  <%= render partial => "templates/page_footer" %>
</div>
```

Read more about templating.

#### Working with Icons

Icons are a key part of any user interface. The best format to use for icons is svg, as they load fast and can be scaled up and down without losing quality. In basic html, to load an svg file, we would just use a normal image tag, such as `<img src='my-icon.svg' />`. This has two shortcomings: 1. It's very cumbersome to modify the icon's color, and 2. If there are a lot of icons on your page, your performance can take a hit. To account for this, we load icons slightly differently than normally.

- Icons are stored in the `/app/assets/icons` directory. This repository comes pre-loaded with both heroicons and tabler icons, which are free to use, look great, and cover almost all use cases.
- You can use tailwind classes to style your icons. Use the width and height classes ("w-4 h-4") to style the size, and the text color classes ("text-blue-400") to change the color.

To render an icon, use the following snippet and swap out the name of the file and the classes as necessary.

```
<%= inline_svg_tag("/heroicons/icon-chevron-right.svg", class: "w-5 text-indigo-500" ) %>
```

#### Modals



## For Technical People

