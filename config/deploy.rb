require 'mina/rails'
require 'mina/git'
require 'mina/rvm'    # for rvm support. (https://rvm.io)


set :application_name, 'zen-api'
set :user, 'lsnq'
set :domain, '77.37.208.113'
set :port, '2222'   
set :deploy_to, '/srv/zen-api-prod'
set :repository, 'git@github.com:lsnq/zen-bem-api.git'
set :branch, 'master'
set :rails_env, 'production'
set :rvm_use_path, '/etc/profile.d/rvm.sh'
set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/secrets.yml')

# Optional settings:
#   set :user, 'foobar'          # Username in the server to SSH to.
#   set :port, '30000'           # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# Shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
# Some plugins already add folders to shared_dirs like `mina/rails` add `public/assets`, `vendor/bundle` and many more
# run `mina -d` to see all folders and files already included in `shared_dirs` and `shared_files`
# set :shared_dirs, fetch(:shared_dirs, []).push('public/assets')
# set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/secrets.yml')

# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
task :remote_environment do
  invoke :'rvm:use', 'ruby-2.4.1'
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup do
  in_path(fetch(:shared_path)) do
    command %[mkdir -p config]
    # command %{rbenv install 2.3.0 --skip-existing}
    # Create secrets.yml if it doesn't exist
    path_secrets_yml = "config/secrets.yml"
    secrets_yml = %[production:\n  secret_key_base:\n    #{`rake secret`.strip}]
    command %[test -e #{path_secrets_yml} || echo "#{secrets_yml}" > #{path_secrets_yml}]


    # Remove others-permission for config directory
    command %[chmod -R o-rwx config]
  end
end

desc "Deploys the current version to the server."
task :deploy do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'deploy:cleanup'

   
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run(:local){ say 'done' }
end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs
