# frozen_string_literal: true

module ApplicationHelper
  def flash_notices
    [:notice, :error, :alert].each do |type|
      render(partial: "shared/notice", locals: { message: flash[type] }) unless flash[type].blank?
    end
    nil
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |b|
      render("#{association}/fields", f: b)
    end
    link_to(name, "#", class: "button add_fields", data: { id: id, fields: fields.delete("\n") })
  end
end
