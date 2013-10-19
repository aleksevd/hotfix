Hotfix::Application.routes.draw do
  root to: 'project_files#index'

  resources :project_files, only: [:index, :show]
end
