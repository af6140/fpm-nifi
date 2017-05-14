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

  chain_package true
  chain_recipes "commons", "standard", "cloud", "data", "database", "format", "logging", "messaging", "scripting", "network", "docs"

  depends "nifi-commons", "nifi-standard", "nifi-cloud", "nifi-data", "nifi-database", "nifi-format", "nifi-logging", "nifi-messaging", "nifi-scripting", "nifi-network"

  def build
  end

  def install
  end
end
