FactoryGirl.define do
  factory :aws_ses_newsletters_email_response, class: 'AwsSesNewsletters::EmailResponse' do
    email "MyString"
    extra_info "MyText"
    response_type 1
  end
end
