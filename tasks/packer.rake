def packer_cache_dir
  packer_cache_dir = ENV['PACKER_CACHE_DIR']
  packer_cache_dir = packer_cache_dir.dup.tr '\\', '/' unless packer_cache_dir.nil? || !windows? # replace backslaches on windows.
  packer_cache_dir
end

namespace :packer do
  desc 'Clear the packer cache'
  task :clear_cache do
    next unless File.directory?(packer_cache_dir)

    Dir["#{packer_cache_dir}/*"].each do |file|
      puts "Deleting #{file}"
      File.delete(file)
    end
  end
end