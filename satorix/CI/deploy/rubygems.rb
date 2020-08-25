# frozen_string_literal: true

module Satorix
  module CI
    module Deploy
      module Rubygems


        require 'fileutils'


        include Satorix::Shared::Console


        extend self


        def go
          log_bench('Generating rubygems.org configuration_file...') { generate_rubygems_configuration_file }
          log_bench('Preparing gem build directory...') { prepare_gem_build_directory }
          log_bench('Building gem...') { build_gem }
          built_gems.each { |gem| log_bench("Publishing #{ File.basename gem }...") { publish_gem gem } }
        end


        private


          def build_gem
            Dir.chdir(Satorix.app_dir) do
              run_command 'bundle exec rake build'
            end
          end


          def built_gems
            Dir.glob(File.join(gem_build_directory, '*.gem')).select { |e| File.file? e }
          end


          def gem_build_directory
            File.join Satorix.app_dir, 'pkg'
          end


          def generate_rubygems_configuration_file
            path = File.join(Dir.home, '.gem')
            FileUtils.mkdir_p(path) unless File.exist?(path)

            file = File.join(path, 'credentials')
            File.open(file, 'w') { |f| f.write rubygems_configuration_file_contents }
            FileUtils.chmod 0o600, file
          end


          def prepare_gem_build_directory
            run_command "rm -rf #{ gem_build_directory }"
            FileUtils.mkdir_p gem_build_directory
          end


          def publish_gem(gem)
            run_command "gem push #{ gem } --config-file #{ File.join(Dir.home, '.gem', 'credentials') }"
          rescue RuntimeError
            # To prevent the display of an ugly stacktrace.
            abort "\nGem was not published!"
          end


          def rubygems_api_key
            ENV['SATORIX_CI_RUBYGEMS_API_KEY']
          end


          def rubygems_configuration_file_contents
            "---\n:rubygems_api_key: #{ rubygems_api_key }"
          end


      end
    end
  end
end
