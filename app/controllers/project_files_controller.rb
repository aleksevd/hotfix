class ProjectFilesController < ApplicationController
  before_filter :set_project_file, only: [:show, :update]

  def index
    @project_files = ProjectFile.list(params[:path])
  end

  def show
    @project_files = ProjectFile.list(@dirs[0..-2].join('/'))
  end

  def update
    @project_file.content = params[:project_file][:content]

    if @project_file.save
      redirect_to :back, notice: "Application successfully updated and now is restarting"
    else
      redirect_to :back, alert: "Something went wrong"
    end
  end

  private

  def set_project_file
    @dirs = params[:path].split('/')
    @project_file = ProjectFile.new(name: @dirs[-1], path: params[:path])
  end
end
