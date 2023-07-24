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
      fenced_code_blocks: true
    )
    markdown.render(content)
  end

end