FROM flutter/android-sdk

RUN HTTPS_PROXY=socks5://10.0.33.230:9050 HTTP_PROXY=socks5://10.0.33.230:9050 yes | flutter doctor --android-licenses \
    && HTTPS_PROXY=socks5://10.0.33.230:9050 HTTP_PROXY=socks5://10.0.33.230:9050 flutter doctor \
    && HTTPS_PROXY=socks5://10.0.33.230:9050 HTTP_PROXY=socks5://10.0.33.230:9050 flutter precache \
    && chown -R root:root ${FLUTTER_HOME}
    
