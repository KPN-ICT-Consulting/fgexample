#!/bin/sh
#/*
# * Copyright (c) 2018 KPN
# *
# * Permission is hereby granted, free of charge, to any person obtaining
# * a copy of this software and associated documentation files (the
# * "Software"), to deal in the Software without restriction, including
# * without limitation the rights to use, copy, modify, merge, publish,
# * distribute, sublicense, and/or sell copies of the Software, and to
# * permit persons to whom the Software is furnished to do so, subject to
# * the following conditions:
# *
# * The above copyright notice and this permission notice shall be
# * included in all copies or substantial portions of the Software.
#
# * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#*/
URL=$(ip addr | grep inet | tr -s ' ' | cut -d ' ' -f 3 | tr -d '/' | awk '/172/{print}')
HTTPS_URL="http://$URL:8080"
CURL_WRITE_OUT="-w http_code=%{http_code}"
# -m, --max-time <seconds> FOR curl operation
CURL_MAX_CONNECTION_TIMEOUT="-m 100"

TEMP_WORKING_DIR=/tmp/wp
echo "================ Create tmp path ======================="
mkdir -p $TEMP_WORKING_DIR
echo "================ Create Wordpress DB ======================="
mysql -e "CREATE USER wp@localhost IDENTIFIED BY 'wptest'; GRANT ALL ON *.* TO wp@localhost; FLUSH PRIVILEGES;"
mysql -e 'create database wordpressdb;'
echo "================ Start WORDPRESS ======================="
docker run --name wordpress-demo \
           -p 9000:9000 \
           -e WORDPRESS_DB_HOST=127.0.0.1 \
           -e WORDPRESS_DB_USER=wp@localhost \
           -e WORDPRESS_DB_PASSWORD=wptest \
           -e WORDPRESS_DB_NAME=wordpressdb \
           -e WORDPRESS_TABLE_PREFIX=wp_ \
           -v $TEMP_WORKING_DIR:/var/www/html \
           -d kpnictc/wordpress-demo

echo "===== Give the container time to start - sleep 30 ===="
sleep 30
echo "===== Show the container has unpacked files in $TEMP_WORKING_DIR ===="
ls -l $TEMP_WORKING_DIR
echo "================ Start NGINX ======================="
docker run --name nginx-demo \
           --link wordpress-demo:wordpress \
           -v $TEMP_WORKING_DIR:/var/www/html \
           -p 8080:80 \
           -d kpnictc/nginx-demo

echo "===== Give the container time to start - sleep 10 ===="
sleep 10            
echo "================ Run some Tests ======================="
echo "================ 1. list containers ======================="
docker container ls -a
echo "================ 2. list processes ======================="
docker container ps
echo "================ 3. inspect containers ======================="
docker container inspect wordpress-demo
docker container inspect nginx-demo
echo "================ 4. show containers logs ======================="
docker container logs wordpress-demo
docker container logs nginx-demo
echo "================ 5. inspect port listening ======================="
echo "the URL to check is ${HTTPS_URL}"
# perform curl operation
CURL_RETURN_CODE=0
CURL_OUTPUT=$(curl ${CURL_WRITE_OUT} ${CURL_MAX_CONNECTION_TIMEOUT} ${HTTPS_URL} 2> /dev/null) || CURL_RETURN_CODE=$?
if [ ${CURL_RETURN_CODE} -ne 0 ]; then  
    echo "Curl connection failed with return code - ${CURL_RETURN_CODE}"
    exit 1;
else
    echo "Curl connection success"
    # Check http code for curl operation/response in  CURL_OUTPUT
    httpCode=$(echo "${CURL_OUTPUT}" | sed -e 's/.*\http_code=//')
    if [ ${httpCode} -ne 200 ]; then
        echo "Curl operation/command failed due to server return code - ${httpCode}"
        exit 1;
    fi
fi

echo "================ TODO - ADD MORE TESTS ======================="

echo "================ Clean up ======================="
docker container stop nginx-demo
docker container stop wordpress-demo
docker container rm nginx-demo
docker container rm wordpress-demo
rm -R $TEMP_WORKING_DIR