module VtodosHelper
	def show_tags ( vtodo ) 
		vtodo.tags.map{|t| t.subject}.join(', ')	
		
	end
	def show_tags_as_links ( vtodo ) 
		 #link_to "spring", tag_tagged_vtodos_url(110) 
		vtodo.tags.map{|t| link_to t.subject, tag_tagged_vtodos_url(t)}.join(', ')	
	end
	
	def show_link(tag, str)
		link_to str.to_s, tag_tagged_vtodos_url(tag)
	end
	
end
