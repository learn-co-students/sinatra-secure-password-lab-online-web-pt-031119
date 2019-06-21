class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |info|
      info.string :username
      info.string :password_digest
    end
  end
  
end