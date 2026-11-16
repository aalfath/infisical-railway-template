# Infisical, the open-source secrets management platform.
# Pinned by version and digest. To update, bump both on a branch,
# add a CHANGELOG.md entry, test on a scratch Railway project, then merge.
FROM infisical/infisical:v0.167.10@sha256:1a8ed5e889988b37ffb439d67677de5f42b4864236a9c76fbfa9a097676daabd

# The upstream image already listens on 0.0.0.0:8080 and runs its database
# migrations on boot. These are stated here so the Railway setup is explicit.
ENV HOST=0.0.0.0 \
    PORT=8080

EXPOSE 8080

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["./standalone-entrypoint.sh"]
