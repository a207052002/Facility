class CreateRegister < ActiveRecord::Migration[5.0]
  def change
    create_table :facilities do |t|
      t.string :name  , null: false
      t.string :description  , null: false
      t.boolean :limit , default: false, null: false
      t.boolean :verify, default: false, null: false
    end

    create_table :allow_user do |t|
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

    create_table :use_times do |t|
      t.string :period  ,  null: false
      t.datetime :day  ,  null: false
      t.datetime :created_at
      t.references :user
      t.string :description, default: "", null: false
      t.references :facility
      t.boolean :verified, default: false
    end
  end
end
