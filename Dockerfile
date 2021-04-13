FROM ubuntu:20.04

# Focal Fossa requires two updates, one before installing common
# software properties and another after installing the PPA. Fails
# otherwise.
#
# Also important to upgrade Ubuntu upfront, otherwise it might install
# an earlier development version of Prolog. Install the latest.
RUN apt-get upgrade -y
RUN apt-get update

# https://www.swi-prolog.org/build/PPA.html
RUN apt-get install -y software-properties-common
RUN apt-add-repository ppa:swi-prolog/devel
RUN apt-get update
RUN apt-get install -y swi-prolog-nox

RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y autoconf

WORKDIR /srv
COPY srv .
RUN find . -name '*~' -exec rm {} +
RUN mkdir /var/log/daemon
RUN chown daemon.daemon /var/log/daemon
RUN swipl -g "pack_install(_, [url('https://github.com/royratcliffe/canny_tudor/archive/0.13.0.zip'), inquiry(false), interactive(false), silent(true)])"
RUN swipl -g "pack_install(_, [url('https://github.com/prologr/paxor/archive/0.1.0.zip'), inquiry(false), interactive(false), silent(true)])"
ENTRYPOINT [ "/bin/sh", "-c", "exec swipl [0-9]*.pl -- --no-fork --user=daemon --http=8080" ]

EXPOSE 8080
