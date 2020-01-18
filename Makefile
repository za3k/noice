HOSTNAME=$(shell hostname)
PREFIX=/var/local/media-player
# Install location of 'remote' for client--should be on the path
PREFIX2=/usr/local/bin

all: all-${HOSTNAME}
all-rosemary: media-player-rosemary/noice noice-rosemary/noice
all-germinate: media-player-germinate/bin/noice noice-germinate/noice
all-rclone: all-rosemary

install: install-${HOSTNAME}
install-germinate: media-player-germinate/bin/noice
		mkdir -p $(PREFIX)/bin
		cp -r -t $(PREFIX) media-player-germinate/*

install-rosemary: media-player-rosemary/noice
		mkdir -p $(PREFIX)
		cp media-player-rosemary/* $(PREFIX)
		cp media-player-rosemary/remote $(PREFIX2)/remote

install-rclone: media-player-rosemary/noice
		mkdir -p $(PREFIX)
		cp media-player-rosemary/* $(PREFIX)
		cp media-player-rosemary/remote $(PREFIX2)/remote
		cp -r -t $(PREFIX) media-player-rclone/*

LDLIBS = -lcurses
noice-germinate/noice.o: noice-germinate/util.h noice-germinate/config.h
noice-germinate/strlcat.o: noice-germinate/util.h
noice-germinate/strlcpy.o: noice-germinate/util.h
noice-germinate/noice: noice-germinate/noice.o noice-germinate/strlcat.o noice-germinate/strlcpy.o
		$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS) $(LDLIBS)
media-player-germinate/bin/noice: noice-germinate/noice
		cp $< $@
clean-germinate:
		rm -f noice-germinate/noice.o noice-germinate/strlcat.o noice-germinate/strlcpy.o noice-germinate/noice media-player-germinate/bin/noice

noice-rosemary/noice.o: noice-rosemary/util.h noice-rosemary/config.h
noice-rosemary/strlcat.o: noice-rosemary/util.h
noice-rosemary/strlcpy.o: noice-rosemary/util.h
noice-rosemary/noice: noice-rosemary/noice.o noice-rosemary/strlcat.o noice-rosemary/strlcpy.o
	$(CC) $(CFLAGS) -o $@ $^ $(OBJ) $(LDFLAGS) $(LDLIBS)
media-player-rosemary/noice: noice-rosemary/noice
		cp $< $@
clean-rosemary:
	rm -f noice-rosemary/noice.o noice-rosemary/strlcat.o noice-rosemary/strlcpy.o noice-rosemary/noice media-player-rosemary/noice

clean: clean-rosemary clean-germinate
