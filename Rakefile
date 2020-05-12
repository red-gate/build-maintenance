require 'rake'
require 'rake_performance'

import 'tasks/vagrant.rake'
import 'tasks/localdb.rake'

desc 'Execute our maintenance tasks'
task maintenance: [
  'vagrant:vagrant_global_status_prune',
  'vagrant:vagrant_box_prune',
  'vagrant:delete_obsolete_virtualbox_vagrant_master_vms',
  'vagrant:delete_invalid_vagrant_master_id_files',
  'vagrant:clean_virtualbox_vms_folder'
]
