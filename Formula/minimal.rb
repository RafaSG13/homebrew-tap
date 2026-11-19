# typed: false
# frozen_string_literal: true

class Minimal < Formula
  desc "Extensible terminal coding-agent harness with a Textual interface"
  homepage "https://github.com/RafaSG13/Minimal"
  url "https://files.pythonhosted.org/packages/80/d2/b0d1d07ec57829cb8104952f70189d44955e1dad5cd6e890f0ec2df3f4f6/mnml_agent-0.8.0.tar.gz"
  sha256 "d04586e329147bad4a47901559d342bdd03b9cedbb1d21d29dc6797c38f9e766"
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
