class ContentPagesController < ApplicationController
  before_filter :authenticate_user!, :except => ["show"]

  def show_page
	if params[:theme_uri]
		theme = Theme.find(:first, :conditions => "lower(name) = '#{params[:theme_uri].downcase}'")
	end
	if params[:page_uri] and theme != nil
		page_url = decode_uri(params[:page_uri])
		@page = ContentPage.find(:first, :conditions => "theme_id=#{theme.id} and lower(title) = '#{page_url}'")
	end
	if theme == nil or @page == nil
		redirect_to :status => 404
		return
	end

	render :layout => false
  end

  def index
    @theme = is_theme_owner(params[:theme_id])

    # Get the list of content pages.
    @content_pages = ContentPage.find(:all, :conditions => "theme_id =#{current_user.id}")
  end

  # GET /content_pages/new
  def new
    @theme = is_theme_owner(params[:theme_id])
    
    @page = ContentPage.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /content_pages/1/edit
  def edit
    @page = ContentPage.find(params[:id]) 
    not_owner_or_admin(@page)
  end

  # POST /content_pages
  def create
    theme = is_theme_owner(params[:theme_id])
    	
    @page = ContentPage.new(params[:content_page])
    @page.theme = theme

    respond_to do |format|
      if @page.save
        format.html { redirect_to "/content_pages/?theme_id=#{theme.id}", notice: t(:manage_content_page__create_success) }
      else
	format.html { render action: "new" }
      end
    end
  end

  # PUT /content_pages/1
  def update
    @page = ContentPage.find(params[:id])
    not_owner_or_admin(@page)
    theme = @page.theme
    
    respond_to do |format|
      if @page.update_attributes(params[:content_page])
        format.html { redirect_to "/content_pages/?theme_id=#{theme.id}", notice: t(:manage_content_page__edit_success) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /content_pages/1
  def destroy
    @page = ContentPage.find(params[:id])
    theme = @page.theme
    @page.destroy

    respond_to do |format|
      format.html { redirect_to "/content_pages/?theme_id=#{theme.id}" }
    end
  end

  private
  def not_owner_or_admin(page)
    if page.theme.user.id != current_user.id && !is_admin
	redirect_to "/main/"
	return	
    end
  end

  def is_theme_owner(theme_id)
    # Check that the current user is the theme owner.
    if theme_id == nil
	redirect_to "/main/"
	return	
    end
    theme = Theme.find(:first, :conditions => "id = #{theme_id}")
    if theme == nil or (theme.user.id != current_user.id && !is_admin)
	redirect_to "/main/"
	return	
    end
    
    return theme
  end

  def decode_uri(uri)
	uri = URI::decode(uri)
        return uri.gsub("-", ' ') 
  end

end
