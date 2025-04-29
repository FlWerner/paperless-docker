#!/bin/bash
set -x

function generatesslcert {
    openssl req -newkey rsa:2048 -keyout domain.key -out domain.csr -nodes
    openssl x509 -signkey domain.key -in domain.csr -req -days 365 -out domain.crt
}

function createcaddy {
    if [[ -n proxy_file ]]; then
        cp proxy_file Caddyfile
        fqdn=https://$(hostname -f):443
        dmp=https://hostname:443
        sed -e "s|$dmp|$fqdn|g" Caddyfile > Caddyfile.new
        mv Caddyfile.new Caddyfile
    fi
}
function checkDocker {
    if command -v docker compose &> /dev/null; then
        echo "Docker ist installiert."
    else
        exit 2 "Docker ist NICHT installiert."
fi
}
checkDocker
generatesslcert
createcaddy