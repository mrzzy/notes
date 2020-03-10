# Go Microservices
References [this tutorial](https://ewanvalentine.io/microservices-in-golang-part-1/) 
by Ewan Valantine.
Protobuf [Offical Documentation](https://developers.google.com/protocol-buffers/docs/proto)

## Intro
Running example project for this tutorial: Shipping container managment platform
- building microservices: consignments, users, authentication, vessels
- using: golang, mongodb, grpc, docker, Google Cloud, K8s, NATS, CircleCI, terraform

### Microservices
Microservices seperate applications into individual runnable services 
- traditional Applications are written as monolith applications 
    - sometimes segregates code by purpose
- services seperated by purpose.

Reasons to use Microservices
- complexity reduction by splitting code in small manageable tasks
- scalbility - microservices allow more graunlar horizontal scaling by service

### Go
Why Golang 
- light, weight fast
- powerful standard lib
- ecosystem: go-micro library for building microservices

### Protobuf/gRPC
Protobuf/gRPC provide the communication bridge between microservices
- protobuf is more effcient JSON or XML as a medium for communication via transmitting data with binary instead of strings
- gRPC provides remote process calls via protobuf, uses HTTP/2.0 underneath with support binaries
- developer friendly text file to define Protobuf/gRPC services:
```protobuf
// grpc service definition
service HelloService {
  rpc SayHello (HelloRequest) returns (HelloResponse);
}

// composite types used to pack data
message HelloRequest {
  // [field rule ] type field = field no.
  optional string greeting = 1;
}
message HelloResponse {
  // repeated - zero or more times
  repeated string reply = 1;
}
```
- `protoc` tool to generate language bindings to interact with the protobuf

> Effcient communication between microservices is important to ensure the application 
> is performant. This is not a problem with monolith architecture as each package
> of code would just call other code directly.

## Practical
Exact Source code can be found at the [github repo](https://github.com/EwanValentine/shippy)


### Tutorial 1: Consignment Service
#### Microservice
Create the Consignment Microservices

1. Define the Consignment service data format with protobuf `consignment.proto`
```protobuf
syntax = "proto3";

package consignment; 

// define shipping grpc service
service ShippingService {
  rpc CreateConsignment(Consignment) returns (Response) {}
}

// define composite types use in service definition
message Consignment { ...  }
message Container { ...  }
message Response { ...  }
```

2. Use `protoc` to generate golang language bindings with protobuf data format:
    - generates `consignment.pb.go`  used to interact with protobuf 

```sh
protoc -I. --go_out=plugins=grpc:.  proto/consignment/consignment.proto
```

3. Define servicemicroservice server  in `main.go`
- implement the service methods (ie `CreateConsignment`)

```go
func (s *service) CreateConsignment(ctx context.Context, req *pb.Consignment) (*pb.Response, error) {
    // ... process request & return response
}
```

- setup GRPC microservice to run microservices

```go
func main() {

	// Set-up our gRPC server.
	lis, err := net.Listen("tcp", port)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	s := grpc.NewServer()

	// Register our service with the gRPC server, this will tie our
	// implementation into the auto-generated interface code for our
	// protobuf definition.
	pb.RegisterShippingServiceServer(s, &service{repo})

	// Register reflection service on gRPC server.
	reflection.Register(s)

	log.Println("Running on port:", port)
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
```

#### CLI
Consignment CLI is used the interact with the Consignment Microservice
- make RPC call on microservice to create consignment
1. Pull protobuf language bindings with `go get <consignment-service>@master`

2. Write CLI to create consignment
```go
func main() {
    // ...
	// connect to server
	conn, err := grpc.Dial(address, grpc.WithInsecure())
    // ...
	defer conn.Close()
	client := pb.NewShippingServiceClient(conn)
	
	//.perform rpc call on service
	consignment, err := parseConsignmentJSON(consignPath)
    // ...

	resp, err := client.CreateConsignment(context.Background(), consignment)
    // ...
	log.Printf("Created: %t", resp.Created)
}
```

#### Updating Services
Making changes to the consignment service
- example: adding a `GetConsignments()` service method

1. Update protobuf definition to add service method:
```protobuf
/* services */
service ShippingService {
  rpc CreateConsignment(Consignment) returns (Response) {}
  rpc GetConsignments(GetRequest) returns (Response) {}
}
```

2. Update language bindings with `protoc`

```sh
protoc -I. --go_out=plugins=grpc:.  proto/consignment/consignment.proto
```

3. Implement new `GetConsignments()` method in `consignment-service/main.go`

4. Pull protobuf language bindings to CLI with `go get <consignment-service>@master`

5. Call `GetConsignments()` in CLI in `consignment-cli/main.go`


### Tutorial 2: Docker & Go-Micro
#### Containers (Docker)
Containers are used to faciliate the deployment of microservices
- containers help encapsulate microservices dependencies making deployment easy
- containers can be easily replicated for horizontal scaling 

> containers are also significantly more lightweight as compared to VMs
> as they do not contain OS kernel and other low level components

1. Define containers using a `Dockerfile`:
```Dockerfile
FROM golang:alpine AS build

# install required packages
RUN apk update && apk upgrade && \
    apk add --no-cache git

RUN mkdir /app
WORKDIR /app

# enable go modules
ENV GO111MODULE=on

# copy source code
COPY . .
# download dependencies
RUN go mod download
# build for linux
RUN GOOS=linux go build -a -o consignment-service

# production container
FROM alpine:latest AS production

RUN apk --no-cache add ca-certificates

RUN mkdir /app
WORKDIR /app
# copy executable from build stage
COPY --from=build /app/shippy-service-consignment .

CMD ["./shippy-service-consignment"]
```

2. Build docker container with `docker` CLI

```sh
docker build -t mrzzy/gomicro-consignment-service  .
```

3. Run containers `docker`, port forward 50051 to 50051

```sh
docker run -p $(PORT):50051 -it $(IMAGE) 
```

### Go Micro
Go Micro is a library that makes building microservices easier
- abstracts way the boilerplate code require to setup the microservices
- includes service discovery we dont have to hardcode IP addresses
    - each service registers itself with the service catalogue

1. Regenerate language bindings using `gomicro` plugin:
```sh
go get -u github.com/micro/protobuf/{proto,protoc-gen-go}
protoc --proto_path=. --micro_out=. --go_out=. proto/consignment/consignment.proto
```

#### Microservice
Update the microservice to use `go-micro`:
- set listen port of microservice with `MICRO_SERVER_ADDRESS` env var

1. Update consignment-service to use go-micro
```go
/* ... */
// update service method signatures
func (s *service) CreateConsignment(ctx context.Context, consignment *pb.Consignment, resp *pb.Response) error f
{ /* ... */ }
func (s *service) GetConsignments(ctx context.Context, request *pb.GetRequest, resp *pb.Response) error 
{ /* ... */ }


func main() {
	repo := &Repository{}
	
	// create new microservice
	name := "consignment.service"
	microservice:= micro.NewService(
		micro.Name(name),
	)
	
	// parse args
	microservice.Init()
	
	// register microservice handler
	pb.RegisterShippingServiceHandler(microservice.Server(), &service{repo})
	
	// run server
	err := microservice.Run()
	if err != nil {
		fmt.Printf("Could not run %s microservice: %v\n", name, err)
	}
}

```

#### CLI
2. Update consignment-cli to use go-micro
```go
func main() {
    // .....
    // connect to server
	service := micro.NewService(micro.Name("consignment.cli"))
	service.Init()

	client := pb.NewShippingService("consignment", service.Client())
    // ....
}
```

> `go-micro` uses `mdns` for service discovery, which requires
> the CLI and service to be on the same network for discovery to
> work. Use `docker run --network=host` to run the consignment-service
> on the host network.

### New Service: Vessel
Create new Vessel microservice to manage vessels:

1. Follow setup steps to setup `go-micro` vessel-service
```protobuf
service VesselService {
  rpc FindAvailable(Specification) returns (Response) {}
}
```

2. Configure consignment-service to query vessel-service for vessel for consignment
