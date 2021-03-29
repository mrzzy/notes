# K8s/Kubernetes Notes
_Referenced from Kubernetes  in Action by Marko Luksa_

## Introducing Kubernetes
### The Microservices Trend
Applications(apps) in the industry have begun transitioning from large monoliths
to set of independent, small services working in tedem, communicating with well
defined web APIs.

Microservices vs Monoliths Architecture

| Architecture | Descriptions | Pros | Cons |
| --- | --- | --- | --- |
| Monolith | Apps are lumped together as one big executable | Easy to deploy and manage | Hard to scale, highly coupled, hard to maintain |
| Microservices | Apps built via a set of independent and small microservices | Hard to deploy and manage | Easy to scale horizontally, less coupling, easier to maintain |

The main problem with microservices is the difficulty of how to correctly
deploy and manage a set of microservices on infastructure:
- microservices have constraints defining how they are to be deployed that complicates things
- where should we place each microservice on existing infastructure?
- is the environment of the infastructure properly configured for the microservice to work.

### Where does Kubernetes come in?
Kubernetes attempts to solve the difficulty of deployment and management by:
- abstracting individual infastructure into a resource pool to developers
- automating the placement of services on existing infastructure
- automating health checks and restarting the apps on app failure.
- automating the migration of apps on infastructure failure.
- automating scaling of apps to cater to demand.

> Kubernetes enables continuous delivery by streamlining the Apps deployment process
> for developers and operations: 
> - developers can deploy their apps to Kubernetes
> - operations can focus on maintaining the infastructure that the Kubernetes
> and the Apps run on.

### Containers, Images and Registry
A containers provides isolationn similar to VMs, except that containers 
share the same kernel, which reduces security but allows to be smaller in size,
and have a lower performance and memory overhead compared to VMs.
- containerized applications are applications running in containers
- images contain the data required to start the container,
- registries are the places where you store and deseminate container images

### Defining Kubernetes
Kubernetes is system that allows easy deployment and management of containerized
applications running on clustered infastructure.
- developers write descriptor files that define how the containers to be deployed:
 (ie how many copies of containers, services that the containers expose)

