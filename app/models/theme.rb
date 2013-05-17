class Theme < ActiveRecord::Base
  belongs_to :user

  attr_accessible :name, :is_searchable, :uploaded_file, :description
  attr_accessor :uploaded_file

  validates :name, :uniqueness => { :on => :create, :message => I18n.t(:create_theme__error_name_taken) }
  validates :name, :format => {:on => :create, :with => /^\w+$/i, :message => I18n.t(:create_theme__error_name_bad_format) }
  
  def get_uri
	return self.name.downcase
  end
end
