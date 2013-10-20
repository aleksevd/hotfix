class ProjectFilesController < ApplicationController
  before_filter :set_breadcrumbs
  before_filter :set_server
  before_filter :set_project_file, only: [:show, :update]

  def index
    @project_files = @server.list(params[:path])
  end

  def show
  end

  def update
    @project_file.content = params[:project_file][:content]

    if @project_file.save
      flash.now[:notice] = "Application successfully updated and now is restarting"
    else
      redirect_to :back, alert: "Something went wrong"
    end
  end

  private

  def set_breadcrumbs
    @breadcrumbs = params[:path].split('/') if params[:path]
  end

  def set_server
    @server = Server.new(params[:server_options])
  end

  def set_project_file
    @dirs = params[:path].split('/')
    @project_file = ProjectFile.new(name: @dirs[-1], path: params[:path], server: @server)

    @project_files = @server.list(@dirs[0..-2].join('/'))
  end
end
