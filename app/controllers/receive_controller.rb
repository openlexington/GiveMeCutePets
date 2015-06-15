class ReceiveController < ApplicationController
  def tweet
    Rails.logger(response.body.read)
  end
end
