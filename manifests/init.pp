# Class: dovecot
#
# Install, enable and configure the Dovecot IMAP server.
# Options:
#  $plugins:
#    Array of plugin sub-packages to install. Default: empty
#
class dovecot (
  Array $plugins                    = [],
  # dovecot.conf
  Optional[String] $protocols                  = undef,
  Optional[String] $listen                     = undef,
  Optional[String] $login_greeting             = undef,
  Optional[String] $login_trusted_networks     = undef,
  $verbose_proctitle          = undef,
  $shutdown_clients           = undef,
  # 10-auth.conf
  Optional[Boolean] $disable_plaintext_auth     = undef,
  Optional[String] $auth_username_chars        = undef,
  String $auth_mechanisms            = 'plain',
  Array $auth_include               = ['system'],
  # 10-logging.conf
  $log_path                   = undef,
  $log_timestamp              = undef,
  $auth_verbose               = undef,
  $auth_debug                 = undef,
  $mail_debug                 = undef,
  # 10-mail.conf
  Optional[String] $mail_home                  = undef,
  $mail_fsync                 = undef,
  Optional[String] $mail_location              = undef,
  Optional[String] $mail_uid                   = undef,
  Optional[String] $mail_gid                   = undef,
  $mail_nfs_index             = undef,
  $mail_nfs_storage           = undef,
  $mail_privileged_group      = undef,
  Optional[String] $mail_plugins               = undef,
  $mmap_disable               = undef,
  $dotlock_use_excl           = undef,
  $include_inbox_namespace    = undef,
  # 10-master.conf
  Optional[String] $default_process_limit      = undef,
  Optional[String] $default_client_limit       = undef,
  Optional[String] $auth_listener_userdb_mode   = undef,
  Optional[String] $auth_listener_userdb_user   = undef,
  Optional[String] $auth_listener_userdb_group  = undef,
  Boolean $auth_listener_postfix       = false,
  Optional[String] $auth_listener_postfix_mode  = undef,
  Optional[String] $auth_listener_postfix_user  = undef,
  Optional[String] $auth_listener_postfix_group = undef,
  $imap_login_process_limit   = undef,
  $imap_login_client_limit    = undef,
  $imap_login_service_count   = undef,
  $imap_login_process_min_avail = undef,
  $imap_login_vsz_limit       = undef,
  $pop3_login_service_count   = undef,
  $pop3_login_process_min_avail = undef,
  $default_vsz_limit          = undef,
  $auth_listener_default_user = undef,
  Stdlib::Port $imaplogin_imap_port         = -1,
  Stdlib::Port $imaplogin_imaps_port        = -1,
  Boolean $imaplogin_imaps_ssl         = false,
  Optional[String] $lmtp_unix_listener          = undef,
  Optional[String] $lmtp_unix_listener_mode     = undef,
  Optional[String] $lmtp_unix_listener_user     = undef,
  Optional[String] $lmtp_unix_listener_group    = undef,
  $lmtp_socket_group          = undef,
  $lmtp_socket_mode           = undef,
  $lmtp_socket_path           = undef,
  $lmtp_socket_user           = undef,
  # 10-ssl.conf
  Optional[String] $ssl                        = undef,
  String $ssl_cert                   = '/etc/pki/dovecot/certs/dovecot.pem',
  String $ssl_key                    = '/etc/pki/dovecot/private/dovecot.pem',
  $ssl_cipher_list            = undef,
  $ssl_protocols              = undef,
  $ssl_dh_parameters_length   = undef,
  # 15-lda.conf
  Optional[String] $postmaster_address         = undef,
  Optional[String] $hostname                   = undef,
  Optional[String] $lda_mail_plugins           = undef,
  $lda_mail_location          = undef,
  $lda_mailbox_autocreate     = undef,
  $lda_mailbox_autosubscribe  = undef,
  # 20-imap.conf
  $imap_listen_port            = '*:143',
  $imaps_listen_port           = '*:993',
  Optional[String] $imap_mail_plugins          = undef,
  $imap_client_workarounds    = undef,
  # 20-lmtp.conf
  Optional[String] $lmtp_mail_plugins          = undef,
  Optional[Boolean] $lmtp_save_to_detail_mailbox = undef,
  # 20-pop3.conf
  $pop3_mail_plugins          = undef,
  $pop3_uidl_format           = undef,
  $pop3_client_workarounds    = undef,
  # 20-managesieve.conf
  Optional[Boolean] $manage_sieve               = undef,
  Boolean $managesieve_service         = false,
  Integer $managesieve_service_count   = 0,
  # 90-sieve.conf
  String $sieve                      = '~/.dovecot.sieve',
  $sieve_after                = undef,
  $sieve_before               = undef,
  $sieve_plugins              = undef,
  String $sieve_dir                  = '~/sieve',
  $sieve_max_actions          = undef,
  $sieve_max_redirects        = undef,
  $sieve_max_script_size      = undef,
  $sieve_quota_max_scripts    = undef,
  $sieve_quota_max_storage    = undef,
  Optional[String] $sieve_extensions            = undef,
  Optional[String] $recipient_delimiter         = undef,
  # 90-plugin.conf
  $fts                        = undef,
  # 90-quota.conf
  $quota                      = undef,
  $quota_warnings             = [],
  # auth-passwdfile.conf.ext
  $auth_passwdfile_passdb     = undef,
  $auth_passwdfile_userdb     = undef,
  # auth-sql.conf.ext
  $auth_sql_userdb_static     = undef,
  $auth_sql_path              = '/etc/dovecot/dovecot-sql.conf.ext',
  # auth-ldap.conf.ext
  $auth_ldap_userdb_static    = undef,
  $auth_master_separator      = '*',
  $mail_max_userip_connections = 512,
  Integer $first_valid_uid             = 0,
  Integer $last_valid_uid              = 0,

  Boolean $manage_service              = true,
  $custom_packages             = undef,
  $ensure_packages             = 'installed',

  Optional[String] $ldap_uris                   = undef,
  Boolean $quota_enabled               = false,
  Boolean $acl_enabled                 = false,
  Boolean $replication_enabled         = false,
  Boolean $shared_mailboxes            = false,
  Hash $options_plugins             = {},
  $mailbox_inbox_prefix        = undef,
) {
  if($replication_enabled) {
    validate_hash($options_plugins[replication])
    validate_string($options_plugins[replication][mail_replica])
    validate_string($options_plugins[replication][dsync_remote_cmd])
    validate_string($options_plugins[replication][replication_full_sync_interval])
    validate_string($options_plugins[replication][replication_dsync_parameters])
  }

  if $custom_packages == undef {
    case $::osfamily {
      'RedHat', 'CentOS': {
        $packages = ['dovecot','dovecot-pigeonhole']
      }
      /^(Debian|Ubuntu)$/:{
        $packages = ['dovecot-common','dovecot-imapd', 'dovecot-pop3d', 'dovecot-managesieved', 'dovecot-mysql', 'dovecot-ldap', 'dovecot-lmtpd']
      }
      'FreeBSD' : {
        $packages  = 'mail/dovecot2'
      }
      default: { fail("OS ${::operatingsystem} and version ${::operatingsystemrelease} is not supported.")
      }
    }
  } else {
    $packages = $custom_packages
  }

  case $::operatingsystem {
    'RedHat', 'CentOS': {
      $directory = '/etc/dovecot'
      $prefix    = 'dovecot'
    }
    /^(Debian|Ubuntu)$/:{
      $directory = '/etc/dovecot'
      $prefix    = 'dovecot'
    }
    'FreeBSD': {
      $directory = '/usr/local/etc/dovecot'
      $prefix    = 'mail/dovecot2'
    }
    default: { fail("OS ${::operatingsystem} and version ${::operatingsystemrelease} is not supported") }
  }

  # All files in this scope are dovecot configuration files
  if $manage_service {
    File {
      notify  => Service['dovecot'],
      require => Package[$packages],
    }
  }
  else {
    File {
      require => Package[$packages],
    }
  }

  # Install plugins (sub-packages)
  dovecot::plugin { $plugins: before => Package[$packages], prefix => $prefix }

  # Main package and service it provides
  package { $packages: ensure => $ensure_packages }
  if $manage_service {
    service { 'dovecot':
      ensure    => running,
      enable    => true,
      hasstatus => true,
      require   => File["${directory}/dovecot.conf"],
    }
  }

  # Main configuration directory
  file { $directory:
    ensure => 'directory',
    path   => $directory,
  }
  file { "${directory}/conf.d":
    ensure => 'directory',
  }

  # Main configuration file
  file { "${directory}/dovecot.conf":
    content => template('dovecot/dovecot.conf.erb'),
  }

  # Configuration file snippets which we modify
  file { "${directory}/conf.d/10-auth.conf":
    content => template('dovecot/conf.d/10-auth.conf.erb'),
  }
  file { "${directory}/conf.d/10-director.conf":
    content => template('dovecot/conf.d/10-director.conf.erb'),
  }
  file { "${directory}/conf.d/10-logging.conf":
    content => template('dovecot/conf.d/10-logging.conf.erb'),
  }
  file { "${directory}/conf.d/10-mail.conf":
    content => template('dovecot/conf.d/10-mail.conf.erb'),
  }
  file { "${directory}/conf.d/10-master.conf":
    content => template('dovecot/conf.d/10-master.conf.erb'),
  }
  file { "${directory}/conf.d/10-ssl.conf":
    content => template('dovecot/conf.d/10-ssl.conf.erb'),
  }
  file { "${directory}/conf.d/15-lda.conf":
    content => template('dovecot/conf.d/15-lda.conf.erb'),
  }
  file { "${directory}/conf.d/15-mailboxes.conf":
    content => template('dovecot/conf.d/15-mailboxes.conf.erb'),
  }
  file { "${directory}/conf.d/20-imap.conf":
    content => template('dovecot/conf.d/20-imap.conf.erb'),
  }
  file { "${directory}/conf.d/20-lmtp.conf":
    content => template('dovecot/conf.d/20-lmtp.conf.erb'),
  }
  file { "${directory}/conf.d/20-managesieve.conf":
    content => template('dovecot/conf.d/20-managesieve.conf.erb'),
  }
  file { "${directory}/conf.d/20-pop3.conf":
    content => template('dovecot/conf.d/20-pop3.conf.erb'),
  }

  if $manage_sieve {
    file { "${directory}/conf.d/20-managesieve.conf":
      content => template('dovecot/conf.d/20-managesieve.conf.erb'),
    }
  }

  file { "${directory}/conf.d/90-sieve.conf":
    content => template('dovecot/conf.d/90-sieve.conf.erb'),
  }
  file { "${directory}/conf.d/90-quota.conf":
    content => template('dovecot/conf.d/90-quota.conf.erb'),
  }
  file { "${directory}/conf.d/90-plugin.conf":
    content => template('dovecot/conf.d/90-plugin.conf.erb'),
  }

  if($replication_enabled) {
    file { "${directory}/conf.d/99-replicator.conf":
      content => template('dovecot/conf.d/99-replicator.conf.erb'),
    }
  } else {
    file { "${directory}/conf.d/99-replicator.conf":
      ensure => absent,
    }
  }

  file { "${directory}/conf.d/auth-passwdfile.conf.ext" :
    content => template('dovecot/conf.d/auth-passwdfile.conf.ext.erb'),
  }
  file { "${directory}/conf.d/auth-sql.conf.ext" :
    content => template('dovecot/conf.d/auth-sql.conf.ext.erb'),
  }
  file { '/etc/dovecot/conf.d/auth-ldap.conf.ext':
    content => template('dovecot/conf.d/auth-ldap.conf.ext.erb'),
  }
}
