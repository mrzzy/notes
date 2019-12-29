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
| <img src="./assets/9f8bba50b95de09625626ddafa0698eb.svg?sanitize=true&invert_in_darkmode" align=middle width=15.045855000000003pt height=22.46574pt/> | A set of all possible current states at timestep <img src="./assets/4f4f4e395762a3af4575de74c019ebb5.svg?sanitize=true&invert_in_darkmode" align=middle width=5.936155500000004pt height=20.222069999999988pt/> |
| <img src="./assets/cf83185198a68ea312b2d4387b1af3fe.svg?sanitize=true&invert_in_darkmode" align=middle width=31.689735000000002pt height=22.46574pt/> | A set of all possible future states at timestep <img src="./assets/628783099380408a32610228991619a8.svg?sanitize=true&invert_in_darkmode" align=middle width=34.246575pt height=21.18732pt/> 
| <img src="./assets/6f9bad7347b91ceebebd3ad7e6f6f2d1.svg?sanitize=true&invert_in_darkmode" align=middle width=7.705549500000004pt height=14.155350000000013pt/> | One possible state at current timestep <img src="./assets/4f4f4e395762a3af4575de74c019ebb5.svg?sanitize=true&invert_in_darkmode" align=middle width=5.936155500000004pt height=20.222069999999988pt/>  (<img src="./assets/1269099b3b71dc7a918e5c7e0f37fc28.svg?sanitize=true&invert_in_darkmode" align=middle width=42.842415pt height=22.46574pt/>) |
| <img src="./assets/675c2f5707a1fa7050c12adc1872ba32.svg?sanitize=true&invert_in_darkmode" align=middle width=11.495550000000003pt height=24.716340000000006pt/> | One possible future state at future timestep <img src="./assets/628783099380408a32610228991619a8.svg?sanitize=true&invert_in_darkmode" align=middle width=34.246575pt height=21.18732pt/> (<img src="./assets/bba14e9473c3cfe3e226f6e3d102ec2a.svg?sanitize=true&invert_in_darkmode" align=middle width=64.09821pt height=24.716340000000006pt/>) |
| <img src="./assets/df5a289587a2f0247a5b97c1e8ac58ca.svg?sanitize=true&invert_in_darkmode" align=middle width=12.836835000000004pt height=22.46574pt/> | A states transition model/function that describes how state changes over time.  |
| <img src="./assets/7f8a20dacaccab775d1e690bcf0f49e1.svg?sanitize=true&invert_in_darkmode" align=middle width=17.447265000000005pt height=22.46574pt/> | A set of coresponding rewards for each state <img src="./assets/1269099b3b71dc7a918e5c7e0f37fc28.svg?sanitize=true&invert_in_darkmode" align=middle width=42.842415pt height=22.46574pt/> |


## Markov Decision Processes
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
> probability of the Markov process changing from one state to another state.

Markov Processes/Chains are a bunch of states <img src="./assets/9d4a039af35f3218c09bff1585ff4641.svg?sanitize=true&invert_in_darkmode" align=middle width=74.30181pt height=14.155350000000013pt/> with the 
markov property. 
- It represented as a set of tuples (<img src="./assets/e257acd1ccbe7fcb654708f1a866bfe9.svg?sanitize=true&invert_in_darkmode" align=middle width=11.027445000000004pt height=22.46574pt/>, <img src="./assets/1fbfa938f7f0ee3057f94c2c2b9dc712.svg?sanitize=true&invert_in_darkmode" align=middle width=15.519570000000003pt height=22.46574pt/>).

### Rewards & Returns
Markov Reward Processes are Markov Processes with a reward <img src="./assets/7b24bdd1cbc079e382b409a4e9f29905.svg?sanitize=true&invert_in_darkmode" align=middle width=45.411465pt height=22.46574pt/> attached 
to each state <img src="./assets/1269099b3b71dc7a918e5c7e0f37fc28.svg?sanitize=true&invert_in_darkmode" align=middle width=42.842415pt height=22.46574pt/>:
- when the agent gets to state <img src="./assets/6f9bad7347b91ceebebd3ad7e6f6f2d1.svg?sanitize=true&invert_in_darkmode" align=middle width=7.705549500000004pt height=14.155350000000013pt/> it attains the reward <img src="./assets/89f2e0d2d24bcf44db73aab8fc03252c.svg?sanitize=true&invert_in_darkmode" align=middle width=7.873024500000003pt height=14.155350000000013pt/>
- It represented as a set of tuples (<img src="./assets/9f8bba50b95de09625626ddafa0698eb.svg?sanitize=true&invert_in_darkmode" align=middle width=15.045855000000003pt height=22.46574pt/>, <img src="./assets/df5a289587a2f0247a5b97c1e8ac58ca.svg?sanitize=true&invert_in_darkmode" align=middle width=12.836835000000004pt height=22.46574pt/>, <img src="./assets/7f8a20dacaccab775d1e690bcf0f49e1.svg?sanitize=true&invert_in_darkmode" align=middle width=17.447265000000005pt height=22.46574pt/>, <img src="./assets/11c596de17c342edeed29f489aa4b274.svg?sanitize=true&invert_in_darkmode" align=middle width=9.423975000000004pt height=14.155350000000013pt/>)

