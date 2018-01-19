#
# Cookbook for Snowplow Analytics
#

package 'docker.io'
package 'docker-compose'

# nginx for nsqd and nsqlookupd LB
directory '/snowplow/nginx/docker' do
	owner	'root' 
	group	'root'
	mode	'0755'
	recursive true
	action	:create
end

template '/snowplow/nginx/docker/docker-compose.yml' do
	source	'nginx-docker.erb'
	owner	'root'
	group	'root'
	mode	'0600'
	action	:create
end

template '/snowplow/nginx/nginx.conf' do
        source  'nginx-conf.erb'
        owner   'root'
        group   'root'
        mode    '0664'
        action  :create
end


execute 'nginx-docker-compose' do
	cwd	'/snowplow/nginx/docker'
	command 'docker-compose up -d'
end

