FROM mcr.microsoft.com/openjdk/jdk:21-ubuntu

ENV GHIDRA_DOWNLOAD_VERSION=11.1.1
ENV GHIDRA_VERSION_DATE=20240614
ENV GHIDRA_DOWNLOAD_FILE_NAME=ghidra_${GHIDRA_DOWNLOAD_VERSION}_PUBLIC_${GHIDRA_VERSION_DATE}.zip
ENV DL https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_${GHIDRA_DOWNLOAD_VERSION}_build/${GHIDRA_DOWNLOAD_FILE_NAME}
ENV GHIDRA_SHA256 7fe8d9a6e7e5267f3cf487a0c046b21fb08d7a602facaa2e81ac2f09b5df2866

RUN apt-get update && apt-get install -y wget unzip dnsutils --no-install-recommends \
    && wget --progress=bar:force -O /tmp/ghidra.zip ${DL} \
    && echo "$GHIDRA_SHA256 /tmp/ghidra.zip" | sha256sum -c - \
    && unzip /tmp/ghidra.zip \
    && mv ghidra_${GHIDRA_DOWNLOAD_VERSION}_PUBLIC /ghidra \
    && chmod +x /ghidra/ghidraRun \
    && echo "===> Clean up unnecessary files..." \
    && apt-get purge -y --auto-remove wget unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /tmp/* /var/tmp/* /ghidra/docs /ghidra/Extensions/Eclipse /ghidra/licenses

WORKDIR /ghidra

COPY entrypoint.sh /entrypoint.sh
COPY server.conf /ghidra/server/server.conf

EXPOSE 13100 13101 13102

RUN mkdir /repos

ENTRYPOINT ["/entrypoint.sh"]
CMD ["server"]
