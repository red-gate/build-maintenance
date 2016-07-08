require 'rake'
require 'rake_performance'

import 'tasks/vagrant.rake'


desc 'Execute our maintenance tasks'
task :maintenance => [:vagrant_global_status_prune, :delete_obsolete_virtualbox_vagrant_master_vms, :delete_invalid_vagrant_master_id_files]

desc ':boom: Delete all vagrant boxes and VirtualBox VMs. :boom:'
task :deep_maintenance => [:delete_all_virtualbox_vagrant_boxes, :delete_obsolete_virtualbox_vagrant_master_vms, :clean_virtualbox_vms_folder]
