FROM cirrusci/android-sdk:30

USER root

ARG flutter_version=master

ENV FLUTTER_HOME=${HOME}/sdks/flutter \
    FLUTTER_VERSION=$flutter_version
ENV FLUTTER_ROOT=$FLUTTER_HOME

ENV PATH ${PATH}:${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin

RUN sdkmanager --proxy=socks5 --proxy_host=10.0.33.231 --proxy_port=1080 "--update" "--verbose" \
    && sdkmanager --proxy=socks5 --proxy_host=10.0.33.231 --proxy_port=1080 "build-tools;28.0.3" "platform-tools" "platforms;android-28" "platforms;android-29" "extras;android;m2repository" "extras;google;google_play_services" "extras;google;m2repository"
    
RUN git clone --branch ${FLUTTER_VERSION} https://github.com/flutter/flutter.git ${FLUTTER_HOME}

RUN HTTPS_PROXY=http://10.0.33.231:1080 HTTP_PROXY=http://10.0.33.231:1080 yes | flutter doctor --android-licenses \
    && flutter doctor \
    && flutter precache \
    && chown -R root:root ${FLUTTER_HOME}
    
