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
  chain_recipes "base", "standard", "cloud", "data", "database", "format", "logging", "messaging", "scripting", "network"

  depends "nifi-base", "nifi-standard", "nifi-cloud", "nifi-data", "nifi-database", "nifi-format", "nifi-logging", "nifi-messaging", "nifi-scripting", "nifi-network"
  def build
    # bat_files= Dir.glob(builddir("nifi-#{version}/bin/*.bat"))
    # bat_files.each do |bat_file|
    #   File.delete bat_file
    # end

    # # change nifi data directories
    # nifi_properties = builddir("nifi-#{version}/conf/nifi.properties")

    # prop_content = File.read(nifi_properties)
    # prop_content = prop_content.gsub(/=\.\/database_repository/, '=/var/lib/nifi/database_repository')
    # prop_content = prop_content.gsub(/=\.\/flowfile_repository/, '=/var/lib/nifi/flowfile_repository')
    # prop_content = prop_content.gsub(/=\.\/content_repository/, '=/var/lib/nifi/content_repository')
    # prop_content = prop_content.gsub(/=\.\/provenance_repository/, '=/var/lib/nifi/provenance_repository')
    # prop_content = prop_content.gsub(/=\.conf\/flow\.xml\.gz/, '=/opt/nifi/flow/flow.xml.gz')

    # File.open(nifi_properties, "w") {|file| file.puts prop_content }
  end

  def install
  end
end

