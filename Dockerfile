FROM debian

MAINTAINER kerwindena

## Install all the Packages

RUN apt-get update && apt-get install -y \
    ssh \
    weechat \
    tmux \

## Configure the container

# Fix sshd for priviliege separation
RUN mkdir /var/run/sshd
RUN chmod 700 /var/run

# Configure ssh
ADD sshd_config /etc/ssh/

# Create /data
RUN mkdir /data

# Configure Weechat
RUN useradd -m -d /home/weechat -s /home/weechat/login.sh weechat
RUN usermod -p '*' weechat

# Add files not to be changed by the end user
ADD login.sh /home/weechat/
ADD config.txt /home/weechat/

# Configure Tor
RUN useradd -m -d /home/tor -s /bin/false tor

## Populate the volume

# Add authorized_keys placeholder
RUN mkdir /home/weechat/.ssh
RUN touch /data/authorized_keys
RUN ln -s /data/authorized_keys /home/weechat/.ssh/

# Configure Tmux
ADD tmux.conf /data/
RUN ln -s /data/tmux.conf /home/weechat/.tmux.conf

## Final steps

# Add Volume under /data
VOLUME ["/data"]

# Expose port 22
EXPOSE 22

# Startup preocedure
CMD ["/usr/sbin/sshd", "-D"]