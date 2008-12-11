class TaggedVtodosController < ApplicationController
  # model :vtodo

  # GET /vtodos
  # GET /vtodos.xml
  def retrieve_vtodos
    @vtodo_as = ICAL::Vtodo.find(:where => {DC::subject => params[:tag_id], ICAL::status => 'active'})
    @vtodo_cs = ICAL::Vtodo.find(:where => {DC::subject => params[:tag_id], ICAL::status => 'done'})
    @tags = Query.new.distinct(:tag).where(:v, ICAL::status, 'active').
                                     where(:v, DC::subject, :tag).execute
  end
  def index
   retrieve_vtodos
    @stat = params[:tag_id]
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
    @stat = params[:tag_id]
    @vtodo = Vtodo.new
    @vtodo.summary = params[:vtodo][:summary]
    @vtodo.description = params[:vtodo][:description]
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
      format.html { redirect_to(tagged_vtodos_url) }
      format.xml  { head :ok }
    end
  end

  def show_tags
    @tags = Tag.find(params[:id])
  end

  def get_item_form
    @stat = params[:tag_id]
    @vtodo = ICAL::Vtodo.new
    render :partial => 'get_item_form'
  end

  def add_item
    @stat = params[:tag_id]
    render :partial => 'add_item'
  end

  def edit_item
    @stat = params[:tag_id]
    @vtodo = ICAL::Vtodo.find_by_id(params[:id])
    render :partial => 'edit_item'
  end

  def edit_item_completed
    @stat = params[:tag_id]
    @vtodo = ICAL::Vtodo.find_by_id(params[:id])
    render :partial => 'edit_item_completed'
  end

  def list_item
    @stat = params[:tag_id]
    @vtodo_a = ICAL::Vtodo.find_by_id(params[:id])
    render :partial => 'list_item'
  end

  def list_item_completed
    @stat = params[:tag_id]
    @vtodo_c = ICAL::Vtodo.find_by_id(params[:id])
    render :partial => 'list_item_completed'
  end

  def create_item
    @stat = params[:tag_id]
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
    @stat = params[:tag_id]
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
    @stat = params[:tag_id]
    retrieve_vtodos
    render :partial => 'index_part'
  end

  # Uncheck item method
  def uncheck_item
    @vtodo_c = ICAL::Vtodo.find_by_id(params[:id])
    @vtodo_c.status = 'active'
    @stat = params[:tag_id] 
    retrieve_vtodos
    render :partial => 'index_part'
 end
end
