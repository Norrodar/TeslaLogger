FROM mcr.microsoft.com/dotnet/aspnet:8.0.15
# timezone / date
RUN echo "Europe/Berlin" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

# install packages
RUN apt-get update && \
 apt-get upgrade && \
 apt-get install -y --no-install-recommends git && \
 apt-get install -y --no-install-recommends mariadb-client && \
 apt-get install -y optipng python3 python3.pip && \
 apt-get clean && \
 apt-get autoremove -y && \
 rm -rf /var/lib/apt/lists/* && \
 echo "export TERM=xterm" >> /root/.bashrc  && \
 echo "DOCKER" >> /tmp/teslalogger-DOCKER && \
 echo "DOCKER" >> /tmp/teslalogger-dockernet8 && \
 pip3 install grpc-stubs --break-system-packages && \
 pip3 install grpcio --break-system-packages && \
 pip3 install protobuf --break-system-packages && \
 pip3 install rich --break-system-packages

RUN mkdir -p /etc/teslalogger
RUN mkdir -p /etc/teslalogger/sqlschema
RUN mkdir -p /etc/teslalogger/git/TeslaLogger/Grafana
RUN mkdir -p /etc/teslalogger/git/TeslaLogger/GrafanaConfig
RUN mkdir -p /etc/teslalogger/git/TeslaLogger/GrafanaPlugins

COPY TeslaLogger/sqlschema.sql /etc/teslalogger/sqlschema
COPY --chmod=777 TeslaLogger/bin /etc/teslalogger/
COPY TeslaLogger/Grafana /etc/teslalogger/git/TeslaLogger/Grafana
COPY TeslaLogger/GrafanaConfig /etc/teslalogger/git/TeslaLogger/GrafanaConfig
COPY TeslaLogger/GrafanaPlugins /etc/teslalogger/git/TeslaLogger/GrafanaPlugins

WORKDIR /etc/teslalogger/Debug/net8.0

ENTRYPOINT ["dotnet", "./TeslaLoggerNET8.dll"]
