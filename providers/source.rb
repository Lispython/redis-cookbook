def whyrun_supported?
  true
end

# Install redis package from source
action :install do
  Chef::Log.info("Install redis server")

  @install_dir = new_resource.install_dir || node["redis"]["install_dir"]
  @prefix = new_resource.prefix || node["redis"]["packages"]["prefix"]
  @version = new_resource.version || node["redis"]["version"]

  @tarball_name = "#{@prefix}#{@version}.tar.gz"
  @download_url = "#{new_resource.location || node["redis"]["packages"]["location"]}/#{@tarball_name}"

  if new_resource.download_dir
    @download_dir = new_resource.download_dir
  else
    @download_dir = "#{node["redis"]["download_dir"]}"
  end

  @tarball_file = "#{@download_dir}/#{@tarball_name}"

  Chef::Log.info("Installing Redis #{new_resource.version} from source")
  self.download()
  self.unpack()
  self.build()
  self.install()
end

action :uninstall do
  Chef::Log.info("Uninstall redis server")
end

def download
  Chef::Log.info("Downloading redis tarball from #{@download_url} to #{@tarball_file}")

  # Make aliace
  download_url = @download_url

  remote_file @tarball_file do
    source download_url
    mode 0644
  end
end

def unpack
  Chef::Log.info("Unpacking redis from tarball")
  execute "cd #{@download_dir} && tar zxf #{@tarball_name}"
end

def build
  download_dir = @download_dir
  execute"cd #{@download_dir}/#{@prefix}#{@version} && make clean && make"
end

def install
  execute "cd #{@download_dir}/#{@prefix}#{@version} && make PREFIX=#{@install_dir} install"
  new_resource.updated_by_last_action(true)
end


def redis_exists?
  exists = Chef::ShellOut.new("which redis-server")
  exists.run_command
  exists.exitstatus == 0 ? true : false
end

def version
  if redis_exists?
    redis_version = Chef::ShellOut.new("redis-server -v")
    redis_version.run_command
    version = redis_version.stdout[/version (\d*.\d*.\d*)/,1] || redis_version.stdout[/v=(\d*.\d*.\d*)/,1]
    Chef::Log.info("The Redis server version is: #{version}")
    return version.gsub("\n",'')
  end
  nil
end


def load_current_resource
  @current_resource = Chef::Resource::RedisInstall.new(@new_resource.name)
  @current_resource.version(version)
  @current_resource
end
