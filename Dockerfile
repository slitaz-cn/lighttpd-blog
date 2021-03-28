FROM slitazcn/base64 AS verify
COPY ./rootfs.gz ./
RUN mkdir -p /home/base64 && \
    cd /home/base64 && \
    mv /rootfs.gz . && \
    (zcat rootfs.gz 2>/dev/null || lzma d rootfs.gz -so) | cpio -id && \
    rm rootfs.gz

FROM scratch AS root
COPY --from=verify /home/base64/ /
ENV PS1 "\u@\h:\w# "
ENV PATH /usr/bin:$PATH
CMD ["/bin/sh","-c","/etc/init.d/lighttpd start"]
