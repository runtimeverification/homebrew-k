class Kframework < Formula
  desc "K Framework Tools 5.0"
  bottle do
    root_url "https://github.com/kframework/k/releases/download/v5.0.0-26cf9b3/"
    sha256 "d156deb6374b00f38994272a96ba16b2e0a0f052c8717a113042cb477b2fb621" => :mojave
  end

  homepage ""
  url "https://github.com/kframework/k/releases/download/v5.0.0-26cf9b3/kframework-5.0.0-src.tar.gz"
  sha256 "2e92023af2db9cbaddc24b44f7dcea80dab5e3f74527c3b28ee39d2afc0c0c5a"
  depends_on "maven" => :build
  depends_on "cmake" => :build
  depends_on "boost" => :build
  depends_on "haskell-stack" => :build
  depends_on "libyaml"
  depends_on "jemalloc"
  depends_on "llvm@8"
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "z3"
  depends_on "opam"
  depends_on "pkg-config" => :build
  depends_on "bison"
  depends_on "flex"

  def install
    ENV["SDKROOT"] = MacOS.sdk_path
    ENV["DESTDIR"] = ""
    ENV["PREFIX"] = "#{prefix}"

    system "mvn", "package", "-DskipTests", "-Dproject.build.type=FastBuild"
    system "package/package"
  end

  def post_install
    ENV["OPAMROOT"] = "#{prefix}/lib/kframework/opamroot"
    ENV["INIT_ARGS"] = "--disable-sandboxing"
    system "#{prefix}/bin/k-configure-opam"
  end

  test do
    system "true"
  end
end
