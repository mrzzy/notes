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
| <img src="./assets/9f8bba50b95de09625626ddafa0698eb.svg?sanitize=true&invert_in_darkmode" align=middle width=15.045855000000003pt height=22.46574pt/> | State of the envrionment at timestep <img src="./assets/4f4f4e395762a3af4575de74c019ebb5.svg?sanitize=true&invert_in_darkmode" align=middle width=5.936155500000004pt height=20.222069999999988pt/> |
| <img src="./assets/cf83185198a68ea312b2d4387b1af3fe.svg?sanitize=true&invert_in_darkmode" align=middle width=31.689735000000002pt height=22.46574pt/> | Future state of the envrionment at timestep <img src="./assets/628783099380408a32610228991619a8.svg?sanitize=true&invert_in_darkmode" align=middle width=34.246575pt height=21.18732pt/> |
| <img src="./assets/df5a289587a2f0247a5b97c1e8ac58ca.svg?sanitize=true&invert_in_darkmode" align=middle width=12.836835000000004pt height=22.46574pt/> | A states transition model/function that describes how state changes over time.  |
| <img src="./assets/7f8a20dacaccab775d1e690bcf0f49e1.svg?sanitize=true&invert_in_darkmode" align=middle width=17.447265000000005pt height=22.46574pt/> | A set of coresponding rewards for each state <img src="./assets/1269099b3b71dc7a918e5c7e0f37fc28.svg?sanitize=true&invert_in_darkmode" align=middle width=42.842415pt height=22.46574pt/> |
| <img src="./assets/ab4745a27f0ed02fe9e696bcff9d032c.svg?sanitize=true&invert_in_darkmode" align=middle width=17.890455000000003pt height=22.46574pt/> | Returns: Total reward at accumulated or discounted reward accumulated |

### RL Process
![Reinforcement Learning Diagram](./assets/reinforcement_learning_diagram.png)
Formally, RL attempts to train the agent to make action <img src="./assets/df02e7666c632d22547b9c75b98c49bf.svg?sanitize=true&invert_in_darkmode" align=middle width=17.29464pt height=22.46574pt/>, given environment
state <img src="./assets/9f8bba50b95de09625626ddafa0698eb.svg?sanitize=true&invert_in_darkmode" align=middle width=15.045855000000003pt height=22.46574pt/> and reward <img src="./assets/7f8a20dacaccab775d1e690bcf0f49e1.svg?sanitize=true&invert_in_darkmode" align=middle width=17.447265000000005pt height=22.46574pt/>, such that it will maxmimise return <img src="./assets/ab4745a27f0ed02fe9e696bcff9d032c.svg?sanitize=true&invert_in_darkmode" align=middle width=17.890455000000003pt height=22.46574pt/>

RL Process:
- the agent observes the current state <img src="./assets/9f8bba50b95de09625626ddafa0698eb.svg?sanitize=true&invert_in_darkmode" align=middle width=15.045855000000003pt height=22.46574pt/> and selects action <img src="./assets/df02e7666c632d22547b9c75b98c49bf.svg?sanitize=true&invert_in_darkmode" align=middle width=17.29464pt height=22.46574pt/>
- the envrionment transitions to new state <img src="./assets/cf83185198a68ea312b2d4387b1af3fe.svg?sanitize=true&invert_in_darkmode" align=middle width=31.689735000000002pt height=22.46574pt/> and gives reward <img src="./assets/464207bf81effbe38d5a981f0168b2d2.svg?sanitize=true&invert_in_darkmode" align=middle width=34.09131000000001pt height=22.46574pt/>
- repeat for the next the timestep <img src="./assets/628783099380408a32610228991619a8.svg?sanitize=true&invert_in_darkmode" align=middle width=34.246575pt height=21.18732pt/>



### Episodic & Continuous Tasks
Episodic RL Tasks 
- tasks that have a defined start and end aka episode (ie a racing game)
- each episode is independent of other episodes

Continuous RL Tasks
- tasks that have no defined end (ie practice & be as good as possible at racing game)

### Returns & Discounted Return
Return <img src="./assets/ab4745a27f0ed02fe9e696bcff9d032c.svg?sanitize=true&invert_in_darkmode" align=middle width=17.890455000000003pt height=22.46574pt/> is the expected final returns that an agent attains over all timesteps
<p align="center"><img src="./assets/3881041d46658ee877d43b9f3f828e98.svg?sanitize=true&invert_in_darkmode" align=middle width=96.85384499999999pt height=49.17594pt/></p>

