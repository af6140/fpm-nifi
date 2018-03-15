require_relative './build_config.rb'

class NifiDocs < FPM::Cookery::Recipe
  require 'pp'

  name 'nifi-docs'
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
    lib_assets = Dir.glob(builddir() + "nifi-#{version}/docs/*" )
    lib_assets.each do | asset |
        destdir("#{app_dir}/docs").install builddir(File.join("nifi-#{version}/docs", File.basename(asset)))
    end
  end

end
