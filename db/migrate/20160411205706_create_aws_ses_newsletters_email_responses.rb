class CreateAwsSesNewslettersEmailResponses < ActiveRecord::Migration
  def change
    create_table :aws_ses_newsletters_email_responses do |t|
      t.string :email
      t.text :extra_info
      t.integer :response_type

      t.timestamps
    end
  end
end
