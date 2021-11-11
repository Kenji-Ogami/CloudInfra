class Instance < ApplicationRecord
    def send_instance
	debugger
        machine = Machine.find(machine_id)
        option = {keys: '/home/kenji/.ssh/key_local',
                  port: 22}
        ip_addr = machine[:ip_addr]
        user = 'kenji'

        Net::SSH.start(ip_addr, user, option) do |ssh|
            loc = format('/home/kenji/instances/%<x>s', x: name)
            cmd = format('mkdir %<x>s', x: loc)
            ssh.exec!(cmd)
            src = '/var/kvm/disk/kvm_centos8_bkup/disk.qcow2'
            dist = loc
            ssh.scp.download! src, dist

            src = '/var/kvm/disk/kvm_centos8_bkup/kvm_centos8_default.xml'
            ssh.scp.download! src, dist
        end
    end
end
