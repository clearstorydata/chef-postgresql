#
# Cookbook Name:: postgresql
# Recipe:: wal-e_recovery

# only install the wal-e entry if we have recovery mode turned on and wal-e enabled
include_recipe "postgresql::set_attr"

if (node['postgresql']['recovery'] || {})['wal_e'] && node['postgresql']['wal_e']['enabled']
  include_recipe 'postgresql::wal-e'
  Chef::Log.info(
    "Set up our wal-e based recovery file.  " +
    "This is destructive to '#{node['postgresql']['config']['data_directory']}'"
  )

  # Save these in variables.
  myuser  = node['postgresql']['recovery']['user'] ||
    node['postgresql']['wal_e']['user']
  mygroup = node['postgresql']['recovery']['group'] ||
    node['postgresql']['wal_e']['group']

  # Create our wal-e recover env_dir so it can be different
  # from where we write our own back up to.
  env_dir = node['postgresql']['recovery']['env_dir'] ||
    node['postgresql']['wal_e']['env_dir'] + "_recovery"

  postgresql_wal_e_envdir env_dir do
    user  myuser
    group mygroup
    access node['postgresql']['recovery']['aws_access_key'] ||
      node['postgresql']['wal_e']['aws_access_key']
    secret node['postgresql']['recovery']['aws_secret_key'] ||
      node['postgresql']['wal_e']['aws_secret_key']

    s3path node['postgresql']['recovery']['s3path']
  end

  # Create a restore script
  template '/usr/local/sbin/pg_restore.sh' do
    source "pg_restore.sh.erb"
    mode      0700
    user 'root'
    group 'root'
    variables envdir: env_dir,
              datadir: node['postgresql']['config']['data_directory']
  end
end
