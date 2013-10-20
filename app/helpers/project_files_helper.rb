module ProjectFilesHelper
  def two_points_link(path, action)
    if action == 'index'
      return link_to '..', project_files_path(path: path.split('/')[0..-2].join('/'))
    else
      if path.split('/').size > 2
        return link_to '..', project_files_path(path: path.split('/')[0..-3].join('/'))
      else
        return
      end
    end
  end

  def entry_path(path, action, entry_name)
    if action == 'index'
      [path, entry_name].join('/')
    else
      [path.split('/')[0..-2], entry_name].flatten.join('/')
    end
  end
end
