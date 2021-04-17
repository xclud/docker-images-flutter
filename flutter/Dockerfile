FROM docker.pna.co.ir/flutter/android-sdk

ARG PROXY_SERVER=192.168.18.18
ARG PROXY_PORT=1080

ENV FLUTTER_HOME=${HOME}/sdks/flutter \
    FLUTTER_VERSION=$flutter_version
ENV FLUTTER_ROOT=$FLUTTER_HOME

ENV PATH ${PATH}:${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin

RUN rm -r ${FLUTTER_HOME} && git clone https://github.com/flutter/flutter.git ${FLUTTER_HOME}

RUN export HTTPS_PROXY=socks5h://${PROXY_SERVER}:${PROXY_PORT} \
    && export HTTP_PROXY=socks5h://${PROXY_SERVER}:${PROXY_PORT} \
    && flutter doctor --android-licenses \
    && flutter doctor \
    && flutter precache \
    && chown -R root:root ${FLUTTER_HOME}
    
RUN export HTTPS_PROXY=socks5h://${PROXY_SERVER}:${PROXY_PORT} \
    && export HTTP_PROXY=socks5h://${PROXY_SERVER}:${PROXY_PORT} \
    && flutter pub global activate junitreport

ENV PATH ${PATH}:/root/.pub-cache/bin

COPY ./sample /opt/sample/
RUN export HTTPS_PROXY=socks5h://${PROXY_SERVER}:${PROXY_PORT} && cd /opt/sample/ && flutter build web
RUN export HTTPS_PROXY=socks5h://${PROXY_SERVER}:${PROXY_PORT} \
    && export HTTP_PROXY=socks5h://${PROXY_SERVER}:${PROXY_PORT} \
    && cd /opt/sample \
    && flutter build web \
    && cd android \
    && chmod +x gradlew \
    && ./gradlew build -x lint -Dhttps.proxyHost=${PROXY_SERVER} -Dhttps.proxyPort=${PROXY_PORT} \
    && flutter build apk \
    && rm -r /opt/sample
