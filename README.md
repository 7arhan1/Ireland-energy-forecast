# Ireland-energy-forecast


This repository contains the code, datasets, models, and outputs for the MSc dissertation project:

Forecasting Monthly Wind and Solar Energy Generation in Ireland Using Time-Series and Machine Learning Models

## Project Overview

- The project tests how well different models can predict monthly wind and solar power generation in Ireland.  
- Models used: ARIMAX, SARIMAX, Extra Trees Regressor (ETR), NGBoost, Dynamic Harmonic Regression (DHR), and Bayesian baselines.  
- Data sources: SEAI, EirGrid, ERA5, and GADM.  
- The focus is on national monthly scale forecasting with capacity and meteorological drivers.  

## Evaluation

- Metrics used: MAE, RMSE, R², MAPE, CRPS (for NGBoost).  
- Interpretability is done using SHAP (bar plots, beeswarm, waterfall).  
- NGBoost also provides prediction intervals for uncertainty analysis.  

## Outputs

- Forecast vs actual plots for wind and solar.  
- Model comparison charts for accuracy.  
- SHAP plots to explain feature importance.  
- Prediction interval diagnostics for NGBoost.  
- Performance tables with all evaluation metrics.  

## Notes

- Raw datasets are included in the data/raw folder (small size).  
- Processed datasets are provided in the data/processed folder and are the exact versions used for model training.  
- Regional capacity data is used only in exploratory analysis (EDA) and not in model training.  
- All results are reproducible using the provided datasets, scripts, and models.  

## Repository Link

This project corresponds to the MSc dissertation submitted in August 2025 at Atlantic Technological University (ATU), Donegal.  

GitHub: https://github.com/7arhan1/Ireland-energy-forecast.git
