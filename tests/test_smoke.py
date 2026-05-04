"""Fast non-Selenium smoke test for the publication-bias-simulation artifacts.

Selenium-based UI tests live in test_ui.py; those need a Chrome browser
and HTTP server. This file gives Overmind's nightly verifier (and any
fresh clone) a fast deterministic check that the simulation artifacts
exist and have the expected schema, without requiring a browser.
"""
from __future__ import annotations

import csv
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def _read_header(path: Path) -> list[str]:
    with path.open(encoding="utf-8") as f:
        return next(csv.reader(f))


def test_index_html_present_and_titled():
    index = ROOT / "index.html"
    assert index.is_file(), f"missing {index}"
    text = index.read_text(encoding="utf-8")
    assert "Publication Bias Adjustment Methods" in text


def test_summary_csvs_have_expected_schema():
    summary = ROOT / "comprehensive_simulation_summary.csv"
    assert summary.is_file(), f"missing {summary}"
    header = _read_header(summary)
    # Core scenario fields + the four estimator families' bias columns.
    for col in ("bias_type", "k_scenario", "true_effect", "true_tau", "n_sims",
                "naive_bias", "tf_bias", "pp_bias", "copas_bias"):
        assert col in header, f"comprehensive_simulation_summary missing {col!r}"


def test_raw_csv_row_count_in_expected_range():
    raw = ROOT / "comprehensive_simulation_raw.csv"
    assert raw.is_file(), f"missing {raw}"
    # Minus header row. Current artifact: ~13_480 rows.
    with raw.open(encoding="utf-8") as f:
        rows = sum(1 for _ in f) - 1
    assert 5_000 <= rows <= 50_000, (
        f"comprehensive_simulation_raw.csv row count {rows} outside the "
        "expected 5_000..50_000 envelope; rerun the simulation or update the bound"
    )
