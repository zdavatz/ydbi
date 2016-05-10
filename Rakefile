require "bundler/gem_tasks"

# dependencies are now declared in ydim.gemspec
desc 'Offer a gem task like hoe'
task :gem => :build do
  Rake::Task[:build].invoke
end

