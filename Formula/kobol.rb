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
  version "0.1.2"
  license "Apache-2.0"

  on_macos do
    # Apple Silicon only. Intel Macs: use the fat JAR (any JVM 21+).
    on_arm do
      url "https://github.com/kobol-lang/kobol/releases/download/v#{version}/kobol-macos-arm64.tar.gz"
      sha256 "265bb5a091d3c1a81e23f52dd15184dccab75409ff8690c838f94272ec3a5118"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/kobol-lang/kobol/releases/download/v#{version}/kobol-linux-aarch64.tar.gz"
      sha256 "88dcff79e0f6268f4acfd9a1c124cae2a780182fac42f7b24c87e6d599fd66ff"
    end

    on_intel do
      url "https://github.com/kobol-lang/kobol/releases/download/v#{version}/kobol-linux-x86_64.tar.gz"
      sha256 "4a351129c0535109d744f76623b0271a239f9a8cbb45c2ef1025de3422a2154d"
    end
  end

  def install
    bin.install "kobol"
  end

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
