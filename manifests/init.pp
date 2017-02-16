#
class grub2($transparent_huge_pages=undef) inherits grub2::params {

  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  if($transparent_huge_pages!=undef)
  {
    exec { 'grub2 transparent huge pages':
      command => "sed 's/^GRUB_CMDLINE_LINUX=\"\\?\\([^\"]*\\)\"\\?/GRUB_CMDLINE_LINUX=\"\\1 transparent_hugepage=${transparent_huge_pages}\"/' -i /etc/default/grub",
      unless  => "grep 'transparent_hugepage=${transparent_huge_pages}' /etc/default/grub",
      notify  => Exec['grub2-mkconfig'],
    }

    # fact
    $eyp_grub2_booted_fact=getvar('::eyp_grub2_booted')

    if($eyp_grub2_booted_fact=='UEFI')
    {
      $bootcfg=$grub2::params::bootcfg_uefi
    }
    else
    {
      # default: BIOS
      $bootcfg=$grub2::params::bootcfg_bios
    }


    #nota: no canviar per unless donat que poden haver mes paramatres gestionats
    exec { 'grub2-mkconfig':
      command     => "${grub2::params::grubmkconfig} -o ${bootcfg}",
      refreshonly => true,
      require     => Exec['grub2 transparent huge pages'],
    }
  }

}
