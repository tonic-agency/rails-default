
Principles
- Use the Platform
  - Why?
    - Future-proof codebase. Will run with browsers in 10+ years 
- Locality Of Behaviour 
  - Aka No Separation without Strong Justification
- Rails as an HTML container
  - This mainly just means default to using vanilla html/js over the libraries that rails loads in.
- No Obfuscation without Strong Justification
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
- Order of operations
  - HTML
    - 
  - CSS
    - Inline Tailwind
    - Inline CSS
    - custom.css
  - JS
    - 
-


- Modals
  - Clicking the link does two things:
    - Loads the content of /modal into the #main-modal-content div
    - Triggers showModal(), which is defined in custom.js 
      - Simply removes the .hidden class
  - Powered by: combination of htmx & global js.. Why?
    - No external libraries - easy to understand what's happening
    - HTML & JS code is easy to access/read through.
    - Show/hide modal function could technically be inlined, but 1. Is likely to have additional behaviour added, and 2. Is used in multiple places

- Tooltips
  - Powered By: External Library. Why?
    - Dynamic positioning is a difficult problem, not solvable with vanilla js.
    - Why Tippy? Explored a lot - needed something that was 1. Lightweight, 2. Easy to use

- Toasts

- NavClicks
  - A pretty common shortcoming in server-side-rendered apps is that there can be a lag between when a user clicks an element (for example a menu link), and when the server shows the new screen or page. To combat this, we have the concept of a NavClick. A NavClick does two things: 1. Immediately gives the clicked element the active styling, and 2. Displays a shimmer effect in the part of the page where the content is expected to load. When combined with htmx's hx-get and hx-target, the user experience is identical to the experience in a polished frontend app.


- Instant Search
  - Powered By: HTMX/ Server side rendering. Why?
    - Server side rendering: Very easy to manage.
    - HTMX: Simple to understand/reuse. Requires no javascript.

- Datepickers
  - Default browser datepicker with onclick. Why?
    - Covers most cases

- Custom Form Elements - Dropdown
  - Plain HTML with inline js & events. Why?
    - IME these behaviours often differ in subtle ways - building one-compon

- Custom Form Elements - Multi Select
  - 
