# MMT

<hr>

# Set-up

Database Engine
--------

Install the correct Postgres for your Linux OS.
For Ubuntu and Mint users, this can be done with apt specifying the correct source repository e.g. xenial, trusty etc.
For Mint users, xenial should work.

```
sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ <YOUR UBUNTU VERSION>-pgdg main"
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
```

Navigate to [app.blockades.dev:5000](http://app.blockades.dev:5000/)

Install [mailcatcher](https://mailcatcher.me/)

```
gem install mailcatcher
```


<hr>

# Process

Contributing
-----------
- Pull master branch
- Checkout to a feature branch
- Make your changes
- Pull request into master

Issues
------
- Create new issue
- Add a label
