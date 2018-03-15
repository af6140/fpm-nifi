require_relative './build_config'
class Nifi < FPM::Cookery::Recipe
  require 'pp'

  name 'nifi'
  arch 'all'
  version BuildConfig::VERSION
  revision BuildConfig.build_rev()
  source BuildConfig::SOURCE
  md5 BuildConfig::MD5SUM

  description 'Apache Nifi'
  pre_install 'scripts/pre_install.sh'
  post_install 'scripts/post_install.sh'


  chain_package true
  chain_recipes "commons", "standard", "cloud", "data", "database", "format", "logging", "messaging", "scripting", "networking", "docs"

  depends "nifi-commons", "nifi-standard", "nifi-cloud", "nifi-data", "nifi-database", "nifi-format", "nifi-logging", "nifi-messaging", "nifi-scripting", "nifi-networking"

  def build
  end

  def install
  end
end
