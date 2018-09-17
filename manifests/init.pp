#
# centos set default kernel: https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/System_Administrators_Guide/sec-Making_Persistent_Changes_to_a_GRUB_2_Menu_Using_the_grubby_Tool.html
#
class grub2 (
              $transparent_huge_pages                   = undef,
              $bootcfg_owner                            = 'root',
              $bootcfg_group                            = 'root',
              $bootcfg_mode                             = '0400',
              $disable_consistent_network_device_naming = false,
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
  }

  if($disable_consistent_network_device_naming)
  {
    if($::osfamily=='redhat')
    {
      package { 'biosdevname':
        ensure => 'present',
        before => Exec['grub2 disable consistent network device naming'],
      }
    }

    exec { 'grub2 disable consistent network device naming':
      command => "sed 's/^GRUB_CMDLINE_LINUX=\"\\?\\([^\"]*\\)\"\\?/GRUB_CMDLINE_LINUX=\"\\1 biosdevname=0 net.ifnames=0\"/' -i /etc/default/grub",
      unless  => "grep 'biosdevname=0 net.ifnames=0' /etc/default/grub",
      notify  => Exec['grub2-mkconfig'],
    }
  }

  #nota: no canviar per unless donat que poden haver mes paramatres gestionats
  exec { 'grub2-mkconfig':
    command     => "${grub2::params::grubmkconfig} -o ${bootcfg}",
    refreshonly => true,
  }
}
