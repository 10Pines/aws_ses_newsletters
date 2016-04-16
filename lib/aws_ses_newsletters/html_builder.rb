require 'premailer'

module AwsSesNewsletters
  class HtmlBuilder
    include Rails.application.routes.url_helpers
    include ActionView::Helpers
    include ActionView::Rendering

    attr_accessor :template_name

    def initialize(template_name, instance_variables_hash = nil)
      @template_name = template_name
      instance_variables_hash.each { |name, value| instance_variable_set("@#{name}", value) } if instance_variables_hash.present?
    end

    def build
      template = File.read(template_name)
      renderer = ERB.new(template)
      html_string = renderer.result(get_binding)
      inline_html_string = ::Premailer.new(html_string, warn_level: Premailer::Warnings::SAFE, with_html_string: true).to_inline_css
      return inline_html_string.gsub(/\n/, "")
    end

    def get_binding
      binding()
    end
  end
end