# Terraform Beginner Bootcamp 2023 - Week 2

## Working with Ruby

### Bundler

Bundler is a package manager for ruby. It is the primary way to install ruby packages (known as gms) for ruby.

#### Install Gems

You need to create a Gemfile and define your gems in that file.

```rb
source "https://rubygems.org"

gem 'sinatra'
gem 'rake'
gem 'pry'
gem 'puma'
gem 'activerecord'
```

Then you need to run the `bundle install` command. This will install the gems system globally (unline nodejs which installs packages in place in a folder called node_modules)

A Gemfile.lock will be created to lock down the gem versiosn being used in this project

#### Executing ruby scripts in the context of bundler

We utilize `bundle exec` to tell future ruby scripts to use the gems we installed. This is the way we set context.

### Sinatra

Sinatra is a micro web-framework for ruby to build web-apps.

Great for mock/development servers or very simple projects. A web-server can be created in a single file.

[Sinatra](https://sinatrarb.com/)

## Terratowns Mock Server

### Running the web server

We can run the web server by executing the following commands:

```rb
bundle install
budle exec ruby server.rb
```

All of the code for our server is stored in the `server.rb` file.

## CRUD

Terraform Provider resources utilize CRUD

Create, Read, Update, and Delete

[CRUD Reference](https://www.codecademy.com/article/what-is-crud)