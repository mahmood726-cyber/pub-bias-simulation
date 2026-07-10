"""Data-contract guards for the R analysis core (R/simulation_utils.R).

R is not part of the default (pytest) verification path, so these tests
protect the *inputs* the R functions depend on. They fail loudly if the
shipped summary CSV drifts in a way that would silently corrupt
``load_simulation_summary()`` or ``summarize_performance()``:

  * ``load_simulation_summary()`` hard-codes ``k_scenario`` factor levels
    c(10, 20, 50); any other value is silently coerced to NA. Guard: the
    CSV must contain only those levels.
  * ``summarize_performance()`` selects ``<method>_<metric>`` columns and
    reduces with min/max(..., na.rm=TRUE); an entirely-NA column would
    return Inf/-Inf instead of a real number. Guard: every method x metric
    column exists and has at least one non-NA numeric value.
"""
from __future__ import annotations

import csv
import math
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SUMMARY = ROOT / "comprehensive_simulation_summary.csv"

METHODS = ("naive", "tf", "pp", "copas")
METRICS = ("bias", "rmse", "mae", "coverage")
ALLOWED_K = {10, 20, 50}


def _rows() -> list[dict]:
    with SUMMARY.open(encoding="utf-8") as f:
        return list(csv.DictReader(f))


def test_k_scenario_only_hardcoded_levels():
    # Every k_scenario value must be one of the levels R hard-codes,
    # otherwise load_simulation_summary() silently produces NA factors.
    rows = _rows()
    assert rows, "summary CSV is empty"
    ks = {int(float(r["k_scenario"])) for r in rows}
    assert ks <= ALLOWED_K, f"k_scenario has levels outside {ALLOWED_K}: {ks}"


def test_method_metric_columns_present_and_not_all_na():
    rows = _rows()
    header = set(rows[0].keys())
    for method in METHODS:
        for metric in METRICS:
            col = f"{method}_{metric}"
            assert col in header, f"summary CSV missing column {col!r}"
            vals = []
            for r in rows:
                raw = r[col]
                if raw in ("", "NA"):
                    continue
                try:
                    v = float(raw)
                except ValueError:
                    continue
                if not math.isnan(v):
                    vals.append(v)
            # A fully-NA column would make summarize_performance() return
            # Inf/-Inf from min/max rather than a real summary value.
            assert vals, f"column {col!r} is entirely NA/empty"
