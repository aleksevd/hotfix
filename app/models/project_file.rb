class ProjectFile
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :name, :is_file, :full_path, :entries, :path, :content, :server, :old_content

  def initialize(attributes = {})
    return if attributes.nil?

    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def path=(string)
    @path = string
    @full_path = server.fixed_app_path + string
  end

  def persisted?
    true
  end

  def server
    @server ||= Server.new
  end

  def content
    return @content if @content

    file = server.get_file_content(full_path)
  end

  def content=(string)
    self.old_content = content
    @content = string.gsub("\r", '')
  end

  def save
    server.rewrite_file(full_path, content)
    server.restart

    true
  end

  def sort_criteria
    type = is_file ? '1' : '0'
    "#{type}#{name.downcase}"
  end
end
