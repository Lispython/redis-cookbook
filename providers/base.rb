def whyrun_supported?
  true
end

action :create do
  Chef::Log.info("Make instance via base #{new_resource.name}")

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

  redis_conf redis_new_resource.name do
    user redis_new_resource.user
    group redis_new_resource.group
    template redis_new_resource.template
    cookbook redis_new_resource.cookbook
    config_dir redis_new_resource.config_dir
    config_file config_file
    config config
  end

  redis_installer = redis_install "redis-server" do
    version redis_new_resource.version
    action :install
  end

  init_d_file = "/etc/init.d/#{redis_new_resource.name}"
  pidfile = "/var/run/#{redis_new_resource.name}.pid"
  exec_file = "#{redis_new_resource.install_dir || node["redis"]["install_dir"]}/bin/redis-server"
  cliexec_file = "#{redis_new_resource.install_dir || node["redis"]["install_dir"]}/bin/redis-cli"

  redis_spawner redis_new_resource.name do
    init_d_file init_d_file
    pidfile pidfile
    port port
    exec_file exec_file
    cliexec_file cliexec_file
    config_file config_file
    cookbook params[:cookbook]
    notifies :restart, resources(:service => redis_new_resource.name), :delayed
  end

  service redis_new_resource.name do
    action :restart
  end
end
