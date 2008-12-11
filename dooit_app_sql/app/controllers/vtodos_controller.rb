require 'active_rdf'
class VtodosController < ApplicationController
  # GET /vtodos
  # GET /vtodos.xml
  def index
  @vtodos = Vtodo.find(:all)
  @vtodo_cs = Vtodo.find(:all, :conditions => "status = 'done'")
  @vtodo_as = Vtodo.find(:all, :conditions => "status = ''")
  @tags = Tag.find(:all)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vtodos }
    end
  end

  # GET /vtodos/1
  # GET /vtodos/1.xml
  def show
    @vtodo = Vtodo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vtodo }
    end
  end

  # GET /vtodos/new
  # GET /vtodos/new.xml
  def new
    @vtodo = Vtodo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vtodo }
    end
  end

  # GET /vtodos/1/edit
  def edit
    @vtodo = Vtodo.find(params[:id])
  end

  # POST /vtodos
  # POST /vtodos.xml
  def create
    @vtodo = Vtodo.new
  @vtodo.summary = params[:vtodo][:summary]
  @vtodo.description = params[:vtodo][:description]
  @vtodo.status = ''
  list = params[:vtodo][:tags].split(",").each {|t| t.strip!}
  list.each do |item|
    tag = Tag.new
    tag = Tag.find_or_create_by_subject(item)
    tag.subject = item
    #tag.save 
    @vtodo.tags << tag
  end

    respond_to do |format|
      if @vtodo.save
        flash[:notice] = 'Vtodo was successfully created.'
        format.html { redirect_to(@vtodo) }
        format.xml  { render :xml => @vtodo, :status => :created, :location => @vtodo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vtodo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /vtodos/1
  # PUT /vtodos/1.xml
  def update
    @vtodo = Vtodo.find(params[:id])

    respond_to do |format|
      if @vtodo.update_attributes(params[:vtodo])
        flash[:notice] = 'Vtodo was successfully updated.'
        format.html { redirect_to(@vtodo) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vtodo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /vtodos/1
  # DELETE /vtodos/1.xml
  def destroy
    @vtodo = Vtodo.find(params[:id])
    @vtodo.destroy

    respond_to do |format|
      format.html { redirect_to(vtodos_url) }
      format.xml  { head :ok }
    end
  end
#show tag method
  def show_tags
  @tags = Tag.find(params[:id])
  end
#get item method
 def get_item_form
  @vtodo = Vtodo.new
  render :partial => 'get_item_form'
 end
#add item method
 def add_item
  render :partial => 'add_item'
 end
#edit item method
 def edit_item
  @vtodo = Vtodo.find(params[:id])
  render :partial => 'edit_item'
 end

#edit item method completed
 def edit_item_completed
  @vtodo = Vtodo.find(params[:id])
  render :partial => 'edit_item_completed'
 end
#list item method
 def list_item
    @vtodo_a = Vtodo.find(params[:id])
  render :partial => 'list_item'
 end
#list item method completed
 def list_item_completed
    @vtodo_c = Vtodo.find(params[:id])
  render :partial => 'list_item_completed'
 end

#create item method
def create_item
    @vtodo = Vtodo.new
  @vtodo.summary = params[:vtodo][:summary]
  @vtodo.description = params[:vtodo][:description]
  @vtodo.status = ''
  list = params[:vtodo][:tags].split(",").each {|t| t.strip!}
  list.each do |item|
    tag = Tag.new
    tag = Tag.find_or_create_by_subject(item)
    tag.subject = item
    #tag.save 
    @vtodo.tags << tag
  end

    respond_to do |format|
      if @vtodo.save
        @vtodo_as = Vtodo.find(:all, :conditions => "status = ''")
    @vtodo_cs = Vtodo.find(:all, :conditions => "status = 'done'")
    @tags = Tag.find(:all)
        format.html { render :partial => 'index_part' }
        format.xml  { render :xml => @vtodo, :status => :created, :location => @vtodo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vtodo.errors, :status => :unprocessable_entity }
      end
    end
  end
#update item method
 def update_item
  @vtodo_a = Vtodo.find(params[:id])

    respond_to do |format|
      if @vtodo_a.update_attributes(params[:vtodo])
        flash[:notice] = 'Vtodo was successfully updated.'
        format.html { render :partial => 'list_item' }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vtodo_a.errors, :status => :unprocessable_entity }
      end
    end

 end



#check item method
 def check_item
  @vtodo_a = Vtodo.find(params[:id])
  @vtodo_a.status = 'done'
  @vtodo_a.save
  @vtodo_as = Vtodo.find(:all, :conditions => "status = ''")
  @vtodo_cs = Vtodo.find(:all, :conditions => "status = 'done'")
  @tags = Tag.find(:all)
  render :partial => 'index_part'
 end

 #uncheck item method
 def uncheck_item
  @vtodo_c = Vtodo.find(params[:id])
  @vtodo_c.status = ''
  @vtodo_c.save
  @vtodo_as = Vtodo.find(:all, :conditions => "status = ''")
  @vtodo_cs = Vtodo.find(:all, :conditions => "status = 'done'")
  @tags = Tag.find(:all)
   render :partial => 'index_part'
 end
end
