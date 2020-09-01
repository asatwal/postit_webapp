require 'twilio-ruby'

class User < ActiveRecord::Base

	include Slugable

	has_many :posts
	has_many :comments
	has_many :votes

	has_secure_password validations: false


	validates :username, presence: true, uniqueness: true
	validates :password, presence: true, on: :create

	validates :password, length: {minimum: 5}, unless: "password.blank?"

	validates :password, confirmation: true, unless: :password_fields_blank?

	slugable_column :username

	def password_fields_blank?
		password.blank? && password_confirmation.blank?
	end

	def admin?
		self.role == 'admin'
	end

	def two_factor_auth?
		!self.phone.blank?
	end

	def generate_pin!
		update_column(:pin, rand(10**6))
	end

	def clear_pin!
		update_column(:pin, nil)
	end

	def send_pin_to_twilio

    account_sid = ENV['ACCOUNT_SID']
    auth_token = ENV['AUTH_TOKEN']
    client = Twilio::REST::Client.new account_sid, auth_token

    msg = "Hello from the eWorx PostIt App. Enter the PIN #{self.pin} to verify your account."

    message = client.account.messages.create(body: msg,
        to: self.phone,
        from: '+441254790257')

    puts message.to
	end

end
