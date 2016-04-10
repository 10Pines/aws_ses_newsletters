require 'aws_ses_newsletters/html_builder'

class PromotionsHtmlBuilder < AwsSesNewsletters::HtmlBuilder
  def initialize_template_name
    @template_name = "#{::Rails.root}/app/views/daily_newsletters/default.html.erb"
  end

  def initialize_variables
    @promotions = [Promotion.new('Promoción Imperdible')]
  end
end