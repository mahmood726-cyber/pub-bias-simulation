Mahmood Ahmad
Tahir Heart Institute
mahmood.ahmad2@nhs.net

Publication Bias Adjustment Methods: A 135-Scenario Simulation Comparison

How do Trim and Fill, PET-PEESE, and the Copas selection model perform for correcting publication bias under varying heterogeneity and study counts in meta-analysis? We simulated 13,480 meta-analyses across 135 scenarios crossing three effect sizes, three heterogeneity levels, three study counts, and five selection mechanisms. Each dataset was analysed with unadjusted random-effects, Trim and Fill, PET-PEESE regression, and Copas maximum-likelihood selection modelling, evaluated by bias, RMSE, and coverage. The Copas model achieved the lowest median RMSE across scenarios with twenty or more studies and maintained 95% CI coverage of 89-96%, while PET-PEESE overcorrected under high heterogeneity with coverage below 50%. All methods were unstable with only ten studies, and Trim and Fill provided insufficient correction when between-study variance exceeded 0.3. No single method is universally best; selection should be guided by heterogeneity magnitude and study count, with multiple methods reported. A key limitation is that only one-sided selection was simulated, excluding outcome reporting bias and p-hacking.

Outside Notes

Type: methods
Primary estimand: RMSE of bias-corrected pooled estimate
App: pubbias.sim R package v1.0
Data: 13,480 simulated meta-analyses across 135 factorial scenarios (3 effect sizes x 3 tau x 3 k x 5 bias mechanisms)
Code: https://github.com/mahmood726-cyber/pub-bias-simulation
Version: 1.0
Validation: DRAFT

References

1. Egger M, Davey Smith G, Schneider M, Minder C. Bias in meta-analysis detected by a simple, graphical test. BMJ. 1997;315(7109):629-634.
2. Duval S, Tweedie R. Trim and fill: a simple funnel-plot-based method of testing and adjusting for publication bias in meta-analysis. Biometrics. 2000;56(2):455-463.
3. Borenstein M, Hedges LV, Higgins JPT, Rothstein HR. Introduction to Meta-Analysis. 2nd ed. Wiley; 2021.

AI Disclosure

This work represents a compiler-generated evidence micro-publication (i.e., a structured, pipeline-based synthesis output). AI is used as a constrained synthesis engine operating on structured inputs and predefined rules, rather than as an autonomous author. Deterministic components of the pipeline, together with versioned, reproducible evidence capsules (TruthCert), are designed to support transparent and auditable outputs. All results and text were reviewed and verified by the author, who takes full responsibility for the content. The workflow operationalises key transparency and reporting principles consistent with CONSORT-AI/SPIRIT-AI, including explicit input specification, predefined schemas, logged human-AI interaction, and reproducible outputs.
