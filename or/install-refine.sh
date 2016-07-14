#!/bin/bash
set -eo pipefail
echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections

DEBIAN_FRONTEND=noninteractive apt-get -y -qq update
DEBIAN_FRONTEND=noninteractive apt-get -y -qq install unzip wget software-properties-common

apt-add-repository -y ppa:webupd8team/java

DEBIAN_FRONTEND=noninteractive apt-get -y -qq update
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq oracle-java7-installer
DEBIAN_FRONTEND=noninteractive apt-get -y --force-yes -qq install ant && rm -Rf /var/cache/apt/*

mkdir /openrefine

# Download OpenRefine from gitub repository and compile
wget --no-check-certificate https://github.com/fusepoolP3/OpenRefine/releases/download/2.6-p3/openrefine-linux-with-rdf.tar.gz && \
    tar xzvf openrefine-linux-with-rdf.tar.gz; rm openrefine-linux-with-rdf.tar.gz

mv openrefine-with-rdf/* /openrefine; rm -rf openrefine-with-rdf

# OpenRefine start script, adjusts the JVM memory according to the machines available memory

echo "#!/bin/bash
MIN_REFINE_MEMORY=$(( 1 * 1024 * 1024 * 1024 ))
if [ -z "\$REFINE_MEMORY" ] ; then
    TOTAL_MEMORY=\`free -b | grep Mem | awk '{print \$2}'\`
    REFINE_MEMORY=\$(( \$TOTAL_MEMORY * 6 / 10 ))

    if [ "\$REFINE_MEMORY" -lt "\$MIN_REFINE_MEMORY" ]; then
        REFINE_MEMORY=\"$MIN_REFINE_MEMORY\"
    fi
fi
exec /openrefine/refine -x log=/var/log/ -i 0.0.0.0 -m \$REFINE_MEMORY" > /start.sh

chmod +x /start.sh

# Add OpenRefine to upstart

echo 'exec /start.sh
start on (local-filesystems and net-device-up IFACE!=lo)
stop on runlevel [!2345]
limit nofile 524288 1048576
limit nproc 524288 1048576
respawn' > /etc/init/openrefine.conf
