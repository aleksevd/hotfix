require 'net/sftp'
require 'stringio'

class Server
  SERVER_OPTIONS = Hotfix::Application.config.server_options

  attr_accessor :host, :user, :password, :restart_command, :fixed_app_path, :port, :target_app

  def initialize(attributes = nil)
    (attributes || SERVER_OPTIONS).each do |name, value|
      send("#{name}=", value)
    end
  end

  def file_list(full_path)
    list = ''

    Net::SFTP.start(host, user, password: password, port: port) do |sftp|
      list = sftp.dir.entries(full_path).map{ |t| [t.name, t.file?] }
    end

    list
  end

  def restart
    Net::SSH.start(host, user, password: password, port: port) do |ssh|
      ssh.exec!(restart_command)
    end
  end

  def rewrite_file(full_path, content)
    Net::SFTP.start(host, user, password: password, port: port) do |sftp|
      io = StringIO.new(content)
      sftp.upload!(io, full_path)
    end
  end

  def get_file_content(full_path)
    content = ''

    Net::SFTP.start(host, user, password: password, port: port) do |sftp|
      sftp.file.open(full_path) do |file|
        content = file.read
      end
    end

    content
  end

  def list(path = '')
    path ||= ''
    inner_list(path).sort_by(&:sort_criteria)
  end

  def inner_list(current_path)
    list = []

    file_list([fixed_app_path, current_path].join('/')).sort{ |a,b| a[0].downcase <=> b[0].downcase }.each do |entry, is_file|
      next if (entry == '..' || entry == '.')
      entry_full_path = [fixed_app_path, current_path, entry].join('/')

      list << ProjectFile.new(name: entry, is_file: is_file, full_path: entry_full_path)
    end

    list
  end
end
