require 'rails_helper'
require 'aws_ses_newsletters/html_builder'

module AwsSesNewsletters
  RSpec.describe HtmlBuilder do
    it 'should build an html' do
      html = HtmlBuilder.new('spec/test_app/app/views/daily_newsletters/simple.html.erb').build
      expect(html).to include('This is a simple email')
      # style should be embedded in emails
      expect(html).to include('style="font-size: 24px"')
    end

    it 'should replace instance variables in the template' do
      @promotions = [OpenStruct.new(name: '10% off this week')]
      html = HtmlBuilder.new('spec/test_app/app/views/daily_newsletters/default.html.erb', {promotions: @promotions}).build
      expect(html).to include('10% off this week')
    end
  end
end
