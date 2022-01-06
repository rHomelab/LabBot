FROM python:3.9-bullseye

LABEL authors="tigattack, dantho281"

ENV PATH="/home/redbot/.local:/home/redbot/.local/bin:${PATH}"

RUN apt-get update && \
   apt-get --no-install-recommends -y install build-essential git openjdk-11-jre-headless && \
   apt-get upgrade -y && \
   apt-get autoremove -y && \
   rm -rf /var/lib/apt/lists/*

RUN groupadd -r redbot -g 1024 && \
   useradd  -r -m -g redbot redbot

COPY requirements.txt redbot.sh /redbot/

RUN mkdir -pv /redbot/data /home/redbot/.local/share/ && \
   ln -sv /redbot/data /usr/local/share/Red-DiscordBot && \
   ln -sv /redbot/data /home/redbot/.local/share/Red-DiscordBot && \
   chown -Rv redbot:redbot /redbot /home/redbot && \
   chmod -v +x /redbot/redbot.sh

USER redbot

RUN python -m pip install --no-cache --upgrade --user -r /redbot/requirements.txt

VOLUME ["/redbot"]

ENTRYPOINT ["/redbot/redbot.sh"]
