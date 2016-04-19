module AwsSesNewsletters
  class EmailResponse < ActiveRecord::Base
    enum response_type: [ :bounce, :complaint ]

    validates_presence_of :email
  end
end
