require 'sha1'

class User < ActiveRecord::Base
  validates_presence_of :username, :password
  validates_uniqueness_of :username

  before_create do |user|
    user.password = SHA1.hexdigest user.password
  end

  def verify pwd
    password == SHA1.hexdigest(pwd)
  end
end
