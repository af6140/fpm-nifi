class NifiLoggin < FPM::Cookery::Recipe
  require 'pp'

  name 'nifi-logging'
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
      nifi-datadog-nar-#{version}.nar
      nifi-lumberjack-nar-#{version}.nar
      nifi-splunk-nar-#{version}.nar
      nifi-windows-event-log-nar-#{version}.nar
      nifi-flume-nar-#{version}.nar
    )
    lib_assets = Dir.glob(builddir() + "nifi-#{version}/lib/*" )
    lib_assets.each do | asset |
      if (File.extname(asset)==".nar" && target_nars.include?(File.basename(asset)))
        destdir("#{app_dir}/lib").install builddir(File.join("nifi-#{version}/lib", File.basename(asset)))
      end
    end
  end

end
