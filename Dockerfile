# Pull base image.
FROM jlesage/baseimage-gui:ubuntu-20.04

# Define download URLs.
ARG TIXATI_VERSION=3.11-1
ARG TIXATI_URL=https://download2.tixati.com/download/tixati_${TIXATI_VERSION}_amd64.deb

# Define working directory.
WORKDIR /tmp

# Add files
COPY rootfs/ /

### Install Tixati
RUN \
	add-pkg \
		libdbus-1-3 \
		libdbus-glib-1-2 \
		libgtk2.0-0 \
		traceroute \
		iputils-ping \
		fonts-wqy-zenhei \
		&& \
	add-pkg --virtual build-dependencies \
		wget \
		gconf2 \
		&& \
	echo "download tixati..." && \
	wget -q ${TIXATI_URL} && \
	dpkg -i tixati_${TIXATI_VERSION}_amd64.deb && \
	del-pkg build-dependencies && \
	apt-get purge --auto-remove gcc-9-base -y && \
	rm -rf /tmp/* /tmp/.[!.]* && \
	# Maximize only the main window.
    sed-patch 's/<application type="normal">/<application type="normal" title="Tixati">/' \
        /etc/xdg/openbox/rc.xml

# Set environment variables.
ENV	APP_NAME="Tixati"

# Define mountable directories.
VOLUME ["/config", "/storage"]

# Expose port
EXPOSE 10844
EXPOSE 10844/udp
