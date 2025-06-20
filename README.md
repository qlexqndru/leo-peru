# Leo Peru - Packing List Analysis Automation

This project automates the transformation of packing list data into comprehensive analysis reports with visualizations.

## Files

- `generate_analysis.py` - Main analysis script
- `shell.nix` - NixOS environment configuration
- `conversation_log.md` - Development session documentation

## Usage

1. Enter the nix shell environment:
```bash
nix-shell
```

2. Run the analysis:
```bash
python generate_analysis.py "PACKING LIST 14.xlsx"
```

This will generate an analysis file with:
- Summary by SIZE with percentages
- Category breakdowns (CAT1, CAT1*, CAT2)
- Pie chart visualization
- Breakdown by LOTE
- Breakdown by production location

## Requirements

- NixOS with Python 3
- pandas
- openpyxl
- xlsxwriter

All dependencies are handled by the shell.nix file.