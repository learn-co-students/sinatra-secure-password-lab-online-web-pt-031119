class User < ActiveRecord::Base
	has_secure_password  #Because our user has has_secure_password, we won't be able to save this to the database unless our user filled out the password field.
end