> Use plain returns for episodic tasks

---
Discounted Returns <img src="./assets/ab4745a27f0ed02fe9e696bcff9d032c.svg?sanitize=true&invert_in_darkmode" align=middle width=17.890455000000003pt height=22.46574pt/> is basically expected returns argumented with discount factor 
<img src="./assets/088df7963678b03ab83132e4c150cdfb.svg?sanitize=true&invert_in_darkmode" align=middle width=34.372800000000005pt height=21.18732pt/>:
- exponentially reduces the weight of future rewards.
- use for continous RL tasks

<p align="center"><img src="./assets/7ca7bb811b53c89af5e4c1585709ed2d.svg?sanitize=true&invert_in_darkmode" align=middle width=143.81697pt height=49.17594pt/></p>


> Given that rewards <img src="./assets/7f8a20dacaccab775d1e690bcf0f49e1.svg?sanitize=true&invert_in_darkmode" align=middle width=17.447265000000005pt height=22.46574pt/> are equal to <img src="./assets/034d0a6be0424bffe9a6e7ac9236c0f5.svg?sanitize=true&invert_in_darkmode" align=middle width=8.219277000000005pt height=21.18732pt/> and <img src="./assets/0c0cc3864396c4ab5975f7c03d5c3514.svg?sanitize=true&invert_in_darkmode" align=middle width=17.643120000000003pt height=21.18732pt/>  
> then <img src="./assets/78bbe2299c82acff9e63de62b3f3398a.svg?sanitize=true&invert_in_darkmode" align=middle width=81.891645pt height=26.438939999999977pt/> converges to <img src="./assets/492e9fd34340e45c0af837eeb23a3efb.svg?sanitize=true&invert_in_darkmode" align=middle width=23.906190000000002pt height=27.775769999999994pt/>  
> The discount factor <img src="./assets/11c596de17c342edeed29f489aa4b274.svg?sanitize=true&invert_in_darkmode" align=middle width=9.423975000000004pt height=14.155350000000013pt/> ensures that continuing task 
> (tasks with no clearly defined end time <img src="./assets/f7eea52b8ea6e40b6e98d6d777d7979c.svg?sanitize=true&invert_in_darkmode" align=middle width=50.245470000000005pt height=22.46574pt/>) 
> do not have <img src="./assets/f7a0f24dc1f54ce82fecccbbf48fca93.svg?sanitize=true&invert_in_darkmode" align=middle width=16.438455000000005pt height=14.155350000000013pt/> expected reward, and converges to a finite value

Discounted Returns <img src="./assets/ab4745a27f0ed02fe9e696bcff9d032c.svg?sanitize=true&invert_in_darkmode" align=middle width=17.890455000000003pt height=22.46574pt/> can also be presented as recurrence equation:
<p align="center"><img src="./assets/b034a3fd07c404b39d21975c8207a561.svg?sanitize=true&invert_in_darkmode" align=middle width=139.592475pt height=15.0684765pt/></p>

> Use discounted returns for continous tasks

### Policies
Policies <img src="./assets/a5f75f5c24cae21447686b47e4f99d38.svg?sanitize=true&invert_in_darkmode" align=middle width=43.70652pt height=24.65759999999998pt/> defines how the agent acts by returning the probability
of taking action <img src="./assets/44bc9d542a92714cac84e01cbbb7fd61.svg?sanitize=true&invert_in_darkmode" align=middle width=8.689230000000004pt height=14.155350000000013pt/> given state <img src="./assets/6f9bad7347b91ceebebd3ad7e6f6f2d1.svg?sanitize=true&invert_in_darkmode" align=middle width=7.705549500000004pt height=14.155350000000013pt/>:
- the "agent follows the policy", selecting the action based on the 
    probabilities given by the policy

### Value Functions 
Value functions estimate how much return can be expected for the given state <img src="./assets/6f9bad7347b91ceebebd3ad7e6f6f2d1.svg?sanitize=true&invert_in_darkmode" align=middle width=7.705549500000004pt height=14.155350000000013pt/>
or state-action pair <img src="./assets/6f9bad7347b91ceebebd3ad7e6f6f2d1.svg?sanitize=true&invert_in_darkmode" align=middle width=7.705549500000004pt height=14.155350000000013pt/>, <img src="./assets/44bc9d542a92714cac84e01cbbb7fd61.svg?sanitize=true&invert_in_darkmode" align=middle width=8.689230000000004pt height=14.155350000000013pt/>; following policy <img src="./assets/f30fdded685c83b0e7b446aa9c9aa120.svg?sanitize=true&invert_in_darkmode" align=middle width=9.960225000000003pt height=14.155350000000013pt/> thereafter:
> the more the expected return, the more valuable the position

