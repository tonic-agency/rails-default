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

<img src="/images/layouts.png" style="max-width:500px" alt="Diagram explaining layouts" />

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