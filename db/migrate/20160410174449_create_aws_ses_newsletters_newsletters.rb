class CreateAwsSesNewslettersNewsletters < ActiveRecord::Migration
  def change
    create_table :aws_ses_newsletters_newsletters do |t|
      t.string :from
      t.string :subject
      t.text :html_body
      t.text :text_body

      t.timestamps
    end
  end
end
