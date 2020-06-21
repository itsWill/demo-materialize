class Match < ApplicationRecord
  validates :away_team_score, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :home_team_score, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  belongs_to :home_team, class_name: "Team"
  belongs_to :away_team, class_name: "Team"
end
