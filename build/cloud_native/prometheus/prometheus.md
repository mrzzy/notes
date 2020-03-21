# Prometheus
References [offical documentation](https://prometheus.io/)

## Intro
Prometheus is monitoring system & alerting tookit:
- multi-dim data model storing time series data
- PromQL use to query said data
- pulls metrics instead of recieving pushed metrics
- Garfana provides dashboards to visualise data

## Configuration
Configure prometheus using YAML file:
```yaml
global:
  scrape_interval:     15s # how often to scrape for metrics 
  evaluation_interval: 15s # how often prometheus evaluates rules

# rule config
rule_files:
    # ....

# scrape config - where to scrape metrics from
# allow prometheus to mointor itself
scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets: ['localhost:9090']
    
# alertmanger config
alerting:
    # ....
```

### Rules
Rules configure certain aspect of Prometheus's behaviours
- rules are configured in rule files:
```yaml
groups: # define a rule group
  # individual rule
  - name: http_inprogress_requests_job
    # ....

```

#### Recording Rules
Recording rules (`record:`) - precompute frequently needed PromQL expressions
```yaml
    rules:
    - record: job:http_inprogress_requests:sum
      expr: sum(http_inprogress_requests) by (job)
```

#### Alerting Rules
Recording rules (`alert:`) - automatically create alerts when PromQL expression is _true_
- _true_ in PromQL means `expr` returning one or more values

```yaml
groups:
- name: example
  rules:
  - alert: HighRequestLatency
    expr: job:request_latency_seconds:mean5m{job="myjob"} > 0.5
    for: 10m # interval to evaluate expr
    labels:
      severity: page
    annotations: # can be templated  with {}
      summary: High request latency on {{ $labels.instance }}
      desription: High Request Latency of {{ $value}} seconds suggests that {{ $labels.instance }} are overloaded.
```

## Alerting
Setting up alerting in Prometheus:
- configure AlertManager using YAML config file. [example](https://github.com/prometheus/prometheus/blob/release-2.16/config/testdata/conf.good.yml)
    - configure where &amp; how to send the alerts
- configure prometheus to talk to AlertManager
- add alerting rules on Prometheus to automatically create alerts.

## Querying
Use PromQL to query metrics in the form `metric_name{label selector}`:
```promql
promhttp_metric_handler_requests_total{code="200"}
```

Label selector allows to filter metrics by labels:
| Method | Description | Example |
| --- | --- | --- |
| Equals | Label value matches exactly | `code="200"` |
| Not Equals | Opposite of Equals | `code!="200"` |
| Regrex Match | Label value matches regular expression | `environment=~"staging|testing|development"` |
| Not Regrex Match | Opposite of Regrex match | `environment!~"staging|testing|development"` |

> When using regrex match ensure that the regrex does not match an empty string `""`

Range Selector allows us select a range of data:
```promql
promhttp_metric_handler_requests_total{code="200"}[1m]
```
- selects the last 1 minute of data

time specifiers in range selector:
- s - seconds
- m - minutes
- h - hours
- d - days
- w - weeks
- y - years

### Aggregation
Aggregation Methods:

| Aggregate Method | Description |
| --- | --- |
| count() | Count the total no. of data points in the time series metric |
| count_values() | Count the total no. of elements with the same value. |
| stdvar() | Compute population variance |
| stddev() | Compute population standard deviation |
| max(), avg()  | Max value & average value |
| sum() | Sum of data points in metric |
| topk(), bottomk() | Top K/Bottom K values |
| quantile() | Quantile of data points in metric |

Aggregation with specific dimensions:
- sum `http_requests_total` group by `application`  &amp; `group`
```promql
sum by (application, group) (http_requests_total)
```
