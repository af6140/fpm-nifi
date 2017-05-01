class Nifi < FPM::Cookery::Recipe
  require 'pp'

  version '1.1.2'
  source "http://mirrors.ibiblio.org/apache/nifi/#{version}/nifi-#{version}-bin.tar.gz"
  md5 '06113cdc410fdd75d7a2a805c9d44777'

  name 'nifi'
  arch 'all'
  revision '0'

  description 'Apache Nifi'

  config_files '/opt/nifi/conf/nifi.properties', '/opt/nifi/conf/bootstrap.conf', '/opt/nifi/conf/zookeeper.properties',
    '/opt/nifi/conf/logback.xml', '/opt/nifi/conf/authorizers.xml', '/opt/nifi/conf/state-management.xml', '/opt/nifi/conf/login-identity-providers.xml',
    '/opt/nifi/conf/bootstrap-notification-services.xml', '/etc/sysconfig/nifi'

  directories '/opt/nifi', '/var/log/nifi', '/var/lib/nifi', '/var/run/nifi'

  pre_install 'scripts/pre_install.sh'
  post_install 'scripts/post_install.sh'

  def build
    bat_files= Dir.glob(builddir("nifi-#{version}/bin/*.bat"))
    bat_files.each do |bat_file|
      File.delete bat_file
    end

    # change nifi data directories
    nifi_properties = builddir("nifi-#{version}/conf/nifi.properties")

    prop_content = File.read(nifi_properties)
    prop_content = prop_content.gsub(/=\.\/database_repository/, '=/var/lib/nifi/database_repository')
    prop_content = prop_content.gsub(/=\.\/flowfile_repository/, '=/var/lib/nifi/flowfile_repository')
    prop_content = prop_content.gsub(/=\.\/content_repository/, '=/var/lib/nifi/content_repository')
    prop_content = prop_content.gsub(/=\.\/provenance_repository/, '=/var/lib/nifi/provenance_repository')

    File.open(nifi_properties, "w") {|file| file.puts prop_content }
  end

  def install
    app_dir = '/opt/nifi'
    destdir(app_dir).mkdir

    assets = Dir.glob(builddir() + "nifi-#{version}/*" )
    assets.each do | asset |
      destdir("#{app_dir}").install builddir("nifi-#{version}/" +File.basename(asset))
    end

    destdir("#{app_dir}/bin").install workdir("scripts/nifi-env.sh")
    var("lib/nifi").mkdir
    var("log/nifi").mkdir
    var("run/nifi").mkdir
    root('/usr/lib/systemd/system').install workdir('scripts/nifi.service')

    root('/etc/sysconfig/').install workdir('scripts/nifi')
  end

end

