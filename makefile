SHELL := /bin/bash
fennelurl = https://fennel-lang.org/downloads/
fennelversion = 1.5.3
fennelfile = fennel-$(fennelversion).lua
fennel = lib/fennel.lua
lovegit = https://github.com/love2d/love/releases/download/
loveversion = 11.5
loveurl = $(lovegit)$(loveversion)/
lovefile = love-$(loveversion)-x86_64.AppImage
love = bin/love
path = /usr/bin/love
default:

$(fennel):
	wget $(fennelurl)$(fennelfile)
	mv $(fennelfile) $(fennel)

$(love):
	sudo rm -f $(love)
	wget $(loveurl)$(lovefile)
	mv $(lovefile) $(love)
	chmod 755 $(love)
	sudo ln -s `realpath $(love)` $(path)

install: $(fennel) $(love)
uninstall:
	rm -f $(fennel)
	sudo rm -f $(path) $(love)
