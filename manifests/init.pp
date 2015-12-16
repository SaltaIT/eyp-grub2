# == Class: grub2
#
# Full description of class grub2 here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'grub2':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class grub2($transparent_huge_pages=undef) inherits grub2::params {

  Exec {
    path => '/bin:/sbin:/usr/bin:/usr/sbin',
  }

  if($transparent_huge_pages!=undef)
  {
    exec { 'grub2 transparent huge pages':
      command => "sed 's/^\\(GRUB_CMDLINE_LINUX=\"[^\"]*\\)\"/\\1 transparent_hugepage=${transparent_huge_pages}\"/' -i /etc/default/grub",
      unless => "grep 'transparent_hugepage=${transparent_huge_pages}' /etc/default/grub",
      notify => Exec['grub2-mkconfig'],
    }

    exec { 'grub2-mkconfig':
      command => 'grub2-mkconfig -o /boot/grub2/grub.cfg',
      refreshonly => true,
    }

  }

}
