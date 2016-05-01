require 'aws_ses_newsletters/mail_builder'

module AwsSesNewsletters
  # Inherit from this class to create a Newsletter and override *create_newsletter* & *get_recipients*
  # It is a Sidekiq::Worker, so the method that will be executed is *perform*, which creates a AwsSesNewsletters::Newsletter
  # and sends the newsletter to all defined recipients.
  class NewslettersSender
    include ::Sidekiq::Worker
    attr_accessor :newsletter

    SES = AWS::SES::Base.new(access_key_id: ENV['SES_ACCESS_KEY_ID'],
                             secret_access_key: ENV['SES_SECRET_ACCESS_KEY'])

    # this method is the one that is executed when starting a sidekiq process
    def perform
      @newsletter = create_newsletter
      send_emails
    end

    # Send a preview email
    def preview_to(recipient)
      @newsletter = build_newsletter
      mail = build_mail
      mail.to = recipient.email
      replace_and_send_mail_safely(mail, recipient)
    end
    protected

    # Iterate over recipients and sends emails
    def send_emails
      mail = build_mail
      get_recipients do |recipient|
        unless EmailResponse.exists?(email: recipient.email) # bounces & complaints
          mail.to = recipient.email
          replace_and_send_mail_safely(mail, recipient)
        end
      end
    end

    # Override this method to create a AwsSesNewsletters::Newsletter
    # ==== Example
    # AwsSesNewsletter::Newsletter.create(from: 'you@example.com', subject: 'newsletter subject', html_body: '<p>Newsletter here</p>')
    def create_newsletter
      fail NotImplementedError
    end

    # Override this method to build a AwsSesNewsletters::Newsletter to preview
    # ==== Example
    # AwsSesNewsletter::Newsletter.new(from: 'you@example.com', subject: 'newsletter subject', html_body: '<p>Newsletter here</p>')
    def build_newsletter
      fail NotImplementedError
    end

    # Override this method to get the recipients, yielding for every recipient you want to send an email to
    # It is recommended to batch if there are many recipients
    # ==== Example
    # User.where(wants_newsletter: true).find_in_batches(batch_size: 100) do |group|
    #   group.each do |recipient|
    #     yield recipient
    #   end
    # end
    def get_recipients
      fail NotImplementedError
    end

    # override this method if you want to inline images
    # return a Hash where the key is the key used in the template and the value is the file
    def get_images
      {}
    end

    # Perform custom replacements and send the email without throwing any exception
    def replace_and_send_mail_safely(mail, recipient)
      html_body = mail.html_part.body.raw_source
      do_custom_replacements_for(mail, recipient)
      send_raw_email_safely(mail)
      mail.html_part.body = html_body
    end

    # calls aws-ses *send_raw_email* with a +mail+
    def send_raw_email_safely(mail)
      begin
        SES.send_raw_email(mail)
      rescue StandardError => e
        Rails.logger.info e.message
      end
    end

    # Override this method to perform a replacement for a particular email
    # Usually you will want to override the body
    # ==== Example
    # mail.html_part.body = mail.html_part.body.raw_source.gsub('recipient_email', recipient.email)
    def do_custom_replacements_for(mail, recipient)
    end

    private

    # Builds a Mail
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