Types of Value Functions:

| Value Function | Description | Formula |
| --- | --- | --- | 
| State-Value Function | State-Value function <img src="./assets/85aed0b0f7b723a72042b5a7378030bf.svg?sanitize=true&invert_in_darkmode" align=middle width=37.380915pt height=24.65759999999998pt/> estimate return <img src="./assets/ab4745a27f0ed02fe9e696bcff9d032c.svg?sanitize=true&invert_in_darkmode" align=middle width=17.890455000000003pt height=22.46574pt/> starting in given state <img src="./assets/6f9bad7347b91ceebebd3ad7e6f6f2d1.svg?sanitize=true&invert_in_darkmode" align=middle width=7.705549500000004pt height=14.155350000000013pt/>, following policy <img src="./assets/f30fdded685c83b0e7b446aa9c9aa120.svg?sanitize=true&invert_in_darkmode" align=middle width=9.960225000000003pt height=14.155350000000013pt/> thereafter | <img src="./assets/771370e527f368ceff8bf14896650845.svg?sanitize=true&invert_in_darkmode" align=middle width=165.562155pt height=24.65759999999998pt/> |
| Q-Value Action-Value function | Action-Value function  <img src="./assets/f4fd307c043a8d1ae7d10dec8715ec8f.svg?sanitize=true&invert_in_darkmode" align=middle width=52.746210000000005pt height=24.65759999999998pt/> estimates return <img src="./assets/ab4745a27f0ed02fe9e696bcff9d032c.svg?sanitize=true&invert_in_darkmode" align=middle width=17.890455000000003pt height=22.46574pt/> starting state <img src="./assets/6f9bad7347b91ceebebd3ad7e6f6f2d1.svg?sanitize=true&invert_in_darkmode" align=middle width=7.705549500000004pt height=14.155350000000013pt/> & taking action <img src="./assets/44bc9d542a92714cac84e01cbbb7fd61.svg?sanitize=true&invert_in_darkmode" align=middle width=8.689230000000004pt height=14.155350000000013pt/>, following policy <img src="./assets/f30fdded685c83b0e7b446aa9c9aa120.svg?sanitize=true&invert_in_darkmode" align=middle width=9.960225000000003pt height=14.155350000000013pt/> thereafter | <img src="./assets/83ac36d20ca2a9df76fb4c65aec87510.svg?sanitize=true&invert_in_darkmode" align=middle width=236.957655pt height=24.65759999999998pt/> |

> Action-Values for state-action pairs are also known as Q-Values (Q as in Quality)

## Training RL Algorithms
The goal of RL is to find a optimal policy such that the agent following this 
policy would yield the highest return

A policy <img src="./assets/f30fdded685c83b0e7b446aa9c9aa120.svg?sanitize=true&invert_in_darkmode" align=middle width=9.960225000000003pt height=14.155350000000013pt/> is considered better/equal to another policy <img src="./assets/e1c4ca96d10da0d56ad235b3b5fe363e.svg?sanitize=true&invert_in_darkmode" align=middle width=13.750110000000005pt height=24.716340000000006pt/> when its
expected return is greater or equal then the another policy's expected return,
for all states <img src="./assets/6f9bad7347b91ceebebd3ad7e6f6f2d1.svg?sanitize=true&invert_in_darkmode" align=middle width=7.705549500000004pt height=14.155350000000013pt/>:
<p align="center"><img src="./assets/1012abc756f221945e1fb824a8c83224.svg?sanitize=true&invert_in_darkmode" align=middle width=243.93269999999998pt height=17.289525pt/></p>

### Optimal Policy/Value Functions
Optimal policy <img src="./assets/8923627cee5b833cddaad7685aa3d696.svg?sanitize=true&invert_in_darkmode" align=middle width=16.105650000000004pt height=14.155350000000013pt/> is the best possible policy <img src="./assets/0ca38a08c3a4390f67355fae79d1bc8e.svg?sanitize=true&invert_in_darkmode" align=middle width=77.53878pt height=14.155350000000013pt/>, which
would yield the highest return

