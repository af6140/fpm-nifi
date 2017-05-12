class NifiDataBase < FPM::Cookery::Recipe
  require 'pp'

  name 'nifi-database'
  arch 'all'
  def self.build_rev
    ENV.fetch('BUILD_REVISION', '0')
  end

  version "1.2.0"
  revision build_rev()
  source "http://mirrors.ibiblio.org/apache/nifi/#{version}/nifi-#{version}-bin.tar.gz"
  md5 'e1e1c54bf88402f1c5d5b35cfeb1dc76'

  depends 'nifi-base'

  def build
  end


  def install
    app_dir = '/opt/nifi'
    target_nars = %W(
      nifi-dbcp-service-nar-#{version}.nar
      nifi-mongodb-nar-#{version}.nar
      nifi-hbase_1_1_2-client-service-nar-#{version}.nar
      nifi-hbase-nar-#{version}.nar
      nifi-cassandra-nar-#{version}.nar
      nifi-couchbase-nar-#{version}.nar
      nifi-hive-nar-#{version}.nar
      nifi-hive-services-api-nar-#{version}.nar
      nifi-cdc-mysql-nar-#{version}.nar
      nifi-hwx-schema-registry-nar-#{version}.nar
    )
    lib_assets = Dir.glob(builddir() + "nifi-#{version}/lib/*" )
    lib_assets.each do | asset |
      if (File.extname(asset)==".nar" && target_nars.include?(File.basename(asset)))
        destdir("#{app_dir}/lib").install builddir(File.join("nifi-#{version}/lib", File.basename(asset)))
      end
    end
  end

end