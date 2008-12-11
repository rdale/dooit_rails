class VtodoBuilder < ActionView::Helpers::FormBuilder
  def vtodo_tag_edit(options = {})
    @template.text_field(@object_name, :tags_string)
  end
end
