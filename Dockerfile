FROM python:3.13-slim-bullseye


ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

ENV RED_HOME=/redbot
ENV RED_USER=reduser

ENV PATH="${RED_HOME}/.local/bin:${PATH}"

ARG RED_UID=1024
ARG RED_GID=1024

RUN groupadd -r -g $RED_GID ${RED_USER} && \
   useradd -rm -g $RED_GID -u ${RED_UID} -d ${RED_HOME} ${RED_USER} && \
   mkdir -pv ${RED_HOME}/data ${RED_HOME}/.config && \
   ln -sv ${RED_HOME}/data ${RED_HOME}/.config/Red-DiscordBot && \
   chown -Rv ${RED_USER}:${RED_USER} $RED_HOME

COPY redbot/requirements.txt ${RED_HOME}/

RUN apt update && \
   apt --no-install-recommends -y install build-essential git openjdk-11-jre-headless units && \
   su $RED_USER -c "python -m pip install --no-cache-dir --user -r ${RED_HOME}/requirements.txt" && \
   apt remove -y build-essential && \
   apt autoremove -y && \
   rm -rf /var/lib/apt/lists/*

COPY --chmod=755 redbot/*.sh ${RED_HOME}/

VOLUME ["${RED_HOME}/data"]

ENTRYPOINT ["/redbot/entrypoint.sh"]
