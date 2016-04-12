require_dependency "aws_ses_newsletters/application_controller"

module AwsSesNewsletters
  class EmailResponsesController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :log_incoming_message

    def bounce
      # TODO: get a certificate and make this secure
      # return render json: {} unless aws_message.authentic?

      if type != 'Bounce'
        puts "Not a bounce - exiting"
        return render json: {}
      end

      bounce = message['bounce']
      bouncerecps = bounce['bouncedRecipients']
      bouncerecps.each do |recp|
        email = recp['emailAddress']
        extra_info  = "status: #{recp['status']}, action: #{recp['action']}, diagnosticCode: #{recp['diagnosticCode']}"

        EmailResponse.create ({ email: email, response_type: 'bounce', extra_info: extra_info})
      end

      render json: {}
    end

    def complaint
      #return render json: {} unless aws_message.authentic?

      if type != 'Complaint'
        Rails.logger.info "Not a complaint - exiting"
        return render json: {}
      end

      complaint = message['complaint']
      recipients = complaint['complainedRecipients']
      recipients.each do |recp|
        email = recp['emailAddress']
        extra_info = "complaintFeedbackType: #{complaint['complaintFeedbackType']}"
        EmailResponse.create ( { email: email, response_type: 'complaint', extra_info: extra_info } )
      end

      render json: {}
    end

    private

    # def aws_message
    #   @aws_message ||= AWS::SNS::Message.new request.raw_post
    # end

    def email_response_params
      params.require(:email_response).permit(:email, :extra_info, :response_type)
    end

    # Weirdly, AWS double encodes the JSON.
    def message
      @message ||= JSON.parse JSON.parse(request.raw_post)['Message']
    end

    def type
      message['notificationType']
    end

    def log_incoming_message
      Rails.logger.info request.raw_post
    end
  end
end
