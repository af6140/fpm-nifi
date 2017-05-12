class NifiBase < FPM::Cookery::Recipe
  require 'pp'

  name 'nifi-base'
  arch 'all'
  def self.build_rev
    ENV.fetch('BUILD_REVISION', '0')
  end

  #source '', :with => :noop

  version "1.2.0"
  revision build_rev()

  source "http://mirrors.ibiblio.org/apache/nifi/#{version}/nifi-#{version}-bin.tar.gz"
  md5 'e1e1c54bf88402f1c5d5b35cfeb1dc76'

  description 'Apache Nifi Base'
  # config_files '/opt/nifi/conf/nifi.properties', '/opt/nifi/conf/bootstrap.conf', '/opt/nifi/conf/zookeeper.properties',
  #   '/opt/nifi/conf/logback.xml', '/opt/nifi/conf/authorizers.xml', '/opt/nifi/conf/state-management.xml', '/opt/nifi/conf/login-identity-providers.xml',
  #   '/opt/nifi/conf/bootstrap-notification-services.xml', '/etc/sysconfig/nifi', '/opt/nifi/flow'

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
    prop_content = prop_content.gsub(/=\.conf\/flow\.xml\.gz/, '=/opt/nifi/flow/flow.xml.gz')

    File.open(nifi_properties, "w") {|file| file.puts prop_content }
  end

  def install
    app_dir = '/opt/nifi'
    destdir(app_dir).mkdir

    lib_assets = Dir.glob(builddir() + "nifi-#{version}/lib/*" )
    lib_assets.each do | asset |
      puts asset
      if (File.extname(asset)==".jar")
        destdir("#{app_dir}/lib").install builddir(File.join("nifi-#{version}/lib", File.basename(asset)))
      end
    end

    bootstrap_assets = Dir.glob(File.join(builddir() ,"nifi-#{version}/lib/bootstrap/*" ))
    bootstrap_assets.each do |asset|
      destdir("#{app_dir}/lib/bootstrap").install builddir(File.join("nifi-#{version}/lib/bootstrap", File.basename(asset)))
    end

    opt("nifi/flow").mkdir
    destdir("#{app_dir}/bin").install workdir("scripts/nifi-env.sh")
    var("lib/nifi").mkdir
    var("log/nifi").mkdir
    var("run/nifi").mkdir
    var("lib/work").mkdir
    var("lib/tmp").mkdir
    root('/usr/lib/systemd/system').install workdir('scripts/nifi.service')

    root('/etc/sysconfig/').install workdir('scripts/nifi')
  end

end

