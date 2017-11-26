# MMT {magic money tree, margins merkle trees, mutual margins tributaries, mutual margin tendencies, margarine margins together}

_Working title: By the margins, for the margins_

*A software platform for grass roots collective crypto speculation and assisting community driven peer-to-peer (person-to-person) cryptocurrency education at the margins.*

---

TL;DR

In a nutshell this software aims to assist and uplift peer-to-peer do-it-together practical education workshops like this:

https://twitter.com/davidodoswell/status/933194999696461829

https://twitter.com/dan_mi_sun/status/933144890510151681

---

# Current Status and Team

- MMT software is being funded by DBL
- Built as free and open source
- Concurrently establishing an organisation (workers coop? friendly society? other?) to run the software as a service
- This team is currently emergent
- Being pulled from a friendship ecosystem of about 50 people, organising and establishing on [Loomio](http://loomio.org/)
- You can read the backstory to the project here: https://viewer.scuttlebot.io/%25Vxdim9E7D8JHERHKLc6T0qMHcd2Bw9cG58Mb8Z0xpdQ%3D.sha256

---

# Seeking Aims

- MMT seeks to empower communities and individuals at the margins with the knowledge and tools required to get involved with cryptocurrencies.

- MMT seeks to provide the community infrastructure to aid in the complete experience and journey of someone going from zero knowledge to owning and managing their own private keys.

- MMT seeks to support those 'teachers' who are teaching new people, to make the experience of doing so as fluid as possible.  

- MMT will be a community centered cryptocurrency exchange enabling the purchase of a pre-selected subset of cryptocurrencies (enabling community oriented folks to be able to access crypto from like minded folks rather than simply going to corporate platforms).

- MMT will enable members to gift and 'IOU' crypto to new invited members.

- MMT members will be able to manage a portion of their fees and direct them to pre-vetted projects on the platform.

- MMT will allow projects to join the platform to be funded.

- MMT will provide tools for socially backing up private keys and passwords to the platform.

---

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

Install further dependencies
```
sudo apt-get install libxml2-dev
```

Setup Rails

If using Rails for the first time, [follow these instructions](https://github.com/rbenv/rbenv) to setup Ruby environment. MMT ruby version is 2.4.0.

```
# These two only if installing for the first time
gem install bundler
gem install rails

# Clone the repository
git clone git@github.com:blockades/mmt.git && cd mmt

# Install dependencies
bundle

# Create the database
bundle exec rake db:create
bundle exec rake db:migrate

# Seed the database
bundle exec rake setup

# Start the server
bundle exec rails s

# Start Redis
redis-server

# Start Sidekiq
bundle exec sidekiq -C config/sidekiq.yml
```

Install [mailcatcher](https://mailcatcher.me/)

```
gem install mailcatcher
```

Once the server is running you can see this locally here: http://localhost:3000/

Passwords for signing in can be found here: https://github.com/blockades/mmt/blob/development/lib/tasks/setup.rake

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

Thank you for digging into the code!

- Create new issue
- Add a label

Code of Conduct (Work in Progress)
------

https://github.com/blockades/mmt/blob/development/code_of_conduct.md
