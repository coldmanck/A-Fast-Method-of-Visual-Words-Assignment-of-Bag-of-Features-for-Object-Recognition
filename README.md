# A-Fast-Method-of-Visual-Words-Assignment-of-Bag-of-Features-for-Object-Recognition
## Project overview
This repo is the experiment code of the extended abstract, M.-J. Chiou, T. Yamasaki and K. Aizawa, **"A Fast Method of Visual Words Assignment of Bag-of-Features for Object Recognition"**, *MIRU 15th*, July 2015. Please click here to [link](http://cvim.ipsj.or.jp//MIRU2015/) to see the conference website. 

## Introduction 
This paper deals with **object recognition** and **retrieval problems**, especially for large-scale pictures categorization. For these large-scale object recognition problems, high-speed processing is an important factor with respect to practicality. Extracting the features of query pictures is one of the most common processes for state-of-the-art strategies. However, it has been pointed out that feature extraction is one the most time-consuming parts in the object recognition problem. To deal with this problem, this paper introduces **a fast look-up table based method of finding bag-of-features-based indexes of query pictures, without conducting feature extraction**. The proposed look-up table consists of local patches (stored in a pixel form) and their corresponding visual words (assigned from the visual words codebook) of images. By this, the visual word is assigned to the query by retrieving the most similar patch in the database. In our experiment, we compared the proposed method with other common feature extraction methods. In addition, our experiment processes inherits MATLAB code of [ScSPM](http://www.ifp.illinois.edu/~jyang29/ScSPM.htm), while not using sparse coding but just amended to evaluate the proposed method.

## Notice
Please noted that because of size restrict (most of them are datasets and pictures), files in this repo are **not complete**. If you are interested in my work, or would like to see the complete extended abstract, please contact me: **coldmanck [AT] gmail.com** .

## Credit
- Under instruction of my supervisor, Toshihiko Yamasaki and Aizawa Kiyoharu, I did this work at [AIZAWA-YAMASAKI LAB](https://www.hal.t.u-tokyo.ac.jp/lab/), the University of Tokyo. 
- MATLAB code of SCSPM framework