- optimal state-value value function <img src="./assets/62555e11fd1268ce81658e8d04041225.svg?sanitize=true&invert_in_darkmode" align=middle width=14.703315000000003pt height=14.155350000000013pt/> of optimal policy <img src="./assets/8923627cee5b833cddaad7685aa3d696.svg?sanitize=true&invert_in_darkmode" align=middle width=16.105650000000004pt height=14.155350000000013pt/> gives
    the highest expected possible return for a given state $s$

<p align="center"><img src="./assets/49d6f9872fc267a91c4d404e608944d3.svg?sanitize=true&invert_in_darkmode" align=middle width=128.64786pt height=22.19184pt/></p>

- optimal Q-Value/action-value function <img src="./assets/11cf084e7fd83c09088280b2d91d5497.svg?sanitize=true&invert_in_darkmode" align=middle width=14.073510000000004pt height=14.155350000000013pt/> of optimal policy <img src="./assets/8923627cee5b833cddaad7685aa3d696.svg?sanitize=true&invert_in_darkmode" align=middle width=16.105650000000004pt height=14.155350000000013pt/> given the
    the highest possible expected return/Q-Value for taking action $a$ in given state $s$

<p align="center"><img src="./assets/ac2b46c7252ba426191d68ebb7dc3eb6.svg?sanitize=true&invert_in_darkmode" align=middle width=159.37845pt height=22.19184pt/></p>

### Bellman Equation/Optimality
Bellman Equation/Optimality states that Q-value/highest possible expected return <img src="./assets/f3c7d61e0de04b3051708544a32133a3.svg?sanitize=true&invert_in_darkmode" align=middle width=51.381495pt height=24.65759999999998pt/> of 
taking action <img src="./assets/44bc9d542a92714cac84e01cbbb7fd61.svg?sanitize=true&invert_in_darkmode" align=middle width=8.689230000000004pt height=14.155350000000013pt/> in state <img src="./assets/6f9bad7347b91ceebebd3ad7e6f6f2d1.svg?sanitize=true&invert_in_darkmode" align=middle width=7.705549500000004pt height=14.155350000000013pt/>, is computed from:
- the expected reward for taking action <img src="./assets/44bc9d542a92714cac84e01cbbb7fd61.svg?sanitize=true&invert_in_darkmode" align=middle width=8.689230000000004pt height=14.155350000000013pt/>, <img src="./assets/464207bf81effbe38d5a981f0168b2d2.svg?sanitize=true&invert_in_darkmode" align=middle width=34.09131000000001pt height=22.46574pt/>
- the (discounted) Q-Value/highest possible expected return of following optimal policy <img src="./assets/59f77539cf77015ade045b81a9e7700c.svg?sanitize=true&invert_in_darkmode" align=middle width=96.244665pt height=24.65759999999998pt/> thereafter,
  picking best action <img src="./assets/0e4c6f71125913b2b45da22c80bf91ce.svg?sanitize=true&invert_in_darkmode" align=middle width=30.298950000000005pt height=14.155350000000013pt/> such that it maximises <img src="./assets/59f77539cf77015ade045b81a9e7700c.svg?sanitize=true&invert_in_darkmode" align=middle width=96.244665pt height=24.65759999999998pt/>,
  picking action <img src="./assets/910ca541ae1e44e678598366e9172752.svg?sanitize=true&invert_in_darkmode" align=middle width=30.298950000000005pt height=14.155350000000013pt/> ... and so on...)

<p align="center"><img src="./assets/b62fbe836f1006937060308cb53a055e.svg?sanitize=true&invert_in_darkmode" align=middle width=307.8537pt height=25.205564999999996pt/></p>

### Q Learning
Q-Learning attempts to derive the optimal Q-Value function <img src="./assets/11cf084e7fd83c09088280b2d91d5497.svg?sanitize=true&invert_in_darkmode" align=middle width=14.073510000000004pt height=14.155350000000013pt/> by
iteractively adjusting the Q-Value for each state-action pair <img src="./assets/7f639e695da9a78abc9301e9e0f90795.svg?sanitize=true&invert_in_darkmode" align=middle width=44.41404000000001pt height=24.65759999999998pt/>
until it coverges to the correct optimal Q-Value for that state-action <img src="./assets/f3c7d61e0de04b3051708544a32133a3.svg?sanitize=true&invert_in_darkmode" align=middle width=51.381495pt height=24.65759999999998pt/>


