# INSTALLING NODE_EXPORTER
echo "Installing Node Exporter"
# Add users for Prometheus and Node Exporter
useradd --no-create-home --shell /bin/false node_exporter

# Install Node Exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz

# Unpack
tar xvf node_exporter-1.3.1.linux-amd64.tar.gz

# Copy files to new folder
cp node_exporter-1.3.1.linux-amd64/node_exporter /usr/local/bin
chown node_exporter:node_exporter /usr/local/bin/node_exporter

# Remove files
rm -rf node_exporter-1.3.1.linux-amd64.tar.gz node_exporter-1.3.1.linux-amd64

# Setup SystemD
echo "[Unit]
Description=Prometheus Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
PIDFile=/run/prometheus/node_exporter.pid
ExecStart=/usr/local/bin/node_exporter --collector.disable-defaults \
    --collector.arp \
    --collector.cpu \
    --collector.cpufreq \
    --collector.diskstats \
    --collector.filesystem \
    --collector.hwmon \
    --collector.loadavg \
    --collector.mdadm \
    --collector.meminfo \
    --collector.netclass \
    --collector.netdev \
    --collector.netstat \
    --collector.stat \
    --collector.thermal_zone \
    --collector.time \
    --collector.timex \
    --collector.udp_queues \
    --collector.uname \
    --collector.vmstat \
    --collector.systemd
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s SIGINT $MAINPID
Restart=on-failure
StartLimitInterval=600

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/node_exporter.service

# Reload
systemctl daemon-reload

# Start & Enable
systemctl start node_exporter
systemctl enable node_exporter

echo "Node Exporter is now succesfully installed"