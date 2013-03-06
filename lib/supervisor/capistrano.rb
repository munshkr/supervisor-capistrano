require "supervisor/capistrano/version"

module Supervisor
  module Capistrano
    def self.extended(configuration)
      configuration.load do
        namespace :supervisor do
          _cset(:supervisord_configuration, "config/supervisord.conf")
          _cset(:supervisord_logfile, "log/supervisord.log")
          _cset(:supervisord_logfile_maxbytes, "1MB")
          _cset(:supervisord_logfile_backups, 0)
          _cset(:supervisord_loglevel, "info")
          _cset(:supervisord_pidfile, "tmp/pids/supervisord.pid")

          def build_path(path)
            require "pathname"
            p = Pathname.new(path)
            p.relative? ? File.join(current_path, p) : p
          end

          desc "Start Supervisor daemon"
          task :start do
            run "supervisord " \
                  "--configuration=#{build_path(supervisord_configuration)} " \
                  "--logfile=#{build_path(supervisord_logfile)} " \
                  "--logfile_maxbytes=#{supervisord_logfile_maxbytes} " \
                  "--logfile_backups=#{supervisord_logfile_backups} " \
                  "--loglevel=#{supervisord_loglevel} " \
                  "--pidfile=#{build_path(supervisord_pidfile)}"
          end

          desc "Stop Supervisor daemon and all its subprocesses (SIGTERM)"
          task :stop do
            run "kill -SIGTERM `cat #{supervisord_pidfile}`"
          end

          desc "Stop all subprocesses, reload configuration and restart (SIGHUP)"
          task :reload do
            run "kill -SIGHUP `cat #{supervisord_pidfile}`"
          end
        end
      end
    end
  end
end

if Capistrano::Configuration.instance
  Capistrano::Configuration.instance.extend(Supervisor::Capistrano)
end
