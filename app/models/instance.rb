class Instance < ApplicationRecord
  def send_instance

    if machine_id == nil then
      machine = auto_alloc({disk: disk_space, cpu: cpu, memory: memory})
      if machine==nil then
        return {status: 'Failure'}
      end
      self.update(machine_id: machine[:id])
    else
      machine = Machine.find(machine_id)
    end
    option = {keys: '/home/kenji/.ssh/key_local',
              port: 22}
    ip_addr = machine[:ip_addr]
	
	@vm_ip_addr = IpAddress.new({instance_id: self[:id]})
	if @vm_ip_addr.get_ip_addr? then
	  vm_ip_addr = @vm_ip_addr[:ip_addr]
	  @vm_ip_addr.save
	end
	key_loc = ""
    user = 'kenji'

    Net::SSH.start(ip_addr, user, option) do |ssh|
      disk = 'disk.qcow2'
      dat = File.read('app/assets/config/template.xml')
      dat.gsub!('[instance_name]',name)
      dat.gsub!('[uuid]',SecureRandom.uuid)
      dat.gsub!('[cpu]',cpu.to_s)
      dat.gsub!('[memory]',(memory * 1024 * 1024).to_s)
      File.open(format('/home/kenji/kvm_disk/%<x>s.xml', x: name), mode="w"){|f|
		f.write(dat)
	  }
      def_file = format('%<x>s.xml', x: name)
      loc = format('/var/kvm/instances/%<x>s', x: name)
      tmp = '/home/kenji'
      connection = 'enp1s0'
      key_name = format('id_%<x>s.pub', x: name)
	  key_loc = format('/home/kenji/kvm_disk/keys/%<x>s/id_%<x>s', x:name)
	  system(format('mkdir /home/kenji/kvm_disk/keys/%<x>s', x: name))
	  system(format('ssh-keygen -t ed25519 -N "" -f %<x>s', x: key_loc))

	  cfg = File.read('app/assets/config/template.cfg')
	  cfg.gsub!('[name]', name)
	  cfg.gsub!('[ip_addr]', vm_ip_addr)
	  cfg.gsub!('[connection]', connection)
	  cfg.gsub!('[key_name]', key_name)
	  File.open('/home/kenji/kvm_disk/config.sh', mode="w"){|f|
		f.write(cfg)
	  }

	    
	  #Make VM directory
      cmd = format('echo %<pw>s | sudo -S mkdir %<x>s', x: loc, pw: ENV['PW'])
      ssh.exec!(cmd)
	  
	  #Transer disk image
      src = format('/home/kenji/kvm_disk/kvm_centos8_bkup/%<x>s', x: disk)
      dist = tmp
      ssh.scp.upload! src, dist

	  #Transfer define.xml
      src = format('/home/kenji/kvm_disk/%<x>s', x: def_file)
      ssh.scp.upload! src, dist
	  

	  #Transfer config.sh
	  src = '/home/kenji/kvm_disk/config.sh'
      ssh.scp.upload! src, dist

	  #Transfer key
	  src = format('%<x>s.pub', x: key_loc)
      ssh.scp.upload! src, dist

	  
	  #Move disk image & define.xml
	  cmd = format('echo %<pw>s | sudo -S mv /home/kenji/%<x>s %<y>s', x: disk, y: loc, pw: ENV['PW'])
	  ssh.exec!(cmd)
	  
	  cmd = format('echo %<pw>s | sudo -S mv /home/kenji/%<x>s %<y>s', x: def_file, y: loc, pw: ENV['PW'])
	  ssh.exec!(cmd)
	  
	  #Create md_mount
	  cmd = format('echo %<pw>s | sudo -S mkdir %<x>s/md_mount', x: loc, pw: ENV['PW'])
	  ssh.exec!(cmd)	    
 	  
	  sleep 1

	  #Mount metadata_drive, mount first!
	  if machine[:id] == 2 then
	    loop_device = 'loop3p1'
	  else
	    loop_device = 'loop0p1'
	  end

	  cmd = format('echo %<pw>s | sudo -S mount -t vfat /dev/mapper/%<y>s %<x>s/md_mount', x: loc, y: loop_device, pw: ENV['PW'])
	  ssh.exec!(cmd)

	  #Move config.sh
	  cmd = format('echo %<pw>s | sudo -S mv /home/kenji/config.sh %<y>s/md_mount', y: loc, pw: ENV['PW'])
	  ssh.exec!(cmd)

	  #Move key
	  cmd = format('echo %<pw>s | sudo -S mv /home/kenji/id_%<x>s.pub %<y>s/md_mount', x:name, y: loc, pw: ENV['PW'])
	  ssh.exec!(cmd)

	  

	  #Create VM
	  cmd = format('echo %<pw>s | sudo -S virsh create %<x>s/%<y>s', x:loc, y:def_file, pw: ENV['PW'])
	  ssh.exec!(cmd)

	  sleep 1

	  #Clean up md_mount directory
	  #cmd = format('echo %<pw>s | sudo -S rm -f %<x>s/md_mount/*', x: loc, pw: ENV['PW'])
	  #ssh.exec!(cmd)

	  #Unmound metadata_drive
	  cmd = format('echo %<pw>s | sudo -S umount -l %<x>s/md_mount', x: loc, pw: ENV['PW'])
	  ssh.exec!(cmd)

      sleep 20
      #Detach metadata_drive
	  cmd = format('echo %<pw>s | sudo -S virsh detach-disk --domain %<x>s --target vdb', x: name, pw: ENV['PW'])
	  ssh.exec!(cmd)
    end
    self.update(status: 'running', key: File.read(key_loc))
    self.save
    return {name: self[:name], machine_id: self[:machine_id], ip_addr: vm_ip_addr, priv_key: key_loc}
  end

  def auto_alloc(req)
    machines = Machine.all
    instances = Instance.all
    physical_resources = []
    machines.each do |m|
      disk=0
      cpu=0
      memory=0
      instances.each do |inst|
        if inst[:machine_id] == m[:id] then
          disk += inst[:disk_space]
          cpu += inst[:cpu]
          memory += inst[:memory]
        end
      end
      physical_resources.push({machine_id: m[:id], disk: disk, free_space: m[:disk_space] - disk, cpu: cpu,
                               cpu_commit: cpu.to_f / m[:cpu], memory: memory, mem_commit: memory.to_f / m[:memory]})
    end
    candidate = {machine_id: 0, free_space: 0, cpu_commit: 0, mem_commit: 0} 
    physical_resources.each do |r|
      if candidate[:machine_id]==0 then
        if r[:free_space] >= req[:disk] then
          candidate = {machine_id: r[:machine_id],  free_space: r[:free_space],
                                    cpu_commit: r[:cpu_commit], mem_commit: r[:mem_commit]}
        end
      else
        # Allocate a instance to a machine having free disk space more than the requirement and minimum commiting ratio of cpu + memory 
        if r[:free_space] >= req[:disk] then
          # Accept over commit of cpu and memory, then decide a machine having minimum commiting raio of cpu + memory should be allocated a instance
          if (r[:cpu_commit] + r[:mem_commit]) < (candidate[:cpu_commit] + candidate[:mem_commit]) then
            candidate = {machine_id: r[:machine_id],  free_space: r[:free_space],
                                    cpu_commit: r[:cpu_commit], mem_commit: r[:mem_commit]}
          end
        end
      end
    end

    if candidate[:machine_id]==0 then
      return nil
    else
      return machines.find(candidate[:machine_id])
    end
  end

  def release
    option = {keys: '/home/kenji/.ssh/key_local',
              port: 22}
    ip_addr = Machine.find(self[:machine_id])[:ip_addr]
	vm_ip_addr = self[:ip_addr]
    name = self[:name]
    user = 'kenji'
    loc = format('/var/kvm/instances/%<x>s', x: name)
    Net::SSH.start(ip_addr, user, option) do |ssh|
      #Shutdown VM
	  cmd = format('echo %<pw>s | sudo -S virsh shutdown %<x>s', x:name, pw: ENV['PW'])
	  ssh.exec!(cmd)

      sleep 1

      #Remove disk image
	  cmd = format('echo %<pw>s | sudo -S rm -rf %<x>s', x:loc, pw: ENV['PW'])
	  ssh.exec!(cmd)
      
    end

    ip_address = IpAddress.find_by(instance_id: self[:id])
    ip_address.destroy

    
  end
end
