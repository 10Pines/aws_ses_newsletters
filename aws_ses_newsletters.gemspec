$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "aws_ses_newsletters/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "aws_ses_newsletters"
  s.version     = AwsSesNewsletters::VERSION
  s.authors     = ["Federico Zuppa"]
  s.email       = ["fzuppa@gmail.com"]
  s.homepage    = "https://github.com/10pines/aws_ses_newsletters"
  s.summary     = "Easy newsletters with Amazon SES"
  s.description = "Framework that uses aws-ses to send newsletters"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.1.15"
  s.add_dependency "aws-ses"
  s.add_dependency "sidekiq"
  s.add_dependency "nokogiri"
  s.add_dependency "premailer"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
end
