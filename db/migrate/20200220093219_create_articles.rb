class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :text
      t.string :preview
      t.string :aasm_state
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
