require_relative './build_config.rb'
class NifiCommons < FPM::Cookery::Recipe
  require 'pp'

  name 'nifi-commons'
  arch 'all'

  version BuildConfig::VERSION
  revision BuildConfig.build_rev()

  source BuildConfig::SOURCE
  md5 BuildConfig::MD5SUM

  description 'Apache Nifi dpendency and bootstrap jars, directory structures'

  directories '/opt/nifi', '/var/log/nifi', '/var/lib/nifi', '/var/run/nifi'

  pre_install 'scripts/pre_install.sh'
  post_install 'scripts/post_install.sh'



  def build
  end

  def install
    app_dir = '/opt/nifi'
    destdir(app_dir).mkdir

    lib_assets = Dir.glob(builddir() + "nifi-#{version}/lib/*" )
    lib_assets.each do | asset |
      puts asset
      if (File.extname(asset)==".jar")
        destdir("#{app_dir}/lib").install builddir(File.join("nifi-#{version}/lib", File.basename(asset)))
      end
    end

    bootstrap_assets = Dir.glob(File.join(builddir() ,"nifi-#{version}/lib/bootstrap/*" ))
    bootstrap_assets.each do |asset|
      destdir("#{app_dir}/lib/bootstrap").install builddir(File.join("nifi-#{version}/lib/bootstrap", File.basename(asset)))
    end

    opt("nifi/flow").mkdir
    var("lib/nifi").mkdir
    var("log/nifi").mkdir
    var("run/nifi").mkdir
    var("lib/nifi/work").mkdir
    var("lib/nifi/tmp").mkdir

  end

end
