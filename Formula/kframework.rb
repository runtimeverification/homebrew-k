class Kframework < Formula
  desc "K Framework Tools 5.0"
  homepage ""
  url "file:////Users/jenkins-slave/workspace/K_release/homebrew-k/../kframework-5.1.129-src.tar.gz"
  sha256 "744051d045b2ed111d51ad8c504b821d2032fd2cbe94567a21a755fbfe63428b"
  bottle do
    root_url "https://github.com/kframework/k/releases/download/v5.1.129/"
    rebuild 38
    sha256 cellar: :any, big_sur: "b42d48c489e935969a2c0ee4661ecf30f4a2424656211e124e1eb2648026a9fb"
  end
  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "haskell-stack" => :build
  depends_on "maven" => :build
  depends_on "pkg-config" => :build
  depends_on "bison"
  depends_on "flex"
  depends_on "gmp"
  depends_on "jemalloc"
  depends_on "libyaml"
  depends_on "llvm@8"
  depends_on "mpfr"
  depends_on "z3"

  def install
    ENV["SDKROOT"] = MacOS.sdk_path
    ENV["DESTDIR"] = ""
    ENV["PREFIX"] = prefix.to_s

    # Unset MAKEFLAGS for `stack setup`.
    # Prevents `install: mkdir ... ghc-7.10.3/lib: File exists`
    # See also: https://github.com/brewsci/homebrew-science/blob/bb52ecc66b6f9fad4d281342139189ae81d7c410/Formula/tamarin-prover.rb#L27
    ENV.deparallelize do
      cd "haskell-backend/src/main/native/haskell-backend" do
        system "stack", "setup"
      end
    end

    system "mvn", "package", "-DskipTests", "-Dproject.build.type=FastBuild"
    system "package/package"
  end

  test do
    system "true"
  end
end
