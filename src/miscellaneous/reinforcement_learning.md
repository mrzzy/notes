# Reinforcement Learning
Notes heavily derived from [Deep Lizards RL series](https://deeplizard.com/learn/playlist/PLZbbT5o_s2xoWNVdDudn51XM8lOuZ_Njv)

## Reinforcement Learning
Reinforcement Learning (RL) is an area of ML that focuses on training an agent 
to take certain actions in a given environment in a way maximises rewards.

In the context of a playing a game:
- game world is environment
- the scored attained by playing the game is the reward
- the player of the game is agent.
- the moves that player can make in the game is reward.

Intesting Applications of RL:
- AlphaGo - AI Go player that was trained to play the complex game of go.
- OpenAI Five - OpenAI developed five bots to play the game of Dota.

Notational definitions:
| Symbol | Meaning |
| ---- | ---- |
| $S_t$ | A set of all possible current states at timestep $t$ |
| $S_{t+1}$ | A set of all possible future states at timestep $t+1$ 
| $s$ | One possible state at current timestep $t$  ($s \in S_t$) |
| $s'$ | One possible future state at future timestep $t+1$ ($s' \in S_{t+1}$) |
| $P$ | A states transition model/function that describes how state changes over time.  |
| $R_t$ | A set of coresponding rewards for each state $s \in S_t$ |


## Markov Decision Processes
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
> probability of the Markov process changing from one state to another state.

Markov Processes/Chains are a bunch of states $s_1, s_2, ... s_n$ with the 
markov property. 
- It represented as a set of tuples ($S$, $P_t$).

### Rewards & Returns
Markov Reward Processes are Markov Processes with a reward $r \in R_t$ attached 
to each state $s \in S_t$:
- when the agent gets to state $s$ it attains the reward $r$
- It represented as a set of tuples ($S_t$, $P$, $R_t$, $\gamma$)

$R_s$ is a reward function that describes which reward the state is expected to get 
given the current state $s$:
$$
R_s = E(Rt+1 | S_t = S)
$$

Expected Return $G_t$ the total expected future rewards to accumulated 
from current timestep $t$ to final timestep $T$
$$
G_t = \sum_{i=t+1}^{T} R_i
$$

#### Discounted Return
Discounted Returns $G_t$ is basically expected returns argumented with discount factor 
$\gamma, \gamma \lt 1$:
- exponentially reduces the weight of future rewards.

$$
G_t = \sum_{i=t+1}^{T} \gamma^{i-t-1} R_i
$$

The discount factor $\gamma$ ensures that continuing task 
(tasks with no clearly defined end time $T=\infty$) 
do not have $\infty$ expected reward, and converges to a finite value:

Given that rewards $R_t$ are equal to $1$ and $\gamma \lt 1$  
then $G_t = \sum_{k=0}^\infty$ converges to $\frac{1}{1 - y}$


> Discounted Returns $G_t$ can also be presented as recurrence equation:
> $$
> G_t = R_{t+1} + \gamma G_{t+1}
> $$

### Policies
Policies $\pi(s, a)$ defines how the agent acts by returning the probability
of taking action $a$ given state $s$.

The aim of renforcement learning is to find the optimal policy that maxmises
return $G_t$

### Value Functions
Value Functions find the value of a given state $s$

### Belman Equation
TODO: i dont  understand 
Belman Equation.
