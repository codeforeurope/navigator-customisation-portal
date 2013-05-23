class ConfigController < ApplicationController

  # Return full list of public config items.
  # get /config.json
  def index
	themes = Theme.find(:all, :conditions => "is_searchable = 1", :order => "name asc")
	list = Array.new
	for theme in themes
		hash = Hash.new
		hash[:name] = theme.name
		hash[:description] = theme.description
		hash["config_url"] = "#{System::BASE_URL}/config/#{theme.get_uri}.json"
		list.push(hash)
	end
	respond_to do |format|
	  if params[:callback]
		format.json { render :json => list.to_json, :callback => params[:callback] }
	  else
	  	format.json { render :json => list.to_json }
	  end
	end
  end

  # Return the specific theme configuration.
  # get /config/:id.json
  def config_item
	theme = nil
	if params[:id]
		theme = Theme.find(:first, :conditions => "lower(name) = '#{params[:id].downcase}'")
	end
	if theme
		hash = Hash.new
		hash["name"] = theme.name
		hash["description"] = theme.description
		theme_dir = "#{Rails.root}/public/themes/#{theme.get_uri}"
		if File.exist?("#{theme_dir}/theme.css")
			hash["css_url"] = "#{System::BASE_URL}/themes/#{theme.get_uri}/theme.css"
		end
                content_pages = ContentPage.find(:all, :conditions => "theme_id=#{theme.id}", :order => "item_order asc")
		if content_pages.size > 0
			page_list = Array.new
			for page in content_pages
				page_hash = Hash.new
				page_hash["title"] = page.title
				page_hash["ajax_end_point"] = "#{System::BASE_URL}/content_pages/#{theme.get_uri}/#{page.get_uri}"
				page_list.push(page_hash)
			end
			hash["content_pages"] =page_list
		end
		respond_to do |format|
		  if params[:callback]
			format.json { render :json => hash.to_json, :callback => params[:callback] }
		  else
		  	format.json { render :json => hash.to_json }
		  end
		end
	else
		respond_to do |format|
		  if params[:callback]
			format.json { render :json => {"error" => "no match"}, :callback => params[:callback] }
		  else
		  	format.json { render :json => {"error" => "no match"} }
		  end
		end
	end
  end
end
