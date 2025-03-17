# Setup elasticsearch kibana logstash and filebeat on any k8s
## Elastic search :  
```bash
helm upgrade --install elasticsearch elasticsearch \
--set=replicas=1,minimumMasterNodes=1,resources.requests.cpu=100m,resources.requests.memory=1Gi,volumeClaimTemplate.resources.requests.storage=5Gi \
--repo=https://helm.elastic.co -n logging --create-namespace
```
## Logstash: 
``logstash.yaml``
```yaml
persistence:
  enabled: true

logstashConfig:
  logstash.yml: |
    http.host: 0.0.0.0
    # Enable environment variable interpolation
    config.support_escapes: true

extraEnvs: 
  - name: ELASTICSEARCH_PASSWORD
    valueFrom:
      secretKeyRef:
        name: elasticsearch-master-credentials
        key: password
  - name: ELASTICSEARCH_USERNAME
    value: "elastic"  # This is fixed in the Elasticsearch Helm chart

logstashPipeline:
  logstash.conf: |
    input {
      beats {
        port => 5044
      }
    }
    output {
      elasticsearch {
        hosts => "https://elasticsearch-master:9200"
        manage_template => false
        ssl_certificate_verification => false
        index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
        document_type => "%{[@metadata][type]}"
        user => "elastic"
        password => "${ELASTICSEARCH_PASSWORD}"
      }
    }

service:
  type: ClusterIP
  ports:
    - name: beats
      port: 5044
      protocol: TCP
      targetPort: 5044
    - name: http
      port: 8080
      protocol: TCP
      targetPort: 8080
```
To get the Kibana login password run this command. User name is elastic always.
```bash
kubectl get secrets --namespace=logging elasticsearch-master-credentials -ojsonpath='{.data.password}' | base64 -d
```
Now you can install 
```bash
helm upgrade --install logstash logstash --set=replicas=1,resources.requests.cpu=100m,resources.requests.memory=1Gi --repo=https://helm.elastic.co  -f logstash.yaml -n logging
```
## kibana:  
```bash
helm upgrade --install kibana kibana --set=resources.requests.cpu=100m,resources.requests.memory=500Mi  --repo=https://helm.elastic.co -n logging
```
### filebeat: 
create a values.yaml ``filebeat.yaml``
```yaml
daemonset:
  filebeatConfig:
    filebeat.yml: |
      filebeat.inputs:
      - type: container
        paths:
          - /var/log/containers/*.log
        processors:
        - add_kubernetes_metadata:
            host: ${NODE_NAME}
            matchers:
            - logs_path:
                logs_path: "/var/log/containers/"

      output.logstash:
        hosts: ["logstash-logstash:5044"]
```

```bash
helm upgrade --install filebeat filebeat --set=resources.requests.cpu=100m,resources.requests.memory=500Mi  -f filebeat.yaml --repo=https://helm.elastic.co -n logging
```

To expose kibana svc on loadbalancer ( in EKS or GKE etc )
create a svc yaml ``svc-kibana.yaml``
```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: kibana
    release: kibana
  name: kibana-kibana-public
  namespace: logging
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: "nlb"  # Specify NLB
    service.beta.kubernetes.io/aws-load-balancer-internal: "false"  # Public Load Balancer
    service.beta.kubernetes.io/aws-load-balancer-subnets: "subnet-0324d1bfb5d79a8fa,subnet-09eb3e0b450279e70,subnet-00b342ff023c4fb4f" # Public subnets only
    service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags: "Environment=dev,Project=elastic"
    service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: "true"
spec:
  ports:
  - name: http
    port: 5601
    protocol: TCP
    targetPort: 5601
  selector:
    app: kibana
    release: kibana
  type: LoadBalancer
status:
  loadBalancer: {}
```

and apply it ...
```bash
kubectl apply -f svc-kibana.yaml -n logging
kubectl get svc -n logging
```

access with loadbalancer external ip and port :5601 with user as elastic and password extracted by the command before.
