class StatsController < ApplicationController
  include Stats

  # TODO Appliquer à des plages horaires
  def index
    compute_delivery_failure_percent
    compute_readed_percent
  end
end
