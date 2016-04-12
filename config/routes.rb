AwsSesNewsletters::Engine.routes.draw do
  # SNS
  post 'email_responses/bounce' => 'email_responses#bounce'
  post 'email_responses/complaint' => 'email_responses#complaint'
end
