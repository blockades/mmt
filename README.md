**Please note that this is experimental software that is in development.**

**This source code is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. Please refer to the GNU Public License for more details.**

---

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

- MMT software is being funded by [blockades.org](http://blockades.org/).
- Being built as at least open source, ideally free software.
- Concurrently establishing an organisation (workers coop? friendly society? other?) to run the software as a service.
- This team is currently emergent and in flux.
- Being pulled from a friendship ecosystem of about 50 people, organising and establishing on [Loomio](http://loomio.org/).
- You can read the backstory to the project here: https://viewer.scuttlebot.io/%25Vxdim9E7D8JHERHKLc6T0qMHcd2Bw9cG58Mb8Z0xpdQ%3D.sha256

---

# Why?

P2P technologies such as Distributed Ledger Technologies (a.k.a blockchains) are potentially transformative. Our belief is that they will only be truly transformative if we expand who has the power (information, tools, skills, access, resources) to be a peer (as in human peers within P2P) into  marginalised communities. This requires education and skill sharing. Our hope is that as this happens we will see localised transformations as people reconfigure the new skills, tools and access to meet their specific needs.

In the future scenario where the 'value' of cryptocurrencies is much [higher](https://cointelegraph.com/news/bitcoin-price-might-exceed-1-million-more-millionaires-in-world-than-bitcoins) than they are now, we want to make sure that this potential future wealth is spread to the margins and that marginalised communities, projects and people have the tools to coordinate in novel, transformative and liberatory ways.

---

# Seeking | Aims | Intentions

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

Install Docker for your relevant OS

Development Environment
-----------------------

```
docker-compose build
# this bundle step shouldn't be needed but it is...
docker-compose run --rm mmt bundle
docker-compose run --rm mmt rake db:create db:migrate setup
```

Then to run simply use:

```sh
docker-compose up
```

Install [mailcatcher](https://mailcatcher.me/)

```
gem install mailcatcher
```

Once the server is running you can see this locally here: `http://localhost:3000/`

Passwords for signing in can be found here:

`https://github.com/blockades/mmt/blob/development/lib/tasks/setup.rake`

---

# Tools to make your life easier...

- Install [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) for pre-configured git aliases
- Install [Hub](https://hub.github.com/) for easy pull requesting

# Social Spaces

- We use [Keybase](https://keybase.io/) for IM communications. The team is [blockades.mmt](https://keybase.io/popular-teams#blockades.mmt). Reach out if you would like a keybase invite.
- We have a private [Loomio](http://loomio.org) group where the organisation which will run the software is forming. If you are interested in joining this closed group, then please get in touch with one of us.
- We are also using the p2p social network [patchwork](https://www.scuttlebutt.nz/) "a decent(ralised) secure gossip platform". You can find us hanging out in the #MMT channel on the [pub.tshirt.horse](https://pub.tshirt.horse/) 'pub'.

---

# Process

Contributing
-----------

https://github.com/blockades/mmt/blob/development/contributing.md

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

License
------

GNU General Public License v3.0

MMT is Copyright (C) 2017 by the blockades.org. More information on all the developers involved can found in the AUTHORS file.

This source code is free software; you can redistribute it and/or modify it under the terms of the GNU Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.

This source code is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. Please refer to the GNU Public License for more details.

You should have received a copy of the GNU Public License along with this source code; if not, write to: Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
