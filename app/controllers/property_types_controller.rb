class PropertyTypesController < ApplicationController
  before_filter :login_required
  before_filter :require_admin

  def require_admin
    throw "must be admin - code admin levels, yes you"
  end

  def index
    list
    render :action => 'list'
  end

  def list
    @property_type_pages, @property_types = paginate :property_type, :per_page => 10
  end

  def show
    @property_type = PropertyType.find(params[:id])
  end

  def new
    @property_type = PropertyType.new
  end

  def create
    @property_type = PropertyType.new(params[:property_type])
    if @property_type.save
      flash[:notice] = 'PropertyType was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @property_type = PropertyType.find(params[:id])
  end

  def update
    @property_type = PropertyType.find(params[:id])
    if @property_type.update_attributes(params[:property_type])
      flash[:notice] = 'PropertyType was successfully updated.'
      redirect_to :action => 'show', :id => @property_type
    else
      render :action => 'edit'
    end
  end

  def destroy
    PropertyType.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
