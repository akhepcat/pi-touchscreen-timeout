##  This is super basic, as it should be

tstimeout: tstimeout.c
	gcc tstimeout.c -o tstimeout

clean:
	rm -f tstimeout

install: tstimeout
	sudo cp tstimeout /usr/local/bin/
	sudo cp tstimeout.service /etc/systemd/system
	sudo cp tstimeout.defaults /etc/default/tstimeout
	echo "run 'make systemd' to enable and run the service"
	
systemd: tstimeout
	sudo systemctl enable tstimeout.service
	sudo systemctl start tstimeout.service
	sudo systemctl status tstimeout.service
