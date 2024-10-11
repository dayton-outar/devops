# Monitoring and Feedback

In a distributed network of applications, logging plays a critical role in understanding the behavior and performance of your system. Logs provide valuable insights into the health of individual components, track interactions between services, and help identify issues or inefficiencies. Effective logging not only enables debugging and tracing but also aids in monitoring for security incidents, performance bottlenecks, and system failures. 

In distributed systems, the complexity increases due to the involvement of multiple services, communication patterns, and potential failures at different layers. To handle these challenges, a robust logging strategy is crucial. This strategy includes standardized logs, centralization, structured logging, and the use of tools that can aggregate and visualize logs for actionable insights.

## Important Tips for Logging in Distributed Systems

#### 1. **Centralize Logs**
   - Use log aggregation tools like **Fluentd**, **Logstash**, **Graylog**, or **ELK Stack** (Elasticsearch, Logstash, Kibana) to collect logs from multiple services in one place.
   - Centralized logging enables you to monitor and search logs across different applications, simplifying error tracking and trend analysis.
   - **Why it matters**: Without centralized logging, tracing issues across services would require manual log collection from each server or app instance, which can be time-consuming and error-prone.

#### 2. **Use Structured Logging**
   - Log data in a structured format such as JSON or XML, making it easier for log management systems to parse and analyze logs.
   - Include key fields such as **timestamp**, **log level**, **request ID**, **user ID**, **service name**, **transaction ID**, and **environment** (e.g., production, staging).
   - **Why it matters**: Structured logs are machine-readable, enabling automatic analysis, filtering, and querying, which is harder with unstructured log messages.

#### 3. **Ensure Log Consistency**
   - Adopt a standardized logging format across all services. Consistency helps when correlating logs from multiple sources.
   - Implement logging libraries that enforce this format and provide pre-built methods for logging different levels (e.g., error, debug, info).
   - **Why it matters**: Without consistency, logs from different services might be hard to interpret, slowing down root-cause analysis.

#### 4. **Log Contextual Information**
   - Capture and log important context such as request IDs, correlation IDs, and user/session information that can be traced across microservices or distributed components.
   - Use **distributed tracing** with systems like **Jaeger** or **Zipkin** to trace requests through different services.
   - **Why it matters**: Contextual logs allow you to trace the flow of a transaction across multiple services, aiding in debugging complex interactions in distributed environments.

#### 5. **Log at Appropriate Levels**
   - Define and use the correct log levels: **debug**, **info**, **warn**, **error**, and **critical**. 
   - In production, avoid verbose logging (like debug) unless needed to troubleshoot an issue.
   - **Why it matters**: Over-logging can lead to performance issues and overwhelm the system with unnecessary data. Conversely, under-logging could cause missed signals about critical issues.

#### 6. **Monitor Key Metrics and Alerts**
   - Define logging metrics such as **error rate**, **latency**, **request throughput**, and **service availability**.
   - Integrate logging systems with monitoring tools like **Prometheus** or **Grafana** to generate real-time alerts based on logs (e.g., spikes in errors).
   - **Why it matters**: Real-time alerts based on logs help in proactive monitoring, allowing you to fix issues before they escalate and affect end users.

#### 7. **Use Correlation IDs for Request Tracking**
   - Generate a unique correlation ID for every request and propagate it across the entire stack (e.g., microservices, databases, external APIs).
   - Ensure each service logs the correlation ID, allowing you to track a request through different services easily.
   - **Why it matters**: In a distributed system, a single user action may trigger multiple service calls. Correlation IDs allow you to track the request flow across services, making troubleshooting easier.

#### 8. **Ensure Log Retention and Rotation**
   - Set up proper **log retention policies** to store logs for a period (e.g., 30, 90 days), depending on compliance or operational needs.
   - Implement log rotation to avoid overwhelming disk storage, preventing potential service slowdowns.
   - **Why it matters**: Log storage can quickly grow out of control, consuming valuable resources. Rotation ensures logs are archived properly and resources are not over-utilized.

#### 9. **Make Use of Log Aggregation Dashboards**
   - Use visualization tools (e.g., Kibana, Grafana) to build dashboards that aggregate log metrics and visualize patterns.
   - Create dashboards for different aspects such as **error rates**, **latency distribution**, or **service health**.
   - **Why it matters**: Visualizing logs helps to identify trends and anomalies in real-time, which may not be apparent through raw logs alone.

#### 10. **Secure Your Logs**
   - Logs can contain sensitive information such as user data or credentials. Make sure to **mask or redact** sensitive fields.
   - Encrypt logs at rest and in transit, and limit access to logs based on role-based access control (RBAC).
   - **Why it matters**: Logs are a potential source of security leaks. By securing logs, you protect sensitive data from exposure or tampering.

### Using Logs for Feedback and Monitoring

1. **Performance Monitoring**
   - Logs can help monitor the **response time** of services and **database query performance**. By correlating slow response times with specific log entries, you can identify bottlenecks in your distributed system.
   - Example: Analyzing logs from an API service might show that database queries are taking longer than expected, which can then prompt optimization efforts.

2. **Error Diagnosis**
   - Use logs to track **error occurrences**, understand where they happen most frequently, and identify common patterns. Aggregating error logs across services will allow you to determine whether errors are isolated or systemic.
   - Example: If you see repeated database connection timeouts across multiple services, it may indicate an issue with the database rather than individual services.

3. **Anomaly Detection**
   - By monitoring logs for unexpected behavior (e.g., sharp increases in error logs or suspicious login attempts), you can detect security incidents or performance degradation early.
   - Example: A surge in failed authentication logs could indicate a brute-force attack or issues with a third-party identity provider.

