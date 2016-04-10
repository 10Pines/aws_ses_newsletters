SES = AWS::SES::Base.new(access_key_id: ENV['SES_ACCESS_KEY_ID'],
                         secret_access_key: ENV['SES_SECRET_ACCESS_KEY'])