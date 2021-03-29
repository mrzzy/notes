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
- valid padding - no padding is added, output size is reduce

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
- input of <img src="./assets/67613a2a76a214e90630fc1cb38536af.svg?sanitize=true&invert_in_darkmode" align=middle width=75.65778pt height=19.178279999999994pt/> convolved with <img src="./assets/a36a1e0b007884ba84d6355b48c564b5.svg?sanitize=true&invert_in_darkmode" align=middle width=17.566890000000004pt height=14.155350000000013pt/> filters results in an output of dim <img src="./assets/bd097a25712ebb3b6c8bb72ff4e25e17.svg?sanitize=true&invert_in_darkmode" align=middle width=219.492405pt height=24.65759999999998pt/>

![Convolution with Multiple Filters](assets/convnets/multiple_filter_convolution.png)

## Convolution Neural Network in Detail
#### Notations
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
    - $n_H^{[l]} = \frac{n_H^{[l-1]} + 2p^{[l]} - f^{[l]}}{s^{[l]}} +1$
    - $n_W^{[l]} = \frac{n_W^{[l-1]} + 2p^{[l]} - f^{[l]}}{s^{[l]}} +1$

Each filter has a dimensions/shape: <img src="./assets/48fc1e276d4efd7c4681a37aedec79b4.svg?sanitize=true&invert_in_darkmode" align=middle width=123.15484499999998pt height=34.33782pt/>
- since we have <img src="./assets/d09ea3f33d137bc2be7269c721276d5b.svg?sanitize=true&invert_in_darkmode" align=middle width=21.533655000000003pt height=34.33782pt/> filters the weight <img src="./assets/ae126086dbc07dd0439215b0d1f41915.svg?sanitize=true&invert_in_darkmode" align=middle width=29.475105pt height=29.19113999999999pt/> of the convolution layer is <img src="./assets/e3bb8401b00edd9874f6cb24af3bf659.svg?sanitize=true&invert_in_darkmode" align=middle width=165.601755pt height=34.33782pt/>
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
| --- | --- | --- | 
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
    (ie a learnt edge detector is shared across the entire image)
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
  - similar to LeNet-5, although differs in no. of parameters, ReLU, MaxPooling
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

Inception Block applies convolutions of various filter sizes/pooling techniques:
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
3. Data Augumentation - augment data to generate more data
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

## Object Localisation & Detection
Problems in Object Localisation & Detection:
- object classification - what is the object in the image
- object localisation - where the object is in the image
- object detection - tries to classify and localise multiple objects at the sametime.

### Object Localisation 
Defining Object Detection problem:
- predict the class of the object in the image 
- predict the location of the object in the image

Object Localisation - CNN architecture:
![Object Localisation CNN Architecture](./assets/convnets/object_localisation_cnn_architecture.png)

Output Layer of the object localisation CNN to predict:
- softmax to predict the probablity of being each  different classes <img src="./assets/bde257af829cbccebb8082df04a23056.svg?sanitize=true&invert_in_darkmode" align=middle width=100.039335pt height=24.65759999999998pt/>
- bounding box <img src="./assets/85e5a6bb85a9baa28e6e9a10f9373869.svg?sanitize=true&invert_in_darkmode" align=middle width=98.25931499999999pt height=24.65759999999998pt/>  to predict location of object in the image

Structure of the output produced by Object Localisation CNN:

<p align="center"><img src="./assets/942ae81355b136ced9b69adffc244229.svg?sanitize=true&invert_in_darkmode" align=middle width=73.18146pt height=187.39875pt/></p>

> <img src="./assets/d01a40270d2c05177752cd7114f55670.svg?sanitize=true&invert_in_darkmode" align=middle width=16.428390000000004pt height=22.46574pt/> is used to predict the prob. whether there is an actual object
> of interest in the picture at all in the first place. If <img src="./assets/d01a40270d2c05177752cd7114f55670.svg?sanitize=true&invert_in_darkmode" align=middle width=16.428390000000004pt height=22.46574pt/> is
> less than some threshold, we discard the rest of the values.

