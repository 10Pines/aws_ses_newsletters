require 'rails_helper'
require 'ostruct'

module AwsSesNewsletters
  RSpec.describe NewslettersSender do
    let(:daily_newsletter_klass) do
      Class.new(NewslettersSender) do
        def create_newsletter
          Newsletter.create(from: 'fzuppa@esteticia.com',
                                               subject: 'These are the daily news',
                                               html_body: 'Great News Buddy'
          )
        end

        def get_recipients
          yield OpenStruct.new(email: 'fzuppa@10pines.com')
        end
      end
    end

    it 'should send email' do
      ::SES.should_receive(:send_raw_email)
      daily_newsletter_klass.new.perform
    end
  end
end
