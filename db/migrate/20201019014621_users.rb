class Users < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :encrypted_password
      t.string :status
      t.string :role
      t.datetime :last_login_date

      t.timestamps 
    end
  end
end
