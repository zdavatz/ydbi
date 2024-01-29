$:.unshift 'build'
found = false;
if File.exist? 'lib/dbi'
    require 'Rakefile.dbi'
end
if File.exist? 'lib/dbd'
    require 'rake_task_lib'
    build_dbd_tasks(File.basename(Dir['lib/dbd/*.rb'][0], '.rb').downcase)
    found = true;
end
unless found
    abort "Well, this is odd; No DBI or DBD found."
end
require 'bundler/gem_tasks'
