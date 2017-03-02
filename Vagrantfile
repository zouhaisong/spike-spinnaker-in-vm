VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.box_check_update = true
  config.ssh.forward_agent = true

  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  config.vm.network "forwarded_port", guest: 8102, host: 8102, protocol: "tcp", auto_correct: false
  #config.vm.network "forwarded_port", guest: 9000, host: 9000, protocol: "tcp", auto_correct: false
  #config.vm.network "forwarded_port", guest: 8084, host: 8084, protocol: "tcp", auto_correct: false # gate
  #config.vm.network "forwarded_port", guest: 8083, host: 8083, protocol: "tcp", auto_correct: false # orca
  #config.vm.network "forwarded_port", guest: 8088, host: 8088, protocol: "tcp", auto_correct: false # igor
  # config.vm.network "forwarded_port", guest: 80, host: 10080
  # config.vm.network "private_network", ip: "192.168.33.10"
  # config.vm.network "public_network"

  # config.vm.synced_folder "../data", "/vagrant_data"

  description = {:username=>"vagrant", :password=>"123456",
    :usage=>"ubuntu workspace to spike spinnaker", :os=>"ubuntu"
  }

  config.vm.provider :virtualbox do |vb|
    vb.name = "spike-spinnaker"
    vb.memory = 4096
    vb.cpus = 2
    vb.customize ["modifyvm", :id, "--description", description.to_json]
  end
  config.vm.provision :shell, path: "bootstrap.sh"
end
