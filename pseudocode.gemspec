Gem::Specification.new do |spec|
  spec.name          = "jekyll-pseudocode-latex"
  spec.version       = "0.1.1"
  spec.authors       = ["Jules Topart"]
  spec.email         = ["jules.topart@gmail.com"]
  spec.summary       = "A Jekyll plugin to render pseudocode blocks using latex format from MathJax."
  spec.description   = "This plugin allows you to write pseudocode blocks in your Jekyll site using a simplified syntax similar to LaTeX. Make sure to include MathJax"
  spec.homepage      = "https://github.com/JulesTopart/jekyll-pseudocode-latex"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*", "assets/**/*", "README.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "jekyll", ">= 3.0"
end
