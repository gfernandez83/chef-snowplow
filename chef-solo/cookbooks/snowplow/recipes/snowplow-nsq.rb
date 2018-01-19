#
# Cookbook for Snowplow Analytics
#

package 'docker.io'
package 'docker-compose'

# NSQ as collector and enricher
directory '/snowplow/nsq/docker' do
	owner	'root' 
	group	'root'
	mode	'0755'
	recursive true
	action	:create
end

template '/snowplow/nsq/docker/docker-compose.yml' do
	source	'nsq-docker.erb'
	owner	'root'
	group	'root'
	mode	'0600'
	action	:create
end

execute 'nsq-docker-compose' do
	cwd	'/snowplow/nsq/docker'
	command 'docker-compose up -d'
end

execute 'create-nsq-streams' do
	command	'curl -X POST http://0.0.0.0:4251/topic/create?topic=good;curl -X POST http://0.0.0.0:4251/topic/create?topic=bad; curl -X POST http://0.0.0.0:4251/topic/create?topic=good_enriched; curl -X POST http://0.0.0.0:4251/topic/create?topic=bad_enriched;curl -X POST http://0.0.0.0:4351/topic/create?topic=good; curl -X POST http://0.0.0.0:4351/topic/create?topic=bad; curl -X POST http://0.0.0.0:4351/topic/create?topic=good_enriched; curl -X POST http://0.0.0.0:4351/topic/create?topic=bad_enriched'
end

