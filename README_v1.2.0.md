# PhytoEpiQuant v1.2.0: research workflow update

## New features
- Tab guide and equations: explanation of every major analysis and its interpretation.
- Adaptive Venn: 2-4 circles when VennDiagram is installed; 1 or 5-12 binary categories use exact-intersection bar chart.
- Forecast decision-support: integrated pest management guidance, without unverified chemical prescriptions.
- Pathogen niche: 3D: standardized PCA of 3+ environmental variables with pathogen density represented by point colour. Optional plotly for interactive 3D. **This is not a calculated hypervolume.**
- Multi-dataset consolidated report: multiple CSV uploads, per-file descriptive calculations, offline HTML report, figures and results CSV in a ZIP.

## Run
Extract all files. In RStudio set working directory to the folder containing app.R and run `shiny::runApp('.')`. Install `shiny`; optional `plotly` and `VennDiagram` enable interactive 3D and circles. A `zip` executable must be available to produce the report ZIP on Windows (typically installed with Rtools or other zip utilities).

## Known limitations
- The prior Objective–Data–Method Advisor and Scientific validation modules are retained, but have not been independently executed in this environment. Their reported malfunction requires an R console traceback to diagnose reliably.
- Multi-CSV report computes validated descriptive indices only, not every app model or fitted DPC. It does not merge rows or pool replicate series.
- The 3D PCA scatterplot is a niche-space visualization, not a formal kernel hypervolume, overlap statistic or validated disease risk model.
- Forecast advice is generic IPM decision support, not pesticide recommendations. Locally calibrated thresholds are needed.
- R runtime tests are still needed; ZIP integrity and source checks do not establish Shiny functionality.