#### Q-Value Function Representations
Different ways of representing the mapping of the Q-Value function <img src="./assets/d5c18a8ca1894fd3a7d25f242cbe8890.svg?sanitize=true&invert_in_darkmode" align=middle width=7.928167500000005pt height=14.155350000000013pt/>:

| Representations | Description | Suitable Application |
| --- | --- | --- |
| Table | A Table storing the Q-Value for all possible combinations of states and actions | Small no. of combinations state & actions|
| Neural Network(NN) | A NN is trained that takes in input state and value and mapsm it to Q-values | Large no. of combinations of stae & actions |

#### Exploration vs Exploitation
Exploration - randomly selecting actions gather infomation about the environment
- we start with Q-Value function <img src="./assets/d5c18a8ca1894fd3a7d25f242cbe8890.svg?sanitize=true&invert_in_darkmode" align=middle width=7.928167500000005pt height=14.155350000000013pt/> that is significantlly off from the 
  optimal Q-Value function <img src="./assets/11cf084e7fd83c09088280b2d91d5497.svg?sanitize=true&invert_in_darkmode" align=middle width=14.073510000000004pt height=14.155350000000013pt/>
- hence selecting the best possible action (exploitation) based on <img src="./assets/d5c18a8ca1894fd3a7d25f242cbe8890.svg?sanitize=true&invert_in_darkmode" align=middle width=7.928167500000005pt height=14.155350000000013pt/> is a bad idea
- instead randomly select actions to tune <img src="./assets/d5c18a8ca1894fd3a7d25f242cbe8890.svg?sanitize=true&invert_in_darkmode" align=middle width=7.928167500000005pt height=14.155350000000013pt/> towards optimal <img src="./assets/11cf084e7fd83c09088280b2d91d5497.svg?sanitize=true&invert_in_darkmode" align=middle width=14.073510000000004pt height=14.155350000000013pt/>

Exploitation - selecting the best possible action based on Q-Value function <img src="./assets/d5c18a8ca1894fd3a7d25f242cbe8890.svg?sanitize=true&invert_in_darkmode" align=middle width=7.928167500000005pt height=14.155350000000013pt/>
- after tuning <img src="./assets/d5c18a8ca1894fd3a7d25f242cbe8890.svg?sanitize=true&invert_in_darkmode" align=middle width=7.928167500000005pt height=14.155350000000013pt/> sufficently, it converges to optimal Q-Value function <img src="./assets/11cf084e7fd83c09088280b2d91d5497.svg?sanitize=true&invert_in_darkmode" align=middle width=14.073510000000004pt height=14.155350000000013pt/>
- now we can exploit the tuned <img src="./assets/d5c18a8ca1894fd3a7d25f242cbe8890.svg?sanitize=true&invert_in_darkmode" align=middle width=7.928167500000005pt height=14.155350000000013pt/> to choose the (approx.) best action and
    achieve the (approx.) best reward.

Epsilon Greedy Strategy - explore then gradually transition to exploiting
- define a exploration rate <img src="./assets/7ccca27b5ccc533a2dd72dc6fa28ed84.svg?sanitize=true&invert_in_darkmode" align=middle width=6.672451500000003pt height=14.155350000000013pt/> which is probablity of the agent exploring
- start with <img src="./assets/c2101b156b66aec18d423619f4e227b5.svg?sanitize=true&invert_in_darkmode" align=middle width=36.809355000000004pt height=21.18732pt/> and gradually decay/reduce <img src="./assets/c9b6bb6ae4488b10973b26eef4b9e65c.svg?sanitize=true&invert_in_darkmode" align=middle width=40.46229pt height=21.18732pt/>
- simulate the gradual transition from exploration to exploitation


#### Q Learning Loss
Since Q-Learning attempts to get <img src="./assets/d5c18a8ca1894fd3a7d25f242cbe8890.svg?sanitize=true&invert_in_darkmode" align=middle width=7.928167500000005pt height=14.155350000000013pt/> to converge to <img src="./assets/11cf084e7fd83c09088280b2d91d5497.svg?sanitize=true&invert_in_darkmode" align=middle width=14.073510000000004pt height=14.155350000000013pt/> the loss function of
Q-Learning is simply the difference between <img src="./assets/d5c18a8ca1894fd3a7d25f242cbe8890.svg?sanitize=true&invert_in_darkmode" align=middle width=7.928167500000005pt height=14.155350000000013pt/> and <img src="./assets/11cf084e7fd83c09088280b2d91d5497.svg?sanitize=true&invert_in_darkmode" align=middle width=14.073510000000004pt height=14.155350000000013pt/>
<p align="center"><img src="./assets/dd4492f99172ff2a633c1b84bb8a1d75.svg?sanitize=true&invert_in_darkmode" align=middle width=185.47815pt height=16.438356pt/></p>

