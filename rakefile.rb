require 'rake'
#require 'rubygems'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'fileutils'
require 'lib/css_parser'



class File
  # find a file in the load path or raise an exception if the file can
  # not be found.
  def File.find_file_in_path(filename)
    $:.each do |path|
      puts "Trying #{path}"
      file_with_path = path+'/'+filename
      return file_with_path if file?(file_with_path) 
    end
    
  
    raise ArgumentError, "Can't find file #{filename} in Ruby library path"
  end
end


include CssParser

desc 'Run the unit tests.'
Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.libs << 'lib/test'
  t.test_files = FileList['test/test*.rb'].exclude('test_helper.rb')
  t.verbose = false
end


desc 'Generate documentation.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = 'Ruby CSS Parser'
  rdoc.options << '--all' << '--inline-source' << '--line-numbers'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('CHANGELOG')
  rdoc.rdoc_files.include('LICENSE')
  rdoc.rdoc_files.include('lib/*.rb')
  rdoc.rdoc_files.include('lib/css_parser/*.rb')
end


desc 'Generate fancy documentation.'
Rake::RDocTask.new(:fancy) do |rdoc|
  rdoc.rdoc_dir = 'fdoc'
  rdoc.title    = 'Ruby CSS Parser'
  rdoc.options << '--all' << '--inline-source' << '--line-numbers'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('CHANGELOG')
  rdoc.rdoc_files.include('LICENSE')
  rdoc.rdoc_files.include('lib/*.rb')
  rdoc.rdoc_files.include('lib/css_parser/*.rb')
  rdoc.template = File.expand_path(File.dirname(__FILE__) + '/doc-template.rb')
end



spec = Gem::Specification.new do |s| 
  s.name = 'css_parser'
  s.version = '0.9.0'
  s.author = 'Alex Dunae'
  s.homepage = 'http://code.dunae.ca/css_parser'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A set of classes for parsing CSS.'
  s.files = FileList['lib/*.rb', 'lib/**/*.rb', 'test/**/*'].to_a
  s.test_files = Dir.glob('test/test_*.rb') 
  s.has_rdoc = true
  s.extra_rdoc_files = ['README', 'CHANGELOG', 'LICENSE']
  s.rdoc_options << '--all' << '--inline-source' << '--line-numbers'
end

desc 'Build the Ruby CSS Parser gem.'
Rake::GemPackageTask.new(spec) do |pkg| 
  pkg.need_zip = true
  pkg.need_tar = true 
end 


