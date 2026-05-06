# Grafana & Monitoring Stack - Participant Guide

## Workshop Overview

This hands-on guide walks you through setting up a complete monitoring stack. Follow each section in order, running the commands as you go.

---

## Prerequisites Check

Before starting, verify you have the required tools installed:

```bash
# Check Docker version (should be 20.10+)
docker --version

# Check Docker Compose version (should be 1.27+)
docker-compose --version
```

---

## Part 1: Running Standalone Grafana

### Step 1.1: Pull Grafana Image

Download the Grafana Docker image:

```bash
docker pull grafana/grafana:11.0.0
```

**What this does**: Downloads the Grafana image from Docker Hub to your local machine.

**Expected output**: Download progress bars, then "Status: Downloaded newer image..."

### Step 1.2: Run Grafana Container

Start Grafana as a standalone container:

```bash
docker run -d \
  --name grafana \
  -p 3000:3000 \
  grafana/grafana:11.0.0
```

**What this does**:
- `-d`: Runs in detached mode (background)
- `--name grafana`: Names the container "grafana"
- `-p 3000:3000`: Maps port 3000 from container to host
- `grafana/grafana:11.0.0`: The image to run

**Expected output**: A long container ID (e.g., `a1b2c3d4e5f6...`)

### Step 1.3: Verify Grafana is Running

Check the container status:

```bash
docker ps
```

**Expected output**:
```
CONTAINER ID   IMAGE                    STATUS         PORTS                    NAMES
a1b2c3d4e5f6   grafana/grafana:11.0.0   Up 10 seconds  0.0.0.0:3000->3000/tcp   grafana
```

Look for:
- **STATUS**: Should show "Up" followed by time
- **PORTS**: Should show `0.0.0.0:3000->3000/tcp`

### Step 1.4: Check Grafana Logs

View the container logs to ensure it started successfully:

```bash
docker logs grafana
```

**What to look for**:
- "HTTP Server Listen" - confirms web server is running
- "Database migrated" - confirms database is initialized
- No ERROR messages

**Tip**: If you see errors, wait 10 seconds and check again. Grafana takes a few seconds to start.

### Step 1.5: Access Grafana Web Interface

Open your browser and navigate to:

```
http://localhost:3000
```

**Login credentials**:
- Username: `admin`
- Password: `admin`

**What to expect**:
1. Login page
2. Prompt to change password (click "Skip" for now)
3. Grafana home page

### Step 1.6: Explore the Interface

Take 2-3 minutes to explore:

- **Home**: Landing page with quick links
- **Configuration**: Click the gear icon → Data Sources
- **Notice**: No data sources configured yet

**Key observation**: Grafana alone is just an empty visualization tool. It needs data sources!

### Step 1.7: Stop and Remove Grafana Container

Clean up before moving to the full stack:

```bash
# Stop the container
docker stop grafana

# Remove the container
docker rm grafana

# Verify it's gone
docker ps -a
```

**What this does**:
- `docker stop`: Gracefully stops the container
- `docker rm`: Removes the container (but not the image)
- `docker ps -a`: Lists all containers (including stopped ones)

**Expected output**: The grafana container should no longer appear in the list.

---

## Part 2: Running the Complete Monitoring Stack

### Step 2.1: Navigate to Project Directory

```bash
# Navigate to the monitoring directory
cd /path/to/monitoring

# List files to confirm you're in the right place
ls -la
```

**Expected output**: You should see:
- `docker-compose.yml`
- `prometheus/` directory

### Step 2.2: Review Docker Compose Configuration

Take a quick look at the stack configuration:

```bash
# View the docker-compose file
cat docker-compose.yml
```

**What to notice**:
- Three services: node-exporter, prometheus, grafana
- Port mappings: 9100, 9090, 3000
- Volumes for data persistence
- Service dependencies

### Step 2.3: Start the Monitoring Stack

Launch all services with a single command:

```bash
docker-compose up -d
```

**What this does**:
- Reads `docker-compose.yml`
- Creates a network for service communication
- Starts containers in dependency order:
  1. Node Exporter (no dependencies)
  2. Prometheus (depends on node-exporter)
  3. Grafana (depends on prometheus)

