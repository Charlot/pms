# encoding: utf-8

##
# Backup Generated: db_backup
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t db_backup [-c <path_to_configuration_file>]
#
Backup::Model.new(:db_backup, 'Description for db_backup') do
  ##
  # Split [Splitter]
  #
  # Split the backup file in to chunks of 250 megabytes
  # if the backup file size exceeds 250 megabytes
  #
  split_into_chunks_of 1024

  ##
  # MySQL [Database]
  #
  # database MySQL do |db|
  #   # To dump all databases, set `db.name = :all` (or leave blank)
  #   db.name               = "pmsdb"
  #   db.username           = "pmser"
  #   db.password           = "pmser@"
  #   db.host               = "localhost"
  #   db.port               = 3306
  #   db.socket             = "/var/run/mysqld/mysqld.sock"
  #   # Note: when using `skip_tables` with the `db.name = :all` option,
  #   # table names should be prefixed with a database name.
  #   # e.g. ["db_name.table_to_skip", ...]
  #   # db.skip_tables        = ["skip", "these", "tables"]
  #   # db.only_tables        = ["only", "these", "tables"]
  #   # db.additional_options = ["--quick", "--single-transaction"]
  # end

  ##
  # Redis [Database]
  #
  database Redis do |db|
    ##
    # From `dbfilename` in your `redis.conf` under SNAPSHOTTING.
    # Do not include the '.rdb' extension. Defaults to 'dump'
    db.name               = 'dump'
    ##
    # From `dir` in your `redis.conf` under SNAPSHOTTING.
    db.path               = '/var/lib/redis/6379/'
    #db.password           = 'my_password'
    db.host               = 'localhost'
    db.port               = 6379
    # db.socket             = '/tmp/redis.sock'
    db.additional_options = []
    db.invoke_save        = true
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
  # See the Wiki for other delivery options.
  # https://github.com/meskyanichi/backup/wiki/Notifiers
  #
  # notify_by Mail do |mail|
  #   mail.on_success           = true
  #   mail.on_warning           = true
  #   mail.on_failure           = true
  #
  #   mail.from                 = "song.wang@cz-tek.com"
  #   mail.to                   = "song.wang@cz-tek.com"
  #   mail.address              = "smtp.exmail.qq.com"
  #   mail.port                 = 465
  #   mail.domain               = "cz-tek.com"
  #   mail.user_name            = "song.wang@cz-tek.com"
  #   mail.password             = "111111111"
  #   mail.authentication       = "plain"
  #   mail.encryption           = :starttls
  # end


end
