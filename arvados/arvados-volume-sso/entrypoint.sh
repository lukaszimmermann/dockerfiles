#!/bin/sh

cp -a /opt/data/* /tmp/volume
sync
rm -rf /opt/data
sync

echo "Database Password: <(/tmp/databasepassword)"


sync
