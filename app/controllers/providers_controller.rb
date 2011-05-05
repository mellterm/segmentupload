class ProvidersController < ApplicationController
  def index
    @providers = Provider.all
  end

  def show
    @provider = Provider.find(params[:id])
  end

  def new
    @provider = Provider.new
  end

  def create
    @provider = Provider.new(params[:provider])
    if @provider.save
      redirect_to @provider, :notice => "Successfully created provider."
    else
      render :action => 'new'
    end
  end

  def edit
    @provider = Provider.find(params[:id])
  end

  def update
    @provider = Provider.find(params[:id])
    if @provider.update_attributes(params[:provider])
      redirect_to @provider, :notice  => "Successfully updated provider."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @provider = Provider.find(params[:id])
    @provider.destroy
    redirect_to providers_url, :notice => "Successfully destroyed provider."
  end
end
