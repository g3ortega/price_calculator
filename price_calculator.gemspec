lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'price_calculator/version'

Gem::Specification.new do |spec|
  spec.name          = 'price_calculator'
  spec.executable    = ['price_calculator']
  spec.version       = PriceCalculator::VERSION
  spec.authors       = ['Gerardo Ortega']
  spec.email         = ['geraldavid7@gmail.com']

  spec.summary       = 'Price calculator'
  spec.description   = 'Price calculator'
  spec.homepage      = 'http://github.com'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'http://pricecalculator.com'
    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'http://pricecalculator.com'
    spec.metadata['changelog_uri'] = 'http://pricecalculator.com'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'text-table', '~> 1.2.4'
  spec.add_dependency 'thor', '~> 1.1'
  spec.add_dependency 'dry-types', '~> 1.5'
  spec.add_dependency 'dry-struct', '~> 1.4'

  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'pry'
end
