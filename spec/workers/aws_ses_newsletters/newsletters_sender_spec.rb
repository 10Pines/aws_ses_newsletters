require 'rails_helper'
require 'ostruct'

module AwsSesNewsletters
  RSpec.describe NewslettersSender do
    let(:daily_newsletter_klass) do
      Class.new(AwsSesNewsletters::NewslettersSender) do
        def create_newsletter
          Newsletter.create(from: 'federico@10pines.com',
            subject: 'These are the daily news',
            html_body: 'Great News Buddy. http://unsubscribe?email=recipient_email'
          )
        end

        def get_recipients
          [OpenStruct.new(email: 'hernan@10pines.com'), OpenStruct.new(email: 'emilio@10pines.com')].each do |recipient|
            yield recipient
          end
        end

        def do_custom_replacements_for(mail)
          mail.html_part.body.raw_source.gsub('recipient_email', mail.to.to_s)
        end

        def build_newsletter
          Newsletter.new(from: 'federico@10pines.com',
            subject: 'These are the daily news',
            html_body: 'Great News Buddy. http://unsubscribe?email=recipient_email'
          )
        end
      end
    end

    it 'should send email' do
      expect(::SES).to receive(:send_raw_email).twice
      daily_newsletter_klass.new.perform
    end

    it 'should not send email when exists in EmailResponse' do
      FactoryGirl.create(:aws_ses_newsletters_email_response, email: 'bounced@example.com')
      expect(::SES).to_not receive(:send_raw_email)
      bounced_newsletter = Class.new(daily_newsletter_klass) do
        def get_recipients
          yield OpenStruct.new(email: 'bounced@example.com')
        end
      end
      bounced_newsletter.new.perform
    end

    it 'should leave original email intact after replacing and sending' do
      daily_newsletter = daily_newsletter_klass.new
      daily_newsletter.instance_variable_set(:@newsletter, daily_newsletter.create_newsletter)
      mail = daily_newsletter.send(:build_mail)
      mail.to = 'hernan@10pines.com'
      original_html_body = mail.html_part.body.raw_source
      allow(::SES).to receive(:send_raw_email)
      daily_newsletter.send(:replace_and_send_mail_safely, mail)
      expect(mail.html_part.body.raw_source).to eq original_html_body
    end

    it 'should send preview email' do
      expect(::SES).to receive(:send_raw_email)
      daily_newsletter_klass.new.preview_to('federico@10pines.com')
    end
  end
end
