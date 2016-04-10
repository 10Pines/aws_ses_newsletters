FactoryGirl.define do
  factory :aws_ses_newsletters_newsletter, class: 'AwsSesNewsletters::Newsletter' do
    from "MyString"
    subject "MyString"
    html_body "MyText"
    text_body "MyText"
  end
end
