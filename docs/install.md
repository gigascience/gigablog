# Installation of GigaBlog

A new installation of GigaBlog requires a WXR file. This is an XML file
which contains posts, pages, custom post types, comments, custom fields, 
categories, tags, custom taxonomies, and users. In the wxr directory,
there are two wxr files. The file `test.gigablog.wordpress.xml` is a 
small wxr file which contains a couple of posts from GigaBlog. The much
larger `gigablog.wordpress.2016-12-13.xml` file contains all of the posts
from GigaBlog up till the end of December 2016.

The WordPress dashboard permits the WXR file to be used for [importing
content](https://codex.wordpress.org/Importing_Content) into an instance
of WordPress. Media such as images have URL links associated with them
which are used to pull such files from their sources into the WordPress
instance.

## Deploying GigaBlog using Chef

