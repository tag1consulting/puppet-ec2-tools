class ec2_tools {
  #Install PIP
  package { 'python-pip':
    ensure => installed,
  }

  package { 'awscli':
    provider => 'pip',
    ensure => installed,
    require => Package['python-pip'],
  }

  file { '/root/.aws':
    ensure => directory,
    mode => '755',
    owner => 'root',
    group => 'root',
  }

  file { '/root/.aws/config':
    ensure => present,
    replace => no,
    mode => '600',
    owner => 'root',
    group => 'root',
    require => File['/root/.aws'],
    source => 'puppet:///modules/ec2_tools/aws/config_template',
  }

  file { '/root/.aws/credentials':
    ensure => present,
    replace => no,
    mode => '600',
    owner => 'root',
    group => 'root',
    require => File['/root/.aws'],
    source => 'puppet:///modules/ec2_tools/aws/credentials_template',
  }

    
}

class ec2_missing_tools {

  file { '/root/ec2_missing_tools_6cf0b19.zip':
    owner => root,
    group => root,
    mode => 644,
    source => 'puppet:///modules/ec2_tools/ec2_missing_tools_6cf0b19.zip',
  }

  package { 'unzip':
    ensure => installed,
  }

  exec { 'unzip_package':
    command => 'cd /root && unzip /root/ec2_missing_tools_6cf0b19.zip',
    require => [ File['/root/ec2_missing_tools_6cf0b19.zip'], Package['unzip'], Class['ec2_tools'] ],
    path => '/bin:/usr/bin',
    refreshonly => true,
    subscribe => File['/root/ec2_missing_tools_6cf0b19.zip'],
  }
}