Where
- <img src="./assets/f3c7d61e0de04b3051708544a32133a3.svg?sanitize=true&invert_in_darkmode" align=middle width=51.381495pt height=24.65759999999998pt/> can be derieved from the belman equation
- <img src="./assets/48ded56dd07b0d1b828b0ef9029fd6b6.svg?sanitize=true&invert_in_darkmode" align=middle width=206.030055pt height=27.91271999999999pt/> - total discounted expected future rewards

#### Q Learning Update
Q Learning iteratively tunes <img src="./assets/d5c18a8ca1894fd3a7d25f242cbe8890.svg?sanitize=true&invert_in_darkmode" align=middle width=7.928167500000005pt height=14.155350000000013pt/> to <img src="./assets/11cf084e7fd83c09088280b2d91d5497.svg?sanitize=true&invert_in_darkmode" align=middle width=14.073510000000004pt height=14.155350000000013pt/> by apply the following update:
- find optimal possible Q-value for future states and actions:
<p align="center"><img src="./assets/7b43aec43c548b5a9bd76f7b11940998.svg?sanitize=true&invert_in_darkmode" align=middle width=233.80499999999998pt height=25.205564999999996pt/></p>

> since we don't have <img src="./assets/11cf084e7fd83c09088280b2d91d5497.svg?sanitize=true&invert_in_darkmode" align=middle width=14.073510000000004pt height=14.155350000000013pt/>, we use <img src="./assets/d5c18a8ca1894fd3a7d25f242cbe8890.svg?sanitize=true&invert_in_darkmode" align=middle width=7.928167500000005pt height=14.155350000000013pt/> to estimate <img src="./assets/11cf084e7fd83c09088280b2d91d5497.svg?sanitize=true&invert_in_darkmode" align=middle width=14.073510000000004pt height=14.155350000000013pt/>

- estimate the optimal Q-value <img src="./assets/f3c7d61e0de04b3051708544a32133a3.svg?sanitize=true&invert_in_darkmode" align=middle width=51.381495pt height=24.65759999999998pt/> as the new Q-Value <img src="./assets/f80b1ad3e38badc06c5937c4835260a3.svg?sanitize=true&invert_in_darkmode" align=middle width=37.177800000000005pt height=22.46574pt/> using the belman equation
<p align="center"><img src="./assets/9c87cc329d8b3b78b7db240aef9b8f87.svg?sanitize=true&invert_in_darkmode" align=middle width=281.97839999999997pt height=25.205564999999996pt/></p>

> again, since we don't have <img src="./assets/11cf084e7fd83c09088280b2d91d5497.svg?sanitize=true&invert_in_darkmode" align=middle width=14.073510000000004pt height=14.155350000000013pt/>, we use <img src="./assets/d5c18a8ca1894fd3a7d25f242cbe8890.svg?sanitize=true&invert_in_darkmode" align=middle width=7.928167500000005pt height=14.155350000000013pt/> to estimate <img src="./assets/11cf084e7fd83c09088280b2d91d5497.svg?sanitize=true&invert_in_darkmode" align=middle width=14.073510000000004pt height=14.155350000000013pt/>

- update <img src="./assets/d5c18a8ca1894fd3a7d25f242cbe8890.svg?sanitize=true&invert_in_darkmode" align=middle width=7.928167500000005pt height=14.155350000000013pt/> with the new Q-value
<p align="center"><img src="./assets/0d358b233c810cab998a944b23b99fc2.svg?sanitize=true&invert_in_darkmode" align=middle width=270.44655pt height=16.438356pt/></p>

