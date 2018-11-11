# frozen_string_literal: true

module ApplicationHelper
  def self.feature_modules
    ["WITHDRAWL", "EXCHANGE", "DEPOSIT", "GIFT"]
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

  def link_to_add_fields(name, f, association, namespace, html_options = {})
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |b|
      render partial: "#{namespace ? "#{namespace}/" : ""}#{association.to_s}/fields", locals: { f: b, object_id: id }
    end
    if block_given?
      link_to('#', class: "#{html_options.try(:[], :class)} addFields", title: html_options.try(:[], :title), data: { id: id, fields: fields.gsub("\n", "") } ) do
        yield
      end
    else
      link_to(name, '#', class: "#{html_options.try(:[], :class)} button addFields", title: html_options.try(:[], :title), data: { id: id, fields: fields.gsub("\n", "") } )
    end
  end
end
