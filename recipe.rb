class Nifi < FPM::Cookery::Recipe
  require 'pp'

  version '1.2.0'
  source "http://mirrors.ibiblio.org/apache/nifi/#{version}/nifi-#{version}-bin.tar.gz"
  md5 'e1e1c54bf88402f1c5d5b35cfeb1dc76'

  name 'nifi'
  arch 'all'
  def self.build_rev
    ENV.fetch('BUILD_REVISION', '0')
  end

  revision build_rev()

  description 'Apache Nifi'

  chain_package true
  chain_recipes "base", "standard", "cloud", "data", "database", "format", "logging", "messaging", "scripting", "network", "docs"

  depends "nifi-base", "nifi-standard", "nifi-cloud", "nifi-data", "nifi-database", "nifi-format", "nifi-logging", "nifi-messaging", "nifi-scripting", "nifi-network"
  def build
  
  end

  def install
  end
end
