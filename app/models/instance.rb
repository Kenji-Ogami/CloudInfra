class Instance < ApplicationRecord
    def send_instance(name:, machine_id:, cpu:, memory:, disk_space:, key_id:)
        machine = Machine.find(machine_id)
        option = {key: '/home/kenji/.ssh/key_local',
                  poar : 22}
        ip_addr = machine[:ip_addr]
        user = 'kenji'

        Net::SSH.start(ip_addr, user, option) do |ssh|
            src = '/var/kvm/disk/kvm_centos8_bkup/disk.qcow2'
            dist = '/home/kenji/'
            ssh.scp.download! src, dist
        end
    end
end
