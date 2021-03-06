# Notes
*10/10 very creative name I know*

This repository collects some notes from my attempts (with varying levels of success) 
to learn things through courses, books, websites and video lectures
- the notes are NOT market substitutes of the actual referenced material 
  (ie some content may be obmitted)

> Rights & Content included in these notes  belongs to the their respective original  authors. 
> Go show them some :heart: by buying their book/course/viewing their site/
> watching their videos etc.

## Contents
Table of contents  by Topic:
- Data Science

| Topic | References | Status |
| --- | --- | --- |
| [Machine Learning](build/data_science/hands_on_ml/hands_on_ml.md) | [Hands-On Machine Learning with Scikit-Learn, Keras, and TensorFlow](https://www.oreilly.com/library/view/hands-on-machine-learning/9781492032632/) | WIP |
| [Deep Learning](build/data_science/deep_learning_ai/deep_learning.md) | [Deep Learning.ai Course on Deep Learning](https://www.coursera.org/learn/neural-networks-deep-learning) | Only a tiny part available |
| [Structuring ML Projects](build/data_science/deep_learning_ai/structuring_ml_projects.md) | [Deep Learning.ai Course on Structuring ML Projects](https://www.coursera.org/learn/machine-learning-projects) | Done |
| [Convolutional Neural Networks](build/data_science/deep_learning_ai/convolution_neural_nets.md) | [Deep Learning.ai Course on Convolution Neural Networks](https://www.coursera.org/learn/convolutional-neural-networks) | WIP |
| [Reinforcement Learning](build/data_science/deep_lizard/reinforcement_learning.md) | Notes heavily derived from [Deep Lizards RL series](https://deeplizard.com/learn/playlist/PLZbbT5o_s2xoWNVdDudn51XM8lOuZ_Njv) and this [Medium Article](https://towardsdatascience.com/introduction-to-reinforcement-learning-markov-decision-process-44c533ebf8d) | WIP |


- Data Engineering

| Topic | References | Status |
| --- | --- | --- |
| [SQL](build/data_engineering/sql/sql.md) | [Mode tutorial on SQL](https://mode.com/sql-tutorial/introduction-to-sql) | WIP |
| [Data-Intensive Applications](build/data_engineering/data_intense_apps/data_apps.md) | [Designing Data-Intensive Applications](https://www.oreilly.com/library/view/designing-data-intensive-applications/9781491903063/) | WIP |


- Software Developemnt

| Topic | References | Status |
| --- | --- | --- |
| [Scala](build/software_dev/scala_impatient/scala.md) | [Scala for the Impatient](https://horstmann.com/scala/) &amp; [Twitter's Scala School]( https://twitter.github.io/scala_school/ ) | WIP |
| [React Native](build/software_dev/react_native/react_native.md) | [Official Tutorial](http://reactnative.dev/docs/tutorial) on React Native [Redux Documentation](https://redux.js.org/), [React Navigation Documentation](https://reactnavigation.org/) | Mostly Done |
| [Go Microservices](build/software_dev/gomicro/go_microservices.md) | [Ewan Valentine's Tutorial](https://ewanvalentine.io/microservices-in-golang-part-1/) | WIP |
| [Nand2Tetris Part 1](build/software_dev/nand2tetris/nand2tetris_1.md) | [Nand2Tetris Part 1 Course](https://www.coursera.org/learn/build-a-computer)/[The Elements of Computing Systems](https://mitpress.mit.edu/books/elements-computing-systems-second-edition)| Done |
| [Django](build/software_dev/django/django.md) | [Quick Django Refresher Crash Course](https://build.vsupalov.com/quick-django-refresher-crash-course/) &amp; Official Django Tutorials | WIP |

- Cloud Native/Devops

| Topic | References | Status |
| --- | --- | --- |
| [Kubernetes](build/cloud_native/k8s_in_action/k8s.md) | [Kubernetes in Action](https://www.manning.com/books/kubernetes-in-action)  | Mostly done |
| [Terraform](build/cloud_native/terraform/terraform.md) | [Terraform: Up &amp; Running](https://www.terraformupandrunning.com/) | Mostly Done |
| [Prometheus](build/cloud_native/prometheus/prometheus.md) | [Official Documentation](https://prometheus.io.) | Done |


- Data Analytics:

| Topic | References | Status |
| --- | --- | --- |
| [Microsoft Excel](build/data_analytics/ms_excel/excel.md) | [Video Tutorial on Excel by edureka!](https://www.youtube.com/watch?v=RdTozKPY_OQ) and Microsoft Excel documentation. | WIP | 

## Building
Since Github does not support embedded latex in markdown, the notes are
regenerated with [readme2tex](https://github.com/leegao/readme2tex)
1. Install `readme2tex` and its dependencies
2. Run `make`