#### Loss for Object Localisation
Objective Loss function for Object Localisation CNN:
- If we are sure there is an object is in the image (ie <img src="./assets/d01a40270d2c05177752cd7114f55670.svg?sanitize=true&invert_in_darkmode" align=middle width=16.428390000000004pt height=22.46574pt/> is above threshold), 
    we optimise MSE to try to get $\hat{y} \to y$
- Otherwise we only try to optimise logistic loss for <img src="./assets/d01a40270d2c05177752cd7114f55670.svg?sanitize=true&invert_in_darkmode" align=middle width=16.428390000000004pt height=22.46574pt/> to get <img src="./assets/724423ce00ee5bab05a6700094d1a5f8.svg?sanitize=true&invert_in_darkmode" align=middle width=59.24919pt height=31.14176999999998pt/>

#### Landmark Detection
Landmarks are points of interest on an image that we want the CNN to detect.
- CNN will output <img src="./assets/faad89e62631af011b1803d6677beaa2.svg?sanitize=true&invert_in_darkmode" align=middle width=58.64364pt height=24.65759999999998pt/> for each point of interest:
<p align="center"><img src="./assets/14070229f46caefb16346d2469ac987a.svg?sanitize=true&invert_in_darkmode" align=middle width=71.94824999999999pt height=108.49426499999998pt/></p>

![Landmark Detection](./assets/convnets/object_landmark_detection.png)

Example: Facial Recongnition:
- points of interest on a persons face - ie the Iris of a person, nose etc.
- output <img src="./assets/faad89e62631af011b1803d6677beaa2.svg?sanitize=true&invert_in_darkmode" align=middle width=58.64364pt height=24.65759999999998pt/> for each point of interest on the face.

Applications:
- Snapchat filters
- Face ID 
- Pose detection

> Downside: Requires dataset with landmarks labeled, which can be tedious.

### Object Localisation 
Object Detection problem tries to classify and localise multiple objects at the same time.

> Typically classification and localisation focuses on one object, 
> while object detection focuses on multiple objects in the image.

#### Object Localisation CNN
Object Localisation CNN implementation methods:

| Method | Description | Pros | Cons |
| --- | --- | --- | --- |
| Sliding Window |  Train a CNN to classify a closely croped image. Use a _sliding window_ to crop a part of the image to pass for classification with the CNN.  Incrementally increase the size of the sliding window used to crop the image passsed. | Easier to implement. |  Outdated. High Computation cost: More sliding windows of diff size means more accurate predictions but is slow. |
| YOLO | Divide image in to a grid (ie <img src="./assets/dc11121d7fae7c7ec7774809eb2848fc.svg?sanitize=true&invert_in_darkmode" align=middle width=52.968135pt height=21.18732pt/>). Apply CNN to predict bounding box/class label. (more details on YOLO follow.) | Fast. Suitable for real time object detection. | Hard to implement. 
| RCNN | Segments image into region proposal (ie part of image is car, road, etc.). Apply CNN classifier each region proposal. | Segmentation in addition to bounding box. | Hard to implement. Slower compared to YOLO. |

##### YOLO Algorithm
Steps in the YOLO Algorithm:
- Divide the cell into a grid of cells (ie <img src="./assets/eb5a93fa326763fa33cc7d6d7201470f.svg?sanitize=true&invert_in_darkmode" align=middle width=111.554685pt height=22.46574pt/>)
- Apply CNN to predict bounding boxes <img src="./assets/85e5a6bb85a9baa28e6e9a10f9373869.svg?sanitize=true&invert_in_darkmode" align=middle width=98.25931499999999pt height=24.65759999999998pt/> and class labels (combined into <img src="./assets/deceeaf6940a8c7a5a02373728002b0f.svg?sanitize=true&invert_in_darkmode" align=middle width=8.649300000000004pt height=14.155350000000013pt/>) \
    for each grid cell $g$
- Apply duplicate suppression (ie IoU, Non max suppression) to remove duplicate predictions.
- Profit.

> ![YOLO assigns only one cell for each item](./assets/convnets/yolo_assign_object_to_one_cell.png)
> Each object in an image is assigned only to cell where its mid point resides,
> even if parts of the image can reside in other cells.

