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

### Automated restoration using Chef

A Chef script is available for restoring a GigaBlog website.

This script requires the SQL database dump file and tar.gz archive file 
of the wordpress directory to be available from S3 from where they will 
be downloaded and used to restore a version of GigaBlog. The names of 
these files need to be stated in development.json in the sqlS3filename
and wpS3filename attributes.

SQL dumps from the production service of GigaBlog will contain references
to `gigasciencejournal.com/blog`. These need to be replaced with
`localhost:9170/blog` when a test GigaBlog deployed on a local VM is
required. `gigasciencejournal.com/blog` can be selected by changing
the value of the `aws_elastic_ip` attribute. The value of the site_url
attribute is then used instead of `gigasciencejournal.com/blog`.

#### Test deployment

Finally, to use this script, change the value of the [gigablog][instance] 
attribute from `deploy` to `restore` in `development.json` and then 
execute `vagrant up`.

#### Production deployment

GigaBlog can be deployed directly onto AWS as a production service using
Vagrant.

```bash
$ vagrant up --provider=aws
```

### Manual restoration

This requires SSH access to the server hosting GigaBlog. Once logged in,
restore a wordpressdb database onto a MySQL server by using its SQL 
file:

```bash
mysql -u root --password=<% root password %> wordpressdb < wordpressdb.sql
```

The zipped tarball file containing the GigaBlog website also needs to be
extracted to the `/var/www` directory:

```bash
tar -xvzf gigablog.tar.gz -C /var/www
```