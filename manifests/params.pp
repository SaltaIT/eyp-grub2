class grub2::params {

  case $::osfamily
  {
    'redhat' :
    {
      $bootcfg_bios='/boot/grub2/grub.cfg'
      $bootcfg_uefi='/boot/efi/EFI/redhat/grub.cfg'
      case $::operatingsystemrelease
      {
        /^7.*$/:
        {
        }
        default: { fail("Unsupported RHEL/CentOS version!")  }
      }
    }
    default  : { fail('Unsupported OS!') }
  }
}
