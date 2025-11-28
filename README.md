# Bayesian Modeling of Highway Traffic Volume

A comparative study of Bayesian approaches for modeling and predicting traffic volume on the I-94 highway in Minneapolis-St Paul, MN. This project explores both ordinary and hierarchical Bayesian inference methods to develop adaptive traffic flow prediction models.

## 📋 Project Overview

Traffic systems are complex and dynamic, influenced by numerous unpredictable factors such as weather conditions and human behavior. This project addresses the challenge of constructing adaptive models for traffic flow prediction using Bayesian statistical methods.

### Key Features

- **Ordinary Bayesian Inference**: Direct estimation of average hourly traffic volume using Poisson likelihood with Gamma prior
- **Hierarchical Bayesian Inference**: Weather-stratified model capturing hierarchical structure in traffic patterns
- **Posterior Predictive Checks**: Comprehensive model evaluation and comparison
- **MCMC Diagnostics**: Convergence monitoring, effective sample size analysis, and trace plots

## 📊 Dataset

The dataset contains hourly traffic volume observations for westbound I-94 in Minneapolis-St Paul, including:

- **Size**: 48,204 observations
- **Source**: [UCI Machine Learning Repository](https://archive.ics.uci.edu/dataset/492/metro+interstate+traffic+volume)
- **Features**:
  - `traffic_volume`: Hourly I-94 ATR 301 reported westbound traffic volume (target variable)
  - `holiday`: US holidays including Minnesota State Fair
  - `temp`: Average temperature (Kelvin)
  - `rain_1h`: Hourly rain amount (mm)
  - `snow_1h`: Hourly snow amount (mm)
  - `clouds_all`: Cloud cover rate (%)
  - `weather_main`: General weather type (11 categories)
  - `weather_description`: Specific weather description
  - `date_time`: Local CST time

### Data Preprocessing

- Removed observations with physically impossible temperatures (0K)
- Filtered extreme outliers in precipitation (>200mm/hour)
- No missing values in the original dataset

## 🔬 Methodology

### 1. Ordinary Bayesian Model

**Model Specification:**
```
y_i | λ ~ Poisson(λ),  i = 1, ..., n
λ ~ Gamma(2, 1)
```

**Posterior:**
```
f(λ | y₁, ..., yₙ) ∝ f(λ) · f(y₁, ..., yₙ | λ)
```

**Features:**
- Single-parameter model for overall traffic volume
- Efficient computation (72.5s warmup, 76.9s sampling)
- 4 chains, 7000 iterations per chain
- Effective sample size: 4687.3

### 2. Hierarchical Bayesian Model

**Model Structure:**
```
volume[n] ~ Poisson(λ[weather_type[n]])
λ[j] ~ Gamma(λ₀ · τ, τ)
λ₀ ~ Gamma(5, 1)
τ ~ Gamma(2, 1)
```

**Features:**
- Weather-stratified parameters (11 weather types)
- Captures between-group variation
- 4 chains, 1000 iterations per chain
- Runtime: 488.1s warmup, 472.8s sampling

## 📈 Results

### Model Performance

| Model | Convergence | Efficiency | Predictive Performance |
|-------|------------|-----------|----------------------|
| **Ordinary Bayesian** | ✅ Excellent | ⚡ Fast (~149s total) | Good for overall mean |
| **Hierarchical Bayesian** | ✅ Good | ⏱️ Moderate (~961s total) | Excellent for weather-specific predictions |

### Key Findings

1. **Ordinary Model**: Successfully captures the overall average traffic volume across all conditions
2. **Hierarchical Model**: 
   - Accurately predicts traffic volume for each weather category
   - Reveals substantial variation across weather types
   - Better suited for practical applications requiring weather-specific forecasts

### Posterior Predictive Checks

- **Ordinary Model**: Captures true overall mean but misses weather-specific variations
- **Hierarchical Model**: Successfully captures true means for 11/11 weather categories

## 🛠️ Installation & Requirements

### Prerequisites

```r
# Required R version
R >= 4.0.0

# Required packages
install.packages(c(
  "rstan",
  "ggplot2",
  "tidyverse",
  "bayesplot",
  "knitr",
  "gridExtra"
))
```

### Stan Models

The project requires two Stan model files:

1. `Poisson.stan` - Ordinary Bayesian model
2. `Hier_fit.stan` - Hierarchical Bayesian model

## 🚀 Usage

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/bayesian-traffic-volume.git
cd bayesian-traffic-volume
```

### 2. Download the Data

Download the dataset from [UCI Repository](https://archive.ics.uci.edu/dataset/492/metro+interstate+traffic+volume) and save as `Metro_Interstate_Traffic_Volume.csv`

### 3. Run the Analysis

```r
# Set working directory
setwd("path/to/project")

# Render the R Markdown document
rmarkdown::render("551project.Rmd")
```

Or run interactively:
```r
# Source the R Markdown chunks sequentially
knitr::purl("551project.Rmd", output = "analysis.R")
source("analysis.R")
```

## 📁 Project Structure

```
bayesian-traffic-volume/
├── README.md
├── 551project.Rmd              # Main analysis R Markdown file
├── Poisson.stan                # Ordinary Bayesian model specification
├── Hier_fit.stan               # Hierarchical Bayesian model specification
├── Metro_Interstate_Traffic_Volume.csv  # Dataset (download separately)
├── figures/                    # Generated plots and visualizations
└── outputs/                    # Model outputs and diagnostics
```

## 📊 Visualizations

The project generates several key visualizations:

1. **Exploratory Data Analysis**
   - Traffic volume histogram
   - Holiday effects boxplots
   - Weather type boxplots

2. **Model Diagnostics**
   - MCMC trace plots
   - Convergence diagnostics
   - Effective sample size

3. **Posterior Predictive Checks**
   - Overall model posterior distribution
   - Weather-stratified posterior distributions
   - Model comparison plots

## 🔍 Key Insights

### Traffic Volume Patterns

- **Clear weather**: Moderate-high traffic volume
- **Snow/Fog**: Lower traffic volume (visibility concerns)
- **Rain**: Variable traffic patterns
- **Holiday effects**: Significant reduction in traffic volume

### Model Selection Recommendations

- **Overall prediction**: Use ordinary Bayesian model (faster, sufficient for aggregate statistics)
- **Weather-specific prediction**: Use hierarchical model (captures group-level variation)
- **Operational planning**: Hierarchical model preferred for practical applications

## 📝 Future Work

1. **Temporal Dynamics**: Incorporate time series structure using time variables
2. **Prior Elicitation**: Develop informative priors based on domain expertise
3. **Predictive Modeling**: Extend to Bayesian regression for forecasting
4. **Holiday Hierarchy**: Implement hierarchical structure for different holidays
5. **Computational Efficiency**: Optimize Stan code for faster inference
6. **Model Extensions**: 
   - Incorporate spatial effects
   - Add interaction terms (weather × holiday)
   - Explore non-Poisson likelihoods (e.g., Negative Binomial)

## 🎯 Limitations

1. **Temporal Independence**: Current models assume observations are i.i.d., ignoring temporal autocorrelation
2. **Prior Specification**: Uses weakly informative priors due to limited prior knowledge
3. **Computational Cost**: Hierarchical model requires significant computation time
4. **Model Comparison**: Lacks formal model selection criteria (e.g., WAIC, LOO-CV)

## 📚 References

- Avila, A.M., & Mezić, I. (2020). Data-driven analysis and forecasting of highway traffic dynamics. *Nature Communications*, 11, 2090. [https://doi.org/10.1038/s41467-020-15582-5](https://doi.org/10.1038/s41467-020-15582-5)

- Kong, F., Li, J., Jiang, B., Zhang, T., & Song, H. (2019). Big data-driven machine learning-enabled traffic flow prediction. *Transactions on Emerging Telecommunications Technologies*, 30(9), e3482. [https://doi.org/10.1002/ett.3482](https://doi.org/10.1002/ett.3482)

## 👤 Author

**Dingrui Tao**

## 📄 License

This project is available for educational and research purposes.

## 🙏 Acknowledgments

- UCI Machine Learning Repository for providing the dataset
- Stan Development Team for the probabilistic programming framework
- Course instructors and peers for valuable feedback

---

**Note**: This project was completed as part of a Bayesian statistics course project. The analysis demonstrates practical application of Bayesian methods to real-world traffic prediction problems.
