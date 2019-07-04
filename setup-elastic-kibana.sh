#!/bin/bash

#Usage - To install Elasticsearch, Kibana and then import data using docker on your local machine, run:
# ./setup-elastic-kibana-data.sh

#TODO Add robustness eg: to fail fast if Docker not installed

# download Elasticsearch & Kibana images
docker pull docker.elastic.co/elasticsearch/elasticsearch:6.3.2
docker pull docker.elastic.co/kibana/kibana:6.3.2

echo "FETCHED docker.elastic.co/elasticsearch/elasticsearch:6.3.2"
echo "FETCHED docker.elastic.co/kibana/kibana:6.3.2"

# Remove previously installed containers
docker stop elasticsearch_1
docker stop kibana_1

# Run elasticsearch
echo "Starting elasticsearch_1"

docker run -d --rm --name elasticsearch_1 -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:6.3.2 && sleep 20s

# Takes about 20 secs
# Or perform GET http://localhost:9200/ and assert on response?

# Run Kibana
echo "Starting kibana_1"
docker run -d --rm --name kibana_1 --link elasticsearch_1:elasticsearch -p 5601:5601 docker.elastic.co/kibana/kibana:6.3.2 && sleep 20s

echo '--------------- list of running containers ---------------------'
docker ps
echo '----------------------------------------------------------------'
