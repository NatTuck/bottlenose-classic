# Bottlenose

Bottlenose is a web app for managing assignment submission and grading in computer science courses. It provides a flexible mechanism for automatic grading of programming assignments.

For detailed documentation, see the [Wiki](https://github.com/NatTuck/bottlenose/wiki).

## Setup

This is a Rails app, and as such requires Ruby as well as a few other system dependencies.

- Ruby (see `.ruby-version` for version)
- Postgres 9.5.0

### Postgres

Installing postgres should be a matter of a quick conversation with your systems package manager. Once Postgres is installed, configuration simply needs to match the information in `config/database.yml`. This is where you can configure the username and password for the database connections. The Postgres user who connects for this application should have the permissions to create databases.

### Ruby

The recommended method for getting Ruby install on any system is with [rbenv](https://github.com/rbenv/rbenv) although other tools work just fine as well.

```sh
# Install the Ruby determined by the contents of the
# .ruby-version file.
rbenv install

# Ensure Ruby was install correctly. Where <version> is the
# correct version as described in the .ruby-version file.
ruby --version
#=> ruby <version> ...
```

Once you have Ruby installed, install the Ruby dependencies.

```sh
# Install Ruby's package manager "Bundler".
gem install bundler

# If you're using rbenv, you may need to run this command to
# ensure new executables are loaded into your PATH.
rbenv rehash

# Install Bottlenose's dependencies.
bundle install
```

### Usage

This application works much like any Rails app. The following are the most common commands for running the server, or interacting with the application. Rails in development mode (the default) will autoload changes, so running the server once is generally good enough. This doesn't apply to some configurations however.

```sh
# List all tasks which `rake` can perform.
rake -T
# Create the database.
rake db:create
# Run database migrations.
rake db:migrate
# Drop the databse.
rake db:drop

# List the routes for this application.
rake routes

# Run the server.
rails server
# Run a console.
rails console
```
