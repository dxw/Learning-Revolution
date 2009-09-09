class Admin::AdminController < ApplicationController
  layout 'admin'
  before_filter :authenticate

  protected

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "lr_admin" && password == "learning is fun!"
    end
  end
end
