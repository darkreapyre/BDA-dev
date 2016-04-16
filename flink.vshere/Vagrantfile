Vagrant.require_version ">= 1.4.3"
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  numNodes = 4
  r = numNodes..1
  (r.first).downto(r.last).each do |i|
    config.vm.define "node#{i}" do |node|
      node.vm.box = "centos64"
      node.vm.provider "libvirt" do |v|
        v.memory=1024
        v.nic_model_type="virtio-net-pci"
      end
      node.vm.network :private_network, ip: "10.0.0.10#{i}"
      # base setup
      node.vm.hostname = "node#{i}"

      node.vm.provision "shell" do |s|
        s.path = "scripts/setup-os.sh"
        s.args = "-t #{numNodes}"
      end

      node.vm.provision "shell", path: "scripts/setup-java.sh"
	

        # setting flink
	node.vm.provision "shell" do |s|
          s.path = "scripts/setup-flink.sh"
	  s.args = " -t #{numNodes}"		
        end
        if i == 1
        node.vm.network "forwarded_port", guest: 8080, host: 8080
        node.vm.network "forwarded_port", guest: 8081, host: 8081
		node.vm.provision "shell" do |s|
	        	s.path = "scripts/setup-ssh.sh"
	        	s.args = "#{numNodes}"
        	end
	 else
        # zookeeper
        node.vm.provision "shell" do |s|
          s.path = "scripts/setup-zookeeper.sh"
          s.args = "-t #{numNodes}"
        end
        # kafka broker
        node.vm.provision "shell" do |s|
          s.path = "scripts/setup-kafka.sh"
          s.args = "-t #{numNodes}"
        end

	end
      #After everything is provisioned, start Supervisor
      node.vm.provision "shell", inline: "pgrep supervisord || start supervisor"
      node.vm.provision "shell", inline: "supervisorctl start all"

      end
  end
end
