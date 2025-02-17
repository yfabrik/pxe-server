FROM alpine

RUN apk --no-cache add \
tini \
bash \
samba \
&& rm -f /etc/samba/smb.conf

RUN mkdir -p /srv/samba

COPY --chmod=755 samba.sh /usr/bin/samba.sh
COPY --chmod=664 smb.conf /etc/samba/smb.conf


EXPOSE 137 138 139 445

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/samba.sh"]




