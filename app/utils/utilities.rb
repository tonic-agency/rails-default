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
    hash = {
      "undefined" => {
        "tag_css_classes" => "bg-gray-100 text-gray-800",
        "tag_description" => "",
      },
      "tailwind" => {
        "tag_css_classes" => "bg-sky-400 text-white",
        "tag_description" => "Tailwind CSS is a utility-first CSS framework for rapidly building custom user interfaces.",
      },
      "hyperscript" => {
        "tag_css_classes" => "bg-sky-800 text-white",
        "tag_description" => "Hyperscript is a high performance, lightweight, front-end framework for adding interactivity to html.",
      },
      "tonic.css" => {
        "tag_css_classes" => "bg-blue-500 text-white",
        "tag_description" => "Hyperscript is a high performance, lightweight, front-end framework for adding interactivity to html.",
      },
      "htmx" => {
        "tag_css_classes" => "bg-gray-900 text-white",
        "tag_description" => "HTMX lets you easily send ajax requests using html attributes.",
      },
      "minijs" => {
        "tag_css_classes" => "bg-indigo-700 text-white",
        "tag_description" => "Mini Js is a new library from tonic designed to be extremely easy to understand and use."
      }
    } 
    if hash[tag].nil?
      return hash["undefined"]
    else
      return hash[tag]
    end
  end

end