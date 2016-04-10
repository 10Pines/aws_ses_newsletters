class DailyNewslettersSender < AwsSesNewsletters::NewslettersSender

  def create_newsletter
    @newsletter = AwsSesNewsletters::Newsletter.create(from: 'fzuppa@esteticia.com',
      subject: 'These are the daily news',
      html_body: '<p>The daily news will go here</p>'
    )
  end

  def get_recipients
    recipient = Recipient.new('fzuppa@gmail.com', 'Federico', 'Zuppa')
    yield [recipient]
  end
end