#!/bin/bash
# Create systemd service unit file
tee /etc/systemd/system/dockerhost-ansible-state.service << EOM
[Unit]
Description=dockerhost-ansible-state
After=network.target

[Service]
ExecStart=${project_directory}/dockerhost-ansible-state.sh
Type=simple
Restart=on-failure
RestartSec=30

[Install]
WantedBy=multi-user.target
EOM

# Create systemd timer unit file
tee /etc/systemd/system/dockerhost-ansible-state.timer << EOM
[Unit]
Description=Starts dockerhost ansible state playbook 1min after boot

[Timer]
OnBootSec=1min
Unit=dockerhost-ansible-state.service

[Install]
WantedBy=multi-user.target
EOM

# Create project directory
mkdir -p ${project_directory}
# Create dockerhost vars file to be used with Ansible-playbook
tee ${project_directory}/dockerhost-vars.yaml << EOM
oci_region: ${oci_region} 
tenancy_ocid: ${tenancy_ocid} 
web_port: ${web_port} 
project_directory: ${project_directory} 
EOM

# Create dockerhost-ansible-state script
tee ${project_directory}/dockerhost-ansible-state.sh << EOM
#!/bin/bash
# set timezone to Australia/Brisbane
timedatectl set-timezone Australia/Brisbane
# Update package list
apt-get update
# Install pip3 and git
DEBIAN_FRONTEND=noninteractive apt-get -y install python3-pip git
# Pip update pip
pip3 install --upgrade --break-system-packages pip
# Install ansible and oci libraries
pip3 install --upgrade --break-system-packages ansible cryptography pyOpenssl "oci==2.87.0" botocore boto3
# And the collection
ansible-galaxy collection install oracle.oci amazon.aws
# add docker group to ubuntu user
sudo usermod -aG docker ubuntu

# Make the project directory
mkdir -p ${project_directory}/git/oci-dockerhost 
# Clone the project into project directory
git clone ${project_url} ${project_directory}/git/oci-dockerhost
# Change to directory
cd ${project_directory}/git/oci-dockerhost
# Ensure up-to-date
git pull
# Execute playbook
ansible-playbook dockerhost_playbook.yml --extra-vars '@${project_directory}/dockerhost-vars.yaml' >> /var/log/dockerhost.log
EOM

# Start / Enable dockerhost-ansible-state
chmod +x ${project_directory}/dockerhost-ansible-state.sh
systemctl daemon-reload
systemctl start dockerhost-ansible-state.timer
systemctl start dockerhost-ansible-state.service
systemctl enable dockerhost-ansible-state.timer
systemctl enable dockerhost-ansible-state.service
