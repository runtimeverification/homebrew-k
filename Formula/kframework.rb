class Kframework < Formula
  desc "K Framework Tools 5.0"
  homepage ""
  url "https://github.com/runtimeverification/k/releases/download/v6.3.40/kframework-6.3.40-src.tar.gz"
  sha256 "d0284e2f86960ef3b5465fc8e4f8e815fed013e3a086ed38f306f2ef01ba6f6a"
  bottle do
    root_url "https://github.com/runtimeverification/k/releases/download/v6.3.40/"
    rebuild 825
    sha256 ventura: "0f6e2b8dc07cc09946d394363742f94b25ffd9bc44727bc6b114b2c1337c81b3"
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
  depends_on "llvm"
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
        with_env(PATH: ENV["PATH"].sub("#{Formula["llvm"].bin}:", "")) do

        # For both components, we need to run the stack phases _outside_ of
        # Maven to prevent connections from timing out.
        cd "haskell-backend/src/main/native/haskell-backend" do
          system "stack", "setup"
          system "stack", "build"
        end

        cd "hs-backend-booster/src/main/native/hs-backend-booster" do
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
