module AwsSesNewsletters
  class HtmlBuilder
    include Rails.application.routes.url_helpers
    include ActionView::Helpers
    include ActionView::Rendering

    attr_accessor :template_name

    def initialize
      initialize_template_name
      initialize_variables
    end

    def build
      template = File.read(template_name)
      renderer = ERB.new(template)
      html_string = renderer.result(get_binding)
      inline_html_string = Premailer.new(html_string, warn_level: Premailer::Warnings::SAFE, with_html_string: true).to_inline_css
      return inline_html_string.gsub(/\n/, "")
    end

    def get_binding
      binding()
    end
  end
end