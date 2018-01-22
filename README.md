# Snowplow POC using Chef-Solo
## Getting Started
This project is for setting up on-premise Snowplow test environment using Chef-solo. Snowplow is an open-source data analytics tool that is based from Piwik. If you want to know more about their product, you may check their site - https://snowplowanalytics.com/ or github - https://github.com/snowplow/snowplow. 

### Prerequisites
1. Install chef-client. This work has been tested on Ubuntu 16.04 using Chef version 12.20.3. Better get the same vesion to ensure that it'll work without any dependency or deprecation issues.
```
wget https://packages.chef.io/files/stable/chef/12.20.3/ubuntu/16.04/chef_12.20.3-1_amd64.deb | bash
dpkg -i chef_12.20.3-1_amd64.deb 
```
2. Install Java 8 or higher.
```
apt-get update
apt-get install default-jre
apt-get install default-jdk
add-apt-repository ppa:webupd8team/java
apt-get update
apt-get install oracle-java8-installer
```

## Components
Once all files are placed. Need to update the solo.json file to include all recipes to run.
```
{
    "run_list": [ "recipe[snowplow::snowplow-elk]", "recipe[snowplow::snowplow-nsq]", "recipe[snowplow::snowplow-nnginx]", "recipe[snowplow::snowplow-conf]" ]
}
```
snowplow-nsq: This will spawn dockerized NSQ that will serve as the messaging platform. Please see http://nsq.io/ for detailed explanation how it works. The topics for NSQd will also be created after chef run. These are the topics for good, bad, good enriched and bad enriched.

snowplow-nginx: This will spawn dockerized nginx that will be used as reverse proxy and load balancer for the NSQlookupd and NSQd. I have two sets of NSQlookupd and NSQd for HA while I only use one NSQadmin for the NSQ UI.

snowplow-config: This will configure the snowplow collector and snowplow enricher which will both run as docker containers. The collector is responsible for collecting the good and bad data that will be stored in dedicated NSQd topics. These are the raw data in TSV format (tab-separated values) which needs to be further processed or enriched. This is where enricher comes in, it is responsible for processing the raw data into useful and understandable state but still in TSV format. The data that are enriched are also being stored in dedicated NSQd topics.

snowplow-elk: This installs the ELK stack that will be used for storage and visualization of gathered data - Elasticsearch 5.5.3, Logstash 5.5.3 and Kibana 5.5.3. You may use higher version but I cannot assure that it will work as expected. This has also been tested using ELK version 5.6. Worth noting that I included NSQ to Logstash plugin since I used Logstash to transform my data from TSV to JSON format so it can be stored to Elasticsearch and be viewed in Kibana. 

## Suggestions
To secure you data and access on ELK, you may add x-pack plugins which has 30 days free trial but you need to purchase it after the trial period. You may also use NGINX reverse proxy for login security in Kibana incase you don't want to spend money for x-pack.

## Running the tests
You may now run chef to build the evaluation environment.
```
chef-solo -c solo.rb -j solo.json
```

If you went over Snowplow documentation, you must know that there are several steps to build Snowplow. One of the first part is setting up the trackers. Trackers differ on the type of your application (PHP, Golang, Java, JS, and many more). 
You may set these trackers on your web or mobile applications so you may start plowing your data.

Once the trackers are up, you should observe the data coming into your NSQ, translated by logtsash, stored in ES and can now be viewed in Kibana. This data is essential to assess how well your app works, your users activities and how can you improve your applications in real time to make the best out for your users. This is only the basic setup, your architecture and design will depend on how big your data is and you need to also determine what type of data you need to be able to select the type of platforms you may use for your own environment.



