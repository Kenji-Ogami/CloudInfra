class Instance < ApplicationRecord
    def send_instance
	debugger
        machine = Machine.find(machine_id)
        option = {keys: '/home/kenji/.ssh/key_local',
                  port: 22}
        ip_addr = machine[:ip_addr]
        user = 'kenji'

        Net::SSH.start(ip_addr, user, option) do |ssh|
            src = '/home/kenji/kvm_disk/kvm_centos8_bkup/disk.qcow2'
	    dist = '/home/kenji/disk.qcow2'
            ssh.scp.upload! src, dist
        end
    end
end
