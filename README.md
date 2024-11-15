# Implementation of the MABAC Multicriteria Method in R

This repository contains the implementation of the **MABAC (Multi-Attributive Border Approximation Area Comparison)** multicriteria decision-making method using the R programming language. The application was developed to facilitate multicriteria decision-making through an accessible and user-friendly web application.

## Project Description

Multicriteria decision-making is a discipline that uses complex mathematical models to evaluate and select the best alternative among various options, minimizing biases. This project aims to provide a web-based tool that implements the MABAC method, enabling users to perform automatic calculations based on a predefined spreadsheet.

The tool was developed using the **R programming language**, combined with the **Shiny** library, to create an interactive graphical interface. The application is hosted on **shinyapps.io** and is publicly available.

## Features

- Upload `.xlsx` spreadsheets for analysis.
- Automatic execution of MABAC method calculations.
- Visualization of results in tables and charts.
- Intuitive interface for detailed analysis of criteria and alternatives.
- Provision of a standard spreadsheet to help users start their analyses.

## Technologies Used

- **R (version 4.2.3)**: Programming language used for data analysis and method implementation.
- **RStudio (version 2023.06.1)**: IDE used for R development.
- **Shiny (version 1.7.5)**: Library used for creating the web interface.
- **shinyapps.io**: Platform used to host the application.
- **Git and GitHub**: Tools for version control and code storage.

## How to Run the Project

1. Clone the repository:

   ```bash
   git clone https://github.com/slabaverse/mabacR_.git
   cd mabacR_
   ```

2. Ensure you have R and RStudio installed.

3. Open the project in RStudio.

4. Install the necessary dependencies:

   ```R
   install.packages(c("shiny", "readxl", "ggplot2"))
   ```

5. Run the application:

   ```R
   shiny::runApp()
   ```

## How to Use the Application

1. Download the standard spreadsheet provided in the application.
2. Fill in the spreadsheet with the criteria and alternatives you wish to evaluate.
3. Upload the spreadsheet to the application.
4. View the automatically generated results in the **Results** tab.
5. Use the **Charts** tab to visualize the graphical analysis of alternatives against criteria.

## Results

The tool has been validated using academic datasets and produced results consistent with original studies, demonstrating its accuracy and robustness.

Access the web version of the application [here](https://arslabadack.shinyapps.io/mabacR).

## References

This project was developed as part of the **Final Graduation Project** to obtain a specialization in Data Science and Analytics - 2023.

Authors:  
- **Adam Roger Slabadack**: [arslabadack@gmail.com](mailto:arslabadack@gmail.com)  
- **Marcos dos Santos**: PhD in Operations Research, Military Institute of Engineering  

---
