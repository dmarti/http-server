#!/bin/sh

sudo OSV_BRIDGE=virbr0 \
qemu-system-x86_64 -vnc :1 -gdb tcp::1234,server,nowait -m 2G \
-smp 4 -device virtio-blk-pci,id=blk0,bootindex=0,drive=hd0,scsi=off \
-drive file=$HOME/.capstan/repository/http-server/http-server.qemu,if=none,id=hd0,aio=native,cache=none \
-redir tcp:8080::8080 -redir tcp:2222::22 \
-device virtio-net-pci,netdev=hn0 \
-device virtio-rng-pci -enable-kvm -cpu host,+x2apic \
-chardev stdio,mux=on,id=stdio,signal=off \
-mon chardev=stdio,mode=readline,default \
-device isa-serial,chardev=stdio \
-netdev tap,id=hn0,script=$HOME/Projects/osv/scripts/qemu-ifup.sh,vhost=on

