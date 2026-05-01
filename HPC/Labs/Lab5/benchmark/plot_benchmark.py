import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv('benchmark_results.csv')

scenarios = {
    'default': 'Standard Geometry',
    'complex': 'Complex Obstacles',
    'wing': 'Aerodynamic Wing'
}

for scenario_id, title in scenarios.items():
    subset = df[df['Scenario'] == scenario_id]
    
    pivot_df = subset.pivot(index='Exercise', columns='Nodes', values='Time')
    
    fig, ax = plt.subplots(figsize=(8, 5))
    pivot_df.plot(kind='barh', ax=ax, edgecolor='black', width=0.8)
    
    ax.set_title(f'{title}', weight='bold')
    ax.set_xlabel('Execution Time (Seconds)')
    ax.set_ylabel('Exercise')
    ax.invert_yaxis()
    
    ax.grid(axis='x', linestyle='--')
    ax.legend(title='MPI Processes ')
    
    filename = f'benchmark_{scenario_id}.png'
    plt.tight_layout()
    plt.savefig(filename, dpi=300)
    plt.close()
