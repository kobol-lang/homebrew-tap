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
  version "0.1.1"
  license "Apache-2.0"

  on_macos do
    # Apple Silicon only. Intel Macs: use the fat JAR (any JVM 21+).
    on_arm do
      url "https://github.com/kobol-lang/kobol/releases/download/v#{version}/kobol-macos-arm64.tar.gz"
      sha256 "a051530029bd92ad7b91724c028e176ce9ba76c0fb0ad4aa361895febc8559aa"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/kobol-lang/kobol/releases/download/v#{version}/kobol-linux-aarch64.tar.gz"
      sha256 "fe17ff6a713fb76bcf02090517fc525eeb2ca6aec2f9c74bee1f2d79fba590d0"
    end

    on_intel do
      url "https://github.com/kobol-lang/kobol/releases/download/v#{version}/kobol-linux-x86_64.tar.gz"
      sha256 "ac6e46cb83faa7c81c8efd04a7daaa1777485a66ed02bfede499f2e8077df29c"
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
