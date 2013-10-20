module ProjectFilesHelper
  def parent_path(path, action)
    if action == 'index'
      project_files_path(path: path.split('/')[0..-2].join('/'))
    elsif path.split('/').size > 2
      project_files_path(path: path.split('/')[0..-3].join('/'))
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
