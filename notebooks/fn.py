def pctbygroup(df,y):
    '''this function will provide a dictionary of dataframes with the percentage of frequency of values of column if less than 10 y aggregated by each column that corrresponds to the key of the dictionary'''
    cols=[c for c in df.columns if d c!=y]
    dfs={}
    for i in cols:
        dfs[i]=df.groupby(i)[y].value_counts().to_frame().div(df.groupby(i).agg('count')[y].to_frame(),level=i).rename(columns={y:'%'}).sort_values('%')*100
    return dfs
    
def countbygroup(df,y):
    '''this function will provide a dictionary of dataframes  of value counts of column 'y' aggregated by each of the other columns, being that each key will correspond to the column used to aggregate by'''
    cols=[c for c in df.columns if c!=y]
    pds={}
    for i in cols:
        pds[i]=df.groupby(i)[y].value_counts()     
    return pds
