class AddHomeTeamAndAwayTeamScoreToMatch < ActiveRecord::Migration[6.1]
  def change
    add_column :matches, :home_team_score, :integer
    add_column :matches, :away_team_score, :integer
  end
end
