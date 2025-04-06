SHELL := /bin/bash
fennelurl = https://fennel-lang.org/downloads/
fennelversion = 1.5.3
fennelwget = fennel-$(fennelversion).lua
fennel = fennel.lua
default: 

$(fennel):
	wget $(fennelurl)$(fennelwget)
	mv $(fennelwget) $(fennel)

install: $(fennel)
