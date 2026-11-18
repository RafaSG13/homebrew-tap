# typed: false
# frozen_string_literal: true

class Minimal < Formula
  desc "Extensible terminal coding-agent harness with a Textual interface"
  homepage "https://github.com/RafaSG13/Minimal"
  url "https://files.pythonhosted.org/packages/75/e8/f549a3ac8163e8bd384a675f4c31d6cb6aaa63aebedb9ee8200870d1ea16/mnml_agent-0.7.0.tar.gz"
  sha256 "d6e8ff88fab38fa0c0054ef6784009d471738a2fef9b812518f2605492ec5cd1"
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
