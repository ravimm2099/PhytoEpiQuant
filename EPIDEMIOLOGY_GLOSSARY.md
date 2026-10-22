# Epidemiological terminology and equations

Source: user-supplied Chapter 2, *Attributes of Plant Epidemic*. This tab is educational; formulas not explicitly implemented in analytical tabs are not represented as fitted models.

## Epidemic and infection cycle
An epidemic (epiphytotic) is disease development in a host population over time. Inoculation, penetration, establishment, colonization, reproduction, dissemination and survival influence its course.

Formula: Conceptual; no single diagnostic formula.

## Monocyclic / simple-interest
One effective infection cycle per season, typically dominated by primary inoculum. Monomolecular progress may describe saturation.

Formula: dx/dt = Q R (1 - x); x(t) = 1 - (1-x0) exp(-Q R t), if Q and R are constant.

## Polycyclic / compound-interest
Repeated secondary infection cycles in a season. Exponential early increase can become sigmoid as susceptible tissue is depleted.

Formula: Exponential: dx/dt = r x; logistic: dx/dt = r x(1-x).

## Mixed-cycle and polyetic epidemics
Some diseases combine primary seasonal inoculum with repeated secondary spread. Polyetic epidemics build up across years, irrespective of within-season cycle count.

Formula: Multiple-season dynamics need year-specific inoculum carryover.

## Incidence
Fraction of assessed plants or organs classified diseased. Define the unit and case criterion before counting.

Formula: Incidence (%) = 100 * diseased units / total units.

## Severity
Proportion of host tissue area visibly affected, or a justified assessment-scale estimate; not equivalent to incidence.

Formula: Severity (%) = 100 * symptomatic area / assessed area.

## Disease density
Number of lesions or infection units per specified area, plant or sampling unit.

Formula: Density = lesion count / sampled area (or other stated exposure).

## Disease progress curve (DPC)
Plot of incidence or severity against time. Linear, J-shaped, sigmoid, saturation and bimodal patterns may arise; shape alone does not prove pathogen cycle type.

Formula: Observed (time, intensity); fit candidate models only when assumptions are appropriate.

## Disease gradient
Change in disease intensity with distance from an inoculum source; source geometry and dispersal matter.

Formula: Illustrative: y(d) = a exp(-b d), with a,b estimated from distance data.

## Take-off level / zero date
A selected rapid-growth threshold and its estimated crossing date; definitions are pathosystem-specific, not universal.

Formula: t* = inf{t: fitted intensity(t) >= threshold}.

## Apparent infection rate r
Rate parameter estimated from change in visible disease proportion; differs by model and observation units.

Formula: Logistic: r = [logit(x2)-logit(x1)]/(t2-t1); 0 < x1,x2 < 1.

## Basic infection rate R / reproduction number R0
The chapter uses R for a sporulation-related basic infection rate. R0 instead denotes secondary infections per infectious case in a fully susceptible setting. Neither equals fitted apparent r.

Formula: Threshold condition R0 > 1 (or i * Rc > 1 under the chapter convention); requires transmission data.

## AUDPC
Trapezoidal integral of measured intensity from first to last observation. Higher values mean more cumulative measured disease over that window.

Formula: AUDPC = sum[(yi + yi+1)/2 * (ti+1 - ti)].

## Relative AUDPC and AUDPS
rAUDPC normalizes AUDPC to the maximum possible area; AUDPS adjusts endpoint weighting and is a distinct measure.

Formula: rAUDPC = AUDPC/[100 * (tn-t1)] for percentage severity.

## AUDPC limitations
Depends on start/end times, assessment frequency, scale, missing observations and error. Similar AUDPC may conceal very different epidemic shapes.

Formula: Compare on matched time windows and scales; inspect original DPC.

## Control through x0, r and t
Reducing initial inoculum, slowing epidemic rate or shortening susceptible exposure can reduce disease, with different impacts under different models.

Formula: Early exponential approximation: x(t) = x0 exp(r*t), not bounded.

## Slow / rapid epidemic and decline
Rate reflects pathogen biology, host stage and weather. Declining incidence or severity may require models allowing negative slopes or host-tissue loss.

Formula: Model rates are descriptive; positive-only fits cannot represent declining series.

## Thresholds and decision making
Warning, action, economic injury and epidemic thresholds have different meanings; thresholds require crop-pathogen and cost validation.

Formula: Illustrative threshold crossing is not a fungicide recommendation.

## Yield loss and damage curve
Yield loss is the difference between attainable and observed yield; damage curves link measured disease to yield under a defined design.

Formula: Yield loss (%) = 100 * (attainable yield - observed yield)/attainable yield.

## Assessment frequency
Sampling interval influences detection of onset, rate, threshold crossing and AUDPC; time intervals need not be equal for trapezoidal integration.

Formula: Use observed ti+1 - ti in AUDPC.

## Two pathogens and spillover
Co-infections may be additive, antagonistic or synergistic; spillover describes movement from a reservoir population to another host population.

Formula: Illustrative loss model: L = b0 + b1*x1 + b2*x2 + b12*x1*x2.

## Composite fitness index (CFI)
Chapter 2 defines infection frequency IF, lesion area LA and sporulation capacity SC; compare only under standardized protocols.

Formula: CFI = IF * LA * SC; IF is a proportion, LA in cm2/leaflet, SC in sporangia/cm2 lesion.
