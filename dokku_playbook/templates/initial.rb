## Install SSL pemset for nginx
bash 'create_cert_for_ssl' do
  code <<-EOH
  openssl genrsa > /home/dokku/tls/server.key
  openssl req -subj "/C=JP/ST=Kobe-shi/L=Chuo-ku/O=OpsRock LLC/OU=amiage.com/CN=#{node[:ec2][:public_ipv4]}" \
    -new -x509 -nodes -sha1 -days 3650 -key /home/dokku/tls/server.key > /home/dokku/tls/server.crt
  EOH
  creates '/etc/nginx/dummy_cert.pem'
end

file '/home/dokku/tls/server.crt' do
  mode '0644'
end

file '/home/dokku/tls/server.key' do
  mode '0600'
end

## set publickey for dokku

bash "set publickey for dokku" do
  code <<-EOH
  cat /home/ubuntu/.ssh/authorized_keys | /usr/local/bin/sshcommand acl-add dokku #{node[:ec2].public_keys_0_openssh_key.split[2]}
  EOH
  not_if "grep #{node[:ec2].public_keys_0_openssh_key.split[2]} /home/dokku/.ssh/authorized_keys"
end

## Remove setup files
# file '/etc/cron.d/first_boot' do
#   action :delete
# end
#
# directory '/opt/lw1' do
#   action :delete
#   recursive true
# end
#
# directory '/var/chef/cache' do
#   action :delete
#   recursive true
# end
