# Restoring GigaBlog

## Creating a backup of GigaBlog

Restoring a version of GigaBlog requires all of the WordPress files and
a SQL dump of its wordpressdb MySQL database. Execute the command below
on the server hosting the GigaBlog website to create this SQL file:

```bash
mysqldump -u root --password=<% root password %> wordpressdb > wordpressdb.sql
```

`<% root password %>` should, of course, be replaced with the mysql root 
user's password.

The WordPress files which usually reside in `/var/www/wordpress` are also
required. A zipped tarball of these files can be created by:

```bash
tar -zcvf gigablog.tar.gz /var/www/wordpress
```

Both these files are stored locally on a desktop PC and on AWS S3.

## How to restore a backup

To restore a wordpressdb  database back onto a MySQL server using its 
SQL file:

```bash
mysql -u root --password=<% root password %> wordpressdb < wordpressdb.sql
```

The zipped tarball file containing the GigaBlog website also needs to be
extracted to the `/var/www` directory:

```bash
tar -xvzf gigablog.tar.gz -C /var/www
```