class StatisticsController < ApplicationController

  def index
    ActiveRecord::Base.connected_to(role: :reading, shard: :materialize) do
      @home_team_sums = HomeTeamSum.all.to_a

      respond_to do |format|
        format.html
        format.json do
          data = @home_team_sums.sort_by(&:total).reverse.map do |h|
            { id: h.attributes["id"], total: h.total }
          end
          render json: data.to_json
        end
      end
    end
  end
end
