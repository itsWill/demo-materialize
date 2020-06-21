class MatchGenerator
  @is_running = false
  @stop = false

  def self.run
    @stop = false
    return if @is_running

    @is_running = true
    teams = Team.all

    loop do
      return if @stop
      away_team, home_team = teams.sample(2)
      Match.create!(away_team: away_team, home_team: home_team, away_team_score: rand(10), home_team_score: rand(10))
      sleep 0.25
    end
  end

  def self.stop
    @stop = true
    @is_running = false
  end
end
