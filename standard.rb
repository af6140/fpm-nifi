require_relative './build_config'
class NifiStandard < FPM::Cookery::Recipe
  require 'pp'

  name 'nifi-standard'
  arch 'all'

  version BuildConfig::VERSION
  revision BuildConfig.build_rev()
  source BuildConfig::SOURCE
  md5 BuildConfig::MD5SUM

  depends 'nifi-commons'

  description 'Commonly used processors and controller services, systemd configurations'

  config_files '/opt/nifi/conf/nifi.properties', '/opt/nifi/conf/bootstrap.conf', '/opt/nifi/conf/zookeeper.properties',  '/opt/nifi/conf/logback.xml', '/opt/nifi/conf/authorizers.xml', '/opt/nifi/conf/state-management.xml', '/opt/nifi/conf/login-identity-providers.xml', '/opt/nifi/conf/bootstrap-notification-services.xml', '/etc/sysconfig/nifi'

  pre_install 'scripts/pre_install.sh'
  post_install 'scripts/post_install.sh'

  def build
    # change nifi data directories
    nifi_properties = builddir("nifi-#{version}/conf/nifi.properties")

    prop_content = File.read(nifi_properties)
    prop_content = prop_content.gsub(/=\.\/database_repository/, '=/var/lib/nifi/database_repository')
    prop_content = prop_content.gsub(/=\.\/flowfile_repository/, '=/var/lib/nifi/flowfile_repository')
    prop_content = prop_content.gsub(/=\.\/content_repository/, '=/var/lib/nifi/content_repository')
    prop_content = prop_content.gsub(/=\.\/provenance_repository/, '=/var/lib/nifi/provenance_repository')
    prop_content = prop_content.gsub(/=\.conf\/flow\.xml\.gz/, '=/opt/nifi/flow/flow.xml.gz')

    File.open(nifi_properties, "w") {|file| file.puts prop_content }

    #remove windows batch file
    bat_files= Dir.glob(builddir("nifi-#{version}/bin/*.bat"))
    bat_files.each do |bat_file|
      File.delete bat_file
    end

  end

  def install
    # systemd service and environment file
    root('/usr/lib/systemd/system').install workdir('scripts/nifi.service')
    root('/etc/sysconfig/').install workdir('scripts/nifi')

    # basic nars
    app_dir = '/opt/nifi'
    standard_nars = %W(
      nifi-framework-api-#{version}.nar
      nifi-framework-nar-#{version}.nar
      nifi-standard-nar-#{version}.nar
      nifi-standard-services-api-nar-#{version}.nar
      nifi-jetty-bundle-#{version}.nar
      nifi-provenance-repository-nar-#{version}.nar
      nifi-language-translation-nar-#{version}.nar
      nifi-ldap-iaa-providers-nar-#{version}.nar
      nifi-kerberos-iaa-providers-nar-#{version}.nar
      nifi-spring-nar-#{version}.nar
      nifi-site-to-site-reporting-nar-#{version}.nar
      nifi-email-nar-#{version}.nar
      nifi-registry-nar-#{version}.nar
      nifi-stateful-analysis-nar-#{version}.nar
      nifi-update-attribute-nar-#{version}.nar
      nifi-http-context-map-nar-#{version}.nar
      nifi-ssl-context-service-nar-#{version}.nar
      nifi-record-serialization-services-nar-#{version}.nar
      nifi-enrich-nar-#{version}.nar
      nifi-distributed-cache-services-nar-#{version}.nar
      nifi-lookup-services-nar-#{version}.nar
      nifi-metrics-reporter-service-api-nar-#{version}.nar
      nifi-metircs-reporting-nar-#{version}.nar
    )
    lib_assets = Dir.glob(builddir() + "nifi-#{version}/lib/*" )
    lib_assets.each do | asset |
      if (File.extname(asset)==".nar" && standard_nars.include?(File.basename(asset)))
        destdir("#{app_dir}/lib").install builddir(File.join("nifi-#{version}/lib", File.basename(asset)))
      end
    end

    conf_assets = Dir.glob(builddir() + "nifi-#{version}/conf/*" )
    conf_assets.each do | asset |
      destdir("#{app_dir}/conf").install builddir(File.join("nifi-#{version}/conf", File.basename(asset)))
    end

    bin_assets = Dir.glob(builddir() + "nifi-#{version}/bin/*" )
    bin_assets.each do | asset |
      destdir("#{app_dir}/bin").install builddir(File.join("nifi-#{version}/bin", File.basename(asset)))
    end
    #overwrite nifi-env.sh
    destdir("#{app_dir}/bin").install workdir("scripts/nifi-env.sh")

  end
end
