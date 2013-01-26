#
# Cookbook Name:: redis
# Recipe:: user
#
# Copyright 2013, Alexandr Lispython (alex@oout.ru)
#
# All rights reserved - Do Not Redistribute
#

group node["redis"]["group"] do
  action :create
  system true
  not_if "grep #{node['redis']['group']} /etc/group"
end

user node["redis"]["user"] do
  comment "redis service user"
  gid node["redis"]["group"]
  system true
  shell "/bin/bash"
  action :create
  not_if "grep #{node['redis']['user']} /etc/passwd"
end
