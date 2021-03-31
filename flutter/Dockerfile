FROM flutter/android-sdk

ENV HTTPS_PROXY http://10.0.33.230:8118
ENV HTTP_PROXY http://10.0.33.230:8118

RUN flutter doctor --android-licenses \
    && flutter doctor \
    && flutter precache \
    && chown -R root:root ${FLUTTER_HOME}
    
RUN mkdir -p /opt/sample \
    && cd /opt/sample \
    && flutter create . \
    && flutter build web \
    && cd android \
    && ./gradlew build -Dhttps.proxyHost=10.0.33.230 -Dhttps.proxyPort=8118 \
    && rm -r /opt/sample
