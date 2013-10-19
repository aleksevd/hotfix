class ProjectFilesController < ApplicationController
  def index
    @project_files = ProjectFile.list(params[:path])
  end

  def show
  end
end
