class CreateMatches < ActiveRecord::Migration[6.1]
  def change
    create_table :matches do |t|
      t.string :name
      t.integer :home_team_id
      t.integer :away_team_id
      t.integer :score

      t.timestamps
    end
  end
end
