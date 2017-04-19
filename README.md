# PHP running in apache for most application.

This is latest PHP 5 images, with pre-installed extensions:

````
[PHP Modules]
bcmath
bz2
calendar
Core
ctype
curl
date
dom
ereg
exif
fileinfo
filter
ftp
gd
gettext
hash
iconv
imap
intl
json
libxml
mbstring
mcrypt
memcache
mysql
mysqli
mysqlnd
openssl
pcntl
pcre
PDO
pdo_mysql
pdo_pgsql
pdo_sqlite
pgsql
Phar
posix
readline
Reflection
session
shmop
SimpleXML
soap
sockets
SPL
sqlite3
standard
sysvmsg
sysvsem
sysvshm
tokenizer
wddx
xml
xmlreader
xmlwriter
xsl
Zend OPcache
zip
zlib

[Zend Modules]
Zend OPcache
````

Also this container turn on the errorlogs for debug and increase post_max_size, upload_max_filesize to 200M