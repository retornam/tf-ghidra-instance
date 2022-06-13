FROM openjdk:11-jdk-slim

ENV GHIDRA_DOWNLOAD_VERSION=10.1.4
ENV GHIDRA_VERSION_DATE=20220519
ENV GHIDRA_DOWNLOAD_FILE_NAME=ghidra_${GHIDRA_DOWNLOAD_VERSION}_PUBLIC_${GHIDRA_VERSION_DATE}.zip
ENV DL https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_${GHIDRA_DOWNLOAD_VERSION}_build/${GHIDRA_DOWNLOAD_FILE_NAME}
ENV GHIDRA_SHA256 91556c77c7b00f376ca101a6026c0d079efbf24a35b09daaf80bda897318c1f1

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
