require 'rake'
require 'rake_performance'

import 'tasks/vagrant.rake'

desc 'Execute our maintenance tasks'
task maintenance: [
  'vagrant:vagrant_global_status_prune',
  'vagrant:delete_obsolete_virtualbox_vagrant_master_vms',
  'vagrant:delete_invalid_vagrant_master_id_files'
]

desc ':boom: Delete all vagrant boxes and VirtualBox VMs. :boom:. Then redownload the latest versions of our most used boxes.'
task deep_maintenance: [
  'vagrant:delete_all_virtualbox_vagrant_boxes',
  'vagrant:delete_obsolete_virtualbox_vagrant_master_vms',
  'vagrant:clean_virtualbox_vms_folder',
  'vagrant:download_common_vagrant_boxes'
]
