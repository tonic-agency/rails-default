module Utilities
   
  def self.markdown_to_html(filename)
    content = File.read(filename)
    markdown = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML.new(
        hard_wrap: true,
        link_attributes: { target: '_blank' },
        fenced_code_blocks: true,
      ),
      autolink: true, 
      space_after_headers: true,
      fenced_code_blocks: true,
      tables: true 
    )
    markdown.render(content)
  end

  def self.tag_metadata(tag="")
    hash = Utilities.library_list
    if hash[tag].nil?
      return hash["undefined"]
    else
      return hash[tag]
    end
  end

  def self.library_list 
    {
      "undefined" => {
        "tag_css_classes" => "bg-gray-100 text-gray-800",
        "tag_description" => "",
      },
      "tailwind" => {
        "type" => "css",
        "tag_css_classes" => "bg-sky-400 text-white",
        "tag_description" => "Tailwind CSS is a utility-first CSS framework for rapidly building custom user interfaces.",
      },
      "hyperscript" => {
        "type" => "js",
        "tag_css_classes" => "bg-sky-800 text-white",
        "tag_description" => "Hyperscript is a high performance, lightweight, front-end framework for adding interactivity to html.",
      },
      "tonic.css" => {
        "type" => "css",
        "tag_css_classes" => "bg-blue-500 text-white",
        "tag_description" => "Hyperscript is a high performance, lightweight, front-end framework for adding interactivity to html.",
      },
      "htmx" => {
        "tag_css_classes" => "bg-gray-900 text-white",
        "tag_description" => "HTMX lets you easily send ajax requests using html attributes.",
      },
      "minijs" => {
        "type" => "js",
        "tag_css_classes" => "bg-indigo-700 text-white",
        "tag_description" => "Mini Js is a new library from tonic designed to be extremely easy to understand and use."
      },
      "vanilla" => {
        "type" => "js",
        "tag_css_classes" => "bg-indigo-700 text-white",
        "tag_description" => "Vanilla"
      }
    } 
  end

  def self.js_library_list
    Utilities.library_list.select{|k,v| v["type"] == "js"}
  end

  def self.code_snippet_types
    {
      :dropdown => {
        :name => "Dropdown"
      },
      :modal => { 
        :name => "Modal"
      },
      :toast => {
        :name => "Toast"
      },
      :accordion => {
        :name => "Accordion"
      }
    }
  end

  def self.get_snippet_files(properties={})

    views_dir = Rails.root.join('app', 'views', 'examples')

    # Array to hold the names of files that match the criteria
    matching_files = []

    # Iterate over each file in the directory
    Dir.glob("#{views_dir}/*").each do |file_path|
      # Read the contents of the file
      content = File.read(file_path)

      # Use FrontMatterParser to parse the frontmatter
      begin
        # Use FrontMatterParser to parse the frontmatter from the file
        parsed = FrontMatterParser::Parser.parse_file(file_path)
      rescue FrontMatterParser::SyntaxError
        # Handle files that don't have valid frontmatter
        next
      end
      
      # Check if the file's frontmatter matches all the given properties
      matches_all_properties = properties.all? do |key, value|
        parsed.front_matter[key.to_s]  == value
      end
      matching_files << File.basename(file_path) if matches_all_properties
    
    end

    matching_files

  end

end