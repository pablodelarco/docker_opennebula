# Use a stable Ubuntu base image
FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install base dependencies
# Install base dependencies
# Install OpenNebula packages
RUN apt-get update && apt-get install -y \
    opennebula \
    opennebula-sunstone \
    opennebula-fireedge \
    opennebula-gate \
    opennebula-flow \
    opennebula-provision \
    # Remove auto-generated keys
    && rm -rf /var/lib/one/.ssh* \
    # Recreate directories without keys
    && mkdir -p /var/lib/one/.ssh /var/lib/one/.ssh-oneprovision \
    && chown -R oneadmin:oneadmin /var/lib/one/.ssh* \
    && chmod 700 /var/lib/one/.ssh \
    && rm -rf /var/lib/apt/lists/*

# Create keyrings directory
RUN mkdir -p /etc/apt/keyrings

# Add OpenNebula repository with the correct key
RUN wget -q -O- https://downloads.opennebula.io/repo/repo2.key | gpg --dearmor --yes --output /etc/apt/keyrings/opennebula.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/opennebula.gpg] https://downloads.opennebula.io/repo/6.10/Ubuntu/22.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list

# Install OpenNebula packages
RUN apt-get update && apt-get install -y \
    opennebula \
    opennebula-sunstone \
    opennebula-fireedge \
    opennebula-gate \
    opennebula-flow \
    opennebula-provision \
    && rm -rf /var/lib/apt/lists/*

# Configure oneadmin user
RUN usermod -aG sudo oneadmin && \
    echo "oneadmin ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set up oneadmin authentication
RUN mkdir -p /var/lib/one/.one \
    && echo 'oneadmin:oneadmin' > /var/lib/one/.one/one_auth \
    && chown -R oneadmin:oneadmin /var/lib/one/.one \
    && chmod 600 /var/lib/one/.one/one_auth \
    && echo 'oneadmin:oneadmin' | chpasswd

# Set up SSH directory structure
RUN mkdir -p /var/lib/one/.ssh && \
    chown -R oneadmin:oneadmin /var/lib/one/.ssh && \
    chmod 700 /var/lib/one/.ssh && \
    mkdir -p /var/run/sshd

# Create necessary directories
RUN mkdir -p /var/log/one /var/lock/one \
    && chown -R oneadmin:oneadmin /var/log/one /var/lock/one

# Initialize OpenNebula DB
RUN sudo -u oneadmin onedb init -f

# Expose ports
EXPOSE 2633 9869 2474 29876 2616 2222

# Copy and set up entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Change CMD to ENTRYPOINT
ENTRYPOINT ["/entrypoint.sh"]
CMD ["sh", "-c", "service ssh start && \
    sudo -u oneadmin /usr/bin/oned && \
    sudo -u oneadmin /usr/bin/sunstone-server start && \
    sudo -u oneadmin /usr/bin/fireedge-server start && \
    sudo -u oneadmin /usr/bin/oneflow-server start && \
    sudo -u oneadmin /usr/bin/onegate-server start && \
    tail -f /var/log/one/*.log"]