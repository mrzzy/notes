# Reinforcement Learning
Notes heavily derived from [Deep Lizards RL series](https://deeplizard.com/learn/playlist/PLZbbT5o_s2xoWNVdDudn51XM8lOuZ_Njv)
and this [Medium Article](https://towardsdatascience.com/introduction-to-reinforcement-learning-markov-decision-process-44c533ebf8da)

## Introduction to Reinforcement Learning
Reinforcement Learning (RL) is an area of ML that focuses on training an agent 
to take certain actions in a given environment in a way maximises returns.


Intesting Applications of RL:
- AlphaGo - AI Go player that was trained to play the complex game of go.
- OpenAI Five - OpenAI developed five bots to play the game of Dota.

### Terms & Defintion
Terms & Definitions:

| Term | Definition |
| --- | --- |
| Environment | An environment with different actions/rewards in which the agent will interact in. Does not change |
| Agent | The entity that RL attempts to train to make actions that maxmimise rewards |
| State | A specific state of that the environment is in based on the actions of the agent. Changes as the agent makes actions. |
| Reward | Numerical values that the agent recieves upon preforming an action in the environment |
| Return | Culmulative reward attained by the agent making actions in envrionment |

#### Notational Definitions
Notational definitions:

| Symbol | Meaning |
| ---- | ---- |
| $S_t$ | State of the envrionment at timestep $t$ |
| $S_{t+1}$ | Future state of the envrionment at timestep $t+1$ |
| $P$ | A states transition model/function that describes how state changes over time.  |
| $R_t$ | A set of coresponding rewards for each state $s \in S_t$ |
| $G_t$ | Returns: Total reward at accumulated or discounted reward accumulated |

### RL Process
![Reinforcement Learning Diagram](./assets/reinforcement_learning_diagram.png)
Formally, RL attempts to train the agent to make action $A_t$, given environment
state $S_t$ and reward $R_t$, such that it will maxmimise return $G_t$

RL Process:
- the agent observes the current state $S_t$ and selects action $A_t$
- the envrionment transitions to new state $S_{t+1}$ and gives reward $R_{t+1}$
- repeat for the next the timestep $t+1$



### Episodic & Continuous Tasks
Episodic RL Tasks 
- tasks that have a defined start and end aka episode (ie a racing game)
- each episode is independent of other episodes

Continuous RL Tasks
- tasks that have no defined end (ie practice & be as good as possible at racing game)

### Returns & Discounted Return
Return $G_t$ is the expected final returns that an agent attains over all timesteps
$$
G_t = \sum_{i=t+1}^{T} R_i
$$

> Use plain returns for episodic tasks

---
Discounted Returns $G_t$ is basically expected returns argumented with discount factor 
$\gamma, \gamma \lt 1$:
- exponentially reduces the weight of future rewards.
- use for continous RL tasks

$$
G_t = \sum_{i=t+1}^{T} \gamma^{i-t-1} R_i
$$

The discount factor $\gamma$ ensures that continuing task 
(tasks with no clearly defined end time $T=\infty$) 
do not have $\infty$ expected reward, and converges to a finite value:

Given that rewards $R_t$ are equal to $1$ and $\gamma \lt 1$  
then $G_t = \sum_{k=0}^\infty$ converges to $\frac{1}{1 - y}$


Discounted Returns $G_t$ can also be presented as recurrence equation:
$$
G_t = R_{t+1} + \gamma G_{t+1}
$$

> Use discounted returns for continous tasks

### Policies & Values
Policies $\pi(a|s)$ defines how the agent acts by returning the probability
of taking action $a$ given state $s$:
- the "agent follows the policy", selecting the action based on the 
    probabilities given by the policy
- value functions are functins

---


## Markov Theory
### Markov Property
Markov property states that future states are independent of past states
given the present state which captures all relevant infomation in history.

The present state $S_t$ only captures all relevant infomation in history when
the following holds:
$$
P(S_{s+1} | S_t) = P(S_{s+1} | S_1, ..., S_t)
$$

When the previous property holds, then it follows that the probablity of
transitioning to future state $s'$ given current state $s$ is defined as:
$$
P_{s,s'} = P(S_{t+1} = s' | S_t = s )
$$

When the the probablity of all possible current state transition are collected
together, that is know the state's transition function/model ($P$), which
describes how state transitions over time.

$$
P = \begin{bmatrix}
P_{s_1, s'_1} & P_{s_1, s'_2} & ... & P_{s_1, s'_n}  \\
P_{s_2, s'_1} & P_{s_2, s'_2} & ... & P_{s_2, s'_n}  \\
... & ... & ... & ... \\
P_{s_n, s'_1} & P_{s_n, s'_2} & ... & P_{s_n, s'_n}  \\
\end{bmatrix}
$$

### Markov Processes
![Markov Processes](./assets/markov_process.png)
> A diagram representing a two-state Markov process. Each number represents the 
> probability of the Markov process transitioning from one state to another state.

Markov Processes/Chains are a bunch of states $s_1, s_2, ... s_n$ with the 
markov property:
- each state $s_i$ may be mapped to another state $s_j$ with a probability $P_{i,j}$
- $P_{i,j}$ defines the probability of the process transitioning to another state $P_j$
  given that $P_i$ be the current state.

### Markov Reward Processses

