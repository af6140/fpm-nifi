require_relative './build_config.rb'

class NifiCloud < FPM::Cookery::Recipe
  require 'pp'

  name 'nifi-cloud'
  arch 'all'
  def self.build_rev
    ENV.fetch('BUILD_REVISION', '0')
  end

  version BuildConfig.VERSION
  revision BuildConfig.build_rev()
  source BuildConfig.SOURCE
  md5 BuildConfig.MD5SUM

  depends 'nifi-base'

  def build
  end


  def install
    app_dir = '/opt/nifi'
    lib_assets = Dir.glob(builddir() + "nifi-#{version}/docs/*" )
    lib_assets.each do | asset |
        destdir("#{app_dir}/docs").install builddir(File.join("nifi-#{version}/docs", File.basename(asset)))
    end
  end

end
