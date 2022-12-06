# docker-weechat #

WeeChat IRC client container is a docker container you run on a server and connect to over ssh. It comes with some plugins and scripts preinstalled and it bundles its own Tor entry node to allow for secure connections to .onion addresses.

This is a fork of kerwindena/weechat that has been updated with WeeChat 3.0 and other small edits.

Please note, that I am not affiliated with the development of either Docker, WeeChat or Tor. I am just the one bundling this container.

## Installation ##

Installing the container is easy but requires some configurational steps.

1. Start a dummy container for persistent storage of all configuration `docker run --name weechat-data mcquack/weechat /bin/true`
2. Get the path to the volume of the data container. This can be easily done with `docker inspect weechat-data | grep Source | sed -r 's/.*"(.*)",/\1/'`
3. Optional: For convenient access to the configuration you might want to symlink it to a more intuitive place
4. Add your ssh keys to the `authorized_keys` located in the config directory
5. Start the container, link the `weechat-data` volumes, and expose the port. This could be done with `docker run --volumes-from=weechat-data --restart=always --name weechat -p 5000:22 -d mcquack/weechat`.

## FAQ ##

### What about Tor? ###

tl;dr: Yes, what about it? It is a tiny demon running, establishing a circuit, and not sending any data through it, as long as you don't use it. No harm done.

The Tor daemon is running with its default configuration. This means, it is configured as an entry node, so it can be used to route requests through the tor network but it does not relay any data from the network. The entry node can be only used from inside the container and there is no data of somebody else to be sent and explicitly there is nothing unencrypted leaving the network. This is great if you don't want to get involved but bad for the network, since you can use it, but don't give anything back. If this bothers you as it bothers me you might want to consider leaving this demon as it is and start another tor daemon outside the container, maybe in another container.

### How do I route a connection through the tor network? ###

WeeChat should have a tor-proxy configured by default in this container. You can verify this with `/proxy list`. If it is missing, please issue a bug and recreate it with `/proxy add tor socks5 127.0.0.1 9050`.
You can activate the tor proxy on a per-server basis by simply using `/set irc.server.<servername>.proxy tor` replacing `<servername>` with the configured name of the server.