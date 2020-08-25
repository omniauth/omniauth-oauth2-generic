# frozen_string_literal: true

module Satorix
  module Custom

    # Ensure the files required by the available_jobs method are available.
    require_relative 'CI/test/custom_bundler_audit'


    extend self


    def available_jobs
      {
        test: {
          custom_bundler_audit: Satorix::CI::Test::CustomBundlerAudit
        }
      }
    end


  end
end