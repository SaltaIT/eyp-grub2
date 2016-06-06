if File.exist?('/proc/cmdline')
  Facter.add('eyp_grub2_kernel_cmdline') do
      setcode do
          File.open("/proc/cmdline", "rb").read
      end
  end
end
