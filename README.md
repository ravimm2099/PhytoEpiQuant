# PhytoEpiQuant

**PhytoEpiQuant v1.0.0** is an R Shiny application for educational and exploratory mathematical analysis of plant disease epidemiology.

**Author:** Dr. Manish Mathur  
**Affiliation:** Chief Technical Officer, ARS- Net (Crop Protection), FNESA, India  
**Email:** eco5320@gmail.com; manish.mathur@icar.org.in

## Quick start

1. Download the repository ZIP using GitHub **Code → Download ZIP**, then extract all files.
2. Open RStudio and run:

```r
install.packages('shiny') # first time only
shiny::runApp('path/to/PhytoEpiQuant_GitHub_v1.0.0')
```

Alternatively, open the extracted folder as an RStudio project, set it as the working directory, and run `shiny::runApp('.')`. Do not launch `app.R` alone or from a ZIP preview.

## Suggested workflow

1. **Start here**: read the workflow.
2. **Dataset Diagnostic & Analysis Planner**: upload a CSV, map variables, inspect data quality, and identify compatible analyses and missing variables.
3. **Data templates & column guide**: review the examples and required measurement units.
4. **Analysis tabs**: select a single independent experimental series when appropriate, calculate results and export them.
5. **Scientific validation: DPC, AUDPC & forecasting**: fit candidate curves to observed disease severity, inspect diagnostics, calculate replicate-level AUDPC, and evaluate exploratory forecasts.

## Included modules

- Disease progress simulation (DPC)
- Automatic DPC fitting and candidate-model comparison (logistic, Gompertz, monomolecular, optional bounded exponential)
- AUDPC and relative AUDPC; replicate-level AUDPC summaries
- Disease-count and probability distributions
- Dispersion, ordinary runs, nearest-neighbour and directed-network calculations
- Venn intersections and overlap visualizations
- Exploratory threshold crossing and disease forecasting
- Dataset suitability screening and data dictionary

**Important:** The basic DPC tab is a *simulation*, not fitted-model estimation. Use the scientific-validation tab for fitted curves. Dataset compatibility does not prove a model's statistical assumptions. Forecasting is exploratory and not an operational crop-protection warning system.

## Example datasets and tests

- `examples/` contains synthetic teaching datasets and `PowderyMildew_published.csv`, adapted for the app from the published epifitter example.
- `DATA_DICTIONARY.csv`, `COMPLEX_DATA_DICTIONARY.csv`, `TAB_DATASET_GUIDE.csv` describe data fields and examples.
- `tests/test_models.R` checks core calculations.
- `tests/test_published_powdery_mildew.R` checks the published example, including 24 replicate series and AUDPC = 1299.55 %-days for Drip / High moisture / replicate 1.

Run from the repository root:

```r
source('tests/test_models.R')
source('tests/test_published_powdery_mildew.R')
```

## Scientific limitations

- Model comparison assumes an original-scale Gaussian residual approximation; evaluate residuals and biological plausibility.
- Holdout evaluation using final assessments is not external validation. Forecast intervals are not yet implemented.
- Treatment ANOVA is exploratory; verify blocking, randomization and error structure.
- Spatial nearest-neighbour analysis may lack edge correction.
- Users should verify predictions against independent field observations before making management decisions.

## Documentation

See [METHODS_AND_LIMITATIONS.md](METHODS_AND_LIMITATIONS.md), [VALIDATION.md](VALIDATION.md), [DATA_SOURCES.md](DATA_SOURCES.md), and [RELEASE_NOTES.md](RELEASE_NOTES.md).

## License

**A software license has not yet been selected by the author.** Before public release, choose a license and add a `LICENSE` file. Until then, normal copyright restrictions apply. See [LICENSE_DECISION.md](LICENSE_DECISION.md).


## Epidemiological navigation (v1.3.1)
See NAVIGATION_ORDER.md for the ordered 22-tab, eight-stage interface.


## Consolidated v1.4.0 release

See RELEASE_NOTES_v1.4.0.md and RELEASE_CHECKLIST.md.


## Consolidated v1.4.3 and reproducibility
The eight-stage navigation and previously implemented analytical modules are retained. Run `source("RUN_DPC_THREE_WAY_VALIDATION.R")` from the extracted application root with R and epifitter 1.0.0 installed. Outputs are written under `examples/DPC_Three_Way_Results_v1.4.3`. Review convergence and boundary flags before interpreting a finite fit as validated. See `VALIDATION_EVIDENCE_MATRIX.md` and `RELEASE_NOTES_v1.4.3.md`.
