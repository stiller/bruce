Bruce::Admin.controllers :base do
  get :index, :map => "/" do
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true)
    render "base/index"
  end
end
