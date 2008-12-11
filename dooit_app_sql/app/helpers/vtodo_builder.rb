class VtodoBuilder < ActionView::Helpers::FormBuilder
  def vtodo_tag_edit(options = {})
    #@template.select(@object_name, :clave_grupo_id, ClaveGrupo.find(:all, :order => "descripcion").collect {|d| ["#{d.descripcion}", d.id]}, {:prompt => 'Seleccionar...'})
	
	@template.text_field(@object_name, :tags_string)
  end
end
