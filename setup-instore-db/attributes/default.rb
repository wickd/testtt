default['symmetricds']['config']['install_service'] = false
default['symmetricds']['config']['run_server_after_install'] = false
default['symmetricds']['config']['demo_mode'] = false
default['symmetricds']['config']['add_to_path'] = false
default['symmetricds']['config']['is_client_node'] = true

default['mariadb']['mysqld']['user'] = 'mysql'
default['mariadb']['mysqld']['port'] = '3380' #3306
default['mariadb']['mysqld']['basedir'] = '/usr'
default['mariadb']['server_root_password'] = ""
default['mariadb']['allow_root_pass_change'] = false
default['mariadb']['use_default_repository'] = true

default['symmetricds']['config']['engine']['name'] = "in_store_001"
default['symmetricds']['config']['engine']['db']['driver'] = "org.h2.Driver"
default['symmetricds']['config']['engine']['db']['url'] = "jdbc:h2:store001;AUTO_SERVER=TRUE;LOCK_TIMEOUT=60000"
default['symmetricds']['config']['engine']['db']['user'] = "symmetric"
default['symmetricds']['config']['engine']['db']['password'] = ""
default['symmetricds']['config']['engine']['registration']['url'] = "http://localhost:31415/sync/corp-000"
default['symmetricds']['config']['engine']['sync']['url'] = "http://localhost:31415/sync/corp-000"
default['symmetricds']['config']['engine']['group']['id'] = "store"
default['symmetricds']['config']['engine']['external']['id'] = 001
default['symmetricds']['config']['engine']['job']['routing']['period']['time']['ms'] = 5000
default['symmetricds']['config']['engine']['job']['push']['period']['time']['ms'] = 10000
default['symmetricds']['config']['engine']['job']['pull']['period']['time']['ms'] = 10000
