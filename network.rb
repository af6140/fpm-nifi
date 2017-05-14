class NifiNetwork < FPM::Cookery::Recipe
  require 'pp'

  name 'nifi-networking'
  arch 'all'
  version BuildConfig::VERSION
  revision BuildConfig.build_rev()
  source BuildConfig::SOURCE
  md5 BuildConfig::MD5SUM

  depends 'nifi-base'

  def build
  end


  def install
    app_dir = '/opt/nifi'
    target_nars = %W(
      nifi-slack-nar-#{version}.nar
      nifi-snmp-nar-#{version}.nar
      nifi-social-media-nar-#{version}.nar
      nifi-tcp-nar-#{version}.nar
      nifi-websocket-processors-nar-#{version}.nar
      nifi-websocket-services-api-nar-#{version}.nar
      nifi-websocket-services-jetty-nar-#{version}.nar
    )
    lib_assets = Dir.glob(builddir() + "nifi-#{version}/lib/*" )
    lib_assets.each do | asset |
      if (File.extname(asset)==".nar" && target_nars.include?(File.basename(asset)))
        destdir("#{app_dir}/lib").install builddir(File.join("nifi-#{version}/lib", File.basename(asset)))
      end
    end
  end

end
