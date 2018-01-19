#
# Cookbook for Snowplow Analytics
#

package 'docker.io'
package 'docker-compose'

# Snowplow collector and enricher 
directory '/snowplow/config/docker' do
        owner   'root'
        group   'root'
        mode    '0755'
        recursive true
        action  :create
end

template '/snowplow/config/nsq-collector.conf' do
	source	'nsq-collector.erb'
	owner	'root'
	group	'root'
	mode	'0664'
	action	:create
end

template '/snowplow/config/nsq-enrich.conf' do
        source  'nsq-enrich.erb'     
        owner   'root'  
        group   'root'  
        mode    '0664'  
        action  :create
end 

template '/snowplow/config/resolver.conf' do
        source  'nsq-resolver.erb'   
        owner   'root'
        group   'root'
        mode    '0664'
        action  :create
end

template '/snowplow/config/docker/docker-compose.yml' do
        source  'snowplow-docker.erb'
        owner   'root'
        group   'root'
        mode    '0600'
        action  :create
end

execute 'snowplow-docker-compose' do
        cwd     '/snowplow/config/docker'
        command 'docker-compose up -d'
end