<img src="./assets/a7968fd86498dd93ad9dc7240e1ca4d7.svg?sanitize=true&invert_in_darkmode" align=middle width=18.685920000000003pt height=22.46574pt/> is a reward function that describes which reward the state is expected to get 
given the current state <img src="./assets/6f9bad7347b91ceebebd3ad7e6f6f2d1.svg?sanitize=true&invert_in_darkmode" align=middle width=7.705549500000004pt height=14.155350000000013pt/>:
<p align="center"><img src="./assets/27e4e8a77f2fa8e13c657db3a41e8027.svg?sanitize=true&invert_in_darkmode" align=middle width=167.52615pt height=16.438356pt/></p>

Expected Return <img src="./assets/ab4745a27f0ed02fe9e696bcff9d032c.svg?sanitize=true&invert_in_darkmode" align=middle width=17.890455000000003pt height=22.46574pt/> the total expected future rewards to accumulated 
from current timestep <img src="./assets/4f4f4e395762a3af4575de74c019ebb5.svg?sanitize=true&invert_in_darkmode" align=middle width=5.936155500000004pt height=20.222069999999988pt/> to final timestep <img src="./assets/2f118ee06d05f3c2d98361d9c30e38ce.svg?sanitize=true&invert_in_darkmode" align=middle width=11.889405000000002pt height=22.46574pt/>
<p align="center"><img src="./assets/3881041d46658ee877d43b9f3f828e98.svg?sanitize=true&invert_in_darkmode" align=middle width=96.85384499999999pt height=49.17594pt/></p>

#### Discounted Return
Discounted Returns <img src="./assets/ab4745a27f0ed02fe9e696bcff9d032c.svg?sanitize=true&invert_in_darkmode" align=middle width=17.890455000000003pt height=22.46574pt/> is basically expected returns argumented with discount factor 
<img src="./assets/088df7963678b03ab83132e4c150cdfb.svg?sanitize=true&invert_in_darkmode" align=middle width=34.372800000000005pt height=21.18732pt/>:
- exponentially reduces the weight of future rewards.

<p align="center"><img src="./assets/7ca7bb811b53c89af5e4c1585709ed2d.svg?sanitize=true&invert_in_darkmode" align=middle width=143.81697pt height=49.17594pt/></p>

The discount factor <img src="./assets/11c596de17c342edeed29f489aa4b274.svg?sanitize=true&invert_in_darkmode" align=middle width=9.423975000000004pt height=14.155350000000013pt/> ensures that continuing task 
(tasks with no clearly defined end time <img src="./assets/f7eea52b8ea6e40b6e98d6d777d7979c.svg?sanitize=true&invert_in_darkmode" align=middle width=50.245470000000005pt height=22.46574pt/>) 
do not have <img src="./assets/f7a0f24dc1f54ce82fecccbbf48fca93.svg?sanitize=true&invert_in_darkmode" align=middle width=16.438455000000005pt height=14.155350000000013pt/> expected reward, and converges to a finite value:

Given that rewards <img src="./assets/7f8a20dacaccab775d1e690bcf0f49e1.svg?sanitize=true&invert_in_darkmode" align=middle width=17.447265000000005pt height=22.46574pt/> are equal to <img src="./assets/034d0a6be0424bffe9a6e7ac9236c0f5.svg?sanitize=true&invert_in_darkmode" align=middle width=8.219277000000005pt height=21.18732pt/> and <img src="./assets/0c0cc3864396c4ab5975f7c03d5c3514.svg?sanitize=true&invert_in_darkmode" align=middle width=17.643120000000003pt height=21.18732pt/>  
then <img src="./assets/78bbe2299c82acff9e63de62b3f3398a.svg?sanitize=true&invert_in_darkmode" align=middle width=81.891645pt height=26.438939999999977pt/> converges to <img src="./assets/492e9fd34340e45c0af837eeb23a3efb.svg?sanitize=true&invert_in_darkmode" align=middle width=23.906190000000002pt height=27.775769999999994pt/>


> Discounted Returns <img src="./assets/ab4745a27f0ed02fe9e696bcff9d032c.svg?sanitize=true&invert_in_darkmode" align=middle width=17.890455000000003pt height=22.46574pt/> can also be presented as recurrence equation:
> <p align="center"><img src="./assets/f4756ff2676cc88bedf1967203e3430a.svg?sanitize=true&invert_in_darkmode" align=middle width=175.1178pt height=15.0684765pt/></p>

### Policies
Policies <img src="./assets/5d66cf6fb3bc802039e0002e8c46cb5f.svg?sanitize=true&invert_in_darkmode" align=middle width=46.44618pt height=24.65759999999998pt/> defines how the agent acts by returning the probability
of taking action <img src="./assets/44bc9d542a92714cac84e01cbbb7fd61.svg?sanitize=true&invert_in_darkmode" align=middle width=8.689230000000004pt height=14.155350000000013pt/> given state <img src="./assets/6f9bad7347b91ceebebd3ad7e6f6f2d1.svg?sanitize=true&invert_in_darkmode" align=middle width=7.705549500000004pt height=14.155350000000013pt/>.

The aim of renforcement learning is to find the optimal policy that maxmises
return <img src="./assets/ab4745a27f0ed02fe9e696bcff9d032c.svg?sanitize=true&invert_in_darkmode" align=middle width=17.890455000000003pt height=22.46574pt/>

### Value Functions
Value Functions find the value of a given state <img src="./assets/6f9bad7347b91ceebebd3ad7e6f6f2d1.svg?sanitize=true&invert_in_darkmode" align=middle width=7.705549500000004pt height=14.155350000000013pt/>

### Belman Equation
TODO: i dont  understand 
Belman Equation.
