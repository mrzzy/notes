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
	if err != nil {
		log.Fatalf("Could not connect to: %v", err)
	}
	defer conn.Close()
	client := pb.NewShippingServiceClient(conn)
	
	//.perform rpc call on service
	consignment, err := parseConsignmentJSON(consignPath)
	if err != nil {
		log.Fatalf("could not parse file: %v", err)
	}
    
	resp, err := client.CreateConsignment(context.Background(), consignment)
	if err != nil {
		log.Fatalf("Could not create consignment: %v", err)
	}
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

