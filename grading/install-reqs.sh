#!/bin/bash

cat <<EOF >> /etc/apt/apt.conf.d/80-proxy
Acquire::http::Proxy "http://10.104.142.1:3128";
EOF

apt-get remove -y unattended-upgrades

echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
apt-get update -y
apt-get install -y openjdk-8-jdk gradle
apt-get install -y ruby2.3
apt-get install -y build-essential
apt-get install -y --allow-unauthenticated sbt

adduser --disabled-password --gecos "" student

cat <<EOF > ~/.wgetrc
use_proxy=yes
http_proxy=http://10.104.142.1:3128
EOF

cd /usr/local
wget http://www-us.apache.org/dist/hadoop/common/hadoop-2.7.2/hadoop-2.7.2.tar.gz
tar xzf hadoop-2.7.2.tar.gz

cd ~student

cat <<EOF >> ./.bashrc
export PATH="$PATH:/usr/local/hadoop-2.7.2/bin"
export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
EOF

mkdir .gradle
cat <<EOF > .gradle/gradle.properties
systemProp.http.proxyHost=10.104.142.1
systemProp.http.proxyPort=3128
systemProp.https.proxyHost=10.104.142.1
systemProp.https.proxyPort=3128
EOF

cat <<'EOF' > .gradle/init.gradle
apply plugin:BnRepos

class BnRepos implements Plugin<Gradle> {
    void apply(Gradle gradle) {
        gradle.allprojects{ project ->
            project.repositories {
                all { ArtifactRepository repo ->
                    if (!(repo instanceof MavenArtifactRepository) ||
                          (repo.url.toString() =~ /^https/).find()) {
                        project.logger.lifecycle "Repository ${repo.url} removed. No https."
                        remove repo
                    }
                }

                maven {
                    name "Maven Central"
                    url "http://repo1.maven.org/maven2"
                }
            }
        }
    }
}
EOF

cat <<EOF > ./.wgetrc
use_proxy=yes
http_proxy=http://10.104.142.1:3128
EOF

chown -R student .gradle .wgetrc

echo "Setup done. Now you get to wait for the container to gzip."
