from scipy.stats import chi2_contingency
import numpy as np
import pandas as pd
from sklearn.metrics import confusion_matrix, accuracy_score, recall_score, precision_score, f1_score


# Utilizzo il Coefficiente di Cramer per verificare se esite un' associazione tra due variabili categoriche basata sul test chi-quadrato di indipendenza
def cramers_v(x, y):
    confusion_matrix = pd.crosstab(x, y)
    chi2, _, _, _ = chi2_contingency(confusion_matrix)
    n = confusion_matrix.sum().sum()
    phi2 = chi2 / n
    r, k = confusion_matrix.shape
    phi2corr = max(0, phi2 - ((k-1)*(r-1))/(n-1))    
    rcorr = r - ((r-1)**2)/(n-1)
    kcorr = k - ((k-1)**2)/(n-1)
    return np.sqrt(phi2corr / min((kcorr-1), (rcorr-1)))


def classification_report(y_true, y_pred):
  
  return (accuracy_score(y_true, y_pred), precision_score(y_true, y_pred, zero_division='warn'), recall_score(y_true, y_pred) ) 


def get_coeff_logistic_regression(model, df):

  coefficients = model.coef_[0]

  feature_names = df.drop(columns="Response", axis=1).columns

  feature_importance = pd.DataFrame(data=coefficients, index=feature_names, columns=['Coefficient'])

  feature_importance['Absolute_Coefficient'] = feature_importance['Coefficient'].abs()

  feature_importance = feature_importance.T

  absolute_coefficients = feature_importance.loc[['Absolute_Coefficient'], :]

  absolute_coefficients = absolute_coefficients.rename(index={ 'Absolute_Coefficient': None })

  return absolute_coefficients
