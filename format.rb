require_relative './build_config'
class NifiFormat < FPM::Cookery::Recipe
  require 'pp'

  name 'nifi-format'
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
      nifi-ccda-nar-#{version}.nar
      nifi-hl7-nar-#{version}.nar
      nifi-html-nar-#{version}.nar
      nifi-media-nar-#{version}.nar
      nifi-poi-nar-#{version}.nar
      nifi-evtx-nar-#{version}.nar
    )
    lib_assets = Dir.glob(builddir() + "nifi-#{version}/lib/*" )
    lib_assets.each do | asset |
      if (File.extname(asset)==".nar" && target_nars.include?(File.basename(asset)))
        destdir("#{app_dir}/lib").install builddir(File.join("nifi-#{version}/lib", File.basename(asset)))
      end
    end
  end

end
