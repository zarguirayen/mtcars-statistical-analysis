# 🚗 Statistical Analysis & Modeling — mtcars (R)

This project studies **car fuel consumption (mpg)** using the classic `mtcars` dataset.  
It includes **Exploratory Data Analysis**, **Multiple Linear Regression**, **Variable Selection (AIC)**, and **PCA + Principal Component Regression (PCR)**.

## 📌 Objectives
- Explore relationships between car technical features and fuel efficiency (**mpg**)
- Build regression models to predict fuel consumption
- Compare:
  - Full multiple regression vs reduced model (AIC stepwise)
  - Classical regression vs PCR (PCA-based regression)

## 🔍 Main Steps
✅ **Exploratory Data Analysis (EDA)**
- Summary statistics, distributions (histograms)
- Scatterplot matrix (`pairs`)
- Correlation matrix + visualization (`corrplot`)
- Boxplots

✅ **Multiple Linear Regression**
- Full model with all predictors
- Stepwise variable selection using **AIC**
- Residual diagnostics and comparison

✅ **PCA & PCR**
- PCA to reduce dimensionality
- Interpretation of explained variance
- Regression on first principal components
- Model comparison using **ANOVA**

## 🛠 Tools & Libraries
- R
- readr, ggplot2, gridExtra
- FactoMineR, corrplot
- MASS (stepAIC)
- pls

## 📂 Repository Content
- `src/` → R scripts
- `data/` → dataset (mtcars.csv)
- `report/` → PDF report with methodology and results

## 🚀 How to Run
1. Clone the repo:
```bash
git clone https://github.com/zarguirayen/mtcars-statistical-analysis.git
