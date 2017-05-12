class NifiStandard < FPM::Cookery::Recipe
  require 'pp'

  name 'nifi-standard'
  arch 'all'
  def self.build_rev
    ENV.fetch('BUILD_REVISION', '0')
  end

  version "1.2.0"
  revision build_rev()
  source "http://mirrors.ibiblio.org/apache/nifi/#{version}/nifi-#{version}-bin.tar.gz"
  md5 'e1e1c54bf88402f1c5d5b35cfeb1dc76'

  depends 'nifi-base'

  def build
  end

  def install
    app_dir = '/opt/nifi'
    standard_nars = %W(
      nifi-framework-api-#{version}.nar
      nifi-framework-nar-#{version}.nar
      nifi-standard-nar-#{version}.nar
      nifi-standard-services-api-nar-#{version}.nar
      nifi-jetty-bundle-#{version}.nar
      nifi-provenance-repository-nar-#{version}.nar
      nifi-language-translation-nar-#{version}.nar
      nifi-ldap-iaa-providers-nar-#{version}.nar
      nifi-kerberos-iaa-providers-nar-#{version}.nar
      nifi-spring-nar-#{version}.nar
      nifi-site-to-site-reporting-nar-#{version}.nar
      nifi-email-nar-#{version}.nar
      nifi-registry-nar-#{version}.nar
      nifi-stateful-analysis-nar-#{version}.nar
      nifi-update-attribute-nar-#{version}.nar
      nifi-http-context-map-nar-#{version}.nar
      nifi-ssl-context-service-nar-#{version}.nar
      nifi-record-serialization-services-nar-#{version}.nar
      nifi-enrich-nar-#{version}.nar
      nifi-distributed-cache-services-nar-#{version}.nar
    )
    lib_assets = Dir.glob(builddir() + "nifi-#{version}/lib/*" )
    lib_assets.each do | asset |
      if (File.extname(asset)==".nar" && standard_nars.include?(File.basename(asset)))
        destdir("#{app_dir}/lib").install builddir(File.join("nifi-#{version}/lib", File.basename(asset)))
      end
    end
  end

end