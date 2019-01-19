class CreateUsersTable < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.integer :company_id
      t.integer :current_heart
      t.string :nickname
      t.string :email
      t.string :phone_number
      t.string :location
      t.string :profile_img
      t.string :recommendation_code
      t.string :password
      t.text :team_detail #need check
      t.boolean :is_male
      t.timestamps
    end
  end
end
