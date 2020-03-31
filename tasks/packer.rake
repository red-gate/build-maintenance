require 'fileutils'

def packer_cache_dir
  packer_cache_dir = ENV['PACKER_CACHE_DIR']
  packer_cache_dir = packer_cache_dir.dup.tr '\\', '/' unless packer_cache_dir.nil? || !windows? # replace backslaches on windows.
  packer_cache_dir
end

namespace :packer do
  desc 'Clear the packer cache'
  task :clear_cache do
    next if packer_cache_dir.nil?
    next unless File.directory?(packer_cache_dir)

    Dir["#{packer_cache_dir}/*"].each do |file|
      puts "Deleting #{file}"
      FileUtils.rm_rf(file)
    end
  end
end
