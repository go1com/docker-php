# PHP running in nginx + FPM for most application.

This is latest PHP 7 images, with pre-installed extensions:

````
[PHP Modules]
bcmath
Core
ctype
curl
date
dom
exif
fileinfo
filter
ftp
gd
gettext
hash
iconv
intl
json
libxml
mbstring
mcrypt
memcached
mysqli
mysqlnd
openssl
pcre
PDO
pdo_mysql
pdo_pgsql
pgsql
Phar
Reflection
session
SimpleXML
SPL
sqlite3
standard
tokenizer
xml
xmlwriter
xsl
Zend OPcache
zip
zlib

[Zend Modules]
Zend OPcache
````

Also this container turn on the errorlogs for debug and increase post_max_size, upload_max_filesize to 100M