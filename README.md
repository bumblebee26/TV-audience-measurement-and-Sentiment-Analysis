# TV audience measurement and Sentiment Analysis
A smart system which measures the television audience as well as provides valuable insights about the viewers to the channel providers.

**Features**
1. Check the authenticity of the channels
2. Total viewers watching the channel/program
3. Viewer’s demographic information like
> * Total members in a family
> * Gender
> * Age
> * Emotion

### Work Flow of the product
<p align="center">
  <img src="Other%20data/product_model.jpeg" alt="Flow diagram" title="Working model of the project" width="400" height="500" />
</p>

### Authentication of Channels via digital watermarking
Digital Video Watermarking the channel provider content with hidden watermark and extracting it to check its authenticity and report malicious activities
<p align="center">
  <img src="Other%20data/watermark_results/Channel%20Logo.png" title="Channel Logo" width="300" height="300" />
</p>

##### Watermarking Demo
[Watermarking Demo](http://www.youtube.com/watch?v=t-Om9ugJwDQ)

![](Other%20data/ezgif.com-video-to-gif(1).gif "Digital Watermarking Output")

##### Checking the Robustness of the watermark with attacks
<p align="center">
  <img width="300" height="300" src="Other%20data/watermarking_authentication.png">
</p>

<table>
  <tr>
    <td>Gaussian Noise | PSNR = 65.88</td>
    <td>Salt and Pepper Noise | PSNR = 69.4819</td>
  </tr>
  <tr>
    <td><img src="Other%20data/watermark_results/gaussian.png" title="Guassian Noise" width="400" height="250"/></td>
    <td><img src="Other%20data/watermark_results/saltnpepper.png" title="Salt and Pepper Noise" width="400" height="250"/></td>
  </tr>
 </table>
 <table>
  <tr>
     <td>Cropping | PSNR = 37.3145</td>
     <td>Sharpening | PSNR = 71.3505</td>
  </tr>
  <tr>
    <td><img src="Other%20data/watermark_results/cropping.png" title="Cropping" width="400" height="250"/></td>
    <td><img src="Other%20data/watermark_results/sharpening.png" title="Sharpening effect" width="400" height="250"/></td>
  </tr>
 </table>
 </table>
 <table>
  <tr>
     <td>Histogram Equalization | PSNR = 49.0789</td>
     <td>Intensity Adjustment | PSNR = 68.2943</td>
  </tr>
  <tr>
    <td><img src="Other%20data/watermark_results/histogram.png" title="Histogram Equalization" width="400" height="250"/></td>
    <td><img src="Other%20data/watermark_results/intensityadj.png" title="Intensity Adjustment" width="400" height="250"/></td>
  </tr>
 </table>


### Viewer's Demographic Data Collection
The smart meter consists of a camera which captures the viewers in front of the television. This captured frames are passed through the recognition software that detects gender, age and emotion of the viewer.

[Facial Emotion Recognition Dataset](https://www.kaggle.com/virenbr11/fer-dataset)

[FER dataset training on Kaggle](https://www.kaggle.com/virenbr11/emotion-detection)

##### Age, Gender and Emotion Recognition Demo
[Age, Gender and Emotion Recognition Demo](http://www.youtube.com/watch?v=cXv5vLklFic)

![](Other%20data/ezgif.com-video-to-gif(2).gif "Recognition Output")

[Collected Viewer's Data](https://github.com/bumblebee26/TV-audience-measurement-and-Sentiment-Analysis/blob/master/Age%2C%20Gender%20and%20Emotion%20Recognition/People's%20meter%20data.csv)

### Data Visualization
A website running on the local server, where the measurement authority can login and check the visualizations.

<p align="center">
  <img width="800" height="500" src="Other%20data/website_1.png">
</p>
<p align="center">
  <img width="800" height="500" src="Other%20data/website_2.png">
</p>


## Other Authors
[Yogesh Deshpande](https://www.linkedin.com/in/yogesh21deshpande/)

[Akshay Bhogan](https://www.linkedin.com/in/akshay-bhogan-b13a7870/)
