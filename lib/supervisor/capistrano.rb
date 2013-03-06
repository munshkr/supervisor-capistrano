require "supervisor/capistrano/version"

module Supervisor
  module Capistrano
    SUPERVISORD_OPTIONS = %w{
      configuration
      pidfile
      logfile
      logfile_maxbytes
      logfile_backups
      loglevel
    }

    def self.extended(configuration)
      configuration.load do
        # Define supervisord options
        SUPERVISORD_OPTIONS.each do |opt|
          _cset("supervisord_#{opt}".to_sym, nil)
        end

        namespace :supervisor do
          def abspath(path)
            require "pathname"
            p = Pathname.new(path)
            p.relative? ? File.join(current_path, p) : p
          end

          def supervisord_cmd
            opts = SUPERVISORD_OPTIONS
              .map { |opt| [opt, send("supervisord_#{opt}")] }
              .reject { |opt, value| value.nil? }
              .map { |opt, value|
                if %w{configuration pidfile logfile}.include?(opt)
                  value = abspath(value)
                end
                [opt, value]
              }

            "supervisord #{opts.map { |opt, value| "--#{opt}=#{value}" }.join(" ")}"
          end

          desc "Start Supervisor daemon"
          task :start do
            run supervisord_cmd
          end

          desc "Stop Supervisor daemon and all its subprocesses (SIGTERM)"
          task :stop do
            run "kill -SIGTERM `cat #{abspath(supervisord_pidfile)}`"
          end

          desc "Stop all subprocesses, reload configuration and restart (SIGHUP)"
          task :restart do
            run "kill -SIGHUP `cat #{abspath(supervisord_pidfile)}`"
          end
        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  Capistrano::Configuration.instance.extend(Supervisor::Capistrano)
end
