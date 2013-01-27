# Not dry :-(

def whyrun_supported?
  true
end

action :create do
  Chef::Log.info("Make instance via runit #{new_resource.name}")

  if @current_resource
    Chef::Log.info("#{@current_resource} already exist")
  end

  redis_new_resource = new_resource

  config = Chef::Mixin::DeepMerge.merge(node["redis"]["config"].to_hash, redis_new_resource.config)
  version = redis_new_resource.version || node["redis"]["version"]

  # Specified db for redis server
  config["dbfilename"] = "dump-#{redis_new_resource.name}.rb"

  if redis_new_resource.config_file then
    config_file = "#{redis_new_resource.config_file}"
  else
    config_file = "#{redis_new_resource.config_dir || node["redis"]["config_dir"]}/#{redis_new_resource.name}.conf"
  end

  init_d_file = "/etc/init.d/#{redis_new_resource.name}"
  pidfile = "#{node["redis"]["config"]["pid_dir"]}/#{redis_new_resource.name}.pid"
  exec_file = "#{redis_new_resource.install_dir || node["redis"]["install_dir"]}/bin/redis-server"
  cliexec_file = "#{redis_new_resource.install_dir || node["redis"]["install_dir"]}/bin/redis-cli"

  config["pidfile"] = pidfile
  config["daemonize"] = "no"

  redis_conf redis_new_resource.name do
    user redis_new_resource.user
    group redis_new_resource.group
    template redis_new_resource.template
    cookbook redis_new_resource.cookbook
    config_dir redis_new_resource.config_dir
    config_file config_file
    config config
  end


  runit_service redis_new_resource.name do
    template_name "redis"
    action :nothing
    options(:user => redis_new_resource.user,
            :group => redis_new_resource.group,
            :init_d_file => init_d_file,
            :log_folder => "/var/log/runit/#{redis_new_resource.name}",
            :pidfile => pidfile,
            :exec_file => exec_file,
            :cliexec_file => cliexec_file,
            :config => config_file)
  end

  redis_install "redis-server" do
    version redis_new_resource.version
    action :install
    notifies :restart, resources(:service => redis_new_resource.name), :delayed
  end
end


def load_current_resource
  @current_resource = Chef::Resource::Redis.new(@new_resource.name)
  return @current_resource
end

# Check current installed version
def current_installed_version
  @current_installed_version ||= begin
    return node["redis"]["version"]
  rescue Chef::Exceptions::ShellCommandFailed
  rescue Mixlib::ShellOut::ShellCommandFailed
  end
end
