require 'rake'
require 'rake_performance'

import 'tasks/vagrant.rake'


desc 'Execute our maintenance tasks'
task :maintenance => ['vagrant:vagrant_global_status_prune', 'vagrant:delete_obsolete_virtualbox_vagrant_master_vms', 'vagrant:delete_invalid_vagrant_master_id_files']

desc ':boom: Delete all vagrant boxes and VirtualBox VMs. :boom:'
task :deep_maintenance => ['vagrant:delete_all_virtualbox_vagrant_boxes', 'vagrant:delete_obsolete_virtualbox_vagrant_master_vms', 'vagrant:clean_virtualbox_vms_folder']
