module BuildConfig
  VERSION="1.2.0"
  SOURCE="http://mirrors.ibiblio.org/apache/nifi/#{version}/nifi-#{version}-bin.tar.gz"
  MD5SUM="e1e1c54bf88402f1c5d5b35cfeb1dc76"
  def build_rev
    ENV.fetch('BUILD_REVISION', '0')
  end
end
