# Predicting Facial Beauty using Computer Vision

## Traditional Machine Learning Approach   

#### Feature Generation
The features computation part of the pipeline requires the location of facial landmars of the input images. I have already included the landmarks localized in the data directory of this repo, and you can directly work with them. 

Example of extracting facial features: 

#### Dimensionality Reduction, ML Models, and Evaluation 

```shell
python trainModel -model linear_model -featuredim 20
```

The `-featuredim` argument specifies the number of components chosen by PCA which are how many dimensions to be reduced. 

<!--- After PCA, the `-model` argument is used to indicate the traditional machine learning models including Support Vector Machines (`svm`), Random Forests (`rf`), and Gaussian Process Regression (`gpr`). Checkout the source to change hyperparameters and other options. ---!>

## Requirements
- Python 2.7
- numpy 
- pandas
- scikit-learn

### Dataset
The [SCUT-FBP](http://www.hcii-lab.net/data/SCUT-FBP/EN/introduce.html) dataset has been used. Please cite their research if you happen to use this dataset. The facial landmarks computer on this particular dataset are available in the `data/` directory. 

### License
Creative Commons V1.0
