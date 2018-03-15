Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
    v.name = "fpm_pkg_1.2"
  end

  config.vm.box = "centos/7"
  config.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: "cache"
  config.vm.provision :shell, path: "test/bootstrap.sh"

  config.vm.network "forwarded_port", guest: 18080, host: 18080,  auto_correct: true
end