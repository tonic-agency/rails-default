# Technical Readme


### **Setup**

- `bundle install`
- `rake db:create`
- `rails s`


### Tailwind Support

"Eradicate Build Steps" is one of the principles of HTML First, so by default we use dumb-tailwind for our tailwind styling, which has 90% of the most used tailwind classes but doesn't require a compile step. This file is 750kb in size which may affect performance in some cases. If you would prefer to ship less CSS to production, you can use the steps below.

**Install NPM**

- `curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash`
- `nvm install --lts`

**Install Tailwind**

- `npm install -D tailwindcss`

**Refresh the purged CSS**

- `npx tailwindcss -o ./public/stylesheets/tailwind-trimmed.css`