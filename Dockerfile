FROM slitazcn/base64 AS verify
COPY ./rootfs.gz ./
RUN mkdir -p /home/base64 && \
    cd /home/base64 && \
    mv /rootfs.gz . && \
    (zcat rootfs.gz 2>/dev/null || lzma d rootfs.gz -so) | cpio -id && \
    rm rootfs.gz

FROM scratch AS root
COPY --from=verify /home/base64/ /
RUN wget -O /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64
RUN chmod +x /usr/bin/dumb-init
ENTRYPOINT ["/usr/bin/dumb-init"]
CMD ["/usr/sbin/lighttpd" "-f" "/etc/lighttpd/lighttpd.conf"]

