# Add the current directory to the list of directories to look at for copying templates
def source_paths
  Array(super) + 
    [File.expand_path(File.dirname(__FILE__))]
end

# Create a clean Gemfile
remove_file "Gemfile"
file 'Gemfile'

# Create the layout we want
run "rm app/views/layouts/application.html.erb"
template 'templates/layout.html.erb', 'app/views/layouts/application.html.erb'

# generate the gems we want to start with
add_source "https://rubygems.org/"
gem 'rails', '4.2.7.1'
gem 'mysql2'
gem 'sass-rails'
gem 'bootstrap-sass'
gem 'jquery-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails'
gem 'spring'
gem 'puma'
gem 'byebug', group: [:development, :test]
