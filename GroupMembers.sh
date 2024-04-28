#!/bin/bash

# list of users in the webAdmins group
cat /etc/group |grep webAdmins | cut -d: -f4 | sed "s/,/\n/g"
