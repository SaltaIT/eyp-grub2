#
class grub2($transparent_huge_pages=undef) inherits grub2::params {

  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  if($transparent_huge_pages!=undef)
  {
    exec { 'grub2 transparent huge pages':
      command => "sed 's/^\\(GRUB_CMDLINE_LINUX=\"?[^\"]*\\)\"?/\\1 transparent_hugepage=${transparent_huge_pages}\"/' -i /etc/default/grub",
      unless => "grep 'transparent_hugepage=${transparent_huge_pages}' /etc/default/grub",
      notify => Exec['grub2-mkconfig'],
    }

    exec { 'grub2-mkconfig':
      command => 'grub2-mkconfig -o /boot/grub2/grub.cfg',
      refreshonly => true,
    }

  }

}