**Expected output**:
```
Creating network "monitoring_default" with the default driver
Creating volume "monitoring_prometheus_data" with default driver
Creating volume "monitoring_grafana_data" with default driver
Creating node-exporter ... done
Creating prometheus    ... done
Creating grafana       ... done
```

**Time**: Takes 10-15 seconds for all services to be ready.

### Step 2.4: Verify All Services are Running

Check the status of all containers:

```bash
docker-compose ps
```

**Expected output**:
```
      Name                    Command               State           Ports
----------------------------------------------------------------------------------
grafana          /run.sh                          Up      0.0.0.0:3000->3000/tcp
node-exporter    /bin/node_exporter ...           Up      0.0.0.0:9100->9100/tcp
prometheus       /bin/prometheus ...              Up      0.0.0.0:9090->9090/tcp
```

**Verify**:
- All services show "Up" in the State column
- Ports are correctly mapped

### Step 2.5: Check Service Logs

Monitor the logs to ensure everything started correctly:

```bash
# View all logs
docker-compose logs

# Or view logs for a specific service
docker-compose logs grafana
docker-compose logs prometheus
docker-compose logs node-exporter

# Follow logs in real-time
docker-compose logs -f
```

**What to look for**:
- **node-exporter**: "Listening on :9100"
- **prometheus**: "Server is ready to receive web requests"
- **grafana**: "HTTP Server Listen"

**Tip**: Press `Ctrl+C` to stop following logs.

### Step 2.6: Verify Node Exporter

Check that Node Exporter is collecting metrics:

```bash
# Quick test
curl http://localhost:9100/metrics | head -20
```

**Expected output**: You should see metrics like:
```
# HELP node_cpu_seconds_total Seconds the CPUs spent in each mode.
# TYPE node_cpu_seconds_total counter
node_cpu_seconds_total{cpu="0",mode="idle"} 12345.67
node_cpu_seconds_total{cpu="0",mode="system"} 123.45
...
```

**Or open in browser**: http://localhost:9100/metrics

### Step 2.7: Verify Prometheus

Check that Prometheus is scraping targets:

**Browser**: Open http://localhost:9090

1. Click "Status" → "Targets"
2. Verify both targets are "UP":
   - `prometheus` (9090)
   - `node-exporter` (9100)

**What this means**: Prometheus is successfully pulling metrics from Node Exporter.

### Step 2.8: Test Prometheus Query

Try a simple query:

1. Navigate to http://localhost:9090
2. In the expression box, enter:
   ```promql
   node_cpu_seconds_total
   ```
3. Click "Execute"
4. Switch to "Graph" tab

**Expected result**: You should see time-series data for CPU usage.

---

## Part 3: Configuring Grafana

### Step 3.1: Access Grafana

Open your browser to: http://localhost:3000

**Login**:
- Username: `admin`
- Password: `admin`

**First time**: Skip the password change prompt (or change it if you prefer).

### Step 3.2: Add Prometheus Data Source

Configure Grafana to query Prometheus:

1. Click the **"Connections"**  on the left sidebar
2. Select **"Data Sources"**
3. Click **"Add data source"**
4. Choose **"Prometheus"**
5. Configure:
   - **Name**: `Prometheus` (default is fine)
   - **URL**: `http://prometheus:9090`
   - **Access**: `Server (default)`
6. Scroll down and click **"Save & Test"**

**Expected result**: Green checkmark with "Data source is working"

**Why http://prometheus:9090?**
Docker Compose creates a network where services can reach each other by name. Inside the Docker network, Grafana can reach Prometheus at `prometheus:9090`.

**Troubleshooting**:
- Red error? Check prometheus is running: `docker-compose ps`
- Timeout? Check network: `docker network inspect monitoring_default`

### Step 3.3: Import Node Exporter Dashboard

Get instant monitoring by importing a pre-built dashboard:

1. Click **"Dashboards"** (plus icon) on the left sidebar
2. Click **"+ Create Dashboard" then select **"Import dashboard"**
3. In "Import via grafana.com", enter: `1860`
4. Click **"Load"**
5. Configure the dashboard:
   - **Name**: `Node Exporter Full` (or keep default)
   - **Folder**: `Dashboards`
6. Click **"Import"**

**Expected result**: You should see a comprehensive dashboard with:
- CPU usage graphs
- Memory utilization
- Disk I/O
- Network traffic
- System load

