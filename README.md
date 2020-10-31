# README

This repository is an easily-forkable, stripped-back Rails codebase which includes only Tailwind & Editmode, and is intended to demonstrate how quickly you can get up and running building a website on Rails. It is **designed for beginners**. If you know even a little HTML and CSS, and you have Codespaces access, you should still be able to get up and running. This is because we've intentionally left out things which require additional proficiency such as webpack or npm.  

#### Works with Github codespaces
Github Codespaces allow you to run a full development environment in your browser, complete with the VSCode editor.

## Directions

First, go to Github Codespaces, select "Create new codespace", and enter in the path of this repo (currently editmodelabs/rails-starter).

Once the environment has been created, open your Terminal and run 

`bundle install`

Wait for a minute or so, then run 

`rails s`

#### Congratulations, you're now running your first rails app on codespaces

To allow others to see your app on the internet, we need to take one more step. Click on the "Remote" tab on the left of the interface, and find the "Forwarded Ports" section. Then forward port 3000. Now, click the globe icon to view your live rails app.
