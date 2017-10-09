# MMT

<hr>

# Set-up

Database Engine
--------

```
sudo apt-get update
sudo apt-get install postgresql-9.6 postgresql-contrib-9.6
```

Development Environment
-----------------------

Install and configure DNSMasq

```
sudo apt-get install dnsmasq
sudo echo 'address=/dev/127.0.0.1' >> /etc/dnsmasq.conf
sudo cp /etc/dnsmasq.conf /etc/dnsmasq.conf.pkg
sudo echo '127.0.0.1^Iblockades.dev' >> /etc/hosts
sudo /etc/init.d/dnsmasq restart
```

Install a JavaScript runtime

```
sudo apt-get install nodejs
```

Setup Rails

If using Rails for the first time, [follow these instructions](https://github.com/rbenv/rbenv) to setup Ruby environment. MMT ruby version is 2.4.0.

```
# These two only if installing for the first time
gem install bundler
gem install rails

# Clone the repository
git clone git@github.com:ten-thousand-things/mmt.git && cd mmt
touch .env && echo "APP_DOMAIN='blockades.dev'" >> .env

# Install dependencies
bundle

# Create the database
rake db:create
rake db:migrate

# Start the server
rails s
```

Navigate to [app.blockades.dev:5000](http://app.blockades.dev:5000/)

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
