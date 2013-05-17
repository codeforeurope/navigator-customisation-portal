class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :username, :firstname, :lastname, :agree_terms_and_conditions
  attr_accessible :provider, :uid, :roles_mask

  validates :email, :uniqueness =>{ :on => :update, :case_sensitive => false }
  validates :email, :format => {:on => :update, :with  => Devise.email_regexp }
  validates :password, :presence => {:on=>:create}
  validates :password, :confirmation => {:on=>:create}
  validates :password, :length => { :in => Devise.password_length, :allow_blank => true }
  validates :username, :presence => { :on => :update, :message => I18n.t(:create_user__error_username_missing) }
  validates :username, :uniqueness => { :on => :update, :message => I18n.t(:create_user__error_username_taken) }
  validates :username, :format => {:on => :update, :with => /^\w+$/i, :message => I18n.t(:create_user__error_username_bad_format) }
  validates :agree_terms_and_conditions, :presence => {:on => :update, :message => I18n.t(:create_user__error_agree_terms_and_conditions)}

  has_many :themes, :dependent => :destroy
  	
  def self.find_for_oauth(auth, signed_in_resource=nil)
	  user = User.where(:provider => auth.provider, :uid => auth.uid).first
	  unless user
            user = User.new
            user.firstname = ""	
	    user.lastname = ""	
	    if auth.info.email == nil
		user.email = ""
	    else
	    	user.email = auth.info.email
	    end
	    user.provider = auth.provider
	    user.uid = auth.uid
 	    user.password = Devise.friendly_token[0,20]
	    user.save
	  end
	  return user
  end
end
