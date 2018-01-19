#
# Cookbook for Snowplow Analytics
#

# Install ELK
execute 'install-elasticsearch' do
	command	'wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.5.3.deb && dpkg -i elasticsearch-5.5.3.deb'
end

template '/etc/elasticsearch/elasticsearch.yml' do
	source	'snowplow-es.erb'
	mode	'0660'
	owner 	'root'
	group	'elasticsearch'
end

service 'elasticsearch-enable-start' do
	service_name	'elasticsearch.service'
	action	 [:enable, :start]
end	

execute 'install-kibana' do
	command	'wget https://artifacts.elastic.co/downloads/kibana/kibana-5.5.3-amd64.deb && dpkg -i kibana-5.5.3-amd64.deb'
end

template '/etc/kibana/kibana.yml' do
        source  'snowplow-kibana.erb'
        mode    '0660'
        owner   'root'
        group   'kibana'
end

service 'kibana-enable-start' do
        service_name    'kibana.service'
        action  [:enable, :start]
end

execute 'install-logstash' do
	command 'wget https://artifacts.elastic.co/downloads/logstash/logstash-5.5.3.deb && dpkg -i logstash-5.5.3.deb'
end

template '/etc/logstash/logstash.yml' do
        source  'snowplow-logstash.erb'
        mode    '0665'
        owner   'root'
	group	'logstash'
end

execute 'logstash-nsq-plugin' do
	command	'/usr/share/logstash/bin/logstash-plugin install logstash-input-nsq'
end

template '/etc/logstash/conf.d/logstash-nsq.conf' do
	source	'logstash-nsq.erb'
	owner	'root'
	group	'root'
	mode	'0665'
	action	:create
end

service 'logstash-enable-start' do
	service_name	'logstash.service'
	action	[:enable, :start]
end

