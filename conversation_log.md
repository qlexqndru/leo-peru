# Leo Peru Packing List Analysis - Development Session

## Date: 2025-06-15

## Overview
This session documented the creation of an automated Excel analysis tool for transforming packing list data into comprehensive analysis reports with charts and multiple breakdown views.

## Project Goal
Transform "PACKING LIST 14.xlsx" into analysis format like "PACKING LIST ANALISIS 14.xlsx" with:
- Summary by SIZE with totals and percentages
- Category breakdowns (CAT1, CAT1*, CAT2)
- Pie chart visualization
- Detailed breakdowns by LOTE and production location

## Files Created

### 1. shell.nix
NixOS shell environment with Python dependencies:
```nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    python3
    python3Packages.pandas
    python3Packages.openpyxl
    python3Packages.xlsxwriter
  ];
}
```

### 2. generate_analysis.py
Main Python script that:
- Reads source packing list data
- Groups by CALIBRE (SIZE) and categories
- Calculates totals and percentages
- Creates formatted Excel with 3 sheets
- Generates pie chart visualization

## Key Features Implemented

### Sheet 1: Summary Analysis (Hoja1)
- SIZE distribution with BOXES totals
- TOTAL% calculations
- Category breakdowns (CAT1, CAT1*, CAT2)
- Pie chart showing size distribution with values

### Sheet 2: Breakdown by LOTE
- Detailed view grouped by LOTE, CAT, and CALIBRE
- Subtotals for each LOTE
- Summary section with all LOTEs ranked

### Sheet 3: Breakdown by Location
- Detailed view grouped by CÓDIGO DEL LUGAR DE PRODUCCIÓN
- Shows CAT and CALIBRE combinations per location
- Summary section with location totals

## Technical Challenges Solved

1. **Category Mapping**: Handled numeric category '1' mapping to 'CAT1'
2. **Chart Labels**: Removed unwanted "Column C" and "BOXES" labels from pie chart
3. **Data Grouping**: Created multiple aggregation views for different business needs
4. **NixOS Integration**: Used nix-shell for dependency management

## Usage
```bash
cd /home/qlexqndru/Opusdem/leo-peru
nix-shell --run "python generate_analysis.py 'PACKING LIST 14.xlsx'"
```

This generates an analysis file with the same structure as the example, including:
- Data tables with proper formatting
- Pie chart with size distribution
- Multiple breakdown sheets for detailed analysis

## Summary Statistics from Test Run
- Total boxes: 2496
- Total CAT1: 2392
- Total CAT1*: 24
- Total CAT2: 80

## Future Enhancements
The script is designed to be reusable for any packing list following the same format. Simply run it with different source files to generate corresponding analysis reports.