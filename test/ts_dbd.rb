require 'rubygems'
gem 'test-unit'
# figure out what tests to run
require 'yaml'
require "test/unit"
require 'test/unit/ui/console/testrunner'

Dir.chdir("..") if File.basename(Dir.pwd) == "test"
$LOAD_PATH.unshift(Dir.pwd + "/lib")
Dir.chdir("test") rescue nil
$: << '.'

module Test::Unit::Assertions
    def build_message(head, template=nil, *arguments)
        template += "\n" + "DATABASE: " + dbtype
        template &&= template.chomp
        return AssertionMessage.new(head, template, arguments)
    end
end

class Class
    def name=(klass_name)
        @name = klass_name
    end

    def name
        return @name || super
    end
end

module DBDConfig
    @testbase = { }
    @current_dbtype = nil

    def self.get_config
        config = nil
        if false
            # ydbi is only interested in testing the postgresql database!!
            begin
                config = YAML.load_file(File.join(ENV["HOME"], ".ruby-dbi.test-config.yaml"))
            rescue Exception => e
                config = { }
                config["dbtypes"] = [ ]
            end
        else
            # please keep the definitions in sync between test/ts_dbd.rb and devenv.nix!
            config = { }
            config["dbtypes"] = [ "postgresql" ]
            config["postgresql"] = {"username"=>"ydbi_pg", "password"=>"pg_password", "dbname"=>"ydbi_pg"}
        end
        return config
    end

    def self.inject_sql(dbh, dbtype, file)
        # splits by --- in the file, strips newlines and the semicolons.
        # this way we can still manually import the file, but use it with our
        # drivers for client-independent injection.
        File.open(file).read.split(/\n*---\n*/, -1).collect { |x| x.gsub!(/\n/, ''); x.sub(/;\z/, '') }.each do |stmt|
            tmp = STDERR.dup
            STDERR.reopen('sql.log', 'a')
            begin
                dbh.commit rescue nil
                dbh["AutoCommit"] = true rescue nil
                dbh.do(stmt)
                dbh.commit unless dbtype == 'sqlite3'
            rescue Exception => e
                tmp.puts "Error injecting '#{stmt}' for db #{dbtype}"
                tmp.puts "Error: #{e.message}"
            end
            STDERR.reopen(tmp)
        end
    end

    def self.current_dbtype
        @current_dbtype
    end

    def self.current_dbtype=(setting)
        @current_dbtype = setting
    end

    def self.testbase(klass_name)
        return @testbase[klass_name]
    end

    def self.set_testbase(klass_name, klass)
        @testbase[klass_name] = klass
        klass.name = klass_name.to_s
    end

    def self.suite
        @suite ||= []
    end
end

if __FILE__ == $0
    Dir.chdir("..") if File.basename(Dir.pwd) == "test"
    $LOAD_PATH.unshift(File.join(Dir.pwd, "lib"))
    Dir.chdir("test") rescue nil

    begin
        require 'dbi'
    rescue LoadError => e
        begin
            require 'rubygems'
            gem 'dbi'
            require 'dbi'
        rescue LoadError => e
            abort "DBI must already be installed or must come with this package for tests to work."
        end
    end

    Deprecate.set_action(proc { })

    config = DBDConfig.get_config

    config["dbtypes"] = ENV["DBTYPES"].split(/\s+/) if ENV["DBTYPES"]

    if config and config["dbtypes"]
        config["dbtypes"].each do |dbtype|
            unless config[dbtype]
                warn "#{dbtype} is selected for testing but not configured; see test/DBD_TESTS" if false
                next
            end

            # base.rb is special, see DBD_TESTS
            require "dbd/#{dbtype}/base.rb"
            Dir["dbd/#{dbtype}/test*.rb"].each { |file| require file }
            # run the general tests
            DBDConfig.current_dbtype = dbtype.to_sym
            Dir["dbd/general/test*.rb"].each { |file| load file; @class.name = file; DBDConfig.suite << @class }
        end
    elsif !config["dbtypes"]
        warn "Please see test/DBD_TESTS for information on configuring DBD tests."
    end
end
