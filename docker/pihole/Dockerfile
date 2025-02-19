FROM ubuntu AS build

COPY . . 
RUN bash build.sh


FROM pihole/pihole:2024.07.0


RUN mkdir -p /srv/tftpboot

RUN ln -s /etc/lighttpd/conf-available/10-dir-listing.conf /etc/lighttpd/conf-enabled/
RUN ln -s /etc/lighttpd/conf-available/15-fastcgi-php.conf /etc/lighttpd/conf-enabled/
RUN ln -s /srv/tftpboot /var/www/html/tftpboot

WORKDIR /srv/tftpboot
COPY --from=build /src/wimboot .
COPY --from=build /src/ipxe/src/bin/undionly.kpxe .
COPY --from=build /src/ipxe/src/bin-x86_64-efi/snponly.efi .
COPY --from=build /src/ipxe/src/bin-x86_64-efi/ipxe.efi .
