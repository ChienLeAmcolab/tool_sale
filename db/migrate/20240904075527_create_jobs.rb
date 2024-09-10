class CreateJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :jobs do |t|
      t.text :job_page_link, null: false
      t.text :gpt_prompt
      t.text :gpt_reply
      t.integer :status, default: 2 # status will be stored as an integer

      t.timestamps
    end

    add_index :jobs, :job_page_link, unique: true
  end
end
