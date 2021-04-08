import numpy as np

from sklearn import decomposition
from sklearn import linear_model
from sklearn.ensemble import RandomForestRegressor
from sklearn import svm
from sklearn import gaussian_process
from sklearn.metrics import r2_score, mean_absolute_error, mean_squared_error

## read data
features = np.loadtxt('data/features_ALL.txt', delimiter=',')
ratings = np.loadtxt('data/ratings.txt', delimiter=',')
predictions = np.zeros(ratings.size);

for i in range(0, 500):
	features_train = np.delete(features, i, 0)
	features_test = features[i, :]
	ratings_train = np.delete(ratings, i, 0)
	ratings_test = ratings[i]
	pca = decomposition.PCA(n_components=20)
	pca.fit(features_train)
	features_train = pca.transform(features_train)
	features_test = pca.transform(features_test)
	regr = linear_model.LinearRegression()
	regr.fit(features_train, ratings_train)
	predictions[i] = regr.predict(features_test)
	print('number of models trained:', i+1)

np.savetxt('results/cross_valid_predictions.txt', predictions, delimiter=',', fmt = '%.04f')

corr = np.corrcoef(predictions, ratings)[0, 1]
print(corr)

r2 = r2_score(ratings_test,ratings_predict)
print('R2 Score:', r2)

rmse=np.sqrt(mean_squared_error(ratings_predict, ratings_test))
print('RMSE: ', rmse)

mse=mean_squared_error(ratings_predict, ratings_test)
print('MSE: ',mse)

mae=mean_absolute_error(ratings_test, ratings_predict)
print('MAE: ', mae)
