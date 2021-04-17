FROM docker.pna.co.ir/flutter/android-sdk

ARG PROXY_SERVER=10.0.33.230
ARG PROXY_PORT_SOCKS=9050
ARG PROXY_PORT_HTTP=8118

ENV FLUTTER_HOME=${HOME}/sdks/flutter \
    FLUTTER_VERSION=$flutter_version
ENV FLUTTER_ROOT=$FLUTTER_HOME

ENV PATH ${PATH}:${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin

RUN rm -r ${FLUTTER_HOME} && git clone https://github.com/flutter/flutter.git ${FLUTTER_HOME}

RUN export HTTPS_PROXY=http://${PROXY_SERVER}:${PROXY_PORT_HTTP} \
    && export HTTP_PROXY=http://${PROXY_SERVER}:${PROXY_PORT_HTTP} \
    && flutter doctor --android-licenses \
    && flutter doctor \
    && flutter precache \
    && chown -R root:root ${FLUTTER_HOME}
    
RUN export HTTPS_PROXY=http://${PROXY_SERVER}:${PROXY_PORT_HTTP} \
    && export HTTP_PROXY=http://${PROXY_SERVER}:${PROXY_PORT_HTTP} \
    && flutter pub global activate junitreport

ENV PATH ${PATH}:/root/.pub-cache/bin

COPY ./sample /opt/sample/
RUN export HTTPS_PROXY=http://${PROXY_SERVER}:${PROXY_PORT_HTTP} && cd /opt/sample/ && flutter build web
RUN export HTTPS_PROXY=http://${PROXY_SERVER}:${PROXY_PORT_HTTP} \
    && export HTTP_PROXY=http://${PROXY_SERVER}:${PROXY_PORT_HTTP} \
    && cd /opt/sample \
    && flutter build web \
    && cd android \
    && chmod +x gradlew \
    && ./gradlew build -x lint -Dhttps.proxyHost=${PROXY_SERVER} -Dhttps.proxyPort=${PROXY_PORT_HTTP} \
    && flutter build apk \
    && rm -r /opt/sample
