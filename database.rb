require_relative './build_config'
class NifiDataBase < FPM::Cookery::Recipe
  require 'pp'

  name 'nifi-database'
  arch 'all'
  version BuildConfig::VERSION
  revision BuildConfig.build_rev()
  source BuildConfig::SOURCE
  md5 BuildConfig::MD5SUM

  depends 'nifi-commons'

  post_install 'scripts/post_install.sh'

  def build
  end


  def install
    app_dir = '/opt/nifi'
    target_nars = %W(
      nifi-dbcp-service-nar-#{version}.nar
      nifi-mongodb-nar-#{version}.nar
      nifi-mongodb-services-nar-#{version}.nar
      nifi-hbase_1_1_2-client-service-nar-#{version}.nar
      nifi-hbase-nar-#{version}.nar
      nifi-cassandra-nar-#{version}.nar
      nifi-couchbase-services-api-nar-#{version}.nar
      nifi-couchbase-nar-#{version}.nar
      nifi-hive-nar-#{version}.nar
      nifi-hive-services-api-nar-#{version}.nar
      nifi-cdc-mysql-nar-#{version}.nar
      nifi-hwx-schema-registry-nar-#{version}.nar
      nifi-redis-nar-#{version}.nar
      nifi-redis-service-api-nar-#{version}.nar
      nifi-rethinkdb-nar-#{version}.nar
    )
    lib_assets = Dir.glob(builddir() + "nifi-#{version}/lib/*" )
    lib_assets.each do | asset |
      if (File.extname(asset)==".nar" && target_nars.include?(File.basename(asset)))
        destdir("#{app_dir}/lib").install builddir(File.join("nifi-#{version}/lib", File.basename(asset)))
      end
    end
  end

end