Structure of the output of YOLO: Lumps the output for each  together.
- each grid cell <img src="./assets/3cf4fbd05970446973fc3d9fa3fe3c41.svg?sanitize=true&invert_in_darkmode" align=middle width=8.430510000000004pt height=14.155350000000013pt/>  yields <img src="./assets/deceeaf6940a8c7a5a02373728002b0f.svg?sanitize=true&invert_in_darkmode" align=middle width=8.649300000000004pt height=14.155350000000013pt/>:
- <img src="./assets/deceeaf6940a8c7a5a02373728002b0f.svg?sanitize=true&invert_in_darkmode" align=middle width=8.649300000000004pt height=14.155350000000013pt/> combined together  for each <img src="./assets/3cf4fbd05970446973fc3d9fa3fe3c41.svg?sanitize=true&invert_in_darkmode" align=middle width=8.430510000000004pt height=14.155350000000013pt/> cell yields: <img src="./assets/751798b262a6d850eb341d9efbae90ca.svg?sanitize=true&invert_in_darkmode" align=middle width=97.33317pt height=24.65759999999998pt/>:
<p align="center"><img src="./assets/cadf10a78eeef199ae12d51896323049.svg?sanitize=true&invert_in_darkmode" align=middle width=138.44259pt height=69.041775pt/></p>

> Lumping the output together is advantageous as it allows us to produce predictions
> for all grid cells <img src="./assets/3cf4fbd05970446973fc3d9fa3fe3c41.svg?sanitize=true&invert_in_darkmode" align=middle width=8.430510000000004pt height=14.155350000000013pt/> at once, instead of one at a time. This improves computing speed 
> (YOLO works for real time detection).

