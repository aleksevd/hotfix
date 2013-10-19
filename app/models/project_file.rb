class ProjectFile
  FIXED_APP = Hotfix::Application.config.fixed_application

  attr_accessor :name, :full_path, :entries

  def initialize(attributes = {})
    return if attributes.nil?

    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def file?
    @is_file ||= File.file?(full_path)
  end

  def self.list(path = '')
    path ||= ''
    inner_list(path.split('/')[1..-1], '')
  end

  def self.inner_list(dirs, current_path)
    list = []

    Dir.entries([FIXED_APP['path'], current_path].join('/')).sort{ |a,b| a.downcase <=> b.downcase }.each do |entry|
      next if (entry == '..' || entry == '.')
      entry_full_path = [FIXED_APP['path'], current_path, entry].join('/')
      puts entry
      puts dirs.inspect

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
