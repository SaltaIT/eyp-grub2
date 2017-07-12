class grub2::params {

  case $::osfamily
  {
    'redhat' :
    {

      $bootcfg_uefi='/boot/efi/EFI/redhat/grub.cfg'

      $grubmkconfig='grub2-mkconfig'

      case $::operatingsystemrelease
      {
        /^[5-6].*$/:
        {
          $bootcfg_bios='/boot/grub/grub.cfg' 
        }
        /^7.*$/:
        {
          $bootcfg_bios='/boot/grub2/grub.cfg'
        }
        default: { fail("Unsupported RHEL/CentOS version! - ${::operatingsystemrelease}")  }
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
