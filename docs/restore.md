# Restoring GigaBLOG

## Create backup files for GigaBLOG

Restoring a version of GigaBLOG requires all of the WordPress files and
a SQL dump of its wordpressdb MySQL database. Execute the command below
on the server hosting the GigaBLOG website to create this SQL file:

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

A cron job is used to automatically create the above backup files and send 
upload them in an AWS S3 bucket for storage.

## Restore GigaBLOG using Chef onto a local Virtual Machine

Download a copy of the GigaBLOG source code:
```bash
$ git clone https://github.com/gigascience/gigablog.git
```

Initialise its submodules:
```bash
$ cd gigablog/chef
$ git submodule init
$ git submodule update
```

Create a `local_restore.json` file:
```bash
cp environments/local_restore.json.sample environments/local_restore.json
```

Configure `local_restore.json` with required values for building the 
GigaBLOG. Set a value for the WordPress database password:
```
"wordpress": {
  "db": {
    "root_password": "gigablog",
    "instance_name": "default",
    "name": "wordpressdb",
    "user": "wordpressuser",
    "password": ""
  }
}, 
```

A SQL database dump file and tar.gz archive file of the wordpress directory 
will need to be available in AWS S3 from where they will  be downloaded and used
to restore a version of GigaBLOG. The names of these files need to be stated 
in `local_restore.json` in the `sqlS3filename` and `wpS3filename` attributes:
```
"sqlS3filename": "<% sqlS3filename %>",
"wpS3filename": "<% wpS3filename %>",
```

SQL dumps from the production service of GigaBLOG will contain references
to `gigasciencejournal.com/blog`. These need to be replaced with
`localhost:9170/blog` when a test GigaBLOG deployed on a local VM is
required. `gigasciencejournal.com/blog` can be selected by providing it as
the value of the `gigablog_prod_url` attribute. The value of the site_url
attribute is then used to replace references of `gigasciencejournal.com/blog`
in the database. To use this script, the value of the deployment attribute 
needs to be set to `restore` in `local_restore.json`. This is already done for 
you in `local_restore.json`:
```
"gigablog": {
  "servername": "localhost",
  "deployment": "restore",
  "sqlS3filename": "<% sqlS3filename %>",
  "wpS3filename": "<% wpS3filename %>",
  "vagrant_dir": "/vagrant",
  "log_dir": "/var/www/wordpress",
  "url": "localhost:9170/blog",
  "gigablog_prod_url": "gigasciencejournal.com/blog"
},
```

Your AWS credentials are required in `local_restore.json` to access the above
S3 files:
```  
"aws": {
  "aws_access_key_id": "",
  "aws_secret_access_key": "",
  "aws_default_region": "ap-southeast-1",
  "aws_security_groups": ""
}
```

Finally, set `chef.environment = "local_restore"` in `Vagrantfile` and then 
execute:
```bash
$ vagrant up
```

A local instance of GigaBLOG should appear in 
[http://localhost:9170/blog](http://localhost:9170/blog]) in your web browser.

#### Production deployment

GigaBLOG can be deployed directly onto AWS as a production service using
Vagrant.

Set the `GIGABLOG_BOX` environment variable in ~/.bash_profile:
 
```bash
GIGABLOG_BOX='aws'
```

Then `source ~/.bash_profile` to update environment variables for your
console terminal session.

To deploy onto an AWS virtual server:

```bash
$ vagrant up --provider=aws
# To delete AWS instance
$ vagrant destroy -f
```

Note that there are issues with constraints on dependencies for the 
WordPress cookbook which need to the commented out in 
`chef/chef-cookbooks/wordpress/metadata.rb` when deploying a production
server:

```bash
depends "apache2", ">= 2.0.0"
depends "database", ">= 1.6.0"
depends "mysql", ">= 6.0"
depends "mysql2_chef_gem" #, "~> 1.0.1"
# depends "build-essential"
depends "iis", ">= 1.6.2"
depends "tar", ">= 0.3.1"
depends "nginx" #, "~> 2.7.4"
depends "php-fpm" #, "~> 0.6.10"
depends 'selinux', '~> 0.7'

>>>>>>> 3df63466921b52c26e813922cd66b200a941bfb2
```

### Manual restoration

This requires SSH access to the server hosting GigaBLOG. Once logged in,
restore a wordpressdb database onto a MySQL server by using its SQL 
file:

```bash
mysql -u root --password=<% root password %> wordpressdb < wordpressdb.sql
```

The zipped tarball file containing the GigaBLOG website also needs to be
extracted to the `/var/www` directory:

```bash
tar -xvzf gigablog.tar.gz -C /var/www
```

### Useful commands

#### Reset user password

Its possible to reset user passwords on the command line on the WordPress 
server. Identify the WordPress ID of the user you need to update:
```bash
$ wp --path=/var/www/wordpress
```

Then update the user's password:
```bash
$ wp user update 1 --user_pass=<% new_password%> --path=/var/www/wordpress
```