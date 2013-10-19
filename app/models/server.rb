class Server
  RESTART_COMMAND = Hotfix::Application.config.fixed_application['restart_command']

  def self.restart
    system(RESTART_COMMAND)
  end
end
