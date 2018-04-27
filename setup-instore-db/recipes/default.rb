#
# Cookbook:: setup-instore-db
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

include_recipe 'mariadb'
include_recipe 'yum'
include_recipe 'centos-symmetricds'

execute 'upgrade centos' do
  command "yum upgrade -y"
end

execute 'upgrade centos' do
  command "yum update -y"
end

execute 'install mariadb-server' do
  command "yum install -y mariadb-server"
end

execute 'enable mariadb-server service' do
  command "systemctl enable mariadb"
end

execute 'start mariadb-server service' do
  command "systemctl start mariadb"
end

cookbook_path = File.join(Chef::Config[:cookbook_path], cookbook_name)
migrations_path = File.join(cookbook_path, 'migrations');

execute 'run Instore_Create_Script migration' do
  cwd migrations_path
  # command "mysql -u root -p '' <Instore_Create_Script.sql"
  command "mysql -u root <Instore_Create_Script.sql"
end

execute 'run jms_Create_Script migration' do
  cwd migrations_path
  # command "mysql -u root -p '' <jms_Create_Script.sql"
  command "mysql -u root <jms_Create_Script.sql"
end