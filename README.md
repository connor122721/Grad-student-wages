# Exploration of the Cost of Living and Graduate Student Wages

This repository contains an analysis of the cost of living (COL) and self-reported PhD student salaries across various universities in the United States.

## Data Overview

- **Source:** [PhD Stipends](https://www.phdstipends.com/)
- **Collected by:** Kendall Branham & Connor S. Murray
- **Date:** November 8, 2022

## Project Description

The goal of this project is to explore the relationship between the cost of living and the wages of PhD students. By analyzing self-reported salary data from PhD students across different universities, we aim to provide insights into the financial challenges faced by graduate students.

## Data Collection

The data used in this project was sourced from [PhD Stipends](https://www.phdstipends.com/), a platform where PhD students can anonymously report their stipends. The dataset includes information on stipends, cost of living, and other relevant details from various institutions across the US.

## How to Use

1. **Open an anaconda environment:**
    ```sh
    module load anaconda/2020.11-py3.8
    python3
    ```

2. **Run the code to download data:**
    ```python
    
    # Modules
    import requests
    import json
    import os
    import pandas as pd
    
    # Working directory
    os.chdir("/project/berglandlab/connor/")
    
    # Empty object
    full_stipends = []
    reqlimit = 1000
    
    # Go through each page
    for i in range(0, reqlimit):
        data = requests.get(f'https://www.phdstipends.com/data/{i}').json()['data']
        for entry in data:
            full_stipends.append(entry)
    
        # Gather data from phdstipends pages until the pages no longer return data
        if len(data) < 1:
            break
    
    # Write to CSV file
    pd.DataFrame(full_stipends).to_csv("stipends.csv")
    ```

## Contributing

Contributions are welcome! If you have any suggestions or improvements, feel free to open an issue or submit a pull request.

If you have any questions or need further assistance, please don't hesitate to contact us!
