# C spine fracture detection

## The problem
A sizeable number of hospital visitors suffer from injuries of the cervical spine. Fractures of which are a known cause of death and long term discomfort. As such I aimed to use various image processing techniques to make recognizing these fractures as easy as possible. 

## The work
First I took a dataset from KAGGLE which contained numerous images of CT scans of the cervical spine some with fractures some without. The pictures from this dataset were then selected randomly and some random noise was added to ensure the robustness of my techniques. 

After noise was added I went about engaging my techniques, which included a median filter to help clear the most egregious noise. THis was followed by using an opening technique to remove small unnecesarry aspects of the image to make fractures more readily noticable. Lastly a sobel filter was used to implement edge detection making any unnatural cracks very obvious to the human eye.

To follow with my course requirements for this project I implemented a simple LSTM neural network in MATLAB which used the k-folds training anda verification technique. resulting in a simple neural network which was able to accurately identify fractures 86.6% of the time
