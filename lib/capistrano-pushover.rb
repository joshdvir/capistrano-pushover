require "capistrano-pushover/version"
require "rushover"


module Capistrano
  module Pushover
    Capistrano::Configuration.instance(:must_exist).load do

      set :pushover_with_migrations, false

      namespace :pushover do

        task :set_user do
          set :pushover_client, Rushover::Client.new(pushover_app_token)
          set :pushover_user, Rushover::User.new(pusehover_user_key, pushover_client)
        end

        task :configure_for_migrations do
          set :pushover_with_migrations, true
        end

        task :notify_deploy_started do
          on_rollback do
            pushover_user.notify("#{human} cancelled deployment of #{deployment_name} to #{env}.", :title => "#{application} cancelled deployment", :priority => 1)
          end

          message = "#{human} is deploying #{deployment_name} to #{env}"
          message << " (with migrations)" if pushover_with_migrations
          message << "."

          pushover_user.notify(message, :title => "#{application} started deploying", :priority => priority)          
        end

        task :notify_deploy_finished do
          pushover_user.notify("#{human} finished deploying #{deployment_name} to #{env}.", :title => "#{application} finished deploying", :priority => priority)
        end

        def priority
          fetch(:pushover_priority, 0)
        end

        def deployment_name
          if branch
            "#{application}/#{branch}"
          else
            application
          end
        end

        def human
          ENV['PUSHOVER_USER'] ||
            if (u = %x{git config user.name}.strip) != ""
              u
            elsif (u = ENV['USER']) != ""
              u
            else
              "Someone"
            end
        end

        def env
          fetch(:pushover_env, fetch(:rack_env, fetch(:rails_env, "production")))
        end

        before "pushover:notify_deploy_started", "pushover:set_user"
        before "deploy:migrations", "pushover:configure_for_migrations"
        before "deploy:update_code", "pushover:notify_deploy_started"
        after  "deploy", "pushover:notify_deploy_finished"
        after  "deploy:migrations", "pushover:notify_deploy_finished"
      end

    end
  end
end
