Rails.application.routes.draw do

  mount AwsSesNewsletters::Engine => "/aws_ses_newsletters"
end
