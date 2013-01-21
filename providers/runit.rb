action :create do
  Chef::Log.info("Make instance via runit #{new_resource.name}")

  redis_new_resource = new_resource

  config = Chef::Mixin::DeepMerge.merge(node.redis.defaults.to_hash, redis_new_resource.config)

  redis_conf redis_new_resource.name do
    user redis_new_resource.user
    group redis_new_resouce.group
    template redis_new_resource.template
  end

  # service redis_new_resource.name do
  #   supports :status => true, :restart => true, :reload => true
  #   action [:enable, :restart]
  # end
end
