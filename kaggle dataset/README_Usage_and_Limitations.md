# Kaggle data adaptation for PhytoEpiQuant

Source input: user-uploaded `test dataset from kaggle.csv` (2500 observations). Exact Kaggle URL, dataset author, license and biological provenance were not supplied; verify before public redistribution or publication.

## Files
- Kaggle_Standardized_All_Observations.csv: original seven variables plus infected_binary (0/1), disease_status_ordered (0/1/2), leaf color indicator columns, Plant_Group. These are derived coding variables, NOT measured severity or pathogen identities.
- Kaggle_Exploratory_3D_PCA.csv: selected variables for exploratory 3D PCA. Group=Plant_Group (crop type, NOT pathogen identity); infection_indicator_not_density is a binary infection flag, NOT pathogen density; humidity_pct, temperature_C and leaf_spot_size_original_units are three numerical PCA descriptors, but leaf spot size is a symptom measurement, NOT an environmental predictor.
- Kaggle_Incidence_By_Plant_Type.csv: proportion of sampled records classified mild/severe within each crop, assuming one independent record per plant. Descriptive dataset prevalence, not representative field incidence.
- Kaggle_Status_Counts.csv: category frequencies.

## Using the existing app
1. Fundamentals > Dataset Diagnostic & Analysis Planner: upload Kaggle_Standardized_All_Observations.csv.
2. Statistical epidemiology > Probability distributions / Count distributions: use suitable numeric or binary columns as allowed by the tab. Do not treat ordinal disease_status_ordered as a measured percentage.
3. Advanced analysis > Pathogen niche: 3D: upload Kaggle_Exploratory_3D_PCA.csv. Select 'infection_indicator_not_density' in the density selector ONLY as an exploratory proxy; select humidity_pct, temperature_C and leaf_spot_size_original_units as numeric descriptors, and Plant_Group as the grouping variable. Labels in the current app say 'pathogen', but here the groups are CROPS and the response is a BINARY infection indicator. The resulting plot is NOT pathogen niche modelling and cannot support claims of pathogen stacking. For scientifically valid pathogen niche analysis, collect pathogen species IDs, pathogen density measurements and >=3 measured environmental predictors.
4. Integrated reporting: upload standardized and count/summary files to inspect data-specific summaries; do not assume every module will recognize these custom columns.

## Not supported by this dataset
No assessment dates/time-series -> no DPC, AUDPC or forecasting validation. No geographic coordinates -> no spatial gradients/nearest neighbour. No measured disease severity (%) or leaf area denominator -> no true severity calculation. No pathogen species identification -> no multi-pathogen niche/stacking. No measured yield -> no yield-loss analysis.

## Important
Healthy/mild/severe are disease-status categories, NOT pathogen species. Leaf_Spot_Size has unspecified units; do not assume mm/cm or percentage. Crop type is not pathogen identity. The PCA is exploratory and should be labelled accordingly.
