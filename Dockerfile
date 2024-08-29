FROM adguard/adguardhome:latest
WORKDIR /root
RUN mkdir -p /run/openrc/
RUN touch /run/openrc/softlevel
RUN apk add openrc
RUN apk add tailscale
RUN echo "Ensure the tailscale env TSKEY is set: $TSKEY"
RUN echo $'#!/bin/sh \n\
tailscaled > /tmp/tailscaled.log & \n\
sleep 3 \n\
tailscale up --auth-key=$TSKEY > /tmp/tailscaleup.log & \n\
sleep 1 \n\
/opt/adguardhome/AdGuardHome --no-check-update -c /opt/adguardhome/conf/AdGuardHome.yaml -w /opt/adguardhome/work  \n\
' > /root/adguard-tailscale.sh
RUN chmod 0777 /root/adguard-tailscale.sh 
ENTRYPOINT ["/root/adguard-tailscale.sh"]