### Structural Overview of Kubernetes:
![Kubernetes Structure](https://learning.oreilly.com/library/view/kubernetes-in-action/9781617293726/01fig10_alt.jpg)
Structural Overview of Kubernetes:
- master node runs the kubernetes control plane  which manages the entire cluster:
    - k8s API server which other components talk to 
    - scheduler which schedules containerized apps onto work node.
    - controller manager which manages containers on nodes (ie health checks, handing node failures )
- worker nodes runs:
    - container runtime which is the thing that actually runs the container
    - kubelet manages container on the node
    - kube-proxy provides network load balances for services exposed by containerized apps running on the node.

## First Steps with Kubernetes
### Setup & Kubernetes
Methods to setup kubernetes:
- cloud provider managed kubenetes (ie GKE)
- kubeadm on premise kubernetes

### Kubernetes: Core Objects
Overview of the core objects in kubernetes:

| Object | Description |
| ---  | --- |
| Node | A worker node that kubernetes runs its pods on. |
| Deployment | A descriptor of how to deploy (ie pods, services to create) to application |
| Pod | A group of tightly coupled container(s) that should always be run together on the same node. |
| ReplicationControler | Ensures a specific no. of pods stay healthly and running, otherwise replicates pods to make it so |
| Service | Exposes the containerized application (internally through Cluster IP and externally through through Ingress,NodePort and LoadBalancer) a consistent interface. |
| Namespaces | Organise Kubenetes objects into scoped groups |

### Kubectl Intro
`kubectl` is the CLI that you use to interact with your k8s cluster
Introductory `kubectl` commands:

| Command | Description |
| --- | --- |
| `kubectl cluster-info` | to check if the is up and running and get url of kubernetes's services.|
| `kubectl get <objects>` | get information on a set of  `<objects>` (ie pods, services) or all to get everyobject. Passing `-o wide` shows additional information |
| `kubectl describe <object>` | get detailed  information on a specific `<object>` (ie specific pod or service) |
| `kubectl run <name> --image=<image>` | Run the given `<image>` as a deployment with the name `<name>` 
| `kubectl expose <name> --type=<type --name=<service_name>` | Expose the deployment with the given `<name>` by creating a service of the given `<type>` and `<name>` |
| `kubectl explain <something>` | Show the manual page for `<something>` (ie pod, service, pod.spec, etc..) |
| `kubectl create -f <spec>` | Create kubernetes objects (ie pods, services) based the given descriptor specification  file `<spec>` |
| `kubectl delete <object>` | Delete the given kubenetes object `<object>` |

### Labels
Labels are user defined tags assigned to kubernetes objects (ie pods/services)
for organisational purposes.

Conventional labels:

| Label | Description |
| --- | --- |
| `app` | The application that the belongs to |
| `rel` | Release version of the pod (ie stable, beta, canary) |

> Carnary release is a release where you only a fraction of your users get the
> the new release to prevent bad releases from hitting to many user

#### Accessing Labels
Access labels using `kubectl` as follows:

| Command | Description |
| --- | ---|
| `kubectl get <object> --show-labels` | Get short status information and all labels of `<object>` |
| `kubectl get <object> -L <labels,...>` | Get short status information and the values of specific labels `<labels,...>` of `<object>` |

#### Applying Labels
Labels can be applied via `metadata.labels` in descriptor specifications:
``` yaml
metadata:
  labels: 
    rel: beta
```

or
via kubectl:
```
kubectl label <object> <label>=<value>
```

kubectl can also be used to change existing labels with the `--overwrite` flag:
```
kubectl label <object> <label>=<value> --overwrite
```

#### Filtering by Labels
Using `kubectl get <objects> -l <selector>`, one can filter kubernetes objects by labels:

| Selector | Description |
| --- | --- |
| `<label>` | Get all objects  with the label`<label>` (value does not matter) |
| `"!<label>"` | Get all objects  without the label`<label>` (value does not matter |
| `<label>=<value>` | Get all objects  with the label`<label>` and the value `<value>` |
| `"<label>!=<value>"` | Get all objects  with the label`<label>` and the value is not equal to `<value>` |
| `"<label> in (<values>,...)"` | Get all objects  with the label`<label>` and the value is in the set of values `(<values>,...)` |
| `"<label> notin (<values>,...)"` | Get all objects  with the label`<label>` and the value is not in the set of values `(<values>,...)` |

> Multiple selectors can be combined via commas (ie `app=test,rel=prod`)

### Namespaces
Namespaces organises kubernetes objects into to logical scoped groups.
- by default  all `kubectl` commands operate on the `default` namespace.
- to use another namespace pass `--namespace <namespace>` when using `kubectl`

Create a namespace:
`kubectl create namespace <namespace>`

Delete a namespace and everything inside the namespace:
`kubectl delete namespace <namespace>`

## Pods
### Defining Pods
![Pods](https://learning.oreilly.com/library/view/kubernetes-in-action/9781617293726/02fig05_alt.jpg)
Pods are a group of coupled containers (or a single container that) should always
be run on the same work node.
- a pod represents the basic, indivisable building block in kubernetes
- each pods operates like a single self-contained machine (same hostname, network interfaces, ip address, port space)

> Why do we need pods? Each container is only designed to host one process.
> This means that with multiple process, we have multiple tightly coupled containers,
> thereby requiring pods to group them together.


### Pod Networking
All pods in a kubernetes cluster are connected on a single flat network:
![Pod Networking](https://learning.oreilly.com/library/view/kubernetes-in-action/9781617293726/03fig02_alt.jpg)

This makes inter-pod networking simple as each can be directly contacted via
a static ip without NAT

### Organising Pods
When organising your app into pods, you should split up the app into multiple
pods when possible:
- multiple pods allows kubernetes to distribute them across worker nodes, allowing for better hardware utilitisation
- multiple pods allows you to individually scale each pod

Guidelines for deciding whether containers should be grouped into a single pod or separated in multiple pods:

| Single Pod | Multiple Pods |
| --- | --- |
| Containers must be run together on a single host | Contains can run on different hosts |
| Containers represents a single, highly coupled whole | Containers represent independent components |
| Containers must be scaled together | Containers must be scaled individually |

> The rule of the thumb is to split containers into multiple pods when possible.

### Pod Descriptor
Pod Descriptors are YAML specifications that tell kubernetes how to create a pod.

Example of a pod descriptor `nginx.yaml` for a pod containing a single nginx:
```yaml
apiVersion: v1
kind: Pod
metadata: 
  name: nginx # name of the pod 
  labels: # user defined labels used to organse pods
    app: test
    rel: beta
    creation: manual
spec:
  containers:
    - name: nginx-container
      image: nginx # container image
      command: [ "/usr/bin/nginx" ] # container command aka docker entrypoint
      args: [ "-c", "-s" ]  # command line arguments aka docker cmd;
      env: # pass environment variables to the container
        - name: SECRET
          value: "30"
      ports:
        - containerPort: 80
          protocol: TCP
          name: http
```
> Unlike in docker, specifying the `containerPort` is purely declarative and has 
> no actual effect (ie does not expose ports on the container)

To tell kubernetes to create the pod, run `kubectl create -f nginx.yaml`

### Kubectl: Pod Edition

| Command | Description |
| --- | --- |
| `kubectl get pods`  | Get a short status overview of all pods |
| `kubectl get <pod> -o <output_type>` | Get detailed information about the pod `<pod>` in the filetype `<output_type>`, which can be either `json` or `yaml` |
| `kubectl logs <pod> -c <container>` | See the logs of the container `<container>` in the pod `<pod>` |
| `kubectl port-forward <pod> <host_port>:<pod_port>` | Forward port `<pod_port>` on pod `<pod>` to localhost's `<host_port>` (ie for debugging purposes) |

### Pod Scheduling with Labels
Pods can be contrained to only run on worker node with specific labels:

Example of pod that will only run on nodes labeled with `gpu=true`
```yaml
apiVersion: v1
kind: Pod
spec:
    nodeSelector:
        gpu: "true"
```

## Controllers


### Health Checks
Health Checks perdiodically probes the pods to ensure that they are running correctly.
This allows Kubernetes to determine if the pod is healthy and running correctly
or unhealthly and needs to be restarted


#### Liveness Probes 
Liveness Probes define the methodology used by Kubernetes to check the health of the pod running on a node:
- HTTP GET probe performs a HTTP GET request, expecting a 2XX or 3XX status code
- TCP Socket probe tries to open TCP connection
- Exec probe runs a command in a container and checks its status code (0 success, other failure)

> Liveness probes should be light and cheap to run.

Example HTTP GET Livenesss Probe specification:
```yaml
apiVersion: v1
kind: pod
spec:
  containers:
  - image: web-server
    name: web
    livenessProbe:              
      httpGet: # defines a HTTP get probe
        path: /                 
        port: 80
      initialDelaySeconds: 10 # waits 10s before first probe
```

If the liveness probe fails, Kubernetes will restart the pods
- use `kubectl describe` to determine if the application crashed because of application
    code or kubernetes.
- kubernetes sends `SIGKILL`(137) or `SIGTERM`(143) to kill the container.
-  Use `kubectl logs <pod> --previous` to see the logs of the killed pod.

> The liveness probe should only check the internals are working correctly, 
> not externals (ie can connect to database.) A separate liveness probe should be
> used to check external components are working correctly

### Replication Controllers
Typically, pods and started & mananged by ReplicationController which ensure that the pods 
that it manages are up and running:
- it has a template pod specification from which it can replicate pods.
-  it tries to ensure that the pods running always matches the desired no. by creating and terminating pods. 

A ReplicationController is composed of:
- label selector, which selects  the pods that the ReplicationController by their labels.
- replica count - desired no. of running  podsrecreating pods.
- pod template, which defines the pod specification used to create new pods.

Benefits of ReplicationController
- ensure that desired no. of pods stay running
- fault tolerance on node failure
- enables horizontal scaling.

Example Replication Controller specification:
```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: web-replica-controllor
spec:
  replicas: 3                      
  selector:                        
    app: web
  template: # pod template
    metadata:                      
      labels:                      
        app: web                 
    spec:                          
      containers:                  
      - name: web                
        image: nginx
        ports:                     
        - containerPort: 80
```

> The label selector `selector:` only checks for the labels specified in the
> selector when checking if the pod matches. Additional labels do cause the  pod
> to mismatch.


#### Kubectl: Replication Controller Edition

| Command | Description |
| --- | --- |
| `kubectl edit <ReplicationController>` | Edit the ReplicationController's pod template after the deploying using default editor |
| `kubectl scale <ReplicationController> --replicas=3` | Scale the ReplicationControllers's no. of desired replicas to 3 |
| `kubectl delete <ReplicationController>` | Delete ReplicationControler with  managed pods |
| `kubectl delete <ReplicationController> --cascade=false` | Delete ReplicationControler leaving managed pods untouched |

### Replica Sets
Basically ReplicationControllers with more powerful pod matching  capabilities:
```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: web-replica-set
spec:
  replicas: 3                      
  selector:                        
    matchLabels: # same way as ReplicationController
        app: web
    matchExpressions: # more expressive label selection
        - key: app
          operator: In # In, NotIn, Exists, DoesNotExists
          values:
            - web
  template: # pod template
    metadata:                      
      labels:                      
        app: web                 
    spec:                          
      containers:                  
      - name: web                
        image: nginx
        ports:                     
        - containerPort: 80
```

`operator`s that can be used when using `matchExpressions`:

| Operator | Description |
| --- | --- |
|In|Label’s value must match one of the specified values.|
|NotIn|Label’s value must not match any of the specified values.|
|Exists|Pod must include a label with the specified key (the value isn’t important). When using this operator, you shouldn’t specify the values field.|
|DoesNotExist|Pod must not include a label with the specified key. The values property must not be specified.|

### Daemon Set
Daemon Set ensures there is a replica of a specific pod on every node (ie disk health mointor)

```
apiVersion: apps/v1beta2           
kind: DaemonSet                    
metadata:
  name: ssd-monitor
spec:
  selector:
    matchLabels:
      app: ssd-monitor
  template: # pod template
    metadata:
      labels:
        app: ssd-monitor
    spec:
      nodeSelector:                
        disk: ssd                  
      containers:
      - name: main
        image: luksa/ssd-monitor
```

Each node with the label `disk:ssd` will have the `ssd-mointor` running on them created by the Daemon Set.

### Jobs
Jobs are onetime tasks that should be successful completed once.
- kubenetes ensures that the Job runs to completion, restarting the job on node failure.

```yaml
apiVersion: batch/v1         
kind: Job                    
metadata:
  name: batch-job
spec:                        
  completions: 5 # no. of times to run the job
  parallelism: 2 # no. of runs that be done in parallel
  template: # pod template 
    metadata:
      labels:                
        app: batch-job       
    spec:
      activeDeadlineSeconds: 300 # job must run in 300s
      restartPolicy: OnFailure # must be manually set
      containers:
      - name: job-container
        image: batch-job
```

#### Cron Jobs
Run jobs in the future or at specific time intervals:

```yaml
apiVersion: batch/v1beta1                  
kind: CronJob
metadata:
  name: cron-job
spec:
  schedule: "0,15,30,45 * * * *" # cron interval spec: M H d m W
  startingDeadlineSeconds: 10 # job must start 10s after schedule time.
  jobTemplate: # job template
    spec:
      template: # pod template
        metadata:                          
          labels:                          
            app: periodic-batch-job        
        spec:                              
          restartPolicy: OnFailure         
          containers:                      
          - name: main                     
            image: luksa/batch-job         
```

## Services
Services provide a constant point of access for services provided by pods. This is required as:
- pods are ephemeral and can disappear at any time
- multiple pods may serve the same service for horizontal scaling 

Example of Service Specification:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: web
spec:
  sessionAffinity: ClientIP # serve requests from an IP on the same pod
  ports:
  - name: http
    port: 80 # service listen port
    targetPort: 80 # target container port
  - name: https
    port: 443
    targetPort: 443
  selector: # selects the pods that serves this service.
    app: web
```

### Named Ports
The service can use named `targetPort`, If the Pod has named `containerPort`s:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: web
spec:
  ports:
  - name: http
    port: 80 
    targetPort: http # refers to the containerPort with the name `http`
```

### Endpoints
The service works by forwarding traffic to endpoints.
- endpoints are automatically configured when using `selector` to select pods.
- endpoints  can be customized when not using `selector`  to point to external `ip`s:

```yaml
apiVersion: v1
kind: Endpoints
metadata:
  name: external-service
subsets:
  - addresses: # external used to serve services.
    - ip: 11.11.11.11 
    - ip: 22.22.22.22
    ports:
    - port: 80
```

### Service Discovery
Pods can discover services via environment variables or DNS.

> NOTE: `ping`ing a service to check if it is working does not work.

#### Environment Variables
Pods can discover services via environment variables:
- `<SERVICE>_SERVICE_HOST` env variable holds the `ClusterIP` of the service
- `<SERVICE>_SERVICE_PORT` env variable holds the service listening port.
> Where `<SERVICE>` is a uppercase snake case version of the service name.
> (ie `web-service` becomes `WEB_SERVICE`

#### DNS
Pods can resolve the service's `ClusterIP` by resolving:
`<service>.<namespace>.svc.cluster.local`
- `<service>` is the name of the service
- `<namespace>` is the namespace that service resides in (or `default` for default namespace)

> The `svc.cluster.local` can be obmitted if in service resides in the same cluster.
> `<namespace>` can be obmitted if service resides in the same namespace.

### Accessing the Service
#### Accessing Internally
Each service can be accessed within the cluster via its `ClusterIP`
- try to access the web service from within the cluster (inside a pod):
![Internal Service Access](https://learning.oreilly.com/library/view/kubernetes-in-action/9781617293726/05fig03_alt.jpg)
```sh
kubectl exec <pod> -- curl -s http://<ClusterIP>
```
> Every after `--` is passed to the pod to be executed.

#### Accessing Externally
Ways of acceessing a service externally:
![NodePort Service Routing](https://learning.oreilly.com/library/view/kubernetes-in-action/9781617293726/05fig06_alt.jpg)
- NodePort - each node listens for the service on a specific port.
    - upon reaching the node port, the request is randomly forwarded to one of 
        the service's endpoints
```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-nodeport
spec:
  type: NodePort  # node port type service.
  ports:
  - port: 80         
    targetPort: 80 
    nodePort: 30123 # all nodes expose service at node port
  selector:
    app: web
```
> When deploying NodePort services in the cloud, remember to configure your 
> firewall rule to allow to traffic to the node port.

![Load Balancer Service](https://learning.oreilly.com/library/view/kubernetes-in-action/9781617293726/05fig07_alt.jpg)
- LoadBalancer - use external load balancer to expose service via its IP address. 
    - requests to LoadBalancer ip is load balanced over the service's endpoints
```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-loadbalancer
spec:
  type: LoadBalancer # loadbalancer type service.
  ports:
  - port: 80
    targetPort: 80
  selector:
    app: web
```
> Requires Kubernetes to be configured to use the load balancer, which is typically
> already done on cloud providers. Use `MetalLB` to deploy when kubernetes has
> yet to be configured with a load balancer (ie bare metal) 
 
![Ingress Service](https://learning.oreilly.com/library/view/kubernetes-in-action/9781617293726/05fig09_alt.jpg)
- Ingress - expose multiple HTTP services using HTTP to route service
    - Ingress routes using the hostname and route path in the HTTP url to find target service.
    - Ingress then forwards the request to the service be handled.
    - Access the ingress service by making http request to the IP address displayed
        by `kubectl get ingresses`
```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: web
spec:
  rules:
  - host: web.example.com  # match by http hostname
    http:
      paths:
      - path: /web # match by http route path
        backend:
          serviceName: web-nodeport # name of the target service to forward to
          servicePort: 80  # the port the service is listening on
```
> Target services must be of type NodePort when using cloud providers.


#### Accessing Externally Securely 
Make secure connections to Ingress services with HTTPS:
1. Create a secret with certificate, key pair:
```sh
kubectl create secret tls tls-secret --cert=tls.cert --key=tls.key
```

2. Configure the ingress to use TLS:
```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: kubia
spec:
  tls:                            
  - hosts:                        
    - kubia.example.com # hostnames to use tls.
    secretName: tls-secret # the secret with the certificate and key
  rules:
  ...
```

#### Readiness Probes
Readiness Probes probe to the pod to determine if the pod is ready to receive requests.
- if the readiness probe does not pass, the pod does not receive requests
- same types of probes available as liveness probes. See liveness probes for more info>

> Readiness probes should always be set to ensure that requests do get served
> by pods that are still starting up.

Example HTTP GET readiness probe specification:
```yaml
apiVersion: v1
kind: pod
spec:
  containers:
  - image: web-server
    name: web
    livenessProbe:              
      httpGet: # defines a HTTP get probe
        path: /                 
        port: 80
      initialDelaySeconds: 10 # waits 10s before first probe
```
:
### Headless Services
Instead of accessing pods via the service's `clusterIP` we can access the pods
directly via DNS with headless services
- allows user to collect the IP addresses of all pods behind the service.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-headless
spec:
  clusterIP: None # setting to none makes the service headless
```

## Volumes 
Volumes provide semi-persistent/persistent storage for containers running in pods.
- container filesystem is not persistent across container runs.

Volumes can be mounted in containers at specific mount points to allow the
containers to:
- read their contents (ie mount volume on `/var/htdocs` to provide HTML to serve)
- write to the volume (ie mount volume on `/var/logs` to collect logs)

Example volumes in pod specification:
- here a `emptyDir` volume is used to pass files from the `html-generator` container 
    to the `web-server` container to be served:
``` yaml
apiVersion: v1
kind: Pod
metadata:
  name: web
spec:
  containers:
  - image: generator
    name: html-generator                   
    volumeMounts:                          
    - name: html # specify by volume name which volume to mount                           
      mountPath: /var/htdocs # path to mount this volume in this container
  - image: nginx:alpine                    
    name: web-server                       
    volumeMounts:                          
    - name: html                           
      mountPath: /usr/share/nginx/html 
      readOnly: true  # mount read only
    ports:
    - containerPort: 80
      protocol: TCP
  volumes:                                 
  - name: html # name of volume
    emptyDir: {} # type (and related config) of the volume
```

### Volume Types
Volume types provided by kubernetes:
- `emptyDir` - Mounts a temporary empty directory for temporary storage
```yaml
  volumes:                                 
  - name: volume 
    emptyDir: {} 
```

- `hostPath` - Mounts the directory in the hosting in the pod
```yaml
- name: sysfs
    hostPath:
      path: /sys
```

- `nfs` - NFS share mounted as a volume 
- `gcePersistentDisk`, `awsElaasticBlockStore`, `azureDisk` - Cloud provider based storage mounted as volume 
- bunch of storage options

- `persistentVolumeClaim` - claim allocated or dynamically allocated storage.

### Persistent Volumes & Claims
Persistent Volumes & Claims attempts to abstract away the how from storage, allowing 
developers to focus on what and how much to store:
- admin/auto provisioner creates volume configuring the storage technology (the how) and size
- developers creates persistent volume claim of specific size
- Kubernetes matches claims to actual volumes.

> Persistent volumes are accessible cluster wide

#### Persistent Volume
Admins can manually provision persistent volumes via a Persistent Volume specification:
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: database-pv
spec:
  capacity:                                 
    storage: 10Gi # size of the persistent volument 
  accessModes: # volume access control
  - ReadWriteOnce # only one pod mount r/w
  - ReadOnlyMany  # multiple pods can mount read only
  persistentVolumeReclaimPolicy: Retain # what to do when a pod & claim is done with volume
  gcePersistentDisk: # storage backend
    pdName: database                         
    fsType: ext4                           
```

##### Access Control 
PersistentVolumes access controls:

| Control | Abbreviation | Description |
| --- | --- | --- |
| `ReadWriteOnce` | `RWO` | Only a single node can mount the volume for reading and writing. |
| `ReadOnlyMany` | `ROX` | Multiple nodes can mount the volume for reading. |
| `ReadWriteMany` | `RMX` | Multiple nodes can mount the volume for read and writing. |

##### Reclaim Policy
Reclaim policy defines what to do when a pod and persistentVolumeClaim is done 
with the persistent volume:

| Policy | Description |
| ---  | --- |
| `Retain` | Do nothing. The data remains in the volume and the volume is unavailable to be claimed |
| `Recycle` | Delete the data in the volume to make it available for claiming |
| `Delete` | Delete the persistent volume with its data |

> Some volumes (ie GCE Persistent Disks) do not support the `Recycle` reclaim
> policy.

#### Persistent Volume Claim
Developers claim the storage provided by PersistentVolumes using PersistentVolumeClaims:
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: database-pvc
spec:
  resources:
    requests:                    
      storage: 10Gi # specify claim storage size
  accessModes: # required access control
  - ReadWriteOnce  
  storageClassName: ""  # dyamnic provisioner to use or "" if manually create volume
```

> One PersistentVolumeClaim binds to one and only one PersistentVolume

#### Dynamic Provisioning.
Automatically provision PersistentVolume when developer's persistentVolumeClaims
when are created.
1. Define a StorageClass configuring the provisioner:
```yaml
apiVersion:
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast
provisioner: kubernetes.io/gce-pd  # provisioner bankend: GCE Persistent Disk
parameters: # parameters to pass to the provisioner.
  type: pd-ssd
  zone: europe-west1-b         
```
2. Create PersistentVolumeClaims specifying the StorageClass:
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: database-pvc
spec:
    ...
    storageClassName: fast
```

> By default, there may be a preconfigured StorageClass already ready for us
> (use `kubectl get sc` to check). To use default storage class, leave `storageClassName`
> out of the PersistentVolumeClaim specification

## ConfigMaps and Secrets
ConfigMaps and Secrets are used to configure the applications running in pods.
- ConfigMaps and Secrets help decouple the pod specification from configuration
    allowing you to use the same pod specification for different environments
    (ie development, QA and production).

> For applications with little configuration, configuring with command line
> arguments may suffice. Use `command` and `args` in the pod specification
> to configure the containers with comamdn line arguments.

### ConfigMaps
ConfigMap are key value pairs that contains the configuration that is injected
into containers at runtime as environment variables or files:

Using `kubectl` to create configmaps:
1. Create ConfigMaps with literal values using `kubectl`:
```sh
kubectl create configmap config --form-literal=username=john
```
2. Create ConfigMaps with files as values using `kubectl`:
```sh
kubectl create configmap tmux-config --form-file=tmux=tmux.conf
```

#### Using ConfigMaps as Environment Variables
To use the configuration stored in configMaps as environment variables, 
update the pod specification to reference the configMap:
- Using specific key value pairs in config maps as environment variables:
```yaml
...
 env:   
    - name: INTERVAL # name of the environment variable that will have the value
      valueFrom:
        configMapKeyRef: # reference a config map
          name: config # name of the config map to extract the value from
          key: sleep-interval # key in the config map
...
```
- Expose the entire configMap as a environment variables with a optional prefix:
```yaml
...
 envFrom: 
    - prefix: CONFIG_  # optional prefix for environment variables
      configMapRef: # reference a config map
        name: config # name of the config map obtain values from
...
```
> A key value pair in the configMap with the `interval` will be exposed as
> `CONFIG_INTERVAL` in the container under the above pod specification.

Gotchas when using ConfigMaps as environment variables:
- If the referenced config map does not exist, the pod will not start.
  Set `configMapKeyRef.optional:` to `true` to all the pod to without the config map.
- When using `envFrom` ensure that the keys in the config map are valid environment 
    variable names (ie no `-` allowed). Otherwise they would not be exposed as environment variables.

#### Using ConfigMaps as Files
ConfigMaps can also be exposed as files by being mounted as volumes:
- Expose the entire configMap as files in a volume:
```yaml
 ...
  volumeMounts:
    ...
    - name: config # name of the volume
      mountPath: /etc/nginx/conf.d # path to mount the mount the volume
      readOnly: true
    ...
  volumes:
  ...
  - name: config # name of the volume
    configMap: # reference a config map
      name: nginx-config  # name of the config map to mount the volume
  ...
```
- Expose specific files as files in a volume at a specific path at the mount point:
```yaml
 ...
  volumeMounts:
    ...
    - name: config # name of the volume
      mountPath: /etc/nginx/conf.d # path to mount the mount the volume
      readOnly: true
    ...
  volumes:
  ...
  - name: config # name of the volume
    configMap: # reference a config map
      name: nginx-config  # name of the config map to mount the volume
      item:
        - key: nginx-gzip-config # specify key to select which key to expose
          path: gzip.conf # path in mount point to place the file.
  ...
```

> When mounting volumes onto existing directories, existing files in the directory
> would be hidden to allow the mount.

To mount without overriding existing files, mount only the files that you require:
```yaml
...
spec:
  containers:
  - image: nginx
    volumeMounts:
    - name: volume # name of volume to find file to mount.
      mountPath: /etc/nginx.conf # mounted path in the container
      subPath: nginx.conf # filepath of the file in the volume to mount
...
```

> Configuration in configMap exposed as files in a volume can be changed without
> restarting the container. This is not possible with config exposed 
> environment variables or command line arguments. Updates to configuration 
> in files can take up to a minute to update.

### Secrets
Secrets store and expose sensitive information (ie access tokens, credentials) 
to containers running in pods:
- create secret using `kubectl`:
```yaml
kubectl create secret generic credentials --from-file=https.key --from-file=http.cert
```
- create secret through YAML specification:
```yaml
apiVersion: v1
kind: Secret
metadata:
    name: credentials
stringData: # secret key value pairs with string values
  password: superman
data: # secret key value pairs with base64 encoded values to store binary data
  https.cert: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCekNDQ...
  https.key: LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcE...
```

#### Using Secrets
Using secrets:
- Secrets can be mounted as volumes, each entry as a file in the volume:
```yaml
containers:
 - image: nginx:alpine
    name: web-server
    volumeMounts:
    - name: certs # name of the volume
      mountPath: /etc/nginx/certs/ # path of the volume mountpoint.
      readOnly: true
volumes:
 - name: certs # name of the volume
   secret: # reference a secret to mount as volume
     secretName: credentials # name of the secret to mount as volume
```
- specific secrets in secret can be expoesed as environment variables:
```yaml
...
    env:
    - name: HTTP_SECRET # name of environment variable
      valueFrom:  
        secretKeyRef: # reference a secret to obtain environment variables
          name: http-secret # name of secret to reference
          key: http # key to select key value pair in secret.
...
```
- all secrets in a secret exposed as environment variables:
```yaml
...
    envFrom:
      - secretRef:
        name: secret # name of secret
...
```

#### Docker Registry Authentication
To pull images from a private docker registry:
1. Create a secret with docker registry credentials:
```yaml
kubectl create secret docker-registry registry-secret  \
    --docker-username=username --docker-password=superman \  
    --docker-email=email@provider.com
```
2. Reference the registry credentials secret in the pod YAML definition:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: private-pod
spec:
  imagePullSecrets:  # use the secret to authenticate with registry
  - name: registry-secret # name of the secret
  containers:
  - image: registry/app
    name: main
```

## Deployments
Deployments facilitate deploying and updating applications in kubernetes:
- deployments manage underlying replicas to declaratively implement desired
    application state (ie images to a certain version)

Deployment specification are relatively similar to replicacontroller's:
```yaml
apiVersion: apps/v1beta1
kind: Deployment # specify that this is deployment
metadata:
  name: web # name of the deployment
spec:
  replicas: 3 # replica pods to spawn
  strategy: # deployment strategy
        type: RollingUpdate
  template: # pod template
    metadata:
      name: web
      labels:
        app: web
    spec:
      containers:
      - image: luksa/kubia:v1
        name: nodejs
```

### Deployment Strategies
Strategies to update pods serving a service:
- `Recreate` : delete existing pods first and then start the new ones:
    1. Update the ReplicationControler/ReplicaSet to manage the new pod.
    2. Delete the old pods 
    3. The ReplicationControler/ReplicaSet will replace the old pods with new ones.
- start new pods first, then delete the old ones:
    1. Create ReplicationControler/ReplicaSet to manage the new pod.
    2. The ReplicationControler/ReplicaSet will start the new pods.
- `RollingUpdate` : gradually replace old pods with a new pod one by one:
    1. Create ReplicationControler/ReplicaSet to manage the new pod.
    2. Start a new pod and terminate a old pod. Repeating until all pods are new.

> RollingUpdate strategy requires the app to handle running both old and new 
> versions at the same time.

### Kubectl: Deployment Edition

| Command | Description |
| --- | --- |
| `kubectl apply -f deployment.yml --record ` | Apply deployment YAMLs with `kubectl`.  `--record` saves the `kubectl` command in revision history. |
| `kubectl replace -f deployment.yml` | Replace existing deployment with a new one. |
| `kubectl rollout status deployment <Deployment>` | Display the status of the deployment rollout of the deployment `<Deployment>` |
| `kubectl set image deployment <Deployment> <container>=<image>` | Change the image used by container `<container>` in deployment `<Deployment>` |

### Image Pull Policy
Kubernetes by default when deciding whether to pull a image from the registry:
- `:latest` tagged images are always pulled from the registry
- custom tags (ie `:0.3.1`) images are only pulled once from the registry

> Use the `imagePullPolicy` field in the pod specification to manually configure
> when the image is pulled from the registry.

### Rolling Back Deployments
What to do when a bad deployment (ie one with buggy images) is deployed/rolled out:

| Command | Description |
| --- | --- |
| `kubectl rollout undo deployment <Deployment>` | Revert deployment to the previous version/rolled out deployment. |
| `kubectl rollout history deployment <Deployment>` | Display deployment revision history with revision no. |
| `kubectl rollout undo deployment <Deployment> --to-revision=<revision no.>` | Revert deployment to the version specified by the ` <revision no.>` |

> Revision history is limited by `revisionHistoryLimit` field in the deployment
> spec, which defaults to 2.

### Rollout Rate
Control the rate of rollout in the deployment specification:
```yaml
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 25% # no. of pod instances allowed to exist above the replica count during rollout
      maxUnavailable: 25%  # no. of instance allowed to be unavailable relative to replica count during rollout
```

Pause The rollout to create a canary release where only part of the users hit the 
new pods:
```
kubectl rollout pause deployment <Deployment>
```

### Halting Bad Deployments 
Halting Bad Deployments deployments before they the wreak havoc:
- Configure the deployment's `minReadySeconds` field to configure when to minimum
    a new pod should be ready before considered available.
- Until the new pod from a rollout is available, the rollout will be halted 
- Undo the the bad deployment rollout.
