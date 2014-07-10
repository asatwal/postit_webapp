class User < ActiveRecord::Base
	has_many :posts
	has_many :comments
	has_many :votes

	has_secure_password validations: false



	validates :username, presence: true, uniqueness: true
	validates :password, presence: true, on: :create

	validates :password, length: {minimum: 5}, unless: "password.blank?"

	validates :password, confirmation: true, unless: :password_fields_blank?

	def password_fields_blank?
		password.blank? && password_confirmation.blank?
	end

end