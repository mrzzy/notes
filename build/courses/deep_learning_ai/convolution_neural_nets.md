# Convolutional Neural Networks
Course 3 of _Deep Learning AI_ specialisation on Coursera 
Rights and Credits belong Andrew Ng and Course Creators

## Convolutional Neural Networks
### Computer Vision
Computer Vision(CV) has advanced rapidly due to deep learning:
- unlock door or phone with facial recongnition
- self-driving cars

Computer Vision(CV) Problems
- image classification - classify image into a set of classes
- object detection - recongnise object in picture by drawing bounding box
- neural style transfer - repaint content image in style.

Challenges of CV:
- DL on large image is computationaly intensive 
    - input: $3000 \times 3000 \times 3$ fed into dense layer of $1000$ units will
        result in 3 Billion parameters to fit.

### Convolution
#### Edge Detection
The Most Basic Problem in CV is edge detection which is done with convolution
operation

Problem Example: Vertical Edge Detection
- <img src="./assets/41c375fb358400ef5b5e91c8cc6992e1.svg?sanitize=true&invert_in_darkmode" align=middle width=36.52968pt height=21.18732pt/> image 
- convolve (apply convolution) with a <img src="./assets/9f2b6b0a7f3d99fd3f396a1515926eb3.svg?sanitize=true&invert_in_darkmode" align=middle width=36.52968pt height=21.18732pt/> vertical edge detection filter
<img src="./assets/fabccd3445424aab2f5b110e45e01103.svg?sanitize=true&invert_in_darkmode" align=middle width=127.009245pt height=67.39788pt/>
    1. Slide filter over the image, for each position:
    2. Multiply image covered by filter with corresponding
    3. Save resulting value as result
- results with a <img src="./assets/c23c76f8db7632f222f146e6ba5210dc.svg?sanitize=true&invert_in_darkmode" align=middle width=36.52968pt height=21.18732pt/> resulting matrix with vertical edge

> In mathematics, convolution operation is represented by the <img src="./assets/7c74eeb32158ff7c4f67d191b95450fb.svg?sanitize=true&invert_in_darkmode" align=middle width=8.219277000000005pt height=15.297149999999977pt/> operator
> Also, convolution in mathematics requires the filter be transposed before 
> convolution.
> Convolution in CV, ML is akin to cross corelation in mathematics

#### Convolution Filters
Common Filters:
- vertical edge filter:
<img src="./assets/fabccd3445424aab2f5b110e45e01103.svg?sanitize=true&invert_in_darkmode" align=middle width=127.009245pt height=67.39788pt/>
- horizontal edge filter:
<img src="./assets/e68610b4854ab2a2d42644438588be00.svg?sanitize=true&invert_in_darkmode" align=middle width=152.58012pt height=67.39788pt/>
- Sobel filter:
<img src="./assets/d2444f42a681289520942b71a1e000ae.svg?sanitize=true&invert_in_darkmode" align=middle width=127.009245pt height=67.39788pt/>
- Scharr filter:
<img src="./assets/346cd42a724efef878d3d961d9e5e3f7.svg?sanitize=true&invert_in_darkmode" align=middle width=143.44770000000003pt height=67.39788pt/>

> Instead of hand coding the filters we can use backprop to train the filters
> (ie treat the filter as weights)

#### Padding for Convolution
Using padding with convolution:
- Convolution of input image of dim <img src="./assets/3add1221abfa79cb14021bc2dacd5725.svg?sanitize=true&invert_in_darkmode" align=middle width=39.82506pt height=19.178279999999994pt/> using a filter of <img src="./assets/e9ef2edf7ddb146106f9421892078adc.svg?sanitize=true&invert_in_darkmode" align=middle width=39.726060000000004pt height=22.831379999999992pt/>
results a reduced size image of <img src="./assets/529fc4fc2127477e62afc95b7f374beb.svg?sanitize=true&invert_in_darkmode" align=middle width=181.834455pt height=24.65759999999998pt/>
- pad the input image with zeros to give an output result of the same size as input

