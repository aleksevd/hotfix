require 'net/sftp'
require 'stringio'

class Server
  RESTART_COMMAND = Hotfix::Application.config.fixed_application['restart_command']
  SSH_OPTIONS = Hotfix::Application.config.ssh_options

  def self.restart
    Net::SSH.start(SSH_OPTIONS['host'], SSH_OPTIONS['user'], password: SSH_OPTIONS['password']) do |ssh|
      ssh.exec!(RESTART_COMMAND)
    end
  end

  def self.rewrite_file(full_path, content)
    Net::SFTP.start(SSH_OPTIONS['host'], SSH_OPTIONS['user'], password: SSH_OPTIONS['password']) do |sftp|
      io = StringIO.new(content)
      sftp.upload!(io, full_path)
    end
  end

  def self.get_file_content(full_path)
    content = ''

    Net::SFTP.start(SSH_OPTIONS['host'], SSH_OPTIONS['user'], password: SSH_OPTIONS['password']) do |sftp|
      sftp.file.open(full_path) do |file|
        content = file.read
      end
    end

    content
  end
end
