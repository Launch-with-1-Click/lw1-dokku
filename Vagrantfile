# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "dummy"


  ## AWS
  config.vm.provider :aws do |aws, override|
    aws.access_key_id = ENV['AWS_ACCESS_KEY']
    aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
    aws.keypair_name = ENV['AWS_EC2_KEYPAIR']

    aws.region = ENV['AWS_REGION']
    aws.instance_type = 'c3.2xlarge'
    case ENV['AWS_REGION']
    when 'ap-northeast-1'
      aws.ami = "ami-a1124fa0" # Ubuntu Server 14.04 LTS (HVM), SSD Volume Type
    when 'us-east-1'
      aws.ami = "ami-864d84ee" # Ubuntu Server 14.04 LTS (HVM), SSD Volume Type
    else
      raise "Unsupported region #{ENV['AWS_REGION']}"
    end

    aws.tags = {
      'Name' => 'Dokku host'
    }

    override.ssh.username = "ubuntu"
    override.ssh.private_key_path = ENV['AWS_EC2_KEYPASS']
  end

  config.vm.provision :shell, :path => "bootstrap.sh"
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "dokku_playbook/main.yml"
  end

end
