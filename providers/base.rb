action :create do
  Chef::Log.info("Make instance via base #{new_resource.name}")

  redis_new_resource = new_resource

  config = Chef::Mixin::DeepMerge.merge(node["redis"]["config"].to_hash, redis_new_resource.config)
  version = redis_new_resource.version || node["redis"]["version"]

  redis_conf redis_new_resource.name do
    user redis_new_resource.user
    group redis_new_resource.group
    template redis_new_resource.template
    cookbook redis_new_resource.cookbook
    config_dir redis_new_resource.config_dir
    config config
  end

  redis_install "redis-server" do
    version redis_new_resource.version
  end

  service redis_new_resource.name do
    supports :status => true, :restart => true, :reload => true
    action [:enable, :restart]
  end
end
