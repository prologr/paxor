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

RUN echo "deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/" > /etc/apt/sources.list.d/cran-focal.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9

RUN apt-get update
RUN apt-get install -y r-base
RUN apt-get install -y r-base-dev
RUN apt-get install -y libssl-dev
RUN apt-get install -y libcurl4-openssl-dev

RUN Rscript -e 'install.packages("devtools")'
RUN Rscript -e 'install.packages("remotes")'
RUN Rscript -e 'remotes::install_github("prologr/paxor@0.3.1")'
RUN Rscript -e 'install.packages("Rserve",, "http://rforge.net/")'

WORKDIR /srv
COPY srv .
RUN find . -name '*~' -exec rm {} +

RUN mkdir /var/log/daemon
RUN chown daemon.daemon /var/log/daemon

RUN swipl -g "pack_install(_, [url('https://github.com/royratcliffe/canny_tudor/archive/0.13.0.zip'), inquiry(false), interactive(false), silent(true)])"
RUN swipl -g "pack_install(rserve_client, [interactive(false)])" -g "pack_rebuild(rserve_client)"
RUN swipl -g "pack_install(_, [url('https://github.com/prologr/paxor/archive/0.3.1.zip'), inquiry(false), interactive(false), silent(true)])"

ENTRYPOINT [ "/bin/sh", "-c", "exec swipl [0-9]*.pl -- --no-fork --user=daemon --http=8080" ]

EXPOSE 8080
