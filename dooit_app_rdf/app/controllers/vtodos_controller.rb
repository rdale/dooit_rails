require 'uuid'

class VtodosController < ApplicationController
  # model :vtodo

  def retrieve_vtodos
    @vtodo_as = ICAL::Vtodo.find(:where => {ICAL::status => 'active'})
    @vtodo_cs = ICAL::Vtodo.find(:where => {ICAL::status => 'done'})
    @tags = Query.new.distinct(:tag).where(:v, ICAL::status, 'active').
                                     where(:v, DC::subject, :tag).execute
  end

  # GET /vtodos
  # GET /vtodos.xml
  def index
    retrieve_vtodos

    respond_to do |format|
      format.html # index.html.erb
      format.rdf  { render :xml => ICAL::Vtodo.to_xml }
    end
  end

  # GET /vtodos/1
  # GET /vtodos/1.xml
  def show
    @vtodo = ICAL::Vtodo.find_by_id(params[:id])
    respond_to do |format|
    logger.info("Vtodos.show vtodo: #{@vtodo} format: #{format}")
      format.html # show.html.erb
      format.xml  { render :xml => @vtodo }
      format.rdf  { render :xml => @vtodo }
    end
  end

  # GET /vtodos/new
  # GET /vtodos/new.xml
  def new
    @vtodo = ICAL::Vtodo.new

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
    @vtodo = ICAL::Vtodo.new("#{ICAL::Vtodo::VTODO_BASE_URL}#{UUID.generate}")
    @vtodo.save
    @vtodo.summary = params[:vtodo][:summary]
    @vtodo.description = params[:vtodo][:description]
    @vtodo.status = ''
    list = params[:vtodo][:tags].split(",").each {|t| t.strip!}
    @vtodo.tags = list

    respond_to do |format|
      format.html { redirect_to(@vtodo) }
      format.xml  { render :xml => @vtodo, :status => :created, :location => @vtodo }
    end
  end

  # PUT /vtodos/1
  # PUT /vtodos/1.xml
  def update
    @vtodo = ICAL::Vtodo.find(params[:id])

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
    @vtodo = ICAL::Vtodo.find_by_id(params[:id])
    @vtodo.destroy

    respond_to do |format|
      format.html { redirect_to(vtodos_url) }
      format.xml  { head :ok }
    end
  end

  def show_tags
    @tags = Tag.find(params[:id])
  end

  def get_item_form
    @vtodo = ICAL::Vtodo.new
    render :partial => 'get_item_form'
  end

  def add_item
    render :partial => 'add_item'
  end

  def edit_item
    logger.info("edit_item")
    @vtodo = ICAL::Vtodo.find_by_id(params[:id])
    render :partial => 'edit_item'
  end

  def edit_item_completed
    @vtodo = ICAL::Vtodo.find_by_id(params[:id])
    render :partial => 'edit_item_completed'
  end

  def list_item
    @vtodo_a = ICAL::Vtodo.find_by_id(params[:id])
    render :partial => 'list_item'
  end

 def list_item_completed
   @vtodo_c = ICAL::Vtodo.find_by_id(params[:id])
   render :partial => 'list_item_completed'
 end

  def create_item
    @vtodo = ICAL::Vtodo.new("#{ICAL::Vtodo::VTODO_BASE_URL}#{UUID.generate}")
    @vtodo.save
    @vtodo.summary = params[:ical_vtodo][:summary]
    @vtodo.description = params[:ical_vtodo][:description]
    @vtodo.status = 'active'
    @vtodo.subject = params[:ical_vtodo][:tags].split(",").each {|t| t.strip!}

    retrieve_vtodos

    respond_to do |format|
      format.html { render :partial => 'index_part' }
      format.xml  { render :xml => @vtodo, :status => :created, :location => @vtodo }
    end
  end

  def update_item
    @vtodo_a = ICAL::Vtodo.find_by_id(params[:id])
    respond_to do |format|
      if @vtodo_a.update_attributes(params[:ical_vtodo])
        retrieve_vtodos
        format.html { render :partial => 'index_part' }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vtodo_a.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Check item method
  def check_item
    @vtodo_a = ICAL::Vtodo.find_by_id(params[:id])
    @vtodo_a.status = 'done'

    retrieve_vtodos
    render :partial => 'index_part'
  end

  # Uncheck item method
  def uncheck_item
    @vtodo_c = ICAL::Vtodo.find_by_id(params[:id])
    @vtodo_c.status = 'active'

    retrieve_vtodos
    render :partial => 'index_part'
 end

end
