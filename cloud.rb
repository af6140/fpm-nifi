require_relative './build_config'
class NifiCloud < FPM::Cookery::Recipe
  require 'pp'

  name 'nifi-cloud'
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
      nifi-aws-nar-#{version}.nar
      nifi-azure-nar-#{version}.nar
      nifi-gcp-nar-#{version}.nar
    )
    lib_assets = Dir.glob(builddir() + "nifi-#{version}/lib/*" )
    lib_assets.each do | asset |
      if (File.extname(asset)==".nar" && target_nars.include?(File.basename(asset)))
        destdir("#{app_dir}/lib").install builddir(File.join("nifi-#{version}/lib", File.basename(asset)))
      end
    end
  end

end
