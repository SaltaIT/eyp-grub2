#
class grub2 (
              $transparent_huge_pages = undef,
              $bootcfg_owner          = 'root',
              $bootcfg_group          = 'root',
              $bootcfg_mode           = '0400',
            ) inherits grub2::params {

  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
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

  # 1.4.1 Ensure permissions on bootloader config are configured
  # chown root:root /boot/grub2/grub.cfg
  # chmod og-rwx /boot/grub2/grub.cfg
  file { $bootcfg:
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => $bootcfg_mode,
  }

  if($transparent_huge_pages!=undef)
  {
    exec { 'grub2 transparent huge pages':
      command => "sed 's/^GRUB_CMDLINE_LINUX=\"\\?\\([^\"]*\\)\"\\?/GRUB_CMDLINE_LINUX=\"\\1 transparent_hugepage=${transparent_huge_pages}\"/' -i /etc/default/grub",
      unless  => "grep 'transparent_hugepage=${transparent_huge_pages}' /etc/default/grub",
      notify  => Exec['grub2-mkconfig'],
    }

    #nota: no canviar per unless donat que poden haver mes paramatres gestionats
    exec { 'grub2-mkconfig':
      command     => "${grub2::params::grubmkconfig} -o ${bootcfg}",
      refreshonly => true,
      require     => Exec['grub2 transparent huge pages'],
    }
  }

}
