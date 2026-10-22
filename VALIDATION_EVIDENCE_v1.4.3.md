# Executed validation evidence for v1.4.3

Source: user-executed R script outputs, 21 October 2026. Results are archived verbatim in `validation_v1.4.3_executed/`. Earlier baseline remains in `validation_baseline_v1.4.1/`.

| model         |   attempted |   phyto_success |   phyto_optimizer_converged |   phyto_boundary_fits |   epifitter_comparable |   nls_comparable |   median_phyto_nls_difference_pct |   max_phyto_nls_difference_pct |
|:--------------|------------:|----------------:|----------------------------:|----------------------:|-----------------------:|-----------------:|----------------------------------:|-------------------------------:|
| logistic      |          24 |              24 |                          24 |                     0 |                     24 |               24 |                          0.027249 |                       0.053177 |
| gompertz      |          24 |              24 |                          24 |                     0 |                     24 |               24 |                          0.001978 |                       0.142402 |
| monomolecular |          24 |              24 |                          12 |                    23 |                      1 |               22 |                          0.000647 |                       0.011653 |

**Interpretation:** All 72 model runs returned finite fits, but only 60 optimizer runs were marked converged. Monomolecular has 23 boundary fits, only 12/24 optimizer convergence, 1/24 comparable epifitter output, and 22/24 independent nls fits. Thus this release is evidence-complete for these tests, not fully validated across all modules. No new R execution was performed during packaging.

Two independent `nls` failures: Furrow.Moderate moisture.2, Furrow.Moderate moisture.3; both monomolecular. Predictions in the comparison table are in percentage points.
