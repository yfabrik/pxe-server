# samba inside docker
## with busybox

### marche pas
```
ENTRYPOINT ["busybox", "sh", "-c", "smbd"]
```
```
CMD ["smbd", "--foreground"]
```

```
RUN echo "#!/bin/sh\nsmbd --foreground --log-stdout" > /etc/rc.local && chmod +x /etc/rc.local
```

### marche 
```
RUN echo "::sysinit:/usr/sbin/smbd --foreground --no-process-group" > /etc/inittab
CMD ["busybox", "init"]
```
`::respawn:` au lieu de sysinit marche aussi

```
ENTRYPOINT ["busybox", "sh", "-c", "/usr/bin/samba.sh"]
```
avec samba.sh qui contient `exec smbd`

