module Satorix
  module CI
    module Test
      module CustomBundlerAudit


        include Satorix::Shared::Console


        extend self


        def go
          log_bench('Displaying current Ruby version...') { run_command 'ruby -v' }
          log_bench('Installing bundler-audit...') { install_gem }
          log_bench('Auditing Gemfile.lock...') { run_scan }
        end


        private ########################################################################################################


        def install_gem
          run_command "gem install bundler-audit --no-document --bindir #{ Satorix.bin_dir }"
        end


        def run_scan
          run_command 'bundle-audit check --update  --ignore CVE-2015-9284'
        end


      end
    end
  end
end
