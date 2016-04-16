require 'aws_ses_newsletters/mail_builder'

module AwsSesNewsletters
  class NewslettersSender
    include ::Sidekiq::Worker
    attr_accessor :newsletter

    def perform
      @newsletter = create_newsletter
      send_emails
    end

    def preview_to(email)
      @newsletter = build_newsletter
      mail = build_mail
      mail.to = email
      replace_and_send_mail_safely(mail)
    end
    protected

    def send_emails
      mail = build_mail
      get_recipients do |recipient|
        next if EmailResponse.exists?(email: recipient.email) # bounces & complaints
        mail.to = recipient.email
        replace_and_send_mail_safely(mail)
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

    def replace_and_send_mail_safely(mail)
      html_body = mail.html_part.body.raw_source
      do_custom_replacements_for(mail)
      send_raw_email_safely(mail)
      mail.html_part.body = html_body
    end

    # This method is called in case you want to do some replacements
    def do_custom_replacements_for(mail, *args)
    end

    def send_raw_email_safely(mail)
      begin
        ::SES.send_raw_email(mail)
      rescue StandardError => e
        Rails.logger.info e.message
      end
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
