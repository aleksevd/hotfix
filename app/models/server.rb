require 'net/sftp'
require 'stringio'

class Server
  SERVER_OPTIONS = Hotfix::Application.config.server_options

  attr_accessor :host, :user, :password, :restart_command, :fixed_app_path

  def initialize(attributes = nil)
    (attributes || SERVER_OPTIONS).each do |name, value|
      send("#{name}=", value)
    end
  end

  def file_list(full_path)
    list = ''

    Net::SFTP.start(host, user, password: password) do |sftp|
      list = sftp.dir.entries(full_path).map(&:name)
    end
    puts list.inspect
    list
  end

  def restart
    Net::SSH.start(host, user, password: user) do |ssh|
      ssh.exec!(restart_command)
    end
  end

  def rewrite_file(full_path, content)
    Net::SFTP.start(host, user, password: user) do |sftp|
      io = StringIO.new(content)
      sftp.upload!(io, full_path)
    end
  end

  def get_file_content(full_path)
    content = ''

    Net::SFTP.start(host, user, password: user) do |sftp|
      sftp.file.open(full_path) do |file|
        content = file.read
      end
    end

    content
  end

  def list(path = '')
    path ||= ''
    inner_list(path.split('/')[1..-1], '')
  end

  def inner_list(dirs, current_path)
    list = []

    file_list([fixed_app_path, current_path].join('/')).sort{ |a,b| a.downcase <=> b.downcase }.each do |entry|
      next if (entry == '..' || entry == '.')
      entry_full_path = [fixed_app_path, current_path, entry].join('/')

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
