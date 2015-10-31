module OS
	def OS.windows?
		(/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
	end

	def OS.mac?
		(/darwin/ =~ RUBY_PLATFORM) != nil
	end

	def OS.unix?
		!OS.windows?
	end

	def OS.linux?
		OS.unix? and not OS.mac?
	end
end

# Require YAML module
require 'yaml'
# Read YAML file with box details
configuration = YAML.load_file('config.yaml')
Vagrant.require_version '>= 1.6.0'

Vagrant.configure(2) do |config|

	config.ssh.forward_x11 = configuration["x11forward"]
    config.vm.box = configuration["box"]
    config.vm.hostname = configuration["hostname"]
    config.vm.network "private_network", ip: configuration["ip"]

	# Configuration of the hardware here
    config.vm.provider "virtualbox" do |vb|
        vb.name = configuration["name"]
        vb.memory = configuration["ram"]
        vb.gui = configuration["gui"]
        vb.cpus = configuration["cpus"]
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
		# choices: hda sb16 ac97
		if OS.windows?
			vb.customize ["modifyvm", :id, '--audio', 'dsound', '--audiocontroller', 'hda']
		end
		if OS.mac?
			vb.customize ["modifyvm", :id, '--audio', 'coreaudio', '--audiocontroller', 'hda']
		end
		# Set the VRAM
		vb.customize ["modifyvm", :id, '--vram', configuration["vram"] ]
    end

	# Install the box
    config.vm.provision :shell, :path => "vagrant/install.sh"
    config.vm.provision :shell, :path => "vagrant/postinstall.sh"

	# Any final thoughts?
    config.vm.provision "shell", run: "always" do |s|
		# ending message
        s.inline = "figlet All Done!!"
    end
end