> learning rate <img src="./assets/c745b9b57c145ec5577b82542b2df546.svg?sanitize=true&invert_in_darkmode" align=middle width=10.576500000000003pt height=14.155350000000013pt/> tunes the rate of which <img src="./assets/d5c18a8ca1894fd3a7d25f242cbe8890.svg?sanitize=true&invert_in_darkmode" align=middle width=7.928167500000005pt height=14.155350000000013pt/> adapts the new Q-value 
> vs retaining the old Q-value. This is required as <img src="./assets/d5c18a8ca1894fd3a7d25f242cbe8890.svg?sanitize=true&invert_in_darkmode" align=middle width=7.928167500000005pt height=14.155350000000013pt/> may still not be an
> accurate estimate of <img src="./assets/11cf084e7fd83c09088280b2d91d5497.svg?sanitize=true&invert_in_darkmode" align=middle width=14.073510000000004pt height=14.155350000000013pt/> yet, hence the new Q-value may be inaccurate and 
> we use <img src="./assets/c745b9b57c145ec5577b82542b2df546.svg?sanitize=true&invert_in_darkmode" align=middle width=10.576500000000003pt height=14.155350000000013pt/> to reduce their impact.

## Markov Theory
### Markov Property
Markov property states that future states are independent of past states
given the present state which captures all relevant infomation in history.

The present state <img src="./assets/9f8bba50b95de09625626ddafa0698eb.svg?sanitize=true&invert_in_darkmode" align=middle width=15.045855000000003pt height=22.46574pt/> only captures all relevant infomation in history when
the following holds:
<p align="center"><img src="./assets/d9d51400d97b93d686ff48c40d34bbae.svg?sanitize=true&invert_in_darkmode" align=middle width=227.2941pt height=16.438356pt/></p>

When the previous property holds, then it follows that the probablity of
transitioning to future state <img src="./assets/675c2f5707a1fa7050c12adc1872ba32.svg?sanitize=true&invert_in_darkmode" align=middle width=11.495550000000003pt height=24.716340000000006pt/> given current state <img src="./assets/6f9bad7347b91ceebebd3ad7e6f6f2d1.svg?sanitize=true&invert_in_darkmode" align=middle width=7.705549500000004pt height=14.155350000000013pt/> is defined as:
<p align="center"><img src="./assets/7680e57f6ef2c596128fec27cd8884b1.svg?sanitize=true&invert_in_darkmode" align=middle width=196.4787pt height=17.883195pt/></p>

When the the probablity of all possible current state transition are collected
together, that is know the state's transition function/model (<img src="./assets/df5a289587a2f0247a5b97c1e8ac58ca.svg?sanitize=true&invert_in_darkmode" align=middle width=12.836835000000004pt height=22.46574pt/>), which
describes how state transitions over time.

<p align="center"><img src="./assets/75e975e2595c0fe43071724302183e3e.svg?sanitize=true&invert_in_darkmode" align=middle width=247.82835pt height=79.682295pt/></p>

### Markov Processes
![Markov Processes](./assets/markov_process.png)
> A diagram representing a two-state Markov process. Each number represents the 
> probability of the Markov process transitioning from one state to another state.

Markov Processes/Chains are a bunch of states <img src="./assets/9d4a039af35f3218c09bff1585ff4641.svg?sanitize=true&invert_in_darkmode" align=middle width=74.30181pt height=14.155350000000013pt/> with the 
markov property:
- each state <img src="./assets/4fa3ac8fe93c68be3fe7ab53bdeb2efa.svg?sanitize=true&invert_in_darkmode" align=middle width=12.356520000000005pt height=14.155350000000013pt/> may be mapped to another state <img src="./assets/227f4d8d12b0de49c4ca84f74fa98023.svg?sanitize=true&invert_in_darkmode" align=middle width=13.810005000000006pt height=14.155350000000013pt/> with a probability <img src="./assets/7d51282c16aca8486ef5cf66f4a4b0a1.svg?sanitize=true&invert_in_darkmode" align=middle width=25.213320000000003pt height=22.46574pt/>
- <img src="./assets/7d51282c16aca8486ef5cf66f4a4b0a1.svg?sanitize=true&invert_in_darkmode" align=middle width=25.213320000000003pt height=22.46574pt/> defines the probability of the process transitioning to another state <img src="./assets/40fa09318e2798c7881b3513e10ca968.svg?sanitize=true&invert_in_darkmode" align=middle width=16.658235pt height=22.46574pt/>
  given that <img src="./assets/ef0de0b48cb187b636ae34b0aea8c1db.svg?sanitize=true&invert_in_darkmode" align=middle width=15.204585000000002pt height=22.46574pt/> be the current state.

### Markov Reward Processes

