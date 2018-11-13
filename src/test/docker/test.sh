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
HTTPS_URL="http://localhost:8080"
CURL_CMD="curl -w httpcode=%{http_code}"
# -m, --max-time <seconds> FOR curl operation
CURL_MAX_CONNECTION_TIMEOUT="-m 100"

echo "================ Start WORDPRESS ======================="
docker run --name wordpress-demo \
           -p 9000:9000 \
           -e WORDPRESS_DB_HOST=127.0.0.1 \
           -e WORDPRESS_DB_USER=wp \
           -e WORDPRESS_DB_PASSWORD=wptest \
           -e WORDPRESS_DB_NAME=wordpressdb \
           -e WORDPRESS_TABLE_PREFIX=wp_ \
           -v /tmp/wp:/var/www/html \
           -d kpnictc/wordpress-demo
 
echo "================ Start NGINX ======================="
docker run --name nginx-demo \
           --link wordpress-demo:wordpress \
           -v /tmp/wp:/var/www/html \
           -p 8080:80 \
           -d kpnictc/nginx-demo
           
echo "================ Run some Tests ======================="
echo "================ 1. list containers ======================="
docker container ls -a
echo "================ 2. list processes ======================="
docker container ps
echo "================ 3. inspect containers ======================="
docker container inspect wordpress-demo
docker container inspect nginx-demo
echo "================ 4. inspect port listening ======================="
# perform curl operation
CURL_RETURN_CODE=0
CURL_OUTPUT=`${CURL_CMD} ${CURL_MAX_CONNECTION_TIMEOUT} ${HTTPS_URL} 2> /dev/null` || CURL_RETURN_CODE=$?
if [ ${CURL_RETURN_CODE} -ne 0 ]; then  
    echo "Curl connection failed with return code - ${CURL_RETURN_CODE}"
    exit 1;
else
    echo "Curl connection success"
    # Check http code for curl operation/response in  CURL_OUTPUT
    httpCode=$(echo "${CURL_OUTPUT}" | sed -e 's/.*\httpcode=//')
    if [ ${httpCode} -ne 200 ]; then
        echo "Curl operation/command failed due to server return code - ${httpCode}"
        exit 1;
    fi
fi

echo "================ TODO - ADD MORE TESTS ======================="

