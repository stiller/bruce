Bruce::Admin.helpers do
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = partial("campaigns/" + association.to_s.singularize + "_fields", locals: { f: f })
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end
end
