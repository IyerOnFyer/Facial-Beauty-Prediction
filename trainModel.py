import argparse
import numpy as np
import matplotlib.pyplot as plt

from sklearn import decomposition
from sklearn import linear_model, svm
from sklearn.neural_network import MLPRegressor
from sklearn.ensemble import RandomForestRegressor
from sklearn.tree import DecisionTreeRegressor
from sklearn import gaussian_process, neighbors
from sklearn.metrics import r2_score, mean_squared_error, mean_absolute_error
from sklearn.preprocessing import PolynomialFeatures

parser = argparse.ArgumentParser()
parser.add_argument('-model', type=str, default='linear_model')
parser.add_argument('-featuredim', type=int, default=1)
parser.add_argument('-inputfeatures', type=str, default='data/features_ALL.txt')
parser.add_argument('-labels', type=str, default='data/ratings.txt')
args = parser.parse_args()


features = np.loadtxt(args.inputfeatures, delimiter=',')
#features = preprocessing.scale(features)
features_train = features[0:-51]
features_test = features[-51:-1]

test = features[-1]

pca = decomposition.PCA(n_components=args.featuredim)
pca.fit(features_train)
features_train = pca.transform(features_train)
features_test = pca.transform(features_test)

ratings = np.loadtxt(args.labels, delimiter=',')
#ratings = preprocessing.scale(ratings)
ratings_train = ratings[0:-50]
ratings_test = ratings[-50:]

if args.model == 'linear_model':
	regr = linear_model.LinearRegression()
elif args.model == 'rf':
	regr = RandomForestRegressor(n_estimators=50, random_state=0)
elif args.model == 'gpr':
	regr = gaussian_process.GaussianProcessRegressor(alpha=1e-10)
elif args.model == 'knn':
    regr = neighbors.KNeighborsRegressor(n_neighbors=30)
elif args.model == 'dt':
    regr = DecisionTreeRegressor(**{'random_state': 0, 'max_depth': 15, 'criterion': 'mse'})
elif args.model == 'svm':
    regr = svm.SVR()
elif args.model == 'ann':
    regr = MLPRegressor(hidden_layer_sizes=(1,),  activation='relu', solver='adam',    alpha=0.001,batch_size='auto',
               learning_rate='constant', learning_rate_init=0.01, power_t=0.5, max_iter=1000, shuffle=True,
               random_state=None, tol=0.0001, verbose=False, warm_start=False, momentum=0.9,
               nesterovs_momentum=True, early_stopping=False, validation_fraction=0.1, beta_1=0.9, beta_2=0.999,
               epsilon=1e-08)
else:
	raise NameError('Unknown machine learning model. Please us one of: rf, svm, linear_model, gpr')

if(args.model=="linear_model"):
    model_name="Linear Regression"
elif(args.model=="rf"):
    model_name="Artificial Neural Network"
elif(args.model=="knn"):
    model_name="Artificial Neural Network"
elif(args.model=="ann"):
    model_name="Artificial Neural Network"

regr.fit(features_train, ratings_train)
ratings_predict = regr.predict(features_test)
corr = np.corrcoef(ratings_predict, ratings_test)[0, 1]
print('Correlation:', corr)

r2 = r2_score(ratings_test,ratings_predict)
print('R2 Score:', r2)

rmse=np.sqrt(mean_squared_error(ratings_predict, ratings_test))
print('RMSE: ', rmse)

mse=mean_squared_error(ratings_predict, ratings_test)
print('MSE: ',mse)

mae=mean_absolute_error(ratings_test, ratings_predict)
print('MAE: ', mae)

print(ratings_test)
print(ratings_predict)
plt.plot(ratings_test, ratings_predict, 'o')
m,b = np.polyfit(ratings_test, ratings_test, 1)
plt.plot(ratings_test, m*ratings_test+b)
plt.xlabel("Test Ratings")
plt.ylabel("Predicted Ratings")
plt.title(model_name)


plt.show()
