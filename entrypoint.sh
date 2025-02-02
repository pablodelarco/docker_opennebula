#!/bin/bash

# Generate SSH host keys
ssh-keygen -A

# Generate SSH keys for oneadmin if they don't exist
if [ ! -f /var/lib/one/.ssh/id_rsa ]; then
    sudo -u oneadmin ssh-keygen -t rsa -N "" -f /var/lib/one/.ssh/id_rsa
    chown oneadmin:oneadmin /var/lib/one/.ssh/id_rsa*
    chmod 600 /var/lib/one/.ssh/id_rsa
    chmod 644 /var/lib/one/.ssh/id_rsa.pub
fi

# Create oneprovision SSH key if needed
if [ ! -d /var/lib/one/.ssh-oneprovision ]; then
    sudo -u oneadmin mkdir -p /var/lib/one/.ssh-oneprovision
    sudo -u oneadmin ssh-keygen -t rsa -N "" -f /var/lib/one/.ssh-oneprovision/id_rsa
    chown -R oneadmin:oneadmin /var/lib/one/.ssh-oneprovision
    chmod 600 /var/lib/one/.ssh-oneprovision/id_rsa
fi

# Start services
exec "$@"