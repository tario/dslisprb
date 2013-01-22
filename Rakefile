require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rdoc/task'
require 'rubygems/package_task'
require "rspec/core/rake_task"

spec = Gem::Specification.new do |s|
  s.name = 'dslisprb'
  s.version = '0.0.6'
  s.author = 'Dario Seminara'
  s.email = 'robertodarioseminara@gmail.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Lisp interpreter written in ruby, using code generation'
  s.homepage = "http://github.com/tario/dslisprb"
  s.has_rdoc = true
  s.executables = ["dslisprb"]
  s.files = Dir.glob("{lib,spec}/**/*") + [ 'README.rdoc', 'Rakefile', 'TODO', 'CHANGELOG' ]
end

desc 'Run tests'

RSpec::Core::RakeTask.new("test:units") do |t|
  t.pattern= 'spec/**/*.rb'
end

desc 'Generate RDoc'
Rake::RDocTask.new :rdoc do |rd|
  rd.rdoc_dir = 'doc'
  rd.rdoc_files.add 'lib', 'README.rdoc'
  rd.main = 'README.rdoc'
end

desc 'Build Gem'
Gem::PackageTask.new spec do |pkg|
  pkg.need_tar = true
end

desc 'Clean up'
task :clean => [ :clobber_rdoc, :clobber_package ]

desc 'Clean up'
task :clobber => [ :clean ]