###### YOLO: Bounding Box Encoding
Bounding box <img src="./assets/85e5a6bb85a9baa28e6e9a10f9373869.svg?sanitize=true&invert_in_darkmode" align=middle width=98.25931499999999pt height=24.65759999999998pt/> is encoded in terms of the cell:
- <img src="./assets/b9235037339418f81f23d206ea198636.svg?sanitize=true&invert_in_darkmode" align=middle width=36.771405pt height=22.831379999999992pt/> is the centre of the object encoded as a fraction of the grid cell's dimensions
- <img src="./assets/471535c37fb35ba149cad1c9b069ad65.svg?sanitize=true&invert_in_darkmode" align=middle width=39.75279pt height=22.831379999999992pt/> is the size of the object encoded as a fraction of the grid cell's dimensions 
    (can $\gt 1$ if object larger than grid cell.

###### YOLO: Suppressing Bounding Box duplicates
Methods used by YOLO to remove Bounding Box duplicates:
- Intersection over union (**IoU**) over some threshold: <img src="./assets/d09d9524178ecad83cfb9cde1fa6ebf2.svg?sanitize=true&invert_in_darkmode" align=middle width=42.33933pt height=29.223809999999993pt/> 
    - $A_I$ is the area of intersection between the bounding boxes
    - $A_U$ is the area of union between the bounding boxes
- Non max suppression
    - discard bounding boxes with $P_c$ \lt 0.6$
    - select a bounding box $B$ with the highest $P_c$ for prediction
    - discard any other bounding box  with high _IoU_ with $B$

##### YOLO: Anchor boxes
![YOLO Anchorbox](./assets/convnets/yolo_anchorbox.png)

Anchor boxes allow multiple objects within the same grid cell:
- assumption: object within the same grid cell typically have different shapes
- assign an object to an anchorbox if the <img src="./assets/1df7055d0838cc7b82fa194fd5cc4639.svg?sanitize=true&invert_in_darkmode" align=middle width=29.500020000000003pt height=22.46574pt/> is high.
- since each object is assigned to a different (grid, anchorbox) combination,
    muliple objects can be detected per anchorbox.

Structure of the output with anchorbox:

![YOLO Anchorbox outputs](./assets/convnets/yolo_anchorbox_outputs.png)
- For each anchorbox <img src="./assets/44bc9d542a92714cac84e01cbbb7fd61.svg?sanitize=true&invert_in_darkmode" align=middle width=8.689230000000004pt height=14.155350000000013pt/>, we introduce a new <img src="./assets/deceeaf6940a8c7a5a02373728002b0f.svg?sanitize=true&invert_in_darkmode" align=middle width=8.649300000000004pt height=14.155350000000013pt/>

##### YOLO: Structure of Outputs

Structure of the output of YOLO
- each (grid cell, anchorbox) combination yields <img src="./assets/deceeaf6940a8c7a5a02373728002b0f.svg?sanitize=true&invert_in_darkmode" align=middle width=8.649300000000004pt height=14.155350000000013pt/>:
<p align="center"><img src="./assets/942ae81355b136ced9b69adffc244229.svg?sanitize=true&invert_in_darkmode" align=middle width=73.18146pt height=187.39875pt/></p>
- <img src="./assets/deceeaf6940a8c7a5a02373728002b0f.svg?sanitize=true&invert_in_darkmode" align=middle width=8.649300000000004pt height=14.155350000000013pt/> combined together  for each <img src="./assets/3cf4fbd05970446973fc3d9fa3fe3c41.svg?sanitize=true&invert_in_darkmode" align=middle width=8.430510000000004pt height=14.155350000000013pt/> cell yields: <img src="./assets/4ddc890567fffa82594bf5cf96fbedd7.svg?sanitize=true&invert_in_darkmode" align=middle width=129.753195pt height=24.65759999999998pt/>
    - $n(y)$ no. of values for each $y$ column vector.
    - $A$ - no. of anchorboxes.
    - $G$ - dimensions of the grid.

## CNN Applications: Facial Recognition
Facial Recognition subproblems:
- face verification - output whether the input image is an image a a certain given person.
- face recognition - output which person the input image is from a database of person images.

> Face recongnition is much more difficul than verification as its the database of person images can be quite large.
> However we can use face verification as a building block to build a face recognition system.

### One Shot Learning
In One Shot Learning, the model has to make predictions train only one data example:
- In the context of facial recongnition, the model has to predict the person given only image of person to learn.

Example: Facial Recongnition system for Employee clock info
Simple but unscalable solution: Build a CNN with a Softmax layer that predicts the probablity of
an image being an certain employee:
- requires the CNN to be retrained when a new employee
- not enough training data to train the CNN is suffcient predictive performance.

Solution: Train a CNN to learn a facial simliarity function <img src="./assets/590914eebb613d26eea35495701c226a.svg?sanitize=true&invert_in_darkmode" align=middle width=57.84834pt height=24.65759999999998pt/> which
represents the degree of difference between images.
- <img src="./assets/35c40be16a2f2788993b8dac15d945e2.svg?sanitize=true&invert_in_darkmode" align=middle width=66.89529pt height=24.65759999999998pt/> where <img src="./assets/0fe1677705e987cac4f589ed600aa6b3.svg?sanitize=true&invert_in_darkmode" align=middle width=9.046950000000002pt height=14.155350000000013pt/> is threshold, output not the same person
- <img src="./assets/912b19a477fa9cfcd5c553241d83a0bf.svg?sanitize=true&invert_in_darkmode" align=middle width=66.89529pt height=24.65759999999998pt/> output the same person

> This allows us to address the one shot learning problem as we don't need
> to need retrain the CNN when we add an employee and only need one image
> of employeee to make recongnition recongnise the employee

### Siamese Network
Siamese Networks use:
- an neural network encoder to convert the input to some embedding representation
- compares the embeddings to make for of prediction.

In the context of our facial recongnition example (DeepFace):
- train a NN to take in an input image <img src="./assets/ad769e751231d17313953f80471b27a4.svg?sanitize=true&invert_in_darkmode" align=middle width=24.320010000000003pt height=29.19113999999999pt/> and outputs encoding <img src="./assets/5cdfbe6f73318323418d6b82e4e96dc9.svg?sanitize=true&invert_in_darkmode" align=middle width=40.530105000000006pt height=29.19113999999999pt/>
![Facial Encoding CNN](./assets/convnets/face_recongnition_encoding_cnn.png)
- train NN such that encoding <img src="./assets/5cdfbe6f73318323418d6b82e4e96dc9.svg?sanitize=true&invert_in_darkmode" align=middle width=40.530105000000006pt height=29.19113999999999pt/> satisfy the following conditions:
    - for $x^{(i)}$ &amp; $x^{(j)}$ are images of the same person: 
        $(f(x^{(i)}- f(x^{(j)}))^2$ should be small
    - for $x^{(i)}$ &amp; $x^{(j)}$ are images of the same person: 
        $(f(x^{(i)}- f(x^{(j)}))^2$ should be large

#### Cost Objective: Triplet Loss Function
Triplet Loss Function <img src="./assets/8eb543f68dac24748e65e2e4c5fc968c.svg?sanitize=true&invert_in_darkmode" align=middle width=10.696455000000004pt height=22.46574pt/>:
- compare a triplet of images
    - one _anchor_, $A$ image
    - one _postive_, $P$ image: same person as the anchor image.
    - one _negative_, $N$ image: different person as the anchor image
-  we want neural network encoding <img src="./assets/190083ef7a1625fbc75f243cffb9c96d.svg?sanitize=true&invert_in_darkmode" align=middle width=9.817500000000004pt height=22.831379999999992pt/> to converge to:
    - $(f(A) - f(P))^2$ should be small ie distance $d(A, P)$ between positive images
    - $(f(A) - f(N))^2$ should be large ie distance $d(A, N)$ between negative images
- we can combine both objectives as follows:
    - $(f(A) - f(P))^2 - (f(A) - f(N))^2 \lt 0$
- however this allows the CNN to cheat by outputting <img src="./assets/ec7159ee30bf1eeea1c5cbdfe1122df0.svg?sanitize=true&invert_in_darkmode" align=middle width=138.09938999999997pt height=24.65759999999998pt/>, hence we add a constant margin <img src="./assets/c745b9b57c145ec5577b82542b2df546.svg?sanitize=true&invert_in_darkmode" align=middle width=10.576500000000003pt height=14.155350000000013pt/>
    - $(f(A) - f(P))^2 - (f(A) - f(N))^2 + \alpha \lt 0$
    - $\alpha$ pushes $d(A,P)$ and $d(A,N)$ away from each other.
- Hence the final Triplet loss function <img src="./assets/8eb543f68dac24748e65e2e4c5fc968c.svg?sanitize=true&invert_in_darkmode" align=middle width=10.696455000000004pt height=22.46574pt/> is defined as:
<p align="center"><img src="./assets/59bc87a604966e75ff02d7a33cd302c3.svg?sanitize=true&invert_in_darkmode" align=middle width=616.1842499999999pt height=44.897324999999995pt/></p>

Gotchas with triplet loss:
- triplets (<img src="./assets/6bd1a205a43b3f46880b0e85ed3b75dd.svg?sanitize=true&invert_in_darkmode" align=middle width=52.95081pt height=22.46574pt/>) cannot be chosen randomly
- Choose tripets that are _hard_ to train on which implies:
    $d(A,P) \approx d(A,N)$

> Data size required for training a good images: in the millions

### Facial Reconigtion system
Facial Reconigtion System:
- use encoding CNN <img src="./assets/d1aaca1439d04817c7eb76677044cdc7.svg?sanitize=true&invert_in_darkmode" align=middle width=47.74473pt height=29.19113999999999pt/> to transform images A, B into encodings
- feed the encoding into a simple model (ie logistic regression) to predict if same person

> One possible optimisation is to precompute the encoding in the database, 
> which can save computation time.

## CNN Applications: Neural Style Transfer
Given a content image <img src="./assets/9b325b9e31e85137d1de765f43c0f8bc.svg?sanitize=true&invert_in_darkmode" align=middle width=12.924780000000005pt height=22.46574pt/> and style image <img src="./assets/e257acd1ccbe7fcb654708f1a866bfe9.svg?sanitize=true&invert_in_darkmode" align=middle width=11.027445000000004pt height=22.46574pt/> generate an image <img src="./assets/e257acd1ccbe7fcb654708f1a866bfe9.svg?sanitize=true&invert_in_darkmode" align=middle width=11.027445000000004pt height=22.46574pt/> which
combines the content of <img src="./assets/9b325b9e31e85137d1de765f43c0f8bc.svg?sanitize=true&invert_in_darkmode" align=middle width=12.924780000000005pt height=22.46574pt/> and the style <img src="./assets/e257acd1ccbe7fcb654708f1a866bfe9.svg?sanitize=true&invert_in_darkmode" align=middle width=11.027445000000004pt height=22.46574pt/>:

![Neural Style Transfer](./assets/convnets/neural_style_transfer.png)

### What are CNN layers learning
What the hidden units in the hidden layers of the CNN are learning:
- to find this we run the trained hidden unit over the input patches
- select the image patches that maximise the activation value.
- each layer's hidden units learn progressively more complex concepts (ie line <img src="./assets/e49c6dac8af82421dba6bed976a80bd9.svg?sanitize=true&invert_in_darkmode" align=middle width=16.438455000000005pt height=14.155350000000013pt/> dog)

![Learning in Each Layer of a CNN](./assets/convnets/cnn_learning_in_diff_layers.png)

### Neural Style Transfer Algorithm
Neural Style Transfer Algorithm:
1. Init <img src="./assets/5201385589993766eea584cd3aa6fa13.svg?sanitize=true&invert_in_darkmode" align=middle width=12.924780000000005pt height=22.46574pt/> to random values
2. Use gradient descent/other optimisation methods to optimise <img src="./assets/a8e63435479d59ae289d97fd6e8ecf67.svg?sanitize=true&invert_in_darkmode" align=middle width=36.406425pt height=24.65759999999998pt/>

### Neural Style: Objective/Cost Function
Objective/Cost Function <img src="./assets/a8e63435479d59ae289d97fd6e8ecf67.svg?sanitize=true&invert_in_darkmode" align=middle width=36.406425pt height=24.65759999999998pt/> measures:
- the match between the content of <img src="./assets/9b325b9e31e85137d1de765f43c0f8bc.svg?sanitize=true&invert_in_darkmode" align=middle width=12.924780000000005pt height=22.46574pt/> and <img src="./assets/5201385589993766eea584cd3aa6fa13.svg?sanitize=true&invert_in_darkmode" align=middle width=12.924780000000005pt height=22.46574pt/>
- the match between the style of <img src="./assets/e257acd1ccbe7fcb654708f1a866bfe9.svg?sanitize=true&invert_in_darkmode" align=middle width=11.027445000000004pt height=22.46574pt/> and <img src="./assets/5201385589993766eea584cd3aa6fa13.svg?sanitize=true&invert_in_darkmode" align=middle width=12.924780000000005pt height=22.46574pt/>

<p align="center"><img src="./assets/0fcd16f429ead544aadacbc2f997ee30.svg?sanitize=true&invert_in_darkmode" align=middle width=280.68314999999996pt height=17.031959999999998pt/></p>

> By convention of the original paper, the are two hyperparameters: <img src="./assets/c745b9b57c145ec5577b82542b2df546.svg?sanitize=true&invert_in_darkmode" align=middle width=10.576500000000003pt height=14.155350000000013pt/> &amp; <img src="./assets/8217ed3c32a785f0b5aad4055f432ad8.svg?sanitize=true&invert_in_darkmode" align=middle width=10.165650000000005pt height=22.831379999999992pt/>

#### Content Cost/Loss Function
Content cost function <img src="./assets/a7ea8a006472f16af5e363c6c92c3a83.svg?sanitize=true&invert_in_darkmode" align=middle width=99.74827499999999pt height=24.65759999999998pt/> is defined:
- sample <img src="./assets/b8fb9b6f8aa91875998e314d6703c369.svg?sanitize=true&invert_in_darkmode" align=middle width=20.76723pt height=22.46574pt/> and <img src="./assets/ac800bcf8def491e8d07d67c0dd8ca35.svg?sanitize=true&invert_in_darkmode" align=middle width=21.943020000000004pt height=22.46574pt/> from a hidden layer <img src="./assets/ddcb483302ed36a59286424aa5e0be17.svg?sanitize=true&invert_in_darkmode" align=middle width=11.187330000000003pt height=22.46574pt/> of pretrained CNN (ie VGG)
    after passing raw images $C$ and $G$ in as input respectively.

<p align="center"><img src="./assets/69787157e8df9e151f31d710db430fb3.svg?sanitize=true&invert_in_darkmode" align=middle width=217.61354999999998pt height=32.9901pt/></p>


Content cost function <img src="./assets/fd710a2703722fad683d29854b50e870.svg?sanitize=true&invert_in_darkmode" align=middle width=119.1663pt height=24.65759999999998pt/> is defined:
- sample <img src="./assets/b8fb9b6f8aa91875998e314d6703c369.svg?sanitize=true&invert_in_darkmode" align=middle width=20.76723pt height=22.46574pt/> and <img src="./assets/ac800bcf8def491e8d07d67c0dd8ca35.svg?sanitize=true&invert_in_darkmode" align=middle width=21.943020000000004pt height=22.46574pt/> from a hidden layer <img src="./assets/ddcb483302ed36a59286424aa5e0be17.svg?sanitize=true&invert_in_darkmode" align=middle width=11.187330000000003pt height=22.46574pt/> of pretrained CNN (ie VGG)
    after passing raw images $C$ and $G$ in as input respectively.

#### Style Cost/Loss Function
Style cost function <img src="./assets/b17b6adf1267837b75fbc35a14d73f6d.svg?sanitize=true&invert_in_darkmode" align=middle width=83.674965pt height=24.65759999999998pt/> is defined:
- calculate _style_ matrix by correlating feature values across channels for both <img src="./assets/ac800bcf8def491e8d07d67c0dd8ca35.svg?sanitize=true&invert_in_darkmode" align=middle width=21.943020000000004pt height=22.46574pt/> and <img src="./assets/59bbc09edc168196d7161275f4b53b4d.svg?sanitize=true&invert_in_darkmode" align=middle width=19.098255000000005pt height=22.46574pt/>
- compare the the correations between <img src="./assets/ac800bcf8def491e8d07d67c0dd8ca35.svg?sanitize=true&invert_in_darkmode" align=middle width=21.943020000000004pt height=22.46574pt/> to <img src="./assets/59bbc09edc168196d7161275f4b53b4d.svg?sanitize=true&invert_in_darkmode" align=middle width=19.098255000000005pt height=22.46574pt/> to compare _style_ via normlise square difference.

Example of intution of how style can be approx. by correlation: Vincent Van Gogh's Stary night
- one channel might detect the swirly curls
- one channel might detect white blue colors
- correlation between the two channel might represents his style of displaying swirls and white/blue colors.

![Vincent Van Gogh's Curls](.assets/convnets/cnn_art_style_correlation_representation.png)

Calculating style matrix <img src="./assets/fbfa57ccf216842aef9faf9b8965d2b7.svg?sanitize=true&invert_in_darkmode" align=middle width=45.86439000000001pt height=22.46574pt/> from activation of input <img src="./assets/21fd4e8eecd6bdf1a4d3d6bd1fb8d733.svg?sanitize=true&invert_in_darkmode" align=middle width=8.515980000000004pt height=22.46574pt/> in hidden layer <img src="./assets/ddcb483302ed36a59286424aa5e0be17.svg?sanitize=true&invert_in_darkmode" align=middle width=11.187330000000003pt height=22.46574pt/>, <img src="./assets/47b99861bb0cacbebd353c90c39c30c2.svg?sanitize=true&invert_in_darkmode" align=middle width=16.244415000000004pt height=22.46574pt/>:
<p align="center"><img src="./assets/7464aae1b0bd2857a7468611324650ed.svg?sanitize=true&invert_in_darkmode" align=middle width=279.24105pt height=47.32662pt/></p>
where <img src="./assets/3e18a4a28fdee1744e5e3f79d13b9ff6.svg?sanitize=true&invert_in_darkmode" align=middle width=7.113876000000004pt height=14.155350000000013pt/> &amp; <img src="./assets/3ce681234d1b2ad17008503143e3ed8b.svg?sanitize=true&invert_in_darkmode" align=middle width=10.903860000000005pt height=24.716340000000006pt/> are different combinations of pairs of different channels.

> Formally <img src="./assets/3df3a5241b9eea4e3ea2c2ce0fc9b7b1.svg?sanitize=true&invert_in_darkmode" align=middle width=55.30833pt height=24.65759999999998pt/> is called unormalised correlation/gram matrix.

Style cost function <img src="./assets/f9b60d5eac786b25b541bbb6922147f1.svg?sanitize=true&invert_in_darkmode" align=middle width=103.09299pt height=24.65759999999998pt/>:
<p align="center"><img src="./assets/e96713558db40dabc2376d563ebdf4ee.svg?sanitize=true&invert_in_darkmode" align=middle width=483.83774999999997pt height=35.455859999999994pt/></p>
