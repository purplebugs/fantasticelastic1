#!/bin/bash

#Usage - To install Elasticsearch and Kibana using docker on your local machine, run:
# ./setup-elastic-kibana.sh

#TODO Add robustness eg: to fail fast if Docker not installed

# download Elasticsearch & Kibana images
docker pull docker.elastic.co/elasticsearch/elasticsearch:7.2.0
docker pull docker.elastic.co/kibana/kibana:7.2.0

echo "FETCHED docker.elastic.co/elasticsearch/elasticsearch:7.2.0"
echo "FETCHED docker.elastic.co/kibana/kibana:7.2.0"

# Remove previously installed containers
docker stop elasticsearch_1
docker stop kibana_1

# Run elasticsearch
echo "Starting elasticsearch_1"

docker run -d --rm --name elasticsearch_1 -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:7.2.0 && sleep 20s

# Takes about 20 secs
# Or perform GET http://localhost:9200/ and assert on response?

# Run Kibana
echo "Starting kibana_1"
docker run -d --rm --name kibana_1 --link elasticsearch_1:elasticsearch -p 5601:5601 docker.elastic.co/kibana/kibana:7.2.0 && sleep 20s

echo '--------------- list of running containers ---------------------'
docker ps
echo '----------------------------------------------------------------'


#docker exec -it elasticsearch_1 bash <--- Do not need to be in interactive mode for this! Can simply run the bash commands as follows:

echo "About to create the index: eurovision_winners..."
echo "... add bulk add the data from an external file: eurovision_winners.json ..."
echo "... where each row is known as a document in elasticsearch, and setting the document indexes as the numbers in the path"

curl -s -H "Content-Type: application/json" -XPOST http://localhost:9200/eurovision_winners/docs/_bulk --data-binary "@eurovision_winners.json"
