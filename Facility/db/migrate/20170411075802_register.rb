class Register < ActiveRecord::Migration[5.0]
  def change
    create_table :facilities do |t|
      t.string :name
      t.string :description
    end

    create_table :facilities_users do |t|
      t.references :facility
      t.references :user
    end

    create_table :use_times do |t|
      t.string :period
      t.datetime :day
      t.datetime :created_at
      t.string :user_id
      t.string :description
      t.references :facility
    end
  end
end
