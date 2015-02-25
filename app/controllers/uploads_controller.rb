class UploadsController < ApplicationController

  hobo_model_controller

  # GET /uploads
  # GET /uploads.json
  def index
    if params[:price_id].to_i > 0
      @uploads = Price.find(params[:price_id]).uploads.viewable_by(current_user).to_a
    else
      @uploads = Upload.viewable_by(current_user).to_a.paginate
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @uploads.map{|upload| upload.to_jq_upload(current_user) } }
    end
  end

  # GET /uploads/1
  # GET /uploads/1.json
  def show
    @upload = Upload.user_find(current_user,params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @upload }
    end
  end

  # GET /uploads/new
  # GET /uploads/new.json
  def new
    @upload = Upload.user_new(current_user)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @upload }
    end
  end

  # GET /uploads/1/edit
  def edit
    @upload = Upload.user_find(current_user,params[:id])
  end

  # POST /uploads
  # POST /uploads.json
  def create
    if params[:price_id].to_i > 0
      # Create for price
      @uploadable=Price.user_find(current_user,params[:price_id].to_i)
      @upload = Upload.user_new(current_user,params[:upload])
      @upload.uploadable = @uploadable
    else
      @upload = Upload.new(params[:upload])
    end


    respond_to do |format|
      if @upload.user_save(current_user)
        format.html {
          render :json => [@upload.to_jq_upload(current_user)].to_json,
          :content_type => 'text/html',
          :layout => false
        }
        format.json { render json: {files: [@upload.to_jq_upload(current_user)]}, status: :created, location: @upload }
      else
        format.html { render action: "new" }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /uploads/1
  # PUT /uploads/1.json
  def update
    @upload = Upload.user_find(current_user,params[:id])

    respond_to do |format|
      if @upload.editable_by?(current_user, params[:upload]) 
        @upload.update_attributes(params[:upload])
        format.html { redirect_to @upload, notice: 'Upload was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /uploads/1
  # DELETE /uploads/1.json
  def destroy
    @upload = find_instance

    respond_to do |format|
      if @upload.destroyable_by?(current_user)
        @upload.user_destroy(current_user)
        format.html { redirect_to uploads_url }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: :no_content, status: :forbidden }
      end
    end
  end

end
