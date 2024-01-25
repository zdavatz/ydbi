$:.unshift 'build'
if File.exist? 'lib/dbi'
    require 'Rakefile.dbi'
elsif File.exist? 'lib/dbd'
    require 'rake_task_lib'
    build_dbd_tasks(File.basename(Dir['lib/dbd/*.rb'][0], '.rb').downcase)
else
    abort "Well, this is odd; No DBI or DBD found."
end
require 'bundler/gem_tasks'
