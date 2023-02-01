# Pull base image.
FROM jlesage/baseimage-gui:ubuntu-20.04-v4

# Define working directory.
WORKDIR /tmp

# Generate and install favicons.
RUN \
	APP_ICON_URL=https://raw.githubusercontent.com/angelics/unraid-docker-tixati/main/favicon.png && \
	install_app_icon.sh "$APP_ICON_URL"

# Define download URLs.
ARG TIXATI_VERSION=3.14-1
ARG TIXATI_URL=https://download2.tixati.com/download/tixati_${TIXATI_VERSION}_amd64.deb

### Install Tixati
RUN \
	add-pkg \
		libdbus-1-3 \
		libdbus-glib-1-2 \
		libgtk2.0-0 \
		traceroute \
		iputils-ping \
		fonts-wqy-zenhei \
		locales \		
		&& \
    sed-patch 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen && \
	add-pkg --virtual build-dependencies \
		wget \
		ca-certificates \
		gconf2 \
		&& \
	echo "download tixati $TIXATI_VERSION..." && \
	wget -q ${TIXATI_URL} && \
	dpkg -i tixati_${TIXATI_VERSION}_amd64.deb && \
	del-pkg build-dependencies && \
	rm -rf /tmp/* /tmp/.[!.]*

# Add files
COPY rootfs/ /

# Set environment variables.
RUN \
    set-cont-env APP_NAME "Tixati" && \
    set-cont-env APP_VERSION "$TIXATI_VERSION"

# Define mountable directories.
VOLUME ["/storage"]

# Expose port
EXPOSE 10844
EXPOSE 10844/udp