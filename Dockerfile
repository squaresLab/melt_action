FROM danieltrt/breaking-changes:latest
WORKDIR /home/test/FixIt
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
