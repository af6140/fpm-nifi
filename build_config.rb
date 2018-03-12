module BuildConfig
  VERSION="1.5.0"
  SOURCE="http://ftp.wayne.edu/apache/nifi/#{VERSION}/nifi-#{VERSION}-bin.tar.gz"
  MD5SUM="3a74c126e81ba88f0aedf49c395ff5d1"

  def self.build_rev
    ENV.fetch('BUILD_REVISION', '0')
  end
end
