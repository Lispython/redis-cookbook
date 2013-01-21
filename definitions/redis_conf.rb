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

  init_d_file = "/etc/init.d/#{params[:name]}"
  pidfile = "/var/run/#{params[:name]}.pid"
  exec_file = "#{node["redis"]["install_dir"]}/bin/redis-client"
  cliexec_file = "#{node["redis"]["install_dir"]}/bin/redis-cli"

  if params[:config_file] then
    config_file = "#{params[:config_file]}"
  else
    config_file = "#{config_dir}/#{params[:name]}.conf"
  end

  # Making redis directory
  directory config_dir do
    owner params[:user]
    group params[:group]
    mode 0640
    recursive true
    action :create
  end

  # Making config dir
  directory data_dir do
    owner params[:user]
    group params[:group]
    mode 0640
    recursive true
    action :create
  end

  # Creating redis config
  template config_file do
    owner params[:user]
    group params[:group]
    source params[:template]
    mode 0640
    variables :config => config.to_hash

    # Specify location for template
    if params[:cookbook]
      cookbook params[:cookbook]
    else
      cookbook "redis"
    end
  end

  # Making init.d script
  template init_d_file do
    owner params[:user]
    group params[:group]
    source params[:init_d_template]
    mode 0640
    variables :port => config["port"], :pidfile => pidfile, :config => config_file, :exec_file => exec_file, :cliexec_file => cliexec_file

    # Specify location for template
    if params[:cookbook]
      cookbook params[:cookbook]
    else
      cookbook "redis"
    end
  end
end