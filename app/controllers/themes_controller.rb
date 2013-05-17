class ThemesController < ApplicationController

  before_filter :authenticate_user!

  def index
	# Get the current themes
	@themes = Theme.find(:all, :conditions => "user_id =#{current_user.id}")
  end

  # GET /themes/new
  def new
    @theme = Theme.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /themes/1/edit
  def edit
    @theme = Theme.find(params[:id]) 
    not_owner_or_admin(@theme)
    @has_name = (@theme.name != nil and @theme.name != "")
  end

  # POST /themes
  def create
    @theme = Theme.new(params[:theme])
    @theme.user = current_user

    # Save the theme file.
    save_theme_file(@theme,params)
    
    respond_to do |format|
      if @theme.save
        format.html { redirect_to themes_url, notice: t(:manage_theme__create_success) }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /themes/1
  def update
    @theme = Theme.find(params[:id])
    not_owner_or_admin(@theme)
    @has_name = (@theme.name != nil and @theme.name != "")

    # Save the theme file.
    save_theme_file(@theme,params)

    respond_to do |format|
      if @theme.update_attributes(params[:theme])
        format.html { redirect_to themes_url, notice: t(:manage_theme__edit_success) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /themes/1
  def destroy
    @theme = Theme.find(params[:id])
    @theme.destroy

    respond_to do |format|
      format.html { redirect_to themes_url }
    end
  end

  private
  def not_owner_or_admin(theme)
    if theme.user.id != current_user.id && !is_admin
	redirect_to "/main/"
	return	
    end
  end

  def save_theme_file(theme, params)
	if params[:theme][:uploaded_file] and params[:theme][:uploaded_file].tempfile
		sfile = params[:theme][:uploaded_file].tempfile
		theme_dir = "#{Rails.root}/public/themes/#{theme.get_uri}"

		#Delete the old theme.
		FileUtils.rm_rf(theme_dir) 
	
		#Save the new files.
		FileUtils.mkdir(theme_dir)
		FileUtils.mkdir("#{theme_dir}/images/")
		Zip::ZipFile.open(sfile) do |zipfile|
		  zipfile.each do |file|
			if(file.name.index("testthemerollertheme.min.css"))
			   File.open("#{theme_dir}/theme.css", "w") { |f| f.write(zipfile.read(file.name)) }
			end
			if(file.name.index("/images/"))
			   imgName = file.name[file.name.index("/images/")+8,file.name.length]
			   File.open("#{theme_dir}/images/#{imgName}", "wb") { |f| f.write(zipfile.read(file.name)) }
			end
		  end
		end
	end
  end
end
