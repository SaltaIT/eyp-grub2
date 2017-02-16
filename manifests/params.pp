class grub2::params {

  case $::osfamily
  {
    'redhat' :
    {
      $bootcfg_bios='/boot/grub2/grub.cfg'
      $bootcfg_uefi='/boot/efi/EFI/redhat/grub.cfg'

      $grubmkconfig='grub2-mkconfig'
    }
    'Debian':
    {
      $bootcfg_bios='/boot/grub/grub.cfg'
      $bootcfg_uefi='/boot/efi/EFI/GRUB/grub.cfg'

      $grubmkconfig='grub-mkconfig'
    }
    default  : { fail('Unsupported OS!') }
  }
}
