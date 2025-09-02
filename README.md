# Ireland Energy Forecast

This repository contains all code, datasets, models, and outputs for the MSc dissertation project:

**Forecasting Monthly Wind and Solar Energy Generation in Ireland Using Time-Series and Machine Learning Models**

---

## Project Overview

- **Goal:** To evaluate how time-series and machine learning models can predict monthly wind and solar power generation in Ireland.  

### Models
- **ARIMAX / SARIMAX**: statistical baselines with exogenous drivers.  
- **Extra Trees Regressor (ETR)**: ensemble machine learning benchmark.  
- **NGBoost**: probabilistic boosting with calibrated prediction intervals.  
- **Dynamic Harmonic Regression (DHR)** and **Bayesian approaches**: exploratory models for solar.  

### Data Sources
- **SEAI** – installed capacity and national generation statistics.  
- **EirGrid** – transmission system operator data.  
- **ERA5** – meteorological reanalysis (wind speed, radiation, temperature, cloud cover).  
- **GADM** – regional boundaries for exploratory maps.  

### Forecasting Scale
- National monthly resolution.  

### Train/Test Splits
- **Wind**: Train 2010–2022, Test 2023–2024.  
- **Solar**: Train Aug 2022–2023, Test 2024.  

--
## folder structure

```text
Ireland-energy-forecast/
│
├── data/
│   ├── raw/                       # Original datasets
│   └── processed/                 # Cleaned + engineered datasets
│
├── docs/                          # Reference summaries
│   ├── final_wind_data_summary.txt
│   └── solar_dataset_summary.txt
│
├── models/                        # Saved trained models (.joblib)
│   ├── ARIMAX_exog.joblib
│   ├── NGBoost_Wind.joblib
│   ├── ExtraTrees_Wind_Pruned.joblib
│   └── ... (other model files)
│
├── outputs/                       # Results
│   ├── comparison/
│   │   ├── Solar_comparison/
│   │   │   ├── option_A/
│   │   │   └── Solar_winner/
│   │   └── wind_comparison/
│   │
│   ├── logs/                      # All logs (CSV, JSON)
│   ├── solar/                     # Solar results
│   │   ├── figures/
│   │   ├── logs/
│   │   └── result_tables/
│   └── wind/                      # Wind results
│       ├── figures/
│       ├── logs/
│       └── result_tables/
│
├── scripts/                           # Scripts
│   ├── cleaning_and_merging/
│   │   ├── clean_energy_data.ipynb
│   │   ├── clean_solar_capacity_data.ipynb
│   │   ├── clean_weather_data_era5.ipynb
│   │   ├── clean_wind_capacity_data.ipynb
│   │   ├── extract_solar_radiation_era5.ipynb
│   │   ├── merge_nts_monthlycapacity.ipynb
│   │   └── regional_capacity_clean_merge.ipynb
│   │
│   ├── eda/
│   │   ├── eda_solar.ipynb
│   │   └── eda_wind.ipynb
│   │
│   ├── feature_engineering/
│   │   └── add_lags_rolling.ipynb
│   │
│   ├── train/
│   │   ├── arimax_train_solar.ipynb
│   │   ├── arimax_train_wind.ipynb
│   │   ├── ngboost_solar_train.ipynb
│   │   ├── ngboost_wind_train.ipynb
│   │   ├── train_etr_solar.ipynb
│   │   ├── train_etr_wind.ipynb
│   │   └── exploratory_solar_model.ipynb
│   │
│   ├── comparison/
│   │   └── model_comparison.ipynb
│   │
│   └── utils/
│       ├── __init__.py
│       ├── log_utils.py
│       └── map_plotting.R
│
├── README.md                      # Main GitHub guide

--

# Evaluation

- **Metrics:** MAE, RMSE, R², MAPE, CRPS (NGBoost only).  
- **NGBoost:** also evaluated for prediction interval width and coverage.  
- **Interpretability:** SHAP plots (summary bar, beeswarm, waterfall) used to identify feature importance.  

---

## Outputs

- Forecast vs actual plots for wind and solar.  
- Model comparison charts showing MAE, RMSE, and R² across models.  
- NGBoost confidence interval diagnostics.  
- SHAP plots highlighting key drivers (e.g. lag features, capacity, radiation, wind speed).  
- Performance tables summarising all results.  

---

## Notes

- Regional capacity variables were **retained only for exploratory analysis (EDA)**, not for model training, to avoid redundancy and multicollinearity.  
- Raw datasets are stored in `data/raw/` but may be excluded in some versions due to size.  
- Processed datasets in `data/processed/` are the final versions used for all model training and evaluation.  
- All results are reproducible from the datasets, notebooks, and models provided.  

---
## Repository Link

This repository corresponds to the MSc dissertation submitted in **August 2025** at **Atlantic Technological University (ATU), Donegal**.  

GitHub: [Ireland-energy-forecast](https://github.com/7arhan1/Ireland-energy-forecast.git)
