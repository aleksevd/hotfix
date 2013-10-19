class ProjectFile
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  FIXED_APP_PATH = Hotfix::Application.config.fixed_application['path']

  attr_accessor :name, :full_path, :entries, :path, :content

  def initialize(attributes = {})
    return if attributes.nil?

    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def path=(string)
    @path = string
    @full_path = FIXED_APP_PATH + string
  end

  def file?
    @is_file ||= File.file?(full_path)
  end

  def persisted?
    true
  end

  def content
    return @content if @content

    file = Server.get_file_content(full_path)
  end

  def save
    Server.rewrite_file(full_path, content)
    Server.restart
  end

  def self.list(path = '')
    path ||= ''
    inner_list(path.split('/')[1..-1], '')
  end

  def self.inner_list(dirs, current_path)
    list = []

    Server.file_list([FIXED_APP_PATH, current_path].join('/')).sort{ |a,b| a.downcase <=> b.downcase }.each do |entry|
      next if (entry == '..' || entry == '.')
      entry_full_path = [FIXED_APP_PATH, current_path, entry].join('/')

      if entry == dirs.try(:first)
        list << ProjectFile.new(name: entry,
                                full_path: entry_full_path,
                                entries: inner_list(dirs[1..-1], [current_path, dirs.first].join('/')))
      else
        list << ProjectFile.new(name: entry, full_path: entry_full_path)
      end
    end

    list
  end
end
