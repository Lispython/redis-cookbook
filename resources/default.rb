# -*- coding: utf-8 -*-
#
# Cookbook Name:: redis cookbook
# Recipe:: default

# Create redis configuration with instance running
#
# :copyright: (c) 2013 by Alexandr Lispython (alex@obout.ru).
# :license: BSD, see LICENSE for more details.
# :github: http://github.com/Lispython/redis-cookbook
#

actions :create

attribute :name, :kind_of => String, :name_attribute => true

attribute :user, :kind_of => String, :default => "redis"
attribute :group, :kind_of => String, :default => "redis"
attribute :config, :kind_of => Hash, :default => {}
attribute :cookbook, :kind_of => String
attribute :template, :kind_of => String, :default => "redis.conf.erb"
attribute :init_template, :kind_of => String, :default => "redis_init_script.erb"
attribute :config_dir, :kind_of => String
attribute :data_dir, :kind_of => String
attribute :version, :kind_of => String
attribute :prefix, :kind_of => String
attribute :location, :kind_of => String
attribute :install_dir, :kind_of => String
attribute :download_dir, :kind_of => String

def initialize(*args)
  super
  @action = :create
  @sub_resources = []
  @provider = Chef::Provider::RedisBase
end
