class Page < ActiveRecord::Base
  validates_presence_of :title, :slug, :content
end
