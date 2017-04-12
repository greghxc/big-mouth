# extends gem controller to add auth
class DocsController < Rswag::Ui::HomeController
  http_basic_authenticate_with name: ENV['DOCS_USER'], password: ENV['DOCS_PWD']
end
