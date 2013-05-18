class IszipfileValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value!=nil and value.original_filename!="" and value.original_filename.index(".zip")==nil
	record.errors[attribute] << I18n.t(:manage_theme__error_zip_file) 
    end
  end
end

class Theme < ActiveRecord::Base
  belongs_to :user

  attr_accessible :name, :is_searchable, :uploaded_file, :description
  attr_accessor :uploaded_file

  validates :name, :uniqueness => { :on => :create, :message => I18n.t(:create_theme__error_name_taken) }
  validates :name, :format => {:on => :create, :with => /^\w+$/i, :message => I18n.t(:create_theme__error_name_bad_format) }
  validates :uploaded_file, :iszipfile => true

  def get_uri
	return self.name.downcase
  end
end
