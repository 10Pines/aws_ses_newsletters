require 'newsletters/promotions_html_builder'

class DailyNewslettersSender < AwsSesNewsletters::NewslettersSender

  def create_newsletter
    @newsletter = AwsSesNewsletters::Newsletter.create(from: 'fzuppa@esteticia.com',
      subject: 'These are the daily news',
      html_body: PromotionsHtmlBuilder.new.build
    )
  end

  def get_recipients
    recipient = Recipient.new('fzuppa@gmail.com', 'Federico', 'Zuppa')
    yield [recipient]
  end
end