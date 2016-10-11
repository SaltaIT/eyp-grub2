#[ -d /sys/firmware/efi ] && echo UEFI || echo BIOS
booted = Facter::Util::Resolution.exec('bash -c \'[ -d /sys/firmware/efi ] && echo UEFI || echo BIOS\'').to_s

unless booted.nil? or booted.empty?
  Facter.add('eyp_grub2_booted') do
      setcode do
        booted
      end
  end
end
