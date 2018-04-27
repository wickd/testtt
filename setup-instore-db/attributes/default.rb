default['symmetricds']['config']['install_service'] = false
default['symmetricds']['config']['run_server_after_install'] = false
default['symmetricds']['config']['demo_mode'] = false
default['symmetricds']['config']['add_to_path'] = false
default['symmetricds']['config']['is_client_node'] = true

default['symmetricds']['config']['node']['client']['engine']['name'] = "in_store"
default['symmetricds']['config']['node']['client']['db']['driver'] = "jdbc:mysql://localhost/sampleroot?tinyInt1isBit=false&zeroDateTimeBehavior=convertToNull"
default['symmetricds']['config']['node']['client']['db']['url'] = "192.168.100.7:3306"
default['symmetricds']['config']['node']['client']['db']['user'] = "kfcfran"
default['symmetricds']['config']['node']['client']['db']['password'] = "colonel"
default['symmetricds']['config']['node']['client']['sync']['url'] = "http://192.168.100.7:31415/sync/corp-000"
default['symmetricds']['config']['node']['client']['group']['id'] = "in_store_group"
default['symmetricds']['config']['node']['client']['external']['id'] = 001
default['symmetricds']['config']['node']['client']['job']['routing']['period']['time']['ms'] = 5000
default['symmetricds']['config']['node']['client']['job']['push']['period']['time']['ms'] = 10000
default['symmetricds']['config']['node']['client']['job']['pull']['period']['time']['ms'] = 10000