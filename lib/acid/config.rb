require 'yaml'
require 'logger'
require 'helpers/os'

class Acid::Config
  # Shell executable name for running commands (needs to be in PATH)
  def shell
    return @shell      if @shell
    return 'cmd /C'    if OS.windows? # TODO: is there any other (better) choice than cmd?
    return 'bash -c'   if OS.unix? # Append -r for restricted bash (check bash(1) man page)
    nil
  end

  # Commands to execute before building
  def setup
    @setup || nil
  end

  # Environmental variables to set before building
  def env
    @env || nil
  end

  # Commands to execute to build
  def exec
    @exec || nil
  end

  # Parses the acid.yml file in the current directory
  def read(path)
    LOG.info('Acid::Config') { "Reading config file at '#{path}'" }
    (YAML.load_file path).each { |name, val| instance_variable_set("@#{name}", val) }
  end
end
