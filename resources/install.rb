# -*- coding: utf-8 -*-
#
# Cookbook Name:: redis cookbook
# Recipe:: default

# Install redis server
#
# :copyright: (c) 2013 by Alexandr Lispython (alex@obout.ru).
# :license: BSD, see LICENSE for more details.
# :github: http://github.com/Lispython/redis-cookbook
#

actions :install

attribute :name, :kind_of => String, :name_attribute => true

attribute :version, :kind_of => String
attribute :prefix, :kind_of => String
attribute :location, :kind_of => String
attribute :install_dir, :kind_of => String
attribute :download_dir, :kind_of => String


def initialize(name, run_context=nil)
  super
  @action = :install
  @sub_resources = []
  @provider = Chef::Provider::RedisSource
end
