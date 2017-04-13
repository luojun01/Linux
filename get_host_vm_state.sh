get_host_vm_state.sh

hn=`hostname`
ps aux | grep qemu-system-x86_64 | grep -v grep  | awk '{print $15,$28,$5,$6,$22,$26}' > /tmp/host_vm.state
vsz=`cat /tmp/host_vm.state | awk '{sum+=$3} END {print sum/1024/1024}'`
rss=`cat /tmp/host_vm.state | awk '{sum+=$4} END {print sum/1024/1024}'`
vm_mem=`cat /tmp/host_vm.state | awk '{sum+=$5} END {print sum/1024}'`
vm_cpu=`cat /tmp/host_vm.state |awk '{print $6}' | awk -F "," '{sum+=$1} END {print sum}'`

echo "$hn $vsz $rss $vm_mem $vm_cpu"
