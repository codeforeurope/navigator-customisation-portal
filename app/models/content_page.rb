class ContentPage < ActiveRecord::Base
  require 'open-uri'

  belongs_to :theme

  attr_accessible :title, :content, :item_order

  validates :title, :uniqueness => { :on => :create, :case_sensitive => false, :scope => :theme_id, :message => I18n.t(:create_content_page__error_title_taken) }
  validates :title, :length => { :minimum => 1 }
  validates :content, :length => { :minimum => 1 }
  validates :item_order, :numericality => { :only_integer => true }

  def get_uri
	uri = self.title.downcase
        uri = uri.gsub(" ", '-') 
	return URI::encode(uri)
  end

end
