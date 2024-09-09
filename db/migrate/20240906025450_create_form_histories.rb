class CreateFormHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :form_histories do |t|
      t.string :email, null: true
      t.string :password, null: true
      t.text :apply_prompt, null: true

      t.timestamps
    end
  end
end
