# typed: false
# frozen_string_literal: true

class Minimal < Formula
  desc "Extensible terminal coding-agent harness with a Textual interface"
  homepage "https://github.com/RafaSG13/Minimal"
  url "https://files.pythonhosted.org/packages/e7/08/bd9a56dc3b175b848d8a97c9161f5d7799a394f0546f3218e8c4173a2cb9/mnml_agent-0.9.0.tar.gz"
  sha256 "8cccaf947829dfb70defe249f9f4c132934a3255b13806a8f77a8a870bdbbf36"
  license "MIT"

  depends_on "python@3.13"
  depends_on "uv"

  def install
    # The package's own dependencies (anthropic, textual, ...) have native wheels, so uv installs them from
    # PyPI instead of Homebrew compiling each one as a resource.
    ENV["UV_CACHE_DIR"] = buildpath/".uv-cache"
    system "uv", "venv", "--python", formula_opt_bin("python@3.13")/"python3.13", libexec
    system "uv", "pip", "install", "--python", libexec/"bin/python", buildpath
    bin.install_symlink libexec/"bin/minimal"
  end

  def caveats
    <<~EOS
      Gemini and OpenAI providers are optional. Add them to this install with:
        uv pip install --python #{libexec}/bin/python google-genai openai
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minimal --version")
    assert_match "minimal ext install", shell_output("#{bin}/minimal --help")
  end
end
