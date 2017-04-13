#!/bin/bash

TENANT=$1
echo $TENANT
keystone user-role-add --user luojun01  --role admin  --tenant_id $TENANT
