require 'rake'
require 'rake_performance'

# return a list of virtualbox vm guids that are not currently running.
def get_virtualbox_nonrunning_vm_guids
  running_vms_guids = []
  `vboxmanage list runningvms`.scan(/{(.*)}/) { running_vms_guids << $1 }
  vm_guids = []
  `vboxmanage list vms`.scan(/{(.*)}/) { vm_guids << $1 unless running_vms_guids.include?($1) }

  return vm_guids
end

# Get a list of the Virtual Box Master VM ids from the currently installed vagrant boxes.
def get_vagrant_virtualbox_mastervms_guid
  vagrant_home = ENV['VAGRANT_HOME']
  vagrant_home = "#{ENV['USERPROFILE']}/.vagrant.d" if ENV['USERPROFILE'] and vagrant_home.nil?
  vagrant_home = "~/.vagrant.d" if vagrant_home.nil?

  return Dir["#{vagrant_home}/boxes/**/virtualbox/master_id"].map do |path|
    File.open(path).read.chomp
  end
end

desc 'Delete any non running virtualbox VM that is not linked to a vagrant box. (Clean up virtualbox leftover vms after vagrant boxes are removed.)'
task :delete_obsolete_virtualbox_vagrant_master_vms do
  all_vms = get_virtualbox_nonrunning_vm_guids
  vms_to_keep = get_vagrant_virtualbox_mastervms_guid

  # only delete the vms that are not referenced by any vagrant box.
  vms_to_delete = all_vms.reject do |id|
    vms_to_keep.include?(id)
  end

  puts "delete_obsolete_virtualbox_vagrant_master_vms: Nothing to do" if vms_to_delete.empty?

  vms_to_delete.each do |id|
    puts "delete_obsolete_virtualbox_vagrant_master_vms: Deleting VM: #{id}"
    sh "vboxmanage unregistervm #{id} --delete"
  end
end

desc 'Prune invalid entries from vagrant global-status'
task :vagrant_global_status_prune do
  puts "vagrant_global_status_prune: pruning invalid vagrant environments"
  Bundler.with_clean_env  do
    sh "vagrant global-status --prune"
  end
  puts "vagrant_global_status_prune: done"
end

desc 'Execute our maintenance tasks'
task :maintenance => [:vagrant_global_status_prune, :delete_obsolete_virtualbox_vagrant_master_vms]
