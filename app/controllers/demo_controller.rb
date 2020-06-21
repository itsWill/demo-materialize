class DemoController < ApplicationController
  def index
  end

  def start
    Thread.new { MatchGenerator.run }
    redirect_to statistics_index_path
  end

  def stop
    MatchGenerator.stop
  end
end
