# Start from the latest Swift nightly main toolchain
# Starting as root - 
#
FROM swiftlang/swift:nightly-main-jammy
ARG user=appuser
ARG group=appuser
ARG uid=1000
ARG gid=1000
RUN groupadd -g ${gid} ${group}
RUN useradd -u ${uid} -g ${group} -s /bin/sh -m ${user} # <--- the '-m' create a user home directory


# Install ESP-IDF dependencies
RUN apt-get update \
  && apt-get install --yes --no-install-recommends \
    sudo vim git wget flex bison gperf python3 python3-pip python3-venv \
    ninja-build ccache libffi-dev libssl-dev dfu-util libusb-1.0-0
  
# Install ESP-Matter dependencies
RUN apt-get update \
  && apt-get install --yes --no-install-recommends \
    git gcc g++ pkg-config libssl-dev libdbus-1-dev \
    libglib2.0-dev libavahi-client-dev ninja-build python3-venv python3-dev \
    python3-pip unzip libgirepository1.0-dev libcairo2-dev libreadline-dev 

# Install CMake >= 3.29
RUN pip install --upgrade cmake
USER appuser

# Download ESP-IDF
RUN mkdir -p ~/esp \
  && cd ~/esp \
  && git clone \
    --branch v5.2.1 \
    --depth 1 \
    --shallow-submodules \
    --recursive https://github.com/espressif/esp-idf.git \
    --jobs 24

# Install ESP-IDF
RUN cd ~/esp/esp-idf \
  && ./install.sh esp32c6

# Download ESP-Matter
RUN mkdir -p ~/esp \
  && cd ~/esp \
  && git clone \
    --branch release/v1.2 \
    --depth 1 \
    --shallow-submodules \
    --recursive https://github.com/espressif/esp-matter.git \
    --jobs 24

# Download ESP-Matter
RUN mkdir -p ~/esp \
  && cd ~/esp/esp-matter/connectedhomeip/connectedhomeip \
  && ./scripts/checkout_submodules.py --platform esp32 linux --shallow

# Install ESP-Matter
RUN cd ~/esp/esp-matter \
  && ./install.sh

# Setup shell environment
RUN echo '. ~/esp/esp-idf/export.sh > /dev/null' >> ~/.bashrc \
  && echo '. ~/esp/esp-matter/export.sh > /dev/null' >> ~/.bashrc

ENV ESPPORT='rfc2217://192.168.1.206:4000?ign_set_control'