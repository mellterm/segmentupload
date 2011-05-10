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


    if @document.save
      FileUtils.cp(params[:file].tempfile,"tmp/#{@document.id}.xml")
      @document.parse
      @document.save

      redirect_to provider_documents_path(@provider), :notice => "Successfully created document."
    else
      render :action => 'new'
    end
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
