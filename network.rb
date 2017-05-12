class NifiNetwork < FPM::Cookery::Recipe
  require 'pp'

  name 'nifi-networking'
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