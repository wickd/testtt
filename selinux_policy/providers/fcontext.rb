include Chef::SELinuxPolicy::Helpers

# Support whyrun
def whyrun_supported?
  true
end

def fcontext_defined(file_spec, file_type, label = nil)
  file_hash = {
    'a' => 'all files',
    'f' => 'regular file',
    'd' => 'directory',
    'c' => 'character device',
    'b' => 'block device',
    's' => 'socket',
    'l' => 'symbolic link',
    'p' => 'named pipe',
  }

  label_matcher = label ? "system_u:object_r:#{Regexp.escape(label)}:s0\\s*$" : ''
  "semanage fcontext -l | grep -qP '^#{Regexp.escape(file_spec)}\\s+#{Regexp.escape(file_hash[file_type])}\\s+#{label_matcher}'"
end

def semanage_options(file_type)
  # Set options for file_type
  if node['platform_family'].include?('rhel') && Chef::VersionConstraint.new('< 7.0').include?(node['platform_version'])
    case file_type
    when 'a' then '-f ""'
    when 'f' then '-f --'
    else; "-f -#{file_type}"
    end
  else
    "-f #{file_type}"
  end
end

# Run restorecon to fix label
# https://github.com/sous-chefs/selinux_policy/pull/72#issuecomment-338718721
action :relabel do
  converge_by 'relabel' do
    spec = new_resource.file_spec
    escaped = Regexp.escape spec

    common =
      if spec == escaped
        spec
      else
        index = spec.size.times { |i| break i if spec[i] != escaped[i] }
        ::File.dirname spec[0...index]
      end

    # Just in case the spec is very weird...
    common = '/' if common[0] != '/'

    if ::File.exist? common
      shell_out!('find', common, '-ignore_readdir_race', '-regextype', 'posix-egrep', '-regex', spec, '-prune', '-execdir', 'restorecon', '-iRv', '{}', '+')
    end
  end
end

# Create if doesn't exist, do not touch if fcontext is already registered
action :add do
  execute "selinux-fcontext-#{new_resource.secontext}-add" do
    command "semanage fcontext -a #{semanage_options(new_resource.file_type)} -t #{new_resource.secontext} '#{new_resource.file_spec}'"
    not_if fcontext_defined(new_resource.file_spec, new_resource.file_type)
    only_if { use_selinux }
    notifies :relabel, new_resource, :immediate
  end
end

# Delete if exists
action :delete do
  execute "selinux-fcontext-#{new_resource.secontext}-delete" do
    command "semanage fcontext #{semanage_options(new_resource.file_type)} -d '#{new_resource.file_spec}'"
    only_if fcontext_defined(new_resource.file_spec, new_resource.file_type, new_resource.secontext)
    only_if { use_selinux }
    notifies :relabel, new_resource, :immediate
  end
end

action :modify do
  execute "selinux-fcontext-#{new_resource.secontext}-modify" do
    command "semanage fcontext -m #{semanage_options(new_resource.file_type)} -t #{new_resource.secontext} '#{new_resource.file_spec}'"
    only_if { use_selinux }
    only_if fcontext_defined(new_resource.file_spec, new_resource.file_type)
    not_if  fcontext_defined(new_resource.file_spec, new_resource.file_type, new_resource.secontext)
    notifies :relabel, new_resource, :immediate
  end
end

action :addormodify do
  run_action(:add)
  run_action(:modify)
end
