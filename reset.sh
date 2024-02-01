sudo /etc/init.d/openresty stop
sudo rm -rf /usr/local/openresty/nginx/logs/*
sudo cp nginx.conf /usr/local/openresty/nginx/conf
sudo cp *.lua /usr/local/openresty/nginx/conf/
sudo /etc/init.d/openresty start
sleep 2
cat /usr/local/openresty/nginx/logs/error.log

