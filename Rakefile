require 'rake'
require 'rake_performance'
require 'fileutils'

def windows?
  (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
end

def virtualbox_vm_folder
  return 'D:/VirtualBox VMs'
end

def vagrant_home
  vagrant_home = ENV['VAGRANT_HOME']
  vagrant_home = vagrant_home.dup.gsub '\\', '/' unless vagrant_home.nil? or !windows? # replace backslaches on windows.
  vagrant_home = "#{ENV['USERPROFILE'].dup.gsub! '\\', '/'}/.vagrant.d" if ENV['USERPROFILE'] and vagrant_home.nil?
  vagrant_home = "~/.vagrant.d" if vagrant_home.nil?
  return vagrant_home
end

def read_file(file)
  File.open(file) do |f|
    f.read.chomp
  end
end

# return a list of virtualbox vm guids that are not currently running.
def get_virtualbox_nonrunning_vm_guids
  running_vms_guids = []
  `vboxmanage list runningvms`.scan(/{(.*)}/) { running_vms_guids << $1 }
  vm_guids = []
  `vboxmanage list vms`.scan(/{(.*)}/) { vm_guids << $1 unless running_vms_guids.include?($1) }

  return vm_guids
end

def get_all_virtualbox_vm_guids
  vm_guids = []
  `vboxmanage list vms`.scan(/{(.*)}/) { vm_guids << $1 }
  return vm_guids
end

def get_all_virtualbox_vm_names
  vm_names = []
  `vboxmanage list vms`.scan(/"(.*)"/) { vm_names << $1 }
  return vm_names
end

# Get a list of the Virtual Box Master VM ids from the currently installed vagrant boxes.
def get_vagrant_virtualbox_mastervms_guid
  return Dir["#{vagrant_home}/boxes/**/virtualbox/master_id"].map do |path|
    read_file(path)
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
    begin
      puts "delete_obsolete_virtualbox_vagrant_master_vms: Deleting VM: #{id}"
      sh "vboxmanage unregistervm #{id} --delete"
    rescue => error
      puts "WARNING: Failed to delete #{id}"
    end
  end
end

desc 'Delete files from the VirtualBox VMs folder that are not linked to any Virtualbox VM. Assumes that the folder name matches the vm name. :/'
task :clean_virtualbox_vms_folder do
  vm_names = get_all_virtualbox_vm_names
  Dir["#{virtualbox_vm_folder}/*"].map do |vm_folder|
    folder_name = File.basename(vm_folder)
    unless vm_names.include?(folder_name)
      puts "Deleting #{folder_name} as it does not seem to be linked to any existing VirtualBox VM"
      begin
        FileUtils.rm_rf(vm_folder)
      rescue => error
         puts "WARNING: Failed to delete #{vm_folder} with error: #{error}"
      end
    end
  end
end

desc 'Delete vagrant master_id files that point to virtualbox VMs that somehow do not exist. This will cause vagrant to recreate the master Vm for linked clones'
task :delete_invalid_vagrant_master_id_files do
  vm_guids_to_keep = get_all_virtualbox_vm_guids

  Dir["#{vagrant_home}/boxes/**/virtualbox/master_id"].map do |path|
    guid = read_file(path)
    # unless a virtualbox vm exists with that guid, delete the master_id file.
    if !vm_guids_to_keep.include?(guid)
      puts "Deleting #{path} as no virtualbox VM with id #{guid} can be found..."
      File.delete(path)
    else
      puts "Keeping #{path} as a virtualbox VM with id #{guid} was found."
    end
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

desc 'Remove every vagrant box using virtualbox as a provider. Yep.'
task :delete_all_virtualbox_vagrant_boxes do
  provider = 'virtualbox'
  `vagrant box list`.scan(/([^\s]*)\s+\(#{provider},\s(.*)\)/) do |box, version|
    sh "vagrant box remove #{box} --box-version #{version} --provider #{provider} --force"
  end
end

desc 'Execute our maintenance tasks'
task :maintenance => [:vagrant_global_status_prune, :delete_obsolete_virtualbox_vagrant_master_vms, :delete_invalid_vagrant_master_id_files]
