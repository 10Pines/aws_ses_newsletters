require 'rails_helper'

module AwsSesNewsletters
  RSpec.describe EmailResponsesController, type: :controller do
    routes { AwsSesNewsletters::Engine.routes }

    describe '#bounce' do
      let(:bounce_json) do
        %q{
        {
          "Type" : "Notification",
          "MessageId" : "2d222228-90e1-5ba1-9784-9c60222222e5",
          "TopicArn" : "arn:aws:sns:eu-west-1:863122222282:yourapp_bounces",
          "Message" : "{\"notificationType\":\"Bounce\",\"bounce\":{\"bounceSubType\":\"General\",\"bounceType\":\"Permanent\",\"bouncedRecipients\":[{\"status\":\"5.1.1\",\"action\":\"failed\",\"diagnosticCode\":\"smtp; 550 5.1.1 user unknown\",\"emailAddress\":\"bounce@simulator.amazonses.com\"}],\"reportingMTA\":\"dsn; a6-26.smtp-out.eu-west-1.amazonses.com\",\"timestamp\":\"2015-01-21T00:37:34.429Z\",\"feedbackId\":\"00000122222225fb-9a217d45-8eed-4403-b7d9-172222222be7-000000\"},\"mail\":{\"timestamp\":\"2015-01-21T00:37:33.000Z\",\"source\":\"no-reply@yourdomain.com\",\"destination\":[\"bounce@simulator.amazonses.com\"],\"messageId\":\"000222222222429c-49e59593-7f16-44e3-b5a2-1a222222222c6-000000\"}}",
          "Timestamp" : "2015-01-21T00:37:34.452Z",
          "SignatureVersion" : "1",
          "Signature" : "ZmtUp+wmfSNUW0dGkzVN9A9Q7R88KwfU32zXTHn43pppZAd6pJlwKRdH/B9Ui4M1Sd1gC1Zi2WgLtC2Xi7kf60bdi66a222222222222QKeRy1GbqWfT9kcOvm4aAFlRy0FoDu2FD9iyGPu62RsABlNzLYGNI1YnmIKwHSXXy/St4MMwwGjGLprZsRSSimM/B9VJr5WCzwMmKYr/kWGVr3pN8B5WMRuFw0pYBIemJoZugkHElEypz8KNVRxSwRN3Iz7me38mMDPCs1xiv/6IyNQXu1pdtEWkAPb26feK3SuBpPNpTQtbnaZvt7wNSw==",
          "SigningCertURL" : "https://sns.eu-west-1.amazonaws.com/SimpleNotificationService-d6d622222222222222221f4f9e198.pem",
          "UnsubscribeURL" : "https://sns.eu-west-1.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:eu-west-1:82222222222282:yourapp_bounces:222222224f-7a0a-4e07-b34d-4a662222222226"
        }

      }
      end

      let(:bounce_with_delivery_notification_json) do
        %q{
        {
          "Type" : "Notification",
          "MessageId" : "2d222228-90e1-5ba1-9784-9c60222222e5",
          "TopicArn" : "arn:aws:sns:eu-west-1:863122222282:yourapp_bounces",
          "Message" : "{\"notificationType\":\"Bounce\",\"bounce\":{\"bounceType\":\"Permanent\",\"bounceSubType\": \"General\",\"bouncedRecipients\":[{\"emailAddress\":\"recipient1@example.com\"}],\"timestamp\":\"2012-05-25T14:59:38.237-07:00\",\"feedbackId\":\"00000137860315fd-869464a4-8680-4114-98d3-716fe35851f9-000000\"},\"mail\":{\"timestamp\":\"2012-05-25T14:59:38.237-07:00\",\"messageId\":\"00000137860315fd-34208509-5b74-41f3-95c5-22c1edc3c924-000000\",\"source\":\"email_1337983178237@amazon.com\",\"sourceArn\": \"arn:aws:ses:us-west-2:888888888888:identity/example.com\",\"sendingAccountId\":\"123456789012\",\"destination\":[\"bounce@simulator.amazonses.com\"]}}",
          "Timestamp" : "2015-01-21T00:37:34.452Z",
          "SignatureVersion" : "1",
          "Signature" : "ZmtUp+wmfSNUW0dGkzVN9A9Q7R88KwfU32zXTHn43pppZAd6pJlwKRdH/B9Ui4M1Sd1gC1Zi2WgLtC2Xi7kf60bdi66a222222222222QKeRy1GbqWfT9kcOvm4aAFlRy0FoDu2FD9iyGPu62RsABlNzLYGNI1YnmIKwHSXXy/St4MMwwGjGLprZsRSSimM/B9VJr5WCzwMmKYr/kWGVr3pN8B5WMRuFw0pYBIemJoZugkHElEypz8KNVRxSwRN3Iz7me38mMDPCs1xiv/6IyNQXu1pdtEWkAPb26feK3SuBpPNpTQtbnaZvt7wNSw==",
          "SigningCertURL" : "https://sns.eu-west-1.amazonaws.com/SimpleNotificationService-d6d622222222222222221f4f9e198.pem",
          "UnsubscribeURL" : "https://sns.eu-west-1.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:eu-west-1:82222222222282:yourapp_bounces:222222224f-7a0a-4e07-b34d-4a662222222226"
        }

      }
      end

      it 'creates a new bounce record' do
        expect {
          post :bounce, bounce_json, format: :json
        }.to change(EmailResponse, :count).by(1)
      end

      it 'creates a new bounce record with delivery status' do
        expect {
          post :bounce, bounce_with_delivery_notification_json, format: :json
        }.to change(EmailResponse, :count).by(1)
      end

      it 'saves the information it should' do
        allow(EmailResponse).to receive(:create)
        expect(EmailResponse).to receive(:create).with(hash_including(email: 'bounce@simulator.amazonses.com', response_type: 'bounce', extra_info: "status: 5.1.1, action: failed, diagnosticCode: smtp; 550 5.1.1 user unknown"))
        post :bounce, bounce_json, format: :json
      end
    end
    describe '#complaint' do

      let(:complaint_json) do
        %q{
      {
        "Type" : "Notification",
        "MessageId" : "092cf767-9156-5244-b2d5-ba2222225436",
        "TopicArn" : "arn:aws:sns:eu-west-1:8622222222243:yourapp_email_complaints",
        "Message" : "{\"notificationType\":\"Complaint\",\"complaint\":{\"complaintFeedbackType\":\"abuse\",\"complainedRecipients\":[{\"emailAddress\":\"complaint@simulator.amazonses.com\"}],\"userAgent\":\"Amazon SES Mailbox Simulator\",\"timestamp\":\"2015-01-21T12:56:53.000Z\",\"feedbackId\":\"0000014b022222e7-f934da45-a45c-11e4-9559-192222eb80f1-000000\"},\"mail\":{\"timestamp\":\"2015-01-21T12:56:52.000Z\",\"source\":\"no-reply@yourdomain.com\",\"destination\":[\"complaint@simulator.amazonses.com\"],\"messageId\":\"0000014b0c911fd2-c7eb049f-f610-4b56-6541-2e2222249521-000000\"}}",
        "Timestamp" : "2015-01-21T12:56:54.396Z",
        "SignatureVersion" : "1",
        "Signature" : "u7u/zeRG5KC3K7CpXll22222fwbrAGMn9rZZTTxmy2vrIyioEpIXtCaT6MhjUum2erYBi0Doo8K0/nmD+vNJMK43+IGtqsjQZeEwtr6cWDDJyrxoX53a18fp9YqBNTzwvu9TOkTNn3fUhqbumw9fH1+ltQ3qeDRP1DrpkJczQ080cZPmkF2xeDL2222IDlZJJkWpvivIrt9ZBS/lW4HU0UpjvHVAZhxgZyUoWuRMOM7j3q3aRh/RB9aHOOAw8wdfg5ie8vHSbcEOVdj2fakGfUM3kCVrgm983AjJt2SA==",
        "SigningCertURL" : "https://sns.eu-west-1.amazonaws.com/SimpleNotificationService-d6d679a1d2222522222222222198.pem",
        "UnsubscribeURL" : "https://sns.eu-west-1.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:eu-west-1:863132222282:yourapp_email_complaints:0222222c-d183-45d8-b0ac-787d02222084"
      }
    }
      end

      let(:complaint_wo_feedback_report_json) do
        %q{
      {
        "Type" : "Notification",
        "MessageId" : "092cf767-9156-5244-b2d5-ba2222225436",
        "TopicArn" : "arn:aws:sns:eu-west-1:8622222222243:yourapp_email_complaints",
        "Message" : "{\"notificationType\":\"Complaint\",\"complaint\":{\"complainedRecipients\":[{\"emailAddress\":\"recipient1@example.com\"}],\"timestamp\":\"2012-05-25T14:59:38.613-07:00\",\"feedbackId\":\"0000013786031775-fea503bc-7497-49e1-881b-a0379bb037d3-000000\"},\"mail\":{\"timestamp\":\"2012-05-25T14:59:38.613-07:00\",\"messageId\":\"0000013786031775-163e3910-53eb-4c8e-a04a-f29debf88a84-000000\",\"source\":\"email_1337983178613@amazon.com\",\"sourceArn\": \"arn:aws:ses:us-west-2:888888888888:identity/example.com\",\"sendingAccountId\":\"123456789012\",\"destination\":[\"recipient1@example.com\",\"recipient2@example.com\",\"recipient3@example.com\",\"recipient4@example.com\"]}}",
        "Timestamp" : "2015-01-21T12:56:54.396Z",
        "SignatureVersion" : "1",
        "Signature" : "u7u/zeRG5KC3K7CpXll22222fwbrAGMn9rZZTTxmy2vrIyioEpIXtCaT6MhjUum2erYBi0Doo8K0/nmD+vNJMK43+IGtqsjQZeEwtr6cWDDJyrxoX53a18fp9YqBNTzwvu9TOkTNn3fUhqbumw9fH1+ltQ3qeDRP1DrpkJczQ080cZPmkF2xeDL2222IDlZJJkWpvivIrt9ZBS/lW4HU0UpjvHVAZhxgZyUoWuRMOM7j3q3aRh/RB9aHOOAw8wdfg5ie8vHSbcEOVdj2fakGfUM3kCVrgm983AjJt2SA==",
        "SigningCertURL" : "https://sns.eu-west-1.amazonaws.com/SimpleNotificationService-d6d679a1d2222522222222222198.pem",
        "UnsubscribeURL" : "https://sns.eu-west-1.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:eu-west-1:863132222282:yourapp_email_complaints:0222222c-d183-45d8-b0ac-787d02222084"
      }
    }
      end

      let(:abuse_complaint_json) do
        %q{
      {
        "Type" : "Notification",
        "MessageId" : "092cf767-9156-5244-b2d5-ba2222225436",
        "TopicArn" : "arn:aws:sns:eu-west-1:8622222222243:yourapp_email_complaints",
        "Message" : "{\"notificationType\":\"Complaint\",\"complaint\":{\"userAgent\":\"Comcast Feedback Loop (V0.01)\",\"complainedRecipients\":[{\"emailAddress\":\"recipient1@example.com\"}],\"complaintFeedbackType\":\"abuse\",\"arrivalDate\":\"2009-12-03T04:24:21.000-05:00\",\"timestamp\":\"2012-05-25T14:59:38.623-07:00\",\"feedbackId\":\"000001378603177f-18c07c78-fa81-4a58-9dd1-fedc3cb8f49a-000000\"},\"mail\":{\"timestamp\":\"2012-05-25T14:59:38.623-07:00\",\"messageId\":\"000001378603177f-7a5433e7-8edb-42ae-af10-f0181f34d6ee-000000\",\"source\":\"email_1337983178623@amazon.com\",\"sourceArn\": \"arn:aws:ses:us-west-2:888888888888:identity/example.com\",\"sendingAccountId\":\"123456789012\",\"destination\":[\"recipient1@example.com\",\"recipient2@example.com\",\"recipient3@example.com\",\"recipient4@example.com\"]}}",
        "Timestamp" : "2015-01-21T12:56:54.396Z",
        "SignatureVersion" : "1",
        "Signature" : "u7u/zeRG5KC3K7CpXll22222fwbrAGMn9rZZTTxmy2vrIyioEpIXtCaT6MhjUum2erYBi0Doo8K0/nmD+vNJMK43+IGtqsjQZeEwtr6cWDDJyrxoX53a18fp9YqBNTzwvu9TOkTNn3fUhqbumw9fH1+ltQ3qeDRP1DrpkJczQ080cZPmkF2xeDL2222IDlZJJkWpvivIrt9ZBS/lW4HU0UpjvHVAZhxgZyUoWuRMOM7j3q3aRh/RB9aHOOAw8wdfg5ie8vHSbcEOVdj2fakGfUM3kCVrgm983AjJt2SA==",
        "SigningCertURL" : "https://sns.eu-west-1.amazonaws.com/SimpleNotificationService-d6d679a1d2222522222222222198.pem",
        "UnsubscribeURL" : "https://sns.eu-west-1.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:eu-west-1:863132222282:yourapp_email_complaints:0222222c-d183-45d8-b0ac-787d02222084"
      }
    }
      end

      it 'creates a new complaint record' do
        expect {
          post :complaint, complaint_json, format: :json
        }.to change(EmailResponse, :count).by(1)
      end

      it 'creates a new complaint w/o feedback report record' do
        expect {
          post :complaint, complaint_wo_feedback_report_json, format: :json
        }.to change(EmailResponse, :count).by(1)
      end

      it 'creates a new abuse complaint record' do
        expect {
          post :complaint, abuse_complaint_json, format: :json
        }.to change(EmailResponse, :count).by(1)
      end

      it 'saves the information it should' do
        allow(EmailResponse).to receive(:create)
        expect(EmailResponse).to receive(:create).with(hash_including(email: 'complaint@simulator.amazonses.com', response_type: 'complaint', extra_info: "complaintFeedbackType: abuse"))
        post :complaint, complaint_json, format: :json
      end
    end
  end
end
