# -*- coding: utf-8 -*-
#
# Cookbook Name:: redis cookbook
#
# :copyright: (c) 2013 by Alexandr Lispython (alex@obout.ru).
# :license: BSD, see LICENSE for more details.
# :github: http://github.com/Lispython/redis-cookbook
#

# Global params

default["redis"]['packages']['location'] = "http://redis.googlecode.com/files"
default["redis"]['packages']['prefix'] = "redis-"
default["redis"]["download_dir"] = "/tmp"
default["redis"]["install_dir"] = "/usr/local"

default["redis"]["version"] = "2.6.9"
default["redis"]["user"] = "redis"
default["redis"]["group"] = "redis"
default["redis"]["provider"] = "redis_base"
default["redis"]["config_file"] = "/etc/redis/redis.conf"
default["redis"]["config_dir"] = "/etc/redis"

# Config parameters
# MAIN
default["redis"]["config"]["data_dir"] = "/var/run/redis"
default["redis"]["config"]["daemonize"] = "yes"
default["redis"]["config"]["pid_dir"] = "/var/run"
default["redis"]["config"]["pidfile"] = "#{node["redis"]["config"]["pid_dir"]}/redis.pid"
default["redis"]["config"]["port"] = 6379
default["redis"]["config"]["timeout"] = 0
default["redis"]["config"]["bind"] = "127.0.0.1"

default["redis"]["config"]["listen_socket"] = false
default["redis"]["config"]["unixsocket"] = "/tmp/redis.sock"
default["redis"]["config"]["unixsocketperm"] = 755
default["redis"]["config"]["databases"] = 16

# LOGGING
default["redis"]["config"]["loglevel"] = "notice"
default["redis"]["config"]["logfile"] = "stdout"
default["redis"]["config"]["logfolder"] = "/var/run/log"
default["redis"]["config"]["syslog"]["enabled"] = true
default["redis"]["config"]["syslog"]["ident"] = "redis"
default["redis"]["config"]["syslog"]["facility"] = "local0"


# SNAPSHOTTING
default["redis"]["config"]["save"] = [[900, 1], [300, 10], [60, 10000]]
default["redis"]["config"]["rdbcompression"] = "yes"
default["redis"]["config"]["stop-writes-on-bgsave-error"] = "yes"
default["redis"]["config"]["rdbchecksum"] = "yes"
default["redis"]["config"]["dbfilename"] = "dump.rdb"
default["redis"]["config"]["dir"] = "/var/lib/redis"

# SECURITY
default["redis"]["config"]["requirepass"] = nil

#REPLICATION
default["redis"]["config"]["slave-serve-stale-data"] = "yes"
default["redis"]["config"]["slave-read-only"] = "yes"
default["redis"]["config"]["slave-priority"] = 100

# LIMITS
default["redis"]["config"]["maxclients"] = nil # 1000
default["redis"]["config"]["maxmemory"] = nil
default["redis"]["config"]["maxmemory-police"] = nil

# APPEND ONLY MODE
default["redis"]["config"]["appendonly"] = false
default["redis"]["config"]["appendfsync"] = "everysec"
default["redis"]["config"]["no-appendfsync-on-rewrite"] = "no"
default["redis"]["config"]["auto-aof-rewrite-min-size"] = "64mb"
default["redis"]["config"]["auto-aof-rewrite-percentage"]= 100

# LUA SCRIPTING
default["redis"]["config"]["lua-time-limit"] = 5000

# SLOW LOG
default["redis"]["config"]["slowlog-log-slower-than"] = 10000
default["redis"]["config"]["slowlog-max-len"] = 128

# ADVANCED CONFIG
default["redis"]["config"]["hash-max-ziplist-entries"] = 512
default["redis"]["config"]["hash-max-ziplist-value"] = 64

default["redis"]["config"]["list-max-ziplist-entries"] = 512
default["redis"]["config"]["list-max-ziplist-value"] = 64
default["redis"]["config"]["set-max-intset-entries"] = 512

default["redis"]["config"]["zset-max-ziplist-entries"] = 128
default["redis"]["config"]["zset-max-ziplist-value"] = 64

default["redis"]["config"]["activerehashing"] = true
default["redis"]["config"]["client-output-buffer-limits"] = {
  "normal" => "0 0 0",
  "slave" => "256mb 64mb 60",
  "pubsub" => "32mb 8mb 60"
}


# SERVERS CUSTOMIZING
default["redis"]["servers"] = []
