# typed: false
# frozen_string_literal: true

class Minimal < Formula
  desc "Extensible terminal coding-agent harness with a Textual interface"
  homepage "https://github.com/RafaSG13/Minimal"
  url "https://files.pythonhosted.org/packages/74/81/46502ed77132bdead31a15a4ce83bfd0a23d7ce5a0fab59329a14d68eba6/mnml_agent-0.6.0.tar.gz"
  sha256 "f29ac330e9e601afb62956ee26947e6487a9eafab0412b5ffdcd3cd61ecf3ab9"
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
    code = "import minimal; print(minimal.__version__)"
    assert_equal version.to_s, shell_output("#{libexec}/bin/python -c '#{code}'").strip
    assert_match "minimal ext install", shell_output("#{bin}/minimal --help")
  end
end
