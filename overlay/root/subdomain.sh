#!/bin/bash

. $(dirname $0)/config.sh

rm -f /usr/local/etc/nginx/sites/$1.conf
cp $(dirname $0)/subdomain.conf /usr/local/etc/nginx/sites/$1.conf

sed -i '' -e '/.*'$1'.*/d' /usr/local/etc/nginx/standard.conf

sed -i '' -e 's/DOMAIN/'$DOMAIN'/g' /usr/local/etc/nginx/sites/$1.conf
sed -i '' -e 's/SUB/'$1'/g' /usr/local/etc/nginx/sites/$1.conf
sed -i '' -e 's/IP/'$2'/g' /usr/local/etc/nginx/sites/$1.conf
sed -i '' -e 's/PORT/'$3'/g' /usr/local/etc/nginx/sites/$1.conf
if [ $4 ]; then
    sed -i '' -e 's/SCHEME/'$4'/g' /usr/local/etc/nginx/sites/$1.conf
else
    sed -i '' -e 's/SCHEME/http/g' /usr/local/etc/nginx/sites/$1.conf
fi

service nginx stop

certbot certonly --standalone -d www.$1.$DOMAIN --keep
certbot certonly --standalone -d $1.$DOMAIN --keep
sed -i '' -e 's,authenticator = standalone,authenticator = webroot,g'  /usr/local/etc/letsencrypt/renewal/*.conf

grep -qxF '[[webroot_map]]' /usr/local/etc/letsencrypt/renewal/$1.$DOMAIN.conf || echo -e '[[webroot_map]]' >> /usr/local/etc/letsencrypt/renewal/$1.$DOMAIN.conf
grep -qxF $1.$DOMAIN' = /usr/local/www' /usr/local/etc/letsencrypt/renewal/$1.$DOMAIN.conf || echo -e $1.$DOMAIN' = /usr/local/www' >> /usr/local/etc/letsencrypt/renewal/$1.$DOMAIN.conf
grep -qxF '[[webroot_map]]' /usr/local/etc/letsencrypt/renewal/www.$1.$DOMAIN.conf || echo -e '[[webroot_map]]' >> /usr/local/etc/letsencrypt/renewal/www.$1.$DOMAIN.conf
grep -qxF $1.$DOMAIN' = /usr/local/www' /usr/local/etc/letsencrypt/renewal/www.$1.$DOMAIN.conf || echo -e $1.$DOMAIN' = /usr/local/www' >> /usr/local/etc/letsencrypt/renewal/www.$1.$DOMAIN.conf

service nginx start