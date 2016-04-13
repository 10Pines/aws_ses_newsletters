require 'aws_ses_newsletters/mail_builder'

module AwsSesNewsletters
  class NewslettersSender
    include ::Sidekiq::Worker
    attr_accessor :newsletter

    def perform
      @newsletter = create_newsletter
      send_emails
    end

    protected

    def send_emails
      mail = build_mail
      # html_body = mail.html_part.body.raw_source
      get_recipients do |recipient|
        # next if EmailResponse.exists?(email: recipient.email) # bounces & complaints

        mail.to = recipient.email
        # mail.html_part.body = html_body
        # do_custom_replacements_for(mail, recipient)
        begin
          SES.send_raw_email(mail)
        rescue StandardError => e
          Rails.logger.info e.message
        end
      end
    end

    def create_newsletter
      fail NotImplementedError
    end

    def get_recipients
      fail NotImplementedError
    end

    def get_images
      {}
    end

    # This method is called in case you want to replace via gsub something in the email to make it more customized
    def do_custom_replacements_for(mail, recipient)
    end

    private

    def build_mail
      AwsSesNewsletters::MailBuilder.new(
          from: newsletter.from,
          subject: newsletter.subject,
          html_body: newsletter.html_body,
          images: get_images,
      ).build
    end
  end
end
