class ApplicationController < ActionController::Base
  protect_from_forgery

  require "#{Rails.root}/lib/scraper.rb"
end
