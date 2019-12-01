# proxy-for-webSDK 

web videocall proxy代理服务器包括nginx服务器和turnserver中转服务器。下面依次介绍它们的部署流程。

1、Nginx代理服务器

Nginx是一个开源的第三方代理服务器，只需执行简单的安装命令即可。

（部署前要确保你申请了域名和证书）

CentOS和Ubuntu下可以参考第三方安装教程：https://jingyan.baidu.com/article/bad08e1ec2adc709c85121aa.html

安装完成之后，需要配置Nginx的conf文件。具体步骤如下：

    1.sudo vim /etc/nginx/nginx.conf 
    
    2.在conf文件的http域中添加如下配置项：
        resolver 8.8.8.8;
        server {
                listen  80;
                listen  443;
                server_name <your dns>;
                ssl     on;
                ssl_certificate         <your certificate file absolute path>;
                ssl_certificate_key     <your certificate key file absolute path>;
                location /ap/ {
                        proxy_set_header X-User-Address $remote_addr;
                        proxy_pass https://$arg_url;
                }
                location /cs/ {
                        proxy_pass https://$arg_h:$arg_p/$arg_d;
                }
                location /rs/ {
                        proxy_pass https://$arg_h:$arg_p/$arg_d;
                }
                location /ls/ {
                        proxy_pass https://$arg_h:$arg_p/$arg_d;
                }
                location /ws/ {
                        proxy_pass https://$arg_h:$arg_p;
                        proxy_http_version 1.1;
                        proxy_set_header Upgrade $http_upgrade;
                        proxy_set_header Connection "upgrade";
                }
        }
        
    3.sudo nginx -s reload


2、Turnserver部署

在Turnserver运行包中有四个文件：README，turnserver（执行文件），turnserver.conf，turnserver.sh

README文件，详细指导运行turnserver的步骤：


First, you need to set some parameters into turnserver.sh.

        extIP: external IP address
        udpport: the binding port of udp socket. default "3478"
        tcpport: the binding port of tcp socket. default "3433"
        realm: a symbol of your company. For example "agora.io"
After that, you need to create some users and write them to turnserver.conf.

        the format in turnserver.conf is: 'username=key'.
        you can generate the key by 'echo -n "<username>:<realm>:<password>" | md5sum'.
Finally, you can run the turnserver by turnserver.sh.

        usage: ./turnserver.sh [start/stop]