4. **Audit and Compliance**
   - Logs provide a detailed history of events and actions taken in the system, useful for **audit trails** and compliance with regulations like GDPR.
   - Example: Use logs to verify that data access policies are being followed by tracking access logs for specific resources or users.

5. **Proactive Issue Resolution**
   - With the right log aggregation and alerting setup, logs can give you real-time feedback on issues like service outages, failed API requests, or unexpected user behavior. Automated alerts can notify your team before users report problems.
   - Example: Set up alerts to notify your team whenever error logs exceed a certain threshold, enabling faster resolution before the issue impacts many users.

By implementing these strategies, your logging infrastructure will not only help monitor the health of your distributed network of apps but also provide actionable insights that enhance system reliability, security, and performance.

## Fluentd Cheat Sheet

Here’s a concise cheat sheet for Fluentd, covering its essential concepts and configuration options.

---

### Core Concepts
- **Source**: Defines where Fluentd collects logs (e.g., files, HTTP, syslog).
- **Match**: Specifies where to send logs based on tag patterns.
- **Buffer**: Manages log storage before forwarding, ensuring reliability.
- **Output**: Defines the destination for the processed logs (e.g., Elasticsearch, S3).
- **Filter**: Modifies logs before sending them to the output.
- **Plugin**: Extends Fluentd functionality (e.g., input, output, filter plugins).

---

### Basic Configuration Structure (`fluent.conf`)

```conf
<source>
  @type tail
  path /var/log/nginx/access.log
  pos_file /var/log/td-agent/nginx-access.log.pos
  tag nginx.access
  format nginx
</source>

<filter nginx.access>
  @type record_transformer
  <record>
    hostname ${hostname}
    env production
  </record>
</filter>

<match nginx.access>
  @type stdout
</match>
```

---

### Sources

1. **File (Tail logs)**
    ```conf
    <source>
      @type tail
      path /path/to/logfile
      pos_file /var/log/td-agent/file.pos
      tag your.tag
      format none
    </source>
    ```

2. **HTTP Input**
    ```conf
    <source>
      @type http
      port 9880
    </source>
    ```

3. **Syslog Input**
    ```conf
    <source>
      @type syslog
      port 5140
      tag syslog
    </source>
    ```

---

### Filters

1. **Record Transformer**
    ```conf
    <filter your.tag>
      @type record_transformer
      <record>
        hostname ${hostname}
      </record>
    </filter>
    ```

2. **Grep (Filtering by a specific field)**
    ```conf
    <filter your.tag>
      @type grep
      <regexp>
        key message
        pattern error
      </regexp>
    </filter>
    ```

---

### Outputs

1. **Standard Output (Console)**
    ```conf
    <match your.tag>
      @type stdout
    </match>
    ```

2. **Elasticsearch**
    ```conf
    <match your.tag>
      @type elasticsearch
      host localhost
      port 9200
      index_name fluentd
      logstash_format true
    </match>
    ```

3. **Amazon S3**
    ```conf
    <match your.tag>
      @type s3
      aws_key_id YOUR_AWS_KEY
      aws_sec_key YOUR_AWS_SECRET
      s3_bucket your-bucket
      s3_region us-east-1
      path logs/
    </match>
    ```

---

### Buffers

1. **Basic File Buffer (Disk-based buffering)**
    ```conf
    <match your.tag>
      @type your_output
      <buffer>
        @type file
        path /var/log/td-agent/buffer
        flush_interval 5s
        retry_max_interval 30s
      </buffer>
    </match>
    ```

2. **Memory Buffer (In-memory buffering)**
    ```conf
    <match your.tag>
      @type your_output
      <buffer>
        @type memory
        flush_interval 5s
        retry_max_interval 30s
      </buffer>
    </match>
    ```

---

### Log Rotation & Retention

1. **Rotating Logs (via `logrotate`)**
    Configure `logrotate` for `/var/log/td-agent/td-agent.log`:
    ```bash
    /var/log/td-agent/td-agent.log {
      daily
      rotate 7
      compress
      missingok
      notifempty
      copytruncate
    }
    ```

---

### Error Handling

1. **Retry Strategy**
    ```conf
    <buffer>
      retry_forever true
      retry_wait 5s
      retry_max_interval 30s
    </buffer>
    ```

2. **Handling Failed Events**
    ```conf
    <match **>
      @type file
      path /var/log/failed_events
    </match>
    ```

---

### Useful Commands

- **Start Fluentd**: `fluentd -c /etc/fluentd/fluent.conf`
- **Start Fluentd as a Service**: `systemctl start td-agent`
- **Validate Configuration**: `fluentd --dry-run -c /etc/fluentd/fluent.conf`
- **Check Logs**: `tail -f /var/log/td-agent/td-agent.log`

---

### Best Practices

- **Use Tags**: Always tag your logs for easier filtering and matching.
- **Buffer Logs**: Use disk buffers for reliable log delivery, especially in production.
- **Filters for Cleanup**: Apply filters to reduce log size and normalize data.
- **Monitor Fluentd**: Regularly monitor the status using Fluentd’s logs and plugins like Prometheus for metrics.

This cheat sheet provides a quick reference to key features and configurations of Fluentd. Let me know if you need further details on any part!

## Videos

1. [How Fluentd simplifies collecting and consuming logs | Fluentd simply explained](https://youtu.be/5ofsNyHZwWE?si=cSnfVJGAuTJjaz8i) - [TechWorld with Nana](https://www.youtube.com/@TechWorldwithNana)
2. [Introduction to Fluentd: Collect logs and send almost anywhere](https://youtu.be/Gp0-7oVOtPw?si=P1wwh7R9ofZ4BtBi) - [That DevOps Guy](https://www.youtube.com/@MarcelDempers)