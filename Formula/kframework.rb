class Kframework < Formula
  desc "K Framework Tools 5.0"
  homepage ""
  url "https://github.com/runtimeverification/k/releases/download/v7.1.52/kframework-7.1.52-src.tar.gz"
  sha256 "eec4ff44b932d980873b6824b6e2db925d61e8b21170e04b8225333a3e450135"
  bottle do
    root_url "https://github.com/runtimeverification/k/releases/download/v7.1.52/"
    rebuild 1040
    sha256 arm64_sonoma: "d796cafdca59c0792cb0cecc09e60de65c7aa1a6db35dc56d3efeea17aa015ae"
  end
  depends_on "cmake" => :build
  depends_on "haskell-stack" => :build
  depends_on "maven" => :build
  depends_on "pkg-config" => :build
  depends_on "bison"
  depends_on "boost"
  depends_on "flex"
  depends_on "fmt"
  depends_on "gmp"
  depends_on "jemalloc"
  depends_on "libyaml"
  depends_on "llvm@17"
  depends_on "mpfr"
  depends_on "openjdk"
  depends_on "secp256k1"
  depends_on "z3"

  def install
    ENV["SDKROOT"] = MacOS.sdk_path
    ENV["DESTDIR"] = ""
    ENV["PREFIX"] = prefix.to_s
    ENV["HOMEBREW_PREFIX"] = HOMEBREW_PREFIX

    # Unset MAKEFLAGS for `stack setup`.
    # Prevents `install: mkdir ... ghc-7.10.3/lib: File exists`
    # See also: https://github.com/brewsci/homebrew-science/blob/bb52ecc66b6f9fad4d281342139189ae81d7c410/Formula/tamarin-prover.rb#L27
    ENV.deparallelize do
        # This is a hack to get LLVM off the PATH when building:
        # https://github.com/Homebrew/homebrew-core/issues/122863
        with_env(PATH: ENV["PATH"].sub("#{Formula["llvm@17"].bin}:", "")) do

        # We need to run the stack phases _outside_ of
        # Maven to prevent connections from timing out.
        cd "haskell-backend/src/main/native/haskell-backend" do
          system "stack", "setup"
          system "stack", "build"
        end

      end
    end

    system "mvn", "package", "-DskipTests", "-Dproject.build.type=FastBuild", "-Dmaven.wagon.httpconnectionManager.ttlSeconds=30"
    system "package/package"
  end

  test do
    system "true"
  end
end
