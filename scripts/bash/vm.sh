#!/bin/bash
# by maravento.com

# Start | Stop VMs Virtualbox

# how to use:           /etc/scr/vm.sh {start|stop|shutdown|reset|status}
# update-rc.d add:      update-rc.d vm.sh defaults 99 01
# remove:               update-rc.d -f vm.sh remove
# confirm update-rc.d:  ls -al /etc/rc?.d/ | grep vm.sh
# add user vboxusers:   usermod -a -G vboxusers $USER # where $USER is your user

# admin user
VMUSER=${SUDO_USER:-$(whoami)}
# replace "my_vm_name" with your vm name
# also you can put UUID in this variable (VMNAME="4ec6acc1-a232-566d-a040-6bc4aadc19a6")
VMNAME="my_vm"

case "$1" in
    start)
        echo "Starting $VMNAME..."
        sudo -H -u $VMUSER VBoxManage startvm "$VMNAME" --type headless
        ;;
    stop)
        echo "Saving State $VMNAME..."
    	sudo -H -u $VMUSER VBoxManage controlvm "$VMNAME" savestate
    		sleep 20
        ;;
    shutdown)
        echo "Shutting Down $VMNAME..."
        sudo -H -u $VMUSER VBoxManage controlvm "$VMNAME" acpipowerbutton
    		sleep 20
        ;;
    reset)
        echo "Resetting $VMNAME..."
        sudo -H -u $VMUSER VBoxManage controlvm "$VMNAME" reset
        ;;
    status)
        echo -n "VMNAME->";sudo -H -u $VMUSER VBoxManage showvminfo "$VMNAME" --machinereadable | grep "VMState="| cut -d "=" -f2
        exit 1
        ;;
esac
exit 0
