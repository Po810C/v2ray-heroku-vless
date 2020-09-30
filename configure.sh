#!/bin/sh

# Download and install V2Fly
mkdir /tmp/v2fly
curl -L -H "Cache-Control: no-cache" -o /tmp/v2fly/v2fly.zip https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip
unzip /tmp/v2fly/v2fly.zip -d /tmp/v2fly
install -m 755 /tmp/v2fly/v2ray /usr/local/bin/v2fly
install -m 755 /tmp/v2fly/v2ctl /usr/local/bin/v2flyctl

# Remove temporary directory
rm -rf /tmp/v2fly

# V2Fly new configuration
install -d /usr/local/etc/v2fly
cat << EOF > /usr/local/etc/v2fly/config.json
{
    "inbounds": [
        {
            "port": $PORT,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "$UUID",
                        "level": 0
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                    "acceptProxyProtocol": true, // 提醒：若你用 Nginx/Caddy 等反代 WS，需要删掉这行
                    "path": "/cgi-bin/api/" // 必须换成自定义的 PATH，需要和分流的一致
                }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}
EOF

# Run V2Fly
/usr/local/bin/v2fly -config /usr/local/etc/v2fly/config.json
