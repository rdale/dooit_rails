module VtodosHelper
  def show_tags ( vtodo ) 
    vtodo.tags.join(', ')  
  end

  def active_total_for_tag(tag)
    query = Query.new.select(:v).where(:v, ICAL::status, 'active').
                                 where(:v, DC::subject, tag)
    result = query.execute
    result.length
  end

  def show_link(tag, str)
    link_to str.to_s, tag_tagged_vtodos_url(tag)
  end
end
