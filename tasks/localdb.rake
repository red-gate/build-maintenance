def fixup_localdb(sqllocaldb_exe, instance_name)
  if File.exist?(sqllocaldb_exe)
    if `"#{sqllocaldb_exe}" info #{instance_name}`.match(/(Name:.*#{instance_name}\n)/)
      puts "All good. default instance #{instance_name} for #{sqllocaldb_exe} is OK."
    else
      begin
        sh "\"#{sqllocaldb_exe}\" delete #{instance_name}"
      rescue
        # OK to fail has the local db instance might just not exist. (rather than be broken)
      end

      sh "\"#{sqllocaldb_exe}\" create #{instance_name}"
    end
  else
    puts "#{sqllocaldb_exe} does not exist. Skipping..."
  end
end

namespace :localdb do

  desc 'Delete and recreate broken localdb instances'
  task :recreate_invalid_databases do

    fixup_localdb 'C:/Program Files/Microsoft SQL Server/110/Tools/Binn/sqllocaldb.exe', 'v11.0'
    fixup_localdb 'C:/Program Files/Microsoft SQL Server/120/Tools/Binn/sqllocaldb.exe', 'MSSQLLocalDB'

  end

end
