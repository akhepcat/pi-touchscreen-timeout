##  This is super basic, as it should be

tstimeout: tstimeout.c
	gcc tstimeout.c -o tstimeout

clean:
	rm -f tstimeout

install: tstimeout
	sudo cp tstimeout /usr/local/bin/
