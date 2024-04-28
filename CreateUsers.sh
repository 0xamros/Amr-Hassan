#!/bin/bash

# Create group webAdmins
groupadd webAdmins

# Create users and add them to the group
useradd -m -G webAdmins DevTeam
useradd -m -G webAdmins OpsTeam

