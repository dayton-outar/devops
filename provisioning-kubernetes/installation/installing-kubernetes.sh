## Adapted from https://phoenixnap.com/kb/install-minikube-on-centos

# Update repository
yum -y upgrade

# Set up a KVM hypervisor
yum -y install epel-release
yum -y install libvirt qemu-kvm virt-install virt-top libguestfs-tools bridge-utils

# Start the service
systemctl start libvirtd
sudo systemctl enable libvirtd

# Confirm the service is running. Informational purposes
systemctl status libvirtd

# Add current user to libvirt group
usermod -aG libvirt $(whoami)


# Wget not installed in Centos by default
yum install -y wget

# Download minikube
wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

# Grant minikube permissions to execute
chmod +x minikube-linux-amd64

# Move to local binary folder to be executable in local path
mv minikube-linux-amd64 /usr/local/bin/minikube

# Download kubectl
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"

# Grant kubectl permissions to execute
chmod +x kubectl

# Move to local binary folder to be executable on local path
mv kubectl  /usr/local/bin/

# Configure the libvirt KVM with the following security parameters
## * unix_sock_group = "libvirt"
## * unix_sock_rw_perms = "0770"
#vi /etc/libvirt/libvirtd.conf
#systemctl restart libvirtd.service

# Install Docker
yum install -y docker

# Start Docker
systemctl start docker
# Enable Docker
systemctl enable docker