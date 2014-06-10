namespace :figaro do
  desc "SCP transfer figaro configuration to the shared folder"
  task :setup do
    transfer :up, "config/application.yml", "#{shared_path}/config/application.yml", via: :scp
  end

  desc "Symlink the Figaro application.yml-file"
  task :create_symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/application.yml #{release_path}/config/application.yml"
  end

  after "deploy:setup", "figaro:setup"
  after "deploy:finalize_update", "figaro:create_symlink"
end
