FROM flutter/android-sdk

RUN export HTTPS_PROXY=http://10.0.33.230:8118 \
    && export HTTP_PROXY=http://10.0.33.230:8118 \
    && flutter doctor --android-licenses \
    && flutter doctor \
    && flutter precache \
    && chown -R root:root ${FLUTTER_HOME}
    
RUN export HTTPS_PROXY=http://10.0.33.230:8118 \
    && export HTTP_PROXY=http://10.0.33.230:8118 \
    && flutter pub global activate junitreport

ENV PATH ${PATH}:/root/.pub-cache/bin

COPY ./sample /opt/sample/

RUN export HTTPS_PROXY=http://10.0.33.230:8118 \
    && export HTTP_PROXY=http://10.0.33.230:8118 \
    && cd /opt/sample \
    && flutter build web \
    && cd android \
    && chmod +x gradlew \
    && set -o pipefail \
    && ./gradlew build -Dhttps.proxyHost=10.0.33.230 -Dhttps.proxyPort=8118 \
    && set +o pipefail \
    && flutter build apk \
    && rm -r /opt/sample
