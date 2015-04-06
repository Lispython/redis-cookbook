
define :redis_spawner, :name => nil, :template => "redis_init_script.erb", :host => nil,  :port => nil, :pidfile => nil, :exec_file => nil, :cliexec_file => nil, :cookbook => nil, :config_file => nil,:init_d_file => nil do

  Chef::Log.info("Creating redis init.d at : #{params[:init_d_file]} from #{params[:template]}")

  init_d_file = params[:init_d_file] || "/etc/init.d/#{params[:name]}"

  # Making init.d script
  template params[:init_d_file] do
    owner params[:user]
    group params[:group]
    source params[:template]
    mode 0754
    action :create

    variables :host => params[:host], :port => params[:port], :pidfile => params[:pidfile], :config => params[:config_file], :exec_file => params[:exec_file], :cliexec_file => params[:cliexec_file], :pass => params[:pass]

    # Specify location for template
    if params[:cookbook]
      cookbook params[:cookbook]
    else
      cookbook "redis"
    end
  end
end
