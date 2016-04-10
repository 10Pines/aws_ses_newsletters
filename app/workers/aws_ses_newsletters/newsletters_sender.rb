require 'aws_ses_newsletters/mail_builder'

module AwsSesNewsletters
  class NewslettersSender
    include ::Sidekiq::Worker
    attr_accessor :newsletter

    def perform
      create_newsletter
      send
    end

    protected

    def send
      mail = build_mail
      # html_body = mail.html_part.body.raw_source
      get_recipients do |group_of_recipients|
        group_of_recipients.each do |recipient|
          # next if EmailResponse.exists?(email: recipient.email) # bounces & complaints

          mail.to = recipient.email
          # mail.html_part.body = html_body
          # do_custom_replacements_for(mail, recipient)
          begin
            SES.send_raw_email(mail)
          rescue StandardError => e
          end
        end
      end
    end

    def create_newsletter
      fail NotImplementedError
    end

    def get_recipients
      fail NotImplementedError
    end

    def build_mail
      AwsSesNewsletters::MailBuilder.new(
          from: get_from,
          subject: get_subject,
          html_body: get_html_body,
          images: get_images,
      ).build
    end

    def get_from
      newsletter.from
    end

    def get_subject
      newsletter.subject
    end

    def get_html_body
      newsletter.html_body
    end

    def get_images
      {}
    end

    # This method is called in case you want to replace via gsub something in the email to make it more customized
    def do_custom_replacements_for(mail, recipient)
    end
  end
end
