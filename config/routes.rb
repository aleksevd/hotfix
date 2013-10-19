Hotfix::Application.routes.draw do
  root to: 'project_files#index'

  get :project_files, to: 'project_files#index'
  get :project_file, to: 'project_files#show'
  patch :project_file, to: 'project_files#update'
end
