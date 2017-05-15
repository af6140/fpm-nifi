require_relative './build_config'
class NifiMessaging < FPM::Cookery::Recipe
  require 'pp'

  name 'nifi-messaging'
  arch 'all'
  version BuildConfig::VERSION
  revision BuildConfig.build_rev()
  source BuildConfig::SOURCE
  md5 BuildConfig::MD5SUM

  depends 'nifi-commons'

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
