# Add the current directory to the list of directories to look at for copying templates
def source_paths
  Array(super) + 
    [File.expand_path(File.dirname(__FILE__))]
end

# Default gems to be used
gem 'jbuilder'
gem 'puma'
gem 'responders'
gem_group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'byebug'
end
gem 'faker', group: :test

install_devise = false
# Adding devise if wanted
if yes? "Want to install devise?"
  gem 'devise'
  install_devise = true
  model_name = ask("What would you like the user model to be called? [user]")
  model_name = "user" if model_name.blank?
end

# Copy over a concern, can be a private gem and in the controllers/application.rb require that class
# For simplicity just copying over the file
# We/you can make this inline instead of copying file so that you can have the template online if not,
# then you need to clone the repo first locally.
copy_file 'concerns/full_messages_responder.rb', 'app/controllers/concerns/full_messages_responder.rb'

# Tell the main application controller controllers/application.rb to use that concern
insert_into_file 'app/controllers/application_controller.rb', after: "class ApplicationController < ActionController::API\n" do
  <<-RUBY
    self.responder = FullMessagesResponder
    respond_to :json
  RUBY
end

after_bundle do
  # Modify the generators to use rspec and factory girl instead of unit tests
  application do 
    <<-RUBY
      config.generators do |g|
        g.test_framework :rspec, fixture: true
        g.view_specs false
        g.helper_specs false
      end
    RUBY
  end

  #Stop preloader
  run "spring stop"

  #install rspec
  generate "rspec:install"
  if install_devise
    generate "devise:install"
    generate "devise", model_name
  end

  #remove test folder
  remove_dir 'test'
end
