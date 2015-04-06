# -*- coding: utf-8 -*-
#
# Cookbook Name:: redis cookbook
# Definition:: redis_conf
#
# Making redis configuration file
#
# :copyright: (c) 2013 by Alexandr Lispython (alex@obout.ru).
# :license: BSD, see LICENSE for more details.
# :github: http://github.com/Lispython/redis-cookbook
#

class Chef::Recipe
  include Chef::Mixin::DeepMerge
end

define :redis_conf, :name => nil, :template => "redis.conf.erb", :config => {}, :user => "redis", :group => "redis", :cookbook => nil, :config_dir => nil, :config_file => nil, :init_d_template => "redis_init_script.erb" do

  Chef::Log.info("Making redis config for: #{params[:name]}")
  include_recipe "redis::default"

  config = Chef::Mixin::DeepMerge.merge(node["redis"]["config"].to_hash, params[:config])

  config_dir = params[:config_dir] || node["redis"]["config_dir"]
  data_dir = params[:data_dir] || node["redis"]["config"]["data_dir"]

  if params[:config_file] then
    config_file = "#{params[:config_file]}"
  else
    config_file = "#{params[:config_dir] || node["redis"]["config_dir"]}/#{params[:name]}.conf"
  end

  if config['appendonly']
    config["appendfilename"] = "dump-#{params[:name]}.aof"
  end

  # Making redis directory
  directory config_dir do
    owner params[:user]
    group params[:group]
    mode 0655
    recursive true
    action :create
  end

  # Making config dir
  directory data_dir do
    owner params[:user]
    group params[:group]
    mode 0755
    recursive true
    action :create
  end

  # Making log dir
  directory node["redis"]["config"]["logfolder"] do
    owner params[:user]
    group params[:group]
    mode 0755
    recursive true
    action :create
  end

  # Creating redis config
  template config_file do
    owner params[:user]
    group params[:group]
    source params[:template]
    mode 0755
    action :create
    variables :config => config.to_hash

    # Specify location for template
    if params[:cookbook]
      cookbook params[:cookbook]
    else
      cookbook "redis"
    end
  end
end
