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
TEMP_PLUGINS_PATH=/tmp/plugins
TEMP_THEMES_PATH=/tmp/themes

echo "================ Installing temporary packages ======================="
apk update
apk add --no-cache unzip wget

echo "================ Downloading Themes ======================="
mkdir -p $TEMP_THEMES_PATH
mkdir -p /var/www/html/wp-content/themes/
wget https://downloads.wordpress.org/theme/educenter.1.0.7.zip -P $TEMP_THEMES_PATH
echo "================ Installing Themes ======================="
unzip $TEMP_THEMES_PATH/*.zip -d /var/www/html/wp-content/themes/

echo "================ Downloading Plugins ======================="
mkdir -p $TEMP_PLUGINS_PATH
mkdir -p /var/www/html/wp-content/plugins/
wget https://downloads.wordpress.org/plugin/akismet.4.0.8.zip -P $TEMP_PLUGINS_PATH
echo "================ Installing Plugins ======================="
unzip $TEMP_PLUGINS_PATH/*.zip -d /var/www/html/wp-content/plugins/

echo "================ Clean up ======================="
rm -R $TEMP_PLUGINS_PATH
rm -R $TEMP_THEMES_PATH
apk del unzip wget
