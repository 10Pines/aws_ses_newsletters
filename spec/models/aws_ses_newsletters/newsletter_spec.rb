require 'rails_helper'

module AwsSesNewsletters
  RSpec.describe Newsletter, type: :model do
    it 'should create a Newsletter' do
      expect{Newsletter.create from: 'test@example.com', subject: 'News from the world!', html_body: '<p>News</p>'}.to change(Newsletter, :count).by(1)
    end
  end
end
