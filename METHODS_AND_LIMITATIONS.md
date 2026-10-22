# PhytoEpiQuant scientific validation release v1.5

This is a consolidated update to v1.4, preserving existing tabs and adding **Scientific validation: DPC, AUDPC & forecasting**.

## Start
1. Extract the entire ZIP to a normal folder (do not run inside ZIP preview).
2. Open RStudio, set working directory to the folder containing `app.R`, `models.R`, `spatial_models.R`, and `advanced_models.R`.
3. Run `shiny::runApp('.')`.
4. In the new scientific validation tab, click **Load published PowderyMildew example** or upload a CSV.
5. Select treatment, moisture and replicate. View original-scale fitted models, AICc, residuals, holdout results and threshold classifications.
6. Review the replicate-wise AUDPC table and exploratory factorial ANOVA.

## Input columns
Required: `time` (assessment days), `severity_pct` (0–100). Alternatively `disease_proportion` (0–1) is converted to percent. Recommended: `treatment`, `moisture`, `replicate` (independent experimental unit). Group variables must identify one series uniquely. Multiple observations at one time within the same series must be aggregated appropriately before fitting.

## Methodological cautions
- Models fit by constrained nonlinear least squares on the original proportion scale. Logistic, Gompertz, monomolecular, optional bounded exponential.
- AIC/AICc use the same original-scale Gaussian residual approximation, including an estimated variance parameter. AICc ranking is conditional on candidate model set and error assumptions.
- Residual plots and RMSE are in percentage points. Chronological holdout fits to all but the final two assessments and predicts those final two, but is not independent external validation.
- Threshold crossings are classified separately as first observed day, model-estimated historical crossing, extrapolated future crossing, or not reached. A threshold day estimated by a model is not an observed disease threshold.
- No confidence/prediction intervals or weather-driven operational warning system are provided in v1.5. Future predictions remain exploratory.
- Replicate-wise AUDPC assumes repeated assessments of the same experimental unit; factorial ANOVA is exploratory and may not be appropriate for randomized blocks, split plots or other designs. Review independence, blocking and residual assumptions before inferential reporting.
- The existing **DPC** tab remains a parameter-based simulation. Use the new **Scientific validation** tab for actual fitting.

## Numerical regression test
Run `source('tests/test_published_powdery_mildew.R')`. The published series Drip / High moisture / replicate 1 should return AUDPC 1299.55 %-days and rAUDPC 0.2062777778. All 24 independent series should appear.

## Verification
Data completeness and numerical AUDPC were independently checked with Python. An R interpreter was not available in the authoring environment, so Shiny launch, nonlinear optimizer behavior, ANOVA and plots still require testing in RStudio.

## Additional scope
The other analysis modules are retained from prior releases. Their model assumptions and interpretation should be evaluated individually before publication-quality inference.
