#
# Cookbook Name:: mariadb
# Recipe:: config
#
# Copyright 2014, blablacar.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

begin
  resources('ruby_block[restart_mysql]')
  no_mysql_restart_rc = false
rescue Chef::Exceptions::ResourceNotFound
  no_mysql_restart_rc = true
  # see Galera SST issue, justifying why we tolerate this.
end

template '/root/.my.cnf' do
  source 'root.cnf.erb'
  owner 'root'
  group 'root'
  mode '0600'
  only_if { node['mariadb']['root_my_cnf'] }
end

template node['mariadb']['configuration']['path'] + '/my.cnf' do
  source 'my.cnf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :create, 'ruby_block[restart_mysql]', :immediately unless no_mysql_restart_rc
end

directory '/etc/my.cnf.d/' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  not_if { ::Dir.exist?('/etc/my.cnf.d/') }
end

innodb_options = {}

innodb_options['comment1'] = '#'
innodb_options['comment2'] = '# * InnoDB'
innodb_options['comment3'] = '#'
innodb_options['comment4'] = '# InnoDB is enabled by default with a 10MB ' \
  'datafile in /var/lib/mysql/.'
innodb_options['comment5'] = '# Read the manual for more InnoDB ' \
  'related options. There are many!'

innodb_options['innodb_log_file_size_comment1'] = '# you can\'t just ' \
  'change log file size, ' \
  'requires special procedure'
innodb_options['innodb_log_file_size'] = if node['mariadb']['innodb']['log_file_size'].empty?
                                           '#innodb_log_file_size = 50M'
                                         else
                                           node['mariadb']['innodb']['log_file_size']
                                         end
if node['mariadb']['innodb']['bps_percentage_memory']
  innodb_options['innodb_buffer_pool_size'] =
    (
      node['mariadb']['innodb']['buffer_pool_size'].to_f *
      (node['memory']['total'][0..-3].to_i / 1024)
    ).round.to_s + 'M'
else
  innodb_options['innodb_buffer_pool_size'] = \
    node['mariadb']['innodb']['buffer_pool_size']
end
innodb_options['innodb_log_buffer_size'] = \
  node['mariadb']['innodb']['log_buffer_size']
innodb_options['innodb_file_per_table'] = \
  node['mariadb']['innodb']['file_per_table']
innodb_options['innodb_open_files'] = node['mariadb']['innodb']['open_files']
innodb_options['innodb_io_capacity'] = \
  node['mariadb']['innodb']['io_capacity']
innodb_options['innodb_flush_method'] = \
  node['mariadb']['innodb']['flush_method']
node['mariadb']['innodb']['options'].each do |key, value|
  innodb_options[key] = value
end

mariadb_configuration '20-innodb' do
  section 'mysqld'
  option innodb_options
  action :add
  notifies :create, 'ruby_block[restart_mysql]', :immediately unless no_mysql_restart_rc
end

replication_opts = {}

if node['mariadb']['replication']['log_bin']
  replication_opts['log_bin'] = node['mariadb']['replication']['log_bin']
  replication_opts['sync_binlog'] = \
    node['mariadb']['replication']['sync_binlog']
  replication_opts['log_bin_index']    = \
    node['mariadb']['replication']['log_bin_index']
  replication_opts['expire_logs_days'] = \
    node['mariadb']['replication']['expire_logs_days']
  replication_opts['max_binlog_size'] = \
    node['mariadb']['replication']['max_binlog_size']
end

unless node['mariadb']['replication']['server_id'].empty?
  replication_opts['server_id'] = node['mariadb']['replication']['server_id']
end
node['mariadb']['replication']['options'].each do |key, value|
  replication_opts[key] = value
end

mariadb_configuration '30-replication' do
  section 'mysqld'
  option replication_opts
  action :add
  notifies :create, 'ruby_block[restart_mysql]', :immediately unless no_mysql_restart_rc
end
