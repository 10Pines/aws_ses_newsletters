require 'rails_helper'

module AwsSesNewsletters
  RSpec.describe NewslettersSender do
    it 'should raise not implemented error' do
      expect{NewslettersSender.new.perform}.to raise_error NotImplementedError
    end
  end
end
