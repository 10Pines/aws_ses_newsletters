Recipient = Struct.new(:email, :first_name, :last_name) do
  def display_name
    "#{first_name} #{last_name}"
  end
end