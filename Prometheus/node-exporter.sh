#!/bin/bash
# Notes: 用于生产中Linux系统install Prometheus的Note-exporter 1.3.1
# Version：1.31 
# Creater by Allen Ji on 19 Jan 2023

Download and install wget
sudo yum -y install wget

sudo cd /tmp
sudo wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
sudo tar xvf node_exporter-1.3.1.linux-amd64.tar.gz 
sudo mv node_exporter-1.3.1.linux-amd64 /usr/local/bin/node_exporter
 
sudo groupadd prometheus
sudo useradd -g prometheus -m -d /var/lib/prometheus -s /sbin/nologin prometheus
sudo mkdir /usr/local/prometheus
sudo chown prometheus.prometheus -R /usr/local/prometheus

sudo touch /etc/systemd/system/node_exporter.service
sudo cat > /etc/systemd/system/node_exporter.service << EOF
[Unit]
Description=node_exporter
Documentation=https://prometheus.io/
After=network.target
[Service]
Type=simple
User=prometheus
ExecStart=/usr/local/bin/node_exporter/node_exporter --collector.processes  --collector.filesystem.ignored-mount-points=^/(sys|proc|dev|host|etc)($$|/)
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF
 
sudo systemctl daemon-reload
sudo systemctl restart node_exporter.service
sudo systemctl enable node_exporter.service
 
sudo systemctl start node_exporter.service
sudo systemctl status node_exporter