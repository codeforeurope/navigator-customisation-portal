require 'rexml/document'

class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(resource)
	if resource.is_a?(User)
	 	if resource.agree_terms_and_conditions
			return "/main/"
		else
			return "/users/#{resource.id}/edit"
		end
	else
		return "/main/"	
	end
  end

  def sign_out(resource_or_scope=nil)

        return sign_out_all_scopes unless resource_or_scope
        scope = Devise::Mapping.find_scope!(resource_or_scope)
        user = warden.user(:scope => scope, :run_callbacks => false) # If there is no user

        warden.raw_session.inspect # Without this inspect here. The session does not clear.
        warden.logout(scope)
        warden.clear_strategies_cache!(:scope => scope)
        instance_variable_set(:"@current_#{scope}", nil)

        !!user
  end

  def after_sign_out_path_for(resource)
	return "/main/"
  end

  def admin_required
    if current_user.roles_mask >= Permissions::SUPER_ADMIN_PERMISSIONS
      true
    else
      redirect_to "/main/"
      return	
    end
  end

  def is_admin
    if current_user.roles_mask >= Permissions::SUPER_ADMIN_PERMISSIONS
      return true
    else
      return false
    end
  end
end
