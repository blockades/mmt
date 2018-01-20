# frozen_string_literal: true

module ApplicationHelper
  def self.feature_modules
    ["WITHDRAWL", "EXCHANGE"]
  end

  feature_modules.each do |feature_module|
    define_method "#{feature_module.downcase.pluralize}_enabled?" do
      (ENV.send(:[], feature_module) == "true") || false
    end
  end

  def flash_notices
    raw([:notice, :error, :alert].map do |type|
      content_tag("div", flash[type], id: type, class: "flash") if flash[type].present?
    end.join)
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
