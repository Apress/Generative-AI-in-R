# Section 4.7.5 – Autoregressive Models: Time-Series Forecasting
# This code demonstrates an AR(1) model for time-series forecasting using the 'forecast' package.
# Install and load the required package
install.packages("forecast") # Run only once
library(forecast)
# Generate synthetic time-series data with AR(1) process
set.seed(42)
time_series <- arima.sim(model = list(ar = 0.7), n = 100)
# Fit an AR(1) model (autoregressive of lag 1)
ar_model <- arima(time_series, order = c(1, 0, 0))
# Print model summary
print(ar_model)
# Forecast the next 10 values
forecasted_values <- forecast(ar_model, h = 10)
# Plot the forecast
plot(forecasted_values, main = "Autoregressive Time-Series Forecasting")