Padding modes:
- same padding - pads the input image such that the output size is the same as 
    input size
- valid padding - no padding is added, ouput size is reduce

#### Strided Convolution
Strided Convolution allows you to control no. of strides/steps taken when sliding
over the image.
- <img src="./assets/3add1221abfa79cb14021bc2dacd5725.svg?sanitize=true&invert_in_darkmode" align=middle width=39.82506pt height=19.178279999999994pt/> image padded with padding <img src="./assets/2ec6e630f199f589a2402fdf3e0289d5.svg?sanitize=true&invert_in_darkmode" align=middle width=8.270625000000004pt height=14.155350000000013pt/> convolved with stride <img src="./assets/6f9bad7347b91ceebebd3ad7e6f6f2d1.svg?sanitize=true&invert_in_darkmode" align=middle width=7.705549500000004pt height=14.155350000000013pt/> on filter <img src="./assets/e9ef2edf7ddb146106f9421892078adc.svg?sanitize=true&invert_in_darkmode" align=middle width=39.726060000000004pt height=22.831379999999992pt/>
    result image of size: $(\frac{n+2p-f}{s} + 1) \times (\frac{n+2p-f}{s} + 1)$

#### Convolution over Volumes
To apply convolution over 3 dim volumes with <img src="./assets/fd5cc10255005dce836ac11ab58333da.svg?sanitize=true&invert_in_darkmode" align=middle width=68.97825pt height=22.831379999999992pt/> (ie RGB image) 
- use a 3 dim filter of <img src="./assets/500d39f23e2e8432fc9aaa4554506e0d.svg?sanitize=true&invert_in_darkmode" align=middle width=66.931095pt height=22.831379999999992pt/> where <img src="./assets/3e18a4a28fdee1744e5e3f79d13b9ff6.svg?sanitize=true&invert_in_darkmode" align=middle width=7.113876000000004pt height=14.155350000000013pt/> dim matches with input <img src="./assets/3e18a4a28fdee1744e5e3f79d13b9ff6.svg?sanitize=true&invert_in_darkmode" align=middle width=7.113876000000004pt height=14.155350000000013pt/> dim
- slide filter over image and apply convolution as usual (multiply corresponding values and sum

![3D Convolution](assets/convnets/3d_convolution.png)

#### Multiple Filter 
When applying convolution with multiple filters, the resulting output would
be the result of convolving with each filter stacked together:
- input of <img src="./assets/67613a2a76a214e90630fc1cb38536af.svg?sanitize=true&invert_in_darkmode" align=middle width=75.65778pt height=19.178279999999994pt/> convolved with <img src="./assets/a36a1e0b007884ba84d6355b48c564b5.svg?sanitize=true&invert_in_darkmode" align=middle width=17.566890000000004pt height=14.155350000000013pt/> filters results in an 
    output of dim $(n-f+1) \times (n-f+1) \times n_f$

![Convolution with Multiple Filters](assets/convnets/multiple_filter_convolution.png)

### Convolution Neural Network
#### Notation
Notation used when describing a CNN:
- where <img src="./assets/2f2322dff5bde89c37bcae4116fe20a8.svg?sanitize=true&invert_in_darkmode" align=middle width=5.228421000000005pt height=22.831379999999992pt/> is a convolution layer in a CN

| Notation | Description |
| --- | --- |
| <img src="./assets/4a8f75aa7c7792d8f443a573b331d554.svg?sanitize=true&invert_in_darkmode" align=middle width=21.484155pt height=29.19113999999999pt/> | Filter size used in convolution |
| <img src="./assets/a7671db409ee719d864a7efe0c7197ac.svg?sanitize=true&invert_in_darkmode" align=middle width=19.937445pt height=29.19113999999999pt/> | Padding used before convolution |
| <img src="./assets/523c5a12e023af28a4306c35ea696f86.svg?sanitize=true&invert_in_darkmode" align=middle width=19.372320000000006pt height=29.19113999999999pt/> | Stride used in convolution|
| <img src="./assets/1fc8d3589de1b02f6189063efccac7fd.svg?sanitize=true&invert_in_darkmode" align=middle width=21.533655000000003pt height=34.33782pt/> | No. of filters used in convolution|

A <img src="./assets/1e6f2147542ba43292f2429a1de8f595.svg?sanitize=true&invert_in_darkmode" align=middle width=156.906255pt height=34.33782pt/> input will produce a 
- <img src="./assets/8f50c0520eff865d30135e040262d7b1.svg?sanitize=true&invert_in_darkmode" align=middle width=108.892905pt height=34.33782pt/> output
- where <img src="./assets/1a46d9074acaa020e988125df41bdc48.svg?sanitize=true&invert_in_darkmode" align=middle width=21.533655000000003pt height=34.33782pt/> and <img src="./assets/d755f387ea84ea8a05e2d65b7dc177f1.svg?sanitize=true&invert_in_darkmode" align=middle width=23.999415000000003pt height=34.33782pt/> is derived by:
    - $$ n_H^{[l]} = \frac{n_H^{[l-1]} + 2p^{[l]} - f^{[l]}}{s^{[l]}} +1 $$
    - $$ n_W^{[l]} = \frac{n_W^{[l-1]} + 2p^{[l]} - f^{[l]}}{s^{[l]}} +1 $$

Each filter has a dimensions/shape: <img src="./assets/48fc1e276d4efd7c4681a37aedec79b4.svg?sanitize=true&invert_in_darkmode" align=middle width=123.15484499999998pt height=34.33782pt/>
- since we have <img src="./assets/d09ea3f33d137bc2be7269c721276d5b.svg?sanitize=true&invert_in_darkmode" align=middle width=21.533655000000003pt height=34.33782pt/> filters the weight <img src="./assets/ae126086dbc07dd0439215b0d1f41915.svg?sanitize=true&invert_in_darkmode" align=middle width=29.475105pt height=29.19113999999999pt/> of the convolution layer is 
    $f^{[l]} \times f^{[l]} \times n_C^{[l-1]} \times n_C^{[l]}$
- dimensions of the bias: <img src="./assets/f135a2543fab83a1340b19c4fd6e59d8.svg?sanitize=true&invert_in_darkmode" align=middle width=106.46493000000001pt height=34.33782pt/>

#### Single Layer 
![Single Layer CNN](assets/convnets/convolution_layer.png)

Flow of a single convolution layer in a CNN:
- Apply convolution with one or more layers with filters
- Apply bias and activation function to the output of convolution 
- Stack the resulting feature maps to produce output

> If we have 10x of 3 by 3 by 3 filters, we would have 280 parameters.
> Notice that the no. of parameters is not affected by the input size.
> (ie same parameters works for large images and tiny images without alteration)

#### Multiple Layers
![Convolution Neural Network](assets/convnets/convolution_network.png)

Example of Convolution neural network is stacking together by the following:
- convolution layer(s) to perform convolution:
    - first convolution layer convolves the input to 37 by 37 by 10 feature map
    - second convolution layer convolves feature map to 17 by 17 by 20 feature map 
    - third convolution layer convolves feature map to 7 by 7 by 40 feature map fa
- flatten layer flattens the feature map a 1960 long vector
- dense/fully connected layer(s) to perform regression/classification on vector.

#### Pooling Layers
Pooling Layers allow us to reduce the size of the feature map when passing through
a CNN to reduce training.
- pooling layers have no parameters of their own and do not require training.

Types of pooling layers:
| Pooling | Description | Diagram | 
| --- | --- | --- | --- |
| Max Pooling | Pools by convolving and applying max over each square area of the feature map | ![Max Pooling](assets/convnets/max_pooling.png) |
| Average Pooling | Pools by convolving and applying average over each square area of the feature map | ![Average Pooling](assets/convnets/average_pooling.png)  |

> Intution for max pooling: preserves the maxmimum feature which is typically the
> most relevant.  
> Max pooling is more used then average pooling.

Hyperparameters for pooling: 
- Filter size <img src="./assets/190083ef7a1625fbc75f243cffb9c96d.svg?sanitize=true&invert_in_darkmode" align=middle width=9.817500000000004pt height=22.831379999999992pt/> used for filter when pooling
- stride <img src="./assets/6f9bad7347b91ceebebd3ad7e6f6f2d1.svg?sanitize=true&invert_in_darkmode" align=middle width=7.705549500000004pt height=14.155350000000013pt/> when pooling.

> When <img src="./assets/c77f3136062da785e2cf73647296ad4f.svg?sanitize=true&invert_in_darkmode" align=middle width=85.10254499999999pt height=22.831379999999992pt/>, pooling reduces a input of size <img src="./assets/6b57739e2b40ab1be94708960b6e12a6.svg?sanitize=true&invert_in_darkmode" align=middle width=56.26335pt height=21.18732pt/> to <img src="./assets/3add1221abfa79cb14021bc2dacd5725.svg?sanitize=true&invert_in_darkmode" align=middle width=39.82506pt height=19.178279999999994pt/>
> (ie by half)

### CNN Architecture
Example of CNN ala LeNet-5:
![LeNet-5](assets/convnets/cnn_example_lenet_5.png)

Conventions in CNN:
- as we go deeper, the spatial dimensions of the feature map (width and height) 
    decreases, while the depth increases.
- as we go deeper, the no. of parameters per layer increases

### Advantages of Convolution
Why convolutions work?
- parameter sharing - convolution shares parameters across entire image 
    (ie a learnt edge detector is shared accross the entire image)
- sparsity of connections - for each layer each output values only a small no. of input values.

Advantages
- less parameters, less data required for training, faster training time
- translation invariance - image translated(shifted) should give the same result.

## More CNNs
### CNN Case Studies
Case Studies - great way to learn how to build CNNs

#### Classic Networks
Classic Networks
- LeNet-5 - hand written digits classification
  - the size of the image/feature map decreases, while channels increases
    as it passes through the network
  - Conv-Pool-Conv-Pool pattern with two dense layers afterwards
![LeNet-5](./assets/convnets/case_study_classic_lenet_5.png)
- AlexNet - Imagenet
  - simliar to LeNet-5, although differs in no. of parameters, ReLU, MaxPooling
![AlexNet](./assets/convnets/case_study_class_alexnet.png)
- VGG - Imagenet
  - Conv-Conv-Pool pattern with two dense layers afterwards
![VGG](./assets/convnets/case_study_class_vgg.png)

#### Recent Networks/Methods
##### ResNets
ResNets are networks built from residual blocks
![ResNets](./assets/convnets/case_study_resnet.png)

Residual blocks are layers of NNs with short cuts/skip connections:
- provides a path from the start of the block skip layers of the block
- this combats the vanishing gradient problem allowing very deep NNs to be built
![Residual Blocks](./assets/convnets/case_study_resnet_residual_block.png)

Mathematically, Activation <img src="./assets/1be5ce3d3a1218e123f9fd5470cb15f0.svg?sanitize=true&invert_in_darkmode" align=middle width=20.356050000000003pt height=29.19113999999999pt/> of the residual block is derieved from:
- the input of the residual block <img src="./assets/332cc365a4987aacce0ead01b8bdcc0b.svg?sanitize=true&invert_in_darkmode" align=middle width=9.395100000000005pt height=14.155350000000013pt/> 
- the activation of the previous layer <img src="./assets/84e0c58d7507483f09653f2e62634dea.svg?sanitize=true&invert_in_darkmode" align=middle width=37.182585pt height=29.19113999999999pt/>:
<p align="center"><img src="./assets/175af54614f582aa69cfb349ab4f8a4f.svg?sanitize=true&invert_in_darkmode" align=middle width=131.80167pt height=19.526925pt/></p>

> Why do ResNets work:  identity function (copying the input) is easy to learn 
> - more layers does not hurt performance

##### One by One convolutions
One by One convolution/network in network is performing convolution using a 1x1 filter:
![One by One Convolution](./assets/convnets/one_by_one_covolution.png)
> This akin to having a dense layer within the network. Each element
> of the filter is like a fully connect unit Taking inputs from each 
> channel column.

Applications of One by One convolutions:
- shrink the channel dimensions (ie from 192 to 32)
![Shirkning Channels with One by One Convolutions](./assets/convnets/one_by_one_covolution_application_shrink_dim.png)
- add nonlinearity to the neural network - learns more complex functions

##### Inception Network
Inception Networks are made of Inception Modules:
![Inception Network](./assets/convnets/case_study_inception_network.png)

> The branches/arms of the network are dense/softmax layers which perform 
> predictions. This ensures that the features learnt in the hidden layer are 
> at least somewhat useful to the task at hand.

---
Inception Modules are drived from two ideas: Inception Blocks and Bottleneck Layers

Inception Block applys convolutions of various filter sizes/pooling techniques:
- allows the network to which filter size/pooling to use
- addresses the problem of having to choose filter size/where to put pooling
![Inception Blocks](./assets/convnets/case_study_inception_block.png)

Bottleneck Layer applies a one by one convolution to reduce computation cost:
- by reducing the number of channels one can reduce the operations done by convolution
![Inception Blocks](./assets/convnets/case_study_inception_bottlneck_layer.png)
> Bottleneck Layers when used within reason, should not hurt modeling performance

---
![Inception Block](./assets/convnets/case_study_inception_block.png)
Walkthrough of the Inception Module:
- obtain input as the activation of the previous module/layer
- pass through  of the inception Module
  1. one by one convolution shrinking no. of channels from 192 to 64
  2. one by one convolution shrinking no. of channels to 96 followed by 3 by 3 convolution
  3. one by one convolution shrinking no. of channels to 32 followed by 5 by 5 convolution
  4. max pool with a 3 by 3 filter (stride 1) and a one by one convolutions shrinking no. of channels to 32 
- concatenate the outputs of each branch by the channel

## Practical Advice on CNN
### Practical Advice on using CNNs
Practical Advice on using CNN:
1. use open source implementations if possible
    - less hyperparameters to tune (ie learning rate/decay etc.)
    - pretrained models reduce training time significantly
2. Use transfer learning:
    - use pretrained layers as feature extraction 
      - precompute activation with pretrained layers and use as input
      - freeze pretrained layers and train last few layers
    - fine tune pretrained models to your application 
      - unfreeze after some training abit to fine tune the other layers to your application
    - retrain everything - when you have alot of data
3. Data Argumentation - augment data to generate more data
    - Mirroring - flip horizontally/vertical
    - Random Cropping - randomly crop the image (reasonablely large subset of he image)
    - Color Shifting - randomly admend the RGB channels with some offset (ie PCA color augmentation)
    - Rotation
    - Shearing
    - Color Wraping

> ![Data Augumentation Implementation](./assets/convnets/data_augmentation_implementation.png)
> Implement data augmentation as a parallel/concurrent process to the training
> process, performing data augmentation on the fly

### Data vs Hand Engineering
Sources of knowledge in ML:
- data - information learnt from data
- hand engineering - manual feature engineering/specialised network architecture etc.

Tradeoff between data and hand engineering 
- more data: less hand engineering required to obtain performance
- less data: more hand engineering required to obtain performance

### Benchmarks/Winning Competitions
Tips on Benchmarks/Winning Competitions (dont use in production):
- ensembling - train models indepedently and average their outputs
- multi-crop - run model on multiple version of the image and average results

