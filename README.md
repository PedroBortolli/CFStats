# CFStats - An app to show relevant Codeforces statistics

&nbsp;
## Description

This app is being developed using Ruby on Rails. This project goal is to build a web page that displays relevant Codeforces statistics, such as problems solved by tag, comparisons between users, problems to do, etc.

&nbsp;
## How to install

<details>
	<summary>Click to expand</summary>

	The first thing to be done is to install some dependencies for Ruby. For this step you must have root privilege. Run the following commands:

	``curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -``

	``curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -``

	``echo "deb https://dl.yarnpkg.com/debian/stable main" | \ sudo tee /etc/apt/sources.list . d/yarn.list``

	``sudo apt-get update``

	``sudo apt-get install git-core curl zlib1g-dev build-essential \ libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 \ libxml2-dev libxslt1-dev libcurl4-openssl-dev \ python-software-properties libffi-dev nodejs yarn``

	&nbsp;
	Now to install Ruby:


	``cd``

	``git clone https://github.com/rbenv/rbenv.git ~/.rbenv``

	``echo ’export PATH ="$HOME/.rbenv/bin:$PATH"’ >> ~/.bashrc``

	``echo ’eval "$(rbenv init -)"’ >> ~/.bashrc``

	``exec $SHELL``

	``git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build``

	``echo ’export PATH ="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"’ >> ~/.bashrc``

	``exec $SHELL``

	``rbenv install 2.5.0``

	``rbenv global 2.5.0``

	``ruby -v``

	&nbsp;
	Now to install Rails:

	``gem install rails -v 5.1.4``

	``rbenv rehash``
	&nbsp;

	The last thing to do is to install Postgresql. That's the database this app is being built with. Run:

	``sudo sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' > /etc/apt/sources.list.d/pgdg.list"``

	``wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -``

	``sudo apt-get update``

	``sudo apt-get install postgresql-common``

	``sudo apt-get install postgresql-9.5 libpq-dev``

	&nbsp;
	## Getting the repository

	Once everything is set, clone this repository running:

	``git clone https://github.com/pedrobortolli/CFStats.git``

	Navigate to the folder generated by the clone and install the gems dependencies:

	``bundle install``

	&nbsp;
	## Installing the database of CFStats on postgres

	Create the db_user user:

	``sudo -u postgres createuser db_user``

	Open psql menu to write some commands to give the user permissions:

	``sudo -u postgres psql``

	``postgres=# ALTER USER db_user WITH ENCRYPTED PASSWORD 'db';``

	``postgres=# ALTER USER db_user superuser createrole createdb replication;``

	``postgres=# \q``

	Open /etc/postgresql/9.5/main/pg_hba.conf with root access:

	``sudo nano /etc/postgresql/9.5/main/pg_hba.conf``

	&nbsp;
	Change peer to md5 in these lines:

	Before changing:

	``# "local" is for Unix domain socket connections only``

	``local   all             all                                     peer``

	``# IPv4 local connections:``

	``host    all             all             127.0.0.1/32            peer``

	``# IPv6 local connections:``

	``host    all             all             ::1/128                 peer``

	After your change:

	``# "local" is for Unix domain socket connections only``

	``local   all             all                                     md5``

	``# IPv4 local connections:``

	``host    all             all             127.0.0.1/32            md5``

	``# IPv6 local connections:``

	``host    all             all             ::1/128                 md5``



	Save the file with pressing Ctrl-O. Exit nano with Ctrl-X
	Restart postgresql using:

	``sudo service postgresql restart``

	Them go to the CFStats cloned directory and run the following commands:

	``rake db:create``

	``rake db:migrate``
</details>

&nbsp;
## Running the app server

Run ``rails s``

That's it! Now the app server is running locally on your computer! To visit the webpage, go to your navigator and type ``localhost:3000``

&nbsp;
## If anything goes wrong

If something goes wrong on the installation phase, perhaps something has changed on the current version of some of the applications we are using. Please go to the respective manuals of those applications to try and find a solution.
If anything else goes wrong, please contact us.


&nbsp;
## How to make tests

Simply run ``rake test:models`` to run tests for the models implemented.
(By the next deadline there will be more tests available for other parts of the application)

&nbsp;
## Usage example

Click on "Compare two users!". Now, type 2 valid Codeforces handles and then click on "Compare!". Another page will be loaded containing information about each individual user and also common information between them.

There will be spoiler tags containing links (to the actual Codeforces website) for each problem solved by each user. Also, a graph is ploted containing the amount of problems solved by tag.

New: profile page (requires an account). Click on "Profile" on the index page. There you can add your Codeforces handle, you can add friends, problems and contests to solve later. This feature is still under construction, but it is being developed to be used as some kind of shortcut and as a way to save important Codeforces link to the future.



&nbsp;
## Who works on this project?

* Pedro Bortolli - [@pedrobortolli](http://github.com/pedrobortolli)
* Enzo Hideki [@enzohideki](http://github.com/enzohideki)
* Jonas Arilho [@jonasarilho](http://github.com/jonasarilho)
* Rafael Shimabukuro [@rshimabukuro](http://github.com/rshimabukuro)

&nbsp;
## Important dates

#### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1st deadline (May 19th, 2018)
* Basic structure of the app
* How to install/use
* Basic features implemented
* Basic design of the website implemented

#### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2nd deadline (June 8th, 2018)
* Database implemented
* Started profile page implementation. Will be finished by the 3rd deadline.
* User authentication implemented using Devise
* Update on design of the website. Will be finished by the 3rd deadline.
* Tests added
* Minor bug fixes
#### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3rd deadline
*
