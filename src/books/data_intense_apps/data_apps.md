# Data Intensive Apps
References [Designing Data-Intensive Applications](https://www.oreilly.com/library/view/designing-data-intensive-applications/9781491903063/) book.

## Intro
Applications today have to scale to increasing larger volumes of data (aka data-intensive):
- databases - storing data for later use
- cache  - cache responses to speed up reads
- indexes - speed up search operations
- stream processing - asynchronous message queuing/processing
- batch processing - periodically process data in batches

> Data rather than CPU is the limiting factor for these apps

Data Apps typically have to hook up multiple suitable data systems
- different data systems (ie database/messsage queue) have different performance traits

### Major Concerns
Major Concerns when developing data intensive apps:
- reliability - app still works after hardware or software faults
- scalabiliy - app can handle growing data volumes/complexity
- maintainability - app is easy to work with

### Reliablity
Reliablity - continuing to work correctly even when things go wrong (faults)
- fault-tolerant - app able to withstand some faults
- purposefully triggering faults can be a good way to test faults

> Fault differs from failure as it only affects one component of the app
> while failure happens when the app stops providing services completely

Types of Faults:
| Fault | Description | Example | Solutions |
| --- | --- | --- | --- |
| Hardware Fault | Faults in infastructure hosting the app. | AWS EC2 going down,, hard disk failure. | Software/Hardware Redunancy |
| Software Fault | Faults in app code. More serious as fault might happen at the same time to multiple instances of the app | Leap Second Bugs, Zombie processes, Cascading failures | Clarifying assumptions, testing, crash and restart loops, analyze behavour in production |
| Human Error | Fault due to human actions. | Accidentally wiping Production DB, leaking credentials in source code. etc. Introducing bugs. | Through testing. Make it easy to do the right thing. Recovery from human errors.  Monitoring: performance metrics/error rates. |

### Scability
Scability - ensuring the app works reliability even under increased load

Making apps scalable:
- define load
- measure performance
- cope with load

#### Defining Load
Load Parameter - defining Load on app is application specific:
- requests handled per second
- ratio of read to writes on db
- hit rate on cache


Example case study: Twitter  

Main Features:
- post tweet: 4.6k requests/sec on average 12k requests/sec peak.
- home timeline: 300k requests/se

Approaches:
1. Post tweet insert in SQL DB. Retrieve for feed  use join query.
![Twitter - Approach 1](./assets/intro_scability_case_study_twitter_approach1.png)

- does not scale to home timeline load (300k reqs/sec)

2. Maintain Cache each user's home timeline. When user posts tweet push
    tweet to timeline caches

![Twitter - Approach 2](./assets/intro_scability_case_study_twitter_approach2.png)

- extra work done to to push push new tweet into caches especially if many followers

Solution: Hybrid of  graph to keep track of what affects other &amp; 2: Approach 2 except for those with many followers, then approach 

#### Measuring Performance
Measure Performance of system as load increases
- how performance varies as load parameter increases given hardware resources constant
- how much hardware resources has to be added to maintain performance as load increases

Metrics for measuring performance - also application specific
- hadoop - batch job througphput
- latency/response time - of REST API get requests

> Latency is the waiting time the request waits before handling request
> While repsonse time is the total time that the client waits for the request to be handled

Take multiple measurements to measure performance:
- certain random variables can affect response time (ie packet loss, gc collection, page fault). 
- use statistics (ie median, mean, 95 &amp; 99 percentile.) to get an estimate of performance.
- client side performance measurements are especially important and useful
- 95 &amp; 99 percentile performance is especially important as they show
     worst case performance, especially as the user is large customer.

> Artifical load should be sent concurrently to accurately simulate load.

#### Coping with Load
Approaches for Coping with Load:

| Approach | Description | Pros | Cons |
| --- | --- | --- | --- |
| Scale up (Vertical Scaling) | Host app on machine with more resources | Easier to implement app | Expensive to buy high end machines | 
| Scale out (Horizontal Scaling) | Distribute load accross multiple machines | Easier to scale | Hard to implement app |
| Manually | Manually mointor performance and scale | Predictable |  Human reaction time, work expanded to manually evaluate &amp; scale | 
| Elastic | Autoscaling to automatically cater to increased load. | Scales to unpredictable workloads | Resources consumed can be unpredictable. |

- Good Architectures combine by scaling up and scaling out.
- ensure that scaling descisions are made on actual performance data to
    prevent wasted work on  making applications scale.

> Rule of Thumb: Redesign architecture every order of magnitiude increasef
> in load ()

### Maintainablity
Ensure maintainability to reduce pain of maintaince &amp; avoid costly rewrites:
- operability - make easy to operate the software
    - add healthchecks to verify app health
    - logs to track down problems in app
    - easy to update apps with patches
    - encapsulate dependencies to ensure portablity
    - support automation and intergration with standard tools
- simplicity - make easy for new engineers to  understand the system.
    - abstract away the complex stuff. (performance hacks)
    - consistent naming practices
- evolvabiliy - make it easy to make changes in the system
    - agile software development life cycle
    - test driven development/refactoring
    - making changes to simplier systems are easier
