require_relative './build_config'
class NifiData < FPM::Cookery::Recipe
  require 'pp'

  name 'nifi-data'
  arch 'all'
  version BuildConfig::VERSION
  revision BuildConfig.build_rev()
  source BuildConfig::SOURCE
  md5 BuildConfig::MD5SUM

  depends 'nifi-commons'

  pre_install 'scripts/pre_install.sh'
  post_install 'scripts/post_install.sh'

  def build
  end


  def install
    app_dir = '/opt/nifi'
    target_nars = %W(
      nifi-ambari-nar-#{version}.nar
      nifi-avro-nar-#{version}.nar
      nifi-beats-nar-#{version}.nar
      nifi-elasticsearch-5-nar-#{version}.nar
      nifi-elasticsearch-nar-#{version}.nar
      nifi-hadoop-libraries-nar-#{version}.nar
      nifi-hadoop-nar-#{version}.nar
      nifi-cybersecurity-nar-#{version}.nar
      nifi-solr-nar-#{version}.nar
      nifi-riemann-nar-#{version}.nar
      nifi-kite-nar-#{version}.nar
      nifi-ignite-nar-#{version}.nar
      nifi-parquet-nar-#{version}.nar
      nifi-kafka-0-11-nar-#{version}.nar
      nifi-kafka-1-0-nar-#{version}.nar
      nifi-kudu-nar-#{version}.nar
      nifi-livy-nar-#{version}.nar
      nifi-livy-controller-service-api-nar-#{version}.nar
      nifi-confluent-platform-nar-#{version}.nar
    )
    lib_assets = Dir.glob(builddir() + "nifi-#{version}/lib/*" )
    lib_assets.each do | asset |
      if (File.extname(asset)==".nar" && target_nars.include?(File.basename(asset)))
        destdir("#{app_dir}/lib").install builddir(File.join("nifi-#{version}/lib", File.basename(asset)))
      end
    end
  end

end
