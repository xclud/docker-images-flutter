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
    
RUN export HTTPS_PROXY=http://10.0.33.230:8118 \
    && export HTTP_PROXY=http://10.0.33.230:8118 \
    && mkdir -p /opt/sample \
    && cd /opt/sample \
    && flutter create . \
    && cat >>/opt/sample/pubspec.yaml<<EOF
name: sample
description: A new Flutter application.
publish_to: 'none'
version: 1.0.0

environment:
  sdk: ">=2.12.0 <3.0.0"

dependencies:
  flutter:
    sdk: flutter
  jwt_decoder: any
  http: any
  xml: any
  pointycastle: any
  path_provider: any
  encrypt: any
  persian: 1.0.1
  iran: any
  persian_flutter: any
  image_picker: any
  cached_network_image: any
  shared_preferences: any
  webview_flutter: any
  seamless: any
  simple_animations: ^1.3.12
  flutter_masked_text: any
  provider: any
  url_launcher: any
  flutter_swiper: any
  carousel_slider: ^4.0.0-nullsafety.0
  open_file: any
  firebase_core: any
  firebase_messaging: any
  firebase_analytics: any
  qrscan: any
  map: any
  latlng: any
  location: any
  image: any
  marquee_widget: any
  share: any
  contacts_service: any
  permission_handler: any
  local_auth: ^0.6.3+4
  metrix_plugin: any
  sms_retriever_api: any
  get: ^3.24.0
  percent_indicator: any
dev_dependencies:
  analyzer: any
  golden_toolkit: any
  flutter_test:
    sdk: flutter
EOF \
    && flutter build web \
    && cd android \
    && ./gradlew build -Dhttps.proxyHost=10.0.33.230 -Dhttps.proxyPort=8118 \
    && flutter build apk \
    && rm -r /opt/sample

ENV PATH ${PATH}:/root/.pub-cache/bin
