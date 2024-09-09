class CreateSystemSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :system_settings do |t|
      t.string :attribute_name, null: false
      t.boolean :status, default: false, null: false
      t.timestamps
    end
  end
end
