require_relative './build_config.rb'
class NifiCommons < FPM::Cookery::Recipe
  require 'pp'

  name 'nifi-commons'
  arch 'all'

  version BuildConfig::VERSION
  revision BuildConfig.build_rev()

  #source "http://mirrors.ibiblio.org/apache/nifi/#{version}/nifi-#{version}-bin.tar.gz"
  #md5 'e1e1c54bf88402f1c5d5b35cfeb1dc76'
  source BuildConfig::SOURCE
  md5 BuildConfig::MD5SUM

  description 'Apache Nifi Commons, dpendency and bootstrap jars, directory structures'

  directories '/opt/nifi', '/var/log/nifi', '/var/lib/nifi', '/var/run/nifi'

  pre_install 'scripts/pre_install.sh'
  post_install 'scripts/post_install.sh'



  def build
    bat_files= Dir.glob(builddir("nifi-#{version}/bin/*.bat"))
    bat_files.each do |bat_file|
      File.delete bat_file
    end

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
    var("lib/work").mkdir
    var("lib/tmp").mkdir

  end

end
