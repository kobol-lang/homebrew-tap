# Formula for the Kobol compiler native binary.
#
# This file is hosted in the kobol-lang/homebrew-tap tap repository:
#   https://github.com/kobol-lang/homebrew-tap
#
# Install:
#   brew tap kobol-lang/tap
#   brew install kobol
#
# The SHA-256 fields below are placeholders. This file is the canonical
# template; on each release the `homebrew` job in
# .github/workflows/release.yml fills the real digests from the release's
# SHA256SUMS.txt, bumps `version`, and pushes the result to
# kobol-lang/homebrew-tap (requires the HOMEBREW_TAP_TOKEN secret).
class Kobol < Formula
  desc "A modern COBOL-inspired language for the JVM (native compiler)"
  homepage "https://github.com/kobol-lang/kobol"
  version "0.1.5"
  license "Apache-2.0"

  on_macos do
    # Apple Silicon only. Intel Macs: use the fat JAR (any JVM 21+).
    on_arm do
      url "https://github.com/kobol-lang/kobol/releases/download/v#{version}/kobol-macos-arm64.tar.gz"
      sha256 "6f3abdd865a12acced90ec1ac8a9ab0b61eb923c8cdf1d92b3bf82175849c112"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/kobol-lang/kobol/releases/download/v#{version}/kobol-linux-aarch64.tar.gz"
      sha256 "8f0bb74869739643d626e6d2174416745052e84b7b46379e8a7a9698c2228c78"
    end

    on_intel do
      url "https://github.com/kobol-lang/kobol/releases/download/v#{version}/kobol-linux-x86_64.tar.gz"
      sha256 "c68ec79db80e4c3cea71ed96647cb75ab4dfb9961258b95f81878eacdf481c8b"
    end
  end

  def install
    # The native binary spawns a child `java` to run compiled programs; that JVM
    # needs lib/kobolc.jar (runtime + stdlib). KobolHome resolves it relative to the
    # (canonicalized) executable path, so keep the binary and lib/ together under
    # libexec and expose the binary via a symlink in bin.
    libexec.install "kobol"
    libexec.install "lib"
    bin.install_symlink libexec / "kobol"
  end

  # Compiled Kobol programs run on a JVM; Java 21+ must be available at run time.
  depends_on "openjdk@21" => :recommended

  def caveats
    <<~EOS
      To get started:
        kobol new my-project
        cd my-project && kobol run

      Documentation: https://github.com/kobol-lang/kobol/blob/main/README.md
    EOS
  end

  test do
    # Smoke-test: binary starts and prints the version string
    assert_match "Kobol compiler", shell_output("#{bin}/kobol --version")

    # Minimal compile test
    (testpath / "hello.kbl").write <<~KOBOL
      PROGRAM Hello
      PROCEDURE Main:
        DISPLAY "ok"
      END-PROCEDURE
    KOBOL
    system bin / "kobol", "--check", "hello.kbl"
  end
end
