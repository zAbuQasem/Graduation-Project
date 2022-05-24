#!/bin/bash

Source=/var/www/threats.int
Destination=/home/baker/backups/webapp.tgz

mkdir /home/baker/backups
cd $Source
tar -zcf $Destination *
