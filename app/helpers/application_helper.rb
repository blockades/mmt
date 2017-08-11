module ApplicationHelper

  def flash_notices
    raw([:notice, :error, :alert].map { |type| content_tag('div', flash[type], id: type) unless flash[type].blank?  }.join)
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |b|
      render("#{association.to_s}/fields", f: b)
    end
    link_to(name, '#', class: 'button add_fields', data: { id: id, fields: fields.gsub("\n", "") } )
  end

end