**Time to explore**: Spend 2-3 minutes exploring different panels!

### Step 3.4: Understanding the Dashboard

Key panels to explore:

**CPU Section**:
- **CPU Busy**: Percentage of CPU in use
- **CPU Cores**: Individual core utilization
- **System Load**: 1, 5, 15-minute averages

**Memory Section**:
- **Memory Total**: Total RAM available
- **Memory Used**: Current RAM usage
- **Memory Available**: Free RAM for applications

**Disk Section**:
- **Disk Space**: Available vs used
- **Disk I/O**: Read/write operations per second

**Network Section**:
- **Traffic**: Bytes sent/received
- **Network Traffic**: Per interface

### Step 3.5: Generate Some Load (Optional)

Want to see the graphs move? Generate some CPU load:

```bash
# CPU stress test (run for 30 seconds)
docker run --rm -it containerstack/cpustress --cpu 2 --timeout 30s
```

**Watch the dashboard**: You should see CPU usage spike!

**Tip**: Use time range picker (top right) to zoom into the spike.

---

## Part 4: Creating a Custom Dashboard

### Step 4.1: Create New Dashboard

1. In Grafana, click **"+"** → **"New dashboard"**
2. Click **"+ Add Visualization"**

### Step 4.2: Add CPU Usage Panel

1. In the query editor, click **Code** and enter:
   ```promql
   100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
   ```
2. On the right side panel:
   - **Title**: "CPU Usage %"
   - **Unit**: "Percent (0-100)"
   - **Min**: 0
   - **Max**: 100
3. Click **"Apply"** (top right)

### Step 4.3: Add Memory Usage Panel

1. Click **"Add"** → **"Visualization"**
2. Query:
   ```promql
   100 * (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes))
   ```
3. Configure:
   - **Title**: "Memory Usage %"
   - **Unit**: "Percent (0-100)"
   - **Visualization**: Try "Gauge" instead of "Graph"
4. Click **"Apply"**

### Step 4.4: Save Dashboard

1. Click the **save icon** (disk) at the top
2. Name: "My First Dashboard"
3. Click **"Save"**

**Congratulations!** You've created your first custom dashboard!

---

## Cleanup

### Remove Everything

**Stop and remove containers**:
```bash
docker-compose down
```

**Remove volumes (deletes all data)**:
```bash
docker-compose down -v
```

**Remove images** (optional):
```bash
docker rmi grafana/grafana:11.0.0
docker rmi prom/prometheus:v2.53.0
docker rmi prom/node-exporter:v1.8.2
```

**Verify cleanup**:
```bash
docker ps -a
docker volume ls
docker images
```

---

## Quick Reference

### Service URLs

- **Grafana**: http://localhost:3000 (admin/admin)
- **Prometheus**: http://localhost:9090
- **Node Exporter**: http://localhost:9100/metrics

### Useful PromQL Queries

```promql
# CPU usage
100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory usage
100 * (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes))

# Disk usage
100 - ((node_filesystem_avail_bytes{mountpoint="/"} * 100) / node_filesystem_size_bytes{mountpoint="/"})

# Network traffic
rate(node_network_receive_bytes_total[5m])
```

---

## Next Steps

1. **Explore more dashboards**: Visit https://grafana.com/grafana/dashboards/
2. **Learn PromQL**: https://prometheus.io/docs/prometheus/latest/querying/basics/
3. **Set up alerts**: Create notification rules in Grafana
4. **Add more exporters**: Monitor databases, web servers, etc.
5. **Customize dashboards**: Build dashboards for your specific needs

---

## Additional Resources

- **Grafana Documentation**: https://grafana.com/docs/
- **Prometheus Documentation**: https://prometheus.io/docs/
- **Node Exporter**: https://github.com/prometheus/node_exporter
- **PromQL Basics**: https://prometheus.io/docs/prometheus/latest/querying/basics/
- **Dashboard Examples**: https://grafana.com/grafana/dashboards/

---

## Workshop Complete! 🎉

You've successfully:
- ✅ Run Grafana as a standalone container
- ✅ Deployed a complete monitoring stack
- ✅ Configured Prometheus as a data source
- ✅ Imported and explored a pre-built dashboard
- ✅ Created your own custom dashboard

**Keep experimenting and happy monitoring!**