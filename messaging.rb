class NifiMessaging < FPM::Cookery::Recipe
  require 'pp'

  name 'nifi-messaging'
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
      nifi-amqp-nar-#{version}.nar
      nifi-jms-cf-service-nar-#{version}.nar
      nifi-jms-processors-nar-#{version}.nar
      nifi-mqtt-nar-#{version}.nar
      nifi-kafka-0-10-nar-#{version}.nar
      nifi-kafka-0-8-nar-#{version}.nar
      nifi-kafka-0-9-nar-#{version}.nar
    )
    lib_assets = Dir.glob(builddir() + "nifi-#{version}/lib/*" )
    lib_assets.each do | asset |
      if (File.extname(asset)==".nar" && target_nars.include?(File.basename(asset)))
        destdir("#{app_dir}/lib").install builddir(File.join("nifi-#{version}/lib", File.basename(asset)))
      end
    end
  end

end