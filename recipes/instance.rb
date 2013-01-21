# -*- coding: utf-8 -*-
#
# Cookbook Name:: redis cookbook
# Recipe:: instance
#
# :copyright: (c) 2013 by Alexandr Lispython (alex@obout.ru).
# :license: BSD, see LICENSE for more details.
# :github: http://github.com/Lispython/redis-cookbook
#

include_recipe "redis::default"

puts("Install redis instance cookbook")

node["redis"]["servers"].each() do |server|
  redis "redis-#{server["port"]}" do
    action :create
    config :port => server["port"], "bind" => server["bind"]
  end
end
