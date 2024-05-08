import pandas as pd
datebase = 'Datebase.xlsx'
df_traffic = pd.read_excel(datebase,sheet_name = 'tariff_matrix')
df_credit = pd.read_excel(datebase,sheet_name = 'credit')

df_merge = pd.merge(df_credit, df_traffic)

df_difference = df_merge[(df_merge['rate'] != df_merge['rate_fact']) & (df_merge['credit_date'] == df_merge['start_date'])].copy()

df_difference['rate_diff'] = abs(df_merge['rate'] - df_merge['rate_fact'])

df_result = df_difference[['deal_id','rate_fact','rate','rate_diff','start_date','credit_date']]

print(df_result)
