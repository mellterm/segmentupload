class DocumentsController < ApplicationController
  def index
    @provider = Provider.find(params[:provider_id])
    @documents = @provider.documents.all
  end

  def show
    @document = Document.find(params[:id])
  end

  def new
    @provider = Provider.find(params[:provider_id])
    @document = @provider.documents.build(params[:document])
  end

  def create
    @provider = Provider.find(params[:provider_id])
    @document = @provider.documents.build(params[:document])
    @document.uploaded_by_id =   current_user.id if current_user

    render :action => 'new', :alert => "Please correct the errors below." and return unless @document.save

    archive_path = Rails.root.join("archives", "#{Time.now.strftime( "%Y%m%d%H%M%S" )}-#{params[:file].original_filename}")
    FileUtils.cp(params[:file].tempfile.path, archive_path)

    Rails.logger.info ">>>>>>>>>>>>>>>>>>>> #{archive_path}"
    Stalker.enqueue("document.upload", :id => @document.id, :path => archive_path)
    redirect_to provider_documents_path(@provider), :notice => "Successfully created document."

  end

  def edit
    @document = Document.find(params[:id])
  end

  def update
    @document = Document.find(params[:id])
    if @document.update_attributes(params[:document])
      redirect_to @document, :notice  => "Successfully updated document."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @document = Document.find(params[:id])
    provider_id = @document.provider_id
    @document.destroy
    redirect_to provider_documents_path(provider_id), :notice => "Successfully destroyed document."
  end
end
