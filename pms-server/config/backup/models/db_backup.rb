# encoding: utf-8

##
# Backup Generated: db_backup
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t db_backup [-c <path_to_configuration_file>]
#
# For more information about Backup's components, see the documentation at:
# http://backup.github.io/backup
#
#

Model.new(:db_backup, 'Description for db_backup') do
	split_into_chunks_of 	1024
  ##
  # MySQL [Database]
  #
#  database MySQL do |db|
	## To dump all databases, set `db.name = :all` (or leave blank)
	#db.name               = "pmsdb"
	#db.username           = "pmser"
	#db.password           = "pmser@"
	#db.host               = "localhost"
	#db.port               = 3306
	#db.socket             = "/var/run/mysqld/mysqld.sock"
	## Note: when using `skip_tables` with the `db.name = :all` option,
	## table names should be prefixed with a database name.
	## e.g. ["db_name.table_to_skip", ...]
##    db.skip_tables        = ["skip", "these", "tables"]
	##db.only_tables        = ["only", "these", "tables"]
	##db.additional_options = ["--quick", "--single-transaction"]
  #end

  ##
  # Redis [Database]
  #
  database Redis do |db|
    db.mode               = :copy # or :sync
    # Full path to redis dump file for :copy mode.
    db.rdb_path           = '/var/lib/redis/6379/dump.rdb'
    # When :copy mode is used, perform a SAVE before
    # copying the dump file specified by `rdb_path`.
    db.invoke_save        = false
    db.host               = 'localhost'
    db.port               = 6379
    #db.socket             = '/tmp/redis.sock'
    #db.password           = 'my_password'
    #db.additional_options = []
  end

  ##
  # Local (Copy) [Storage]
  #
  store_with Local do |local|
   local.path       = "~/share/data/pms/backups/"
       local.keep       = 500
  end

  ##
  # Gzip [Compressor]
  #
  compress_with Gzip

  ##
  # Mail [Notifier]
  #
  # The default delivery method for Mail Notifiers is 'SMTP'.
  # See the documentation for other delivery options.
  #
  notify_by Mail do |mail|
	mail.on_success           = true
	mail.on_warning           = true
	mail.on_failure           = true

	mail.from                 = "igoschool@163.com"
	mail.to                   = "song.wang@cz-tek.com"
	mail.address              = "smtp.163.com"
	mail.port                 = 25
	mail.domain               = "https://cz-tek.com"
	mail.user_name            = "igoschool@163.com"
	mail.password             = "igoschool@"
	mail.authentication       = 'plain'
	mail.encryption           = :starttls
  end

end
