class DocumentsController < ApplicationController
  def index
    @documents = Document.all
  end

  def show
    @document = Document.find(params[:id])
  end

  def new
    @document = @provider.documents.build(params[:document])
  end

  def create
	@document = @provider.documents.create(params[:document])
	
    if @document.save
      redirect_to @document, :notice => "Successfully created document."
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
    @document.destroy
    redirect_to documents_url, :notice => "Successfully destroyed document."
  end
end
