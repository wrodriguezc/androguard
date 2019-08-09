#!/bin/sh

#Remove all previous data
rm -rf /data/static_analysis/$1

#Create required directories
mkdir /data/static_analysis/$1 && mkdir /data/static_analysis/$1/resources && mkdir /data/static_analysis/$1/manifest && mkdir /data/static_analysis/$1/decompiled

#Extract manifest data
androguard axml -o /data/static_analysis/$1/manifest/manifest.xml -i /data/samples/$1/$2

#Extract resource data
androguard arsc -o /data/static_analysis/$1/resources/resources.txt -i /data/samples/$1/$2 

#Extract the package name
package=$(cat /data/static_analysis/$1/manifest/manifest.xml | grep -Po '.*package="\K.*?(?=".*)' | tr '.' '/')
androguard decompile -o /data/static_analysis/$1/decompiled -f png -i /data/samples/$1/$2 --limit "^L$package/.*"