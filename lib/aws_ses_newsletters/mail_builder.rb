module AwsSesNewsletters
  # Helper to build a Mail
  class MailBuilder
    attr_accessor :from, :to, :subject, :html_body, :images

    def initialize(from:, subject:, html_body:, images: [])
      @from = from
      @subject = subject
      @html_body = html_body
      @images = images
    end

    def build
      from = self.from
      subject = self.subject
      html_body = self.html_body
      images = self.images

      mail = Mail.new do
        from from
        subject subject
        html = html_body

        # attachments
        images.each do |key, value|
          attachments[key] = value
        end
        attachments.each do |attachment|
          (html = html.sub(attachment.filename, "cid:#{attachment.cid}")) if (html =~ /#{attachment.filename}/)
        end

        html_part do
          body html; content_type 'text/html; charset=UTF-8'
        end
      end
      mail.raise_delivery_errors = true
      mail
    end
  end
end
