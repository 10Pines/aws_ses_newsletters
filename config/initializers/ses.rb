puts "ENV: #{ENV}"
# fail "Please add SES_ACCESS_KEY_ID and SES_SECRET_ACCESS_KEY to your environment variables" unless ENV['SES_ACCESS_KEY_ID'] && ENV['SES_SECRET_ACCESS_KEY']
# SES = AWS::SES::Base.new(access_key_id: ENV['SES_ACCESS_KEY_ID'],
#                            secret_access_key: ENV['SES_SECRET_ACCESS_KEY'])