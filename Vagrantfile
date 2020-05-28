# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# choose how many machines the cluster will contain.
N_VMS = 3

# give network id to each node
NETWORK_ID = "192.168.55"

# Fail if the vagrant-disksize plugin is not installed
#unless Vagrant.has_plugin?("vagrant-disksize")
	#raise 'vagrant-disksize is not installed!'
#end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	config.vm.box = "ubuntu/bionic64"

	# Increase the default disk size of the bento image (64GB) to 96GB
	# vagrant plugin install vagrant-disksize
	# config.disksize.size = '200GB'

	# vagrant plugin install vagrant-vbguest
	# config.vbguest.auto_update = true

	# use a minimal amount of RAM for each node to avoid overwhelming the host.
	config.vm.provider "virtualbox" do |v|
		v.memory = 1024
		v.cpus = 1
		v.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
	end

	hosts_file = []
	# all nodes
	1.upto(N_VMS) do |i|
		config.vm.define vm_name = "node#{i}" do |config|
			config.vm.hostname = vm_name

			ip = "#{NETWORK_ID}.#{100+i}"
			config.vm.network "private_network",
				ip: ip,
				virtualbox__intnet: "clusternet"
		end
	end

	config.vm.network "private_network", type: "dhcp"

	script = <<-SCRIPT
	set -x
	if [[ ! -e /etc/.provisioned ]]; then
	  ### HOSTS
	  rm /etc/hosts
	  for i in {1..N_VMS}; do
		ip="#{NETWORK_ID}.$((100+i))"
		echo "$ip node$i" >> /etc/hosts
	  done

	  ### SSH KEYS
	  # we only generate the key on one of the nodes
	  if [[ ! -e /vagrant/id_ed25519 ]]; then
		ssh-keygen -t ed25519 -f /vagrant/id_ed25519 -N ""
	  fi
	  install -m 600 -o vagrant -g vagrant /vagrant/id_ed25519 /home/vagrant/.ssh/
	  # the extra 'echo' is needed because Vagrant inserts its own key without a
	  # newline at the end
	  (echo; cat /vagrant/id_ed25519.pub) >> /home/vagrant/.ssh/authorized_keys

	  ### USER APPLICATIONS
	  apt-get -y update
	  apt-get -y install nfs-common
	  apt-get -y install openmpi-bin libopenmpi-dev

	  touch /etc/.provisioned
	fi
	SCRIPT
	script.sub! 'N_VMS', N_VMS.to_s

	# Provision
	config.vm.provision :shell, :path => "bootstrap.sh"

	config.vm.provision "shell", inline: script

end

