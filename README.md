# 📘 Case Duration Analysis in Karachi Judiciary

## 📌 Overview

This repository contains the data and code for a quantitative research project examining:

> **"To what extent does the legal status of litigants (Institutional vs. Individual) influence case duration in the Karachi judiciary?"**

The analysis is conducted using **Stata** and follows a fully reproducible workflow, including:

- Data cleaning and preparation  
- Variable construction  
- Exploratory data analysis (EDA)  
- Hypothesis testing (two-sample t-tests)  
- Graphical visualization  

---

## 📂 Repository Contents

| File | Description |
|-----|------------|
| `Karachi_data_QRM.dta` | Dataset containing Sindh High Court case records |
| `analysis.do` | Main Stata DO-file with all analysis steps |
| `README.md` | Instructions for running and reproducing the analysis |

---

## ⚙️ Requirements

To run this project, you will need:

- **Stata** (version 14 or higher recommended)  
- Basic familiarity with running Stata DO-files  

---

## ▶️ How to Run the Project

Follow the steps below to reproduce the analysis exactly.

---

### 1. Download the Repository

- Click **Code → Download ZIP** on GitHub  
- Extract (unzip) the folder to a location on your computer  

---

### 2. Open Stata

Launch Stata on your system.

---

### 3. Set the Working Directory

Set the working directory to the folder containing both the dataset and the DO-file.

```stata
cd "path_to_your_unzipped_folder"
```

Example: cd "C:\Users\YourName\Downloads\karachi-judiciary-case-duration-analysis" (for Windows)
         cd "/Users/YourName/Downloads/karachi-judiciary-case-duration-analysis" (for MacOS)

---

### 4.Run the DO-file

```stata
do analysis.do
