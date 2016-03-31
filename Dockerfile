FROM ubuntu

RUN apt-get update
RUN apt-get -y install expect redis-server nodejs npm

RUN apt-get update && \
    apt-get install -y python-pip && \
    pip install awscli

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/nodejs /usr/bin/node

RUN npm install -g coffee-script
RUN npm install -g yo generator-hubot

# Create hubot user
RUN	useradd -d /hubot -m -s /bin/bash -U hubot -p hubot

# Log in as hubot user and change directory
USER	hubot
WORKDIR /hubot

# Install hubot
RUN yo hubot --owner="1For1 <ops@1for.one>" --name="1For!" --description="Roll, roll, rollercoaster" --defaults

# Some adapters / scripts
RUN npm install hubot-slack --save \
    && npm install hubot-standup-alarm --save \
    && npm install hubot-auth --save \
    && npm install hubot-google-translate --save \
    && npm install hubot-auth --save \
    && npm install hubot-github --save \
    && npm install hubot-alias --save \
    && npm install hubot-gocd --save \
    && npm install hubot-youtube --save \
    && npm install hubot-s3-brain --save \
    && npm install hubot-reminder --save \
    && npm install hubot-strawpoll --save \
    && npm install hubot-leaderboard --save \
    && npm install hubot-docker --save \
    && npm install hubot-at --save \
    && npm install hubot-spot --save \
    && npm install hubot-weather --save \
    && npm install hubot-jenkins --save \
    && npm install hubot-trello --save \
    && npm install hubot-zabbix --save \
    && npm install hubot-weather --save \
    && npm install

RUN npm install cheerio --save && npm install
ADD hubot/scripts/hubot-lunch.coffee /hubot/scripts/

# Activate some built-in scripts
COPY hubot/hubot-scripts.json /hubot/
COPY hubot/external-scripts.json /hubot/

# Must be before USER command
USER root
RUN chown hubot:hubot /hubot/*json
USER hubot

ENV HUBOT_SLACK_TOKEN=ffff-1234-5678-91011-00e4dd HUBOT_STANDUP_PREPEND=@here

# And go
CMD ["/bin/sh", "-c", "bin/hubot --adapter slack"]
