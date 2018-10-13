require "bundler/capistrano"
set :application, "total_hours_wasted"

set :repository,  "git@github.com:jeremiahishere/total_hours_wasted.git" # repo clone url
set :scm, :git # use git
set :branch, "master"
set :rails_env, "production"

set :deploy_to, "/srv/#{application}" # deploy location
set :deploy_via, :remote_cache # keep a local git repo on the server and fetch from that rather than a full clone
set :ssh_options, { :forward_agent => true, :user => "jeremiah" } # use ssh_agent and public key

role :web, "totalhourswasted.com"
role :app, "totalhourswasted.com"
role :db,  "totalhourswasted.com", :primary => true


namespace :deploy do
  task :start do
    puts "not used"
  end

  task :stop do
    puts "not used"
  end

  task :restart do
    #run "service apache2 restart"
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

end

task :fix_permissions do
  run "chown www-data.www-data /srv/#{application} -R"
  run "chmod -R 777 /srv/#{application}/shared/log"
end
after "deploy", :fix_permissions

namespace :db do
  task :reset_db do
    run "cd /srv/#{application}/current && rake db:drop && rake db:create && rake db:migrate && rake db:seed"
  end  

  task :migrate_db do
    run "cd /srv/#{application}/current && rake db:create RAILS_ENV=production && rake db:migrate RAILS_ENV=production"
  end
end
after "deploy", "db:migrate_db"
