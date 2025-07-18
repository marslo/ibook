
## account

```bash
$ sudo adduser --home /srv/share --shell /usr/sbin/nologin --disabled-password ftpuser
$ sudo passwd ftpuser
$ sudo chmod -R 2775 /ftp/release
$ sudo chown -R ftpuser:ftpuser /srv/share
```

## apps
```bash
$ sudo apt install vsftpd nfs-kernel-server nginx samba
```

### vsftpd
```bash
$ sudo cat /etc/vsftpd.conf
listen=YES
listen_ipv6=NO
anonymous_enable=NO
local_enable=YES
write_enable=YES
chroot_local_user=YES
allow_writeable_chroot=YES
local_umask=022
user_sub_token=$USER
local_root=/srv/share
pasv_enable=YES
pasv_min_port=30000
pasv_max_port=31000
# user list
userlist_enable=YES
userlist_file=/etc/vsftpd.user_list
userlist_deny=NO

$ sudo cat /etc/vsftpd.user_list
ftpuser

$ sudo systemctl restart vsftpd
$ sudo systemctl enable vsftpd
```

### nfs
```bash
$ sudo cat /etc/exports
/srv/share 10.87.0.0/20(rw,sync,no_subtree_check,all_squash,anonuid=1001,anongid=1001)
/srv/share 10.110.148.0/22(rw,sync,no_subtree_check,all_squash,anonuid=1001,anongid=1001)
/srv/share 10.68.78.0/24(rw,sync,no_subtree_check,all_squash,anonuid=1001,anongid=1001)
/srv/share 10.69.176.0/24(rw,sync,no_subtree_check,all_squash,anonuid=1001,anongid=1001)

$ sudo exportfs -ra
$ sudo systemctl restart nfs-kernel-server.service
$ sudo systemctl enable nfs-kernel-server.service
```

### nginx
```bash
$ sudo touch /etc/nginx/sites-available/ftp
$ sudo cat /etc/nginx/sites-available/ftp
server {
    listen 80;
    server_name _;

    location / {
        alias /ftp/release/;
        autoindex on;
        autoindex_exact_size off;
        autoindex_localtime on;
    }
}
$ sudo ln -s /etc/nginx/sites-available/ftp /etc/nginx/sites-enabled/
$ sudo unlink /etc/nginx/sites-enabled/default

$ sudo nginx -t
$ sudo systemctl reload nginx.service
$ sudo systemctl enable nginx.service
$ sudo systemctl restart nginx.service
```

### samba

> [!NOTE|label:login in windwows]
> - to avoid the automatic login with DOMAIN\user, you can use the following command:
> ```bash
> \ftpuser
> ```

```bash
# login with simple user instead of domain user
$ sudo cat /etc/samba/smb.conf
[global]
   server role = standalone server
   workgroup = WORKGROUP
   server string = %h log server
   log file = /var/log/samba/log.%m
   max log size = 1000
   # disable guest
   map to guest = Never
   # for windows
   ntlm auth = yes

[ftp]
   path = /ftp
   read only = yes
   guest ok = yes
   valid users = ftpuser
   force user = ftpuser

[ftp_release]
   path = /ftp/release
   read only = no
   guest ok = no
   valid users = ftpuser
   force user = ftpuser

# create the password for samba user
$ sudo smbpasswd -a ftpuser
```

## usage
### ftp
```bash
# -- install --
# debian/ubuntu
$ sudo apt update && sudo apt install ftp lftp
# osx
$ brew install lftp inetutils

# -- connect --
$ ftp 10.110.151.175
Connected to 10.110.151.175.
220 (vsFTPd 3.0.5)
Name (10.110.151.175:marslo): ftpuser
331 Please specify the password.
Password:
230 Login successful.
ftp>

# -- upload/put --
$ echo -e "user ftpuser password\nput localfile.txt\nbye" | ftp -n 10.110.151.175
# -- upload multiple files --
$ echo -e "user ftpuser password\nprompt\nmput *.txt\nbye" | ftp -n 10.110.151.175

# -- download/get --
$ echo -e "user ftpuser password\nget remotefile.txt\nbye" | ftp -n 10.110.151.175
# -- download multiple files --
$ echo -e "user ftpuser password\nprompt\nmget *.txt\nbye" | ftp -n 10.110.151.175

# -- list files --
$ echo -e "user ftpuser password\nls\nbye" | ftp -n 10.110.151.175

# -- delete file --
$ echo -e "user ftpuser password\ndelete remotefile.txt\nbye" | ftp -n 10.110.151.175
# -- delete files with wildcard --
$ echo -e "user ftpuser password\nprompt\nmdelete *.log\nbye" | ftp -n 10.110.151.175

# -- download whole directory with lftp --
$ lftp -u ftpuser,password ftp://10.110.151.175 -e "mirror --verbose /remote/dir $HOME/local/dir; bye"

# -- upload whole directory with lftp --
$ lftp -u ftpuser,password ftp://10.110.151.175 -e "mirror -R $HOME/local/dir /remote/dir; bye"
```
