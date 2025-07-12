#!/bin/bash
// # Create systemd service unit file
// tee /etc/systemd/system/cloudoffice-ansible-state.service << EOM
// [Unit]
// Description=cloudoffice-ansible-state
// After=network.target

// [Service]
// ExecStart=${project_directory}/cloudoffice-ansible-state.sh
// Type=simple
// Restart=on-failure
// RestartSec=30

// [Install]
// WantedBy=multi-user.target
// EOM

// # Create systemd timer unit file
// tee /etc/systemd/system/cloudoffice-ansible-state.timer << EOM
// [Unit]
// Description=Starts cloudoffice ansible state playbook 1min after boot

// [Timer]
// OnBootSec=1min
// Unit=cloudoffice-ansible-state.service

// [Install]
// WantedBy=multi-user.target
// EOM

# Create cloudoffice vars file to be used with Ansible-playbook
tee ${project_directory}/cloudoffice-vars.yaml << EOM
oci_region: ${oci_region} 
tenancy_ocid: ${tenancy_ocid} 
web_port: ${web_port} 
project_directory: ${project_directory} 
EOM

# Create cloudoffice-ansible-state script
tee ${project_directory}/cloudoffice-ansible-state.sh << EOM
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
mkdir -p ${project_directory}/git/cloudoffice 
# Clone the project into project directory
git clone -b ansible ${project_url} ${project_directory}/git/cloudoffice
# Change to directory
cd ${project_directory}/git/cloudoffice
# Ensure up-to-date
git pull
# Execute playbook
ansible-playbook cloudoffice_playbook.yml --extra-vars '@${project_directory}/cloudoffice-vars.yaml' >> /var/log/cloudoffice.log
EOM

// # Start / Enable cloudoffice-ansible-state
// chmod +x ${project_directory}/cloudoffice-ansible-state.sh
// systemctl daemon-reload
// systemctl start cloudoffice-ansible-state.timer
// systemctl start cloudoffice-ansible-state.service
// systemctl enable cloudoffice-ansible-state.timer
// systemctl enable cloudoffice-ansible-state.service
