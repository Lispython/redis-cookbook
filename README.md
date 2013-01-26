Description
===========

Cookbook for setup and configure [redis](http://redis.io) application.


Requirements
============


Attributes
==========

The redis.conf file are dynamically generated from attributes or via ``redis_conf`` definition.

All default values of attributes you can see in `attributes/default.rb`


Usage
=====
To use the cookbook we recommend creating a cookbook named after the application, e.g. my_app.
In metadata.rb you should declare a dependency on this cookbook:

depends "redis"

Include ``recipe[redis::user]`` and ``recipe[redis]``  to you runlist.

To create many servers on one node overrwrite `node["redis"]["servers"]` attribute.

Add ``"recipe[redis::instance]"`` to you runlist. This recipe configure and run redis-servers from `node["redis"]["servers"]` attribute.

Or make you own custom configuration via resouces and definitions.

Install redis server

  redis_install "redis-server" do
    version "2.6.9"
  end

Create redis config

    redis_conf "redis-6379" do
       user "redis"
       group "group"
       template "redis.conf.erb"
       cookbook "redis"
       config_dir "/etc/redis"
       config :port => 6379
    end

Create launch instance:

    service "redis-6379" do
        supports :status => true, :restart => true, :reload => true
        action [:enable, :restart]
    end

Or you can user `redis` resource that included `redis_conf` and `redis_install`:

    redis "redis-6379" do
        action :create
        config :port => server["port"], "bind" => server["bind"]
    end

Definitions
===========


redis_conf
----------

You can create config for redis need use definition ``redis_conf``:

    redis_conf "redis-6379" do
       user "redis"
       group "group"
       template "redis.conf.erb"
       cookbook "redis"
       config_dir "/etc/redis"
       config :port => 6379
    end

#### Attributes

- ``name`` name or path to config file (if config attr not used)
- ``template`` config template file name
- ``user`` user that own application
- ``group`` gtoup that own application
- ``config`` path to config file
- ``cookbook`` location to search config template
- ``config_file`` path to config file
- ``init_d_template`` init.d template name


Resources
=========

### redis

To configure and run redis instance you can user ``redis`` resouce

#### Attribute parameters

- ``name`` instance name
- ``group`` launch by group
- ``user`` launch by user
- ``config``: path to config file
- ``cookbook`` location to seache templates
- ``template`` config template name
- ``init_template`` init.d script template name
- ``config_dir`` path to configs
- ``data_dir`` path to datadir
- ``version`` version to install
- ``prefix`` package name prefix
- ``location`` package base url location
- ``install_dir`` directory to install redis bin files
- ``download_dir`` temporary directory to download package
- ``provider``: instance porvider (default: ``Chef::Provider::RedisBase``)

### install

Resource used to download and install redis server

- ``name`` package name
- ``version`` redis version
- ``prefix`` redis prefix
- ``location`` uri directory location
- ``install_dir`` directory to install redis bin files
- ``download_dir`` temporary directory to download package

### Providers

redis cookbook support 3 providers:

- ``Chef::Provider::RedisBase`` - simple provider that used by redis that configure and install redis via installation provider
- ``Chef::Provider::RedisSoruce`` - provider that help to download and install redis
- ``Chef::Provider::RedisRunit`` - provider, that spawn instance via ``runit``



Recipes
=======

default
-------

Base recipe to configure redis user and group

instance
--------

Recipe to install simple redis instance.

user
----

Recipe to create users


See also
========

- [Redis &mdash; key-value store](http://redis.io)