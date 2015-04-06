# Not dry :-(

def whyrun_supported?
  true
end

action :create do
  Chef::Log.info("Make instance via monit provider #{new_resource.name}")

  if @current_resource
    Chef::Log.info("#{@current_resource} already exist")
  end
  run_context.include_recipe "monit"

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


  redis_conf redis_new_resource.name do
    user redis_new_resource.user
    group redis_new_resource.group
    template redis_new_resource.template
    cookbook redis_new_resource.cookbook
    config_dir redis_new_resource.config_dir
    config_file config_file
    config config
  end

  redis_spawner redis_new_resource.name do
    init_d_file init_d_file
    pidfile pidfile
    port config[:port]
    exec_file exec_file
    cliexec_file cliexec_file
    config_file config_file
    cookbook params[:cookbook]
  end

  monit_conf "#{redis_new_resource.name}" do
    template "redis-monit.erb"
    config(:name => redis_new_resource.name,
           :user => redis_new_resource.user,
           :group => redis_new_resource.group,
           :init_d_file => init_d_file,
           :log_folder => "/var/log/runit/#{redis_new_resource.name}",
           :pidfile => pidfile,
           :exec_file => exec_file,
           :cliexec_file => cliexec_file,
           :config => config)
    cookbook "redis"
  end

  service redis_new_resource.name do
    supports :start => true, :restart => true, :stop => true
    provider Chef::Provider::MonitMonit
  end

  redis_install "redis-server" do
    version redis_new_resource.version
    action :install
    notifies :restart, resources(:service => redis_new_resource.name)
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
