class CreateRegister < ActiveRecord::Migration[5.0]
  def change
    create_table :facilities do |t|
      t.string :name  , null: false
      t.string :description  , null: false
      t.boolean :membership , default: false, null: false
      t.boolean :verify, default: false, null: false
      t.string :board
    end

    create_table :allow_users do |t|
      t.string :portal_id
      t.references :facility
    end

    create_table :facilities_users do |t|
      t.references :facility
      t.references :user
    end

    create_table :users do |t|
      t.string :portal_id  ,  null: false
    end

    create_table :rents do |t|
      t.string :period  ,  null: false
      t.datetime :day  ,  null: false
      t.datetime :created_at
      t.string :description, default: "", null: false
      t.references :facility
      t.string :user_id, null: false
      t.boolean :verified, default: false
      t.boolean :large, default: false
    end

    create_table :large_rent do |t|
      t.string :period , null: false
      t.datetime :day , null: false
      t.integer :month , null: false
      t.references :rent
    end
  end
end
