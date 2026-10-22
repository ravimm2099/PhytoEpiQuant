# Evidence and limitations

| Evidence | Actual status | Conclusion |
|---|---|---|
| AUDPC v1.4.0 executed on 24 powdery mildew series | R user outputs provided | All 24 agree with independent trapezoidal reference |
| epifitter 1.0.0 AUDPC on same series | R user outputs provided | 23 of 24 differ from mathematical reference; investigate version-specific indexing |
| DPC v1.4.1 fits | R user outputs provided | Logistic 18/24, Gompertz 14/24, monomolecular 12/24 |
| DPC v1.4.2 fits | R console summary supplied | Finite fits 24/24 for each; optimizer convergence/boundary flags not yet independently audited |
| v1.4.2 vs stats::nls | R console summary supplied | Logistic 24, Gompertz 24, monomolecular 22 comparable |
| v1.4.2 vs epifitter | R console summary supplied | Logistic 24, Gompertz 24, monomolecular 1 comparable |
| Other analytical modules | Example tests and equation-level checks only | Do not claim full independent numerical validation |

All reported differences in disease progress models are **percentage points of fitted disease severity**, not percentage relative error. Numerical equivalence depends on matched model parameterizations, bounds and optimizer convergence.
