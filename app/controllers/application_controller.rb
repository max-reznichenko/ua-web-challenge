class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :preload_categories

  def preload_categories
    @categories = Category.all
  end
end
