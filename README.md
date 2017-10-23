# MMT

<hr>

# Set-up

Database Engine
--------

Install the correct Postgres for your Linux distribution.
The `lsb_release -cs` sub-command below returns the name of your Ubuntu distribution, such as xenial.
For Mint users, you might have to change $(lsb_release -cs) to your parent Ubuntu distribution.

```
sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main"
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y postgresql-9.6 postgresql-contrib-9.6 libpq-dev
```

Then with your preferred text editor

```
sudo vim /etc/postgresql/9.6/main/pg_hba.conf

# For IPv4 and IPv6 local connections, change 'md5' to 'trust'
# Save and exit

/etc/init.d/postgresql restart
```


Development Environment
-----------------------

Install a JavaScript runtime

```
sudo apt-get install -y nodejs
```

Install Redis
```
sudo apt-get install redis-server
```

Setup Rails

If using Rails for the first time, [follow these instructions](https://github.com/rbenv/rbenv) to setup Ruby environment. MMT ruby version is 2.4.0.

```
# These two only if installing for the first time
gem install bundler
gem install rails

# Clone the repository
git clone git@github.com:ten-thousand-things/mmt.git && cd mmt

# Install dependencies
bundle

# Create the database
rake db:create
rake db:migrate

# Start the server
rails s

# Start Redis
redis-server

# Start Sidekiq
bundle exec sidekiq -C config/sidekiq.yml
```

Navigate to [app.blockades.dev:5000](http://app.blockades.dev:5000/)

Install [mailcatcher](https://mailcatcher.me/)

```
gem install mailcatcher
```

<hr>

# Tools to make your life easier...

- Install [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) for pre-configured git aliases
- Install [Hub](https://hub.github.com/) for easy pull requesting
- We use [Keybase](https://keybase.io/) for communications (because we love crypto)

<hr>

# Process

Contributing
-----------

- Pull master and development branch
- Checkout to development branch
- Checkout to feature/your-new-feature branch
- Make your changes
- Pull request into development

Projects
-------

- Feature and project workflows can be viewed in the repository's [projects section](https://github.com/blockades/mmt/projects)

Issues
------

- Create new issue
- Add a label

