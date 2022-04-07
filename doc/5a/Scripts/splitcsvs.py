import pandas as pd
import openpyxl

# Splits the formatted excel file into csv files

sheet_names = ["DI", "B", "BT", "FO", "EG", "NG", "OS", "ES", "ESC", "MT", "PB"]
excel_file = 'Updated-ESPA-info.xlsx'
all_sheets = pd.read_excel(excel_file, sheet_name=None)
sheets = all_sheets.keys()
i = 0

for sheet_name in sheets:
    sheet = pd.read_excel(excel_file, sheet_name=sheet_name)
    sheet.to_csv("%s.csv" % sheet_names[i], index=False)
    i += 1