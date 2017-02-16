class grub2::params {

  case $::osfamily
  {
    'redhat' :
    {
      $bootcfg_bios='/boot/grub2/grub.cfg'
      $bootcfg_uefi='/boot/efi/EFI/redhat/grub.cfg'
    }
    'Debian':
    {
      $bootcfg_bios='/boot/grub/grub.cfg'
      $bootcfg_uefi='/boot/efi/EFI/GRUB/grub.cfg'
    }
    default  : { fail('Unsupported OS!') }
  }
}
