name              "postgresql"
maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
issues_url        "https://github.com/clearstorydata/chef-postgresql/issues"
source_url        "https://github.com/clearstorydata/chef-postgresql"
description       "Installs and configures postgresql for clients or servers"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "3.5.1015"
recipe            "postgresql", "Includes postgresql::client"
recipe            "postgresql::ruby", "Installs pg gem for Ruby bindings"
recipe            "postgresql::client", "Installs postgresql client package(s)"
recipe            "postgresql::server_streaming_master", "Installs a postgresql streaming (and log shipping) master"
recipe            "postgresql::server_streaming_slave", "Install s postgresql streaming slave (and hot_standby)"
recipe            "postgresql::server", "Installs postgresql server packages, templates"
recipe            "postgresql::server_redhat", "Installs postgresql server packages, redhat family style"
recipe            "postgresql::server_debian", "Installs postgresql server packages, debian family style"
recipe            "postgresql::set_attr", "Sets default compund attributes, included by all other recipes."
recipe            "postgresql::wal-e", "Installs wal-e S3 backup process for postgres"
recipe            "postgresql::wal-e_archive", "Set up wal-e archiving."
recipe            "postgresql::wal-e_recovery", "Restore postgres use wal-e."

%w{ubuntu debian fedora suse amazon}.each do |os|
  supports os
end

%w{redhat centos scientific oracle}.each do |el|
  supports el, ">= 6.0"
end

depends "apt"
depends "build-essential"
depends "logrotate"
depends "openssl"
depends "python"
