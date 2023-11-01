# Evaluating Data Warehousing Performance with Apache Hive: TPC-DS Analysis Project Directory README

---

## Overview

This directory structure is designed for the TPC-DS benchmarking project. It contains query scripts, results, and additional utilities that assist in the process.

## Authors

**Yutao Chen**, **Min Zhang**, **Ziyong Zhang**, **Xianyun Zhuang**  
*Erasmus Mundus BDMA Students*

---

## Directory Structure

- **scripts/**: This directory contains all the execution scripts needed for the project.
  - **test/**: Contains automated tools for running different types of tests such as:
    - **Load Test/**: Scripts related to the Load testing phase.
    - **Power Test/**: Scripts pertaining to the Power testing phase.
    - **Throughput Test/**: Tools and scripts for the Throughput testing phase.
    - **Maintaince Test/**: Contains scripts used during the Maintenance testing phase.
  - **draw/**: This folder includes scripts for generating and drawing graphical representations of our data.
  - Other directories in the `scripts` folder include additional utilities and files that support the main scripts.

- **results/**: Here, you'll find the output from the execution of the scripts located in the `scripts` directory. Each sub-directory corresponds to a particular test or function, and contains the results for that specific execution.
    - **Load Test/**: Results related to the Load testing phase.
    - **Power Test/**: Results pertaining to the Power testing phase.
    - **Throughput Test/**: Results for the Throughput testing phase.
    - **Maintaince Test/**: Results for the Maintenance testing.

- **hive_queries/**: This directory contains all the queries that are being executed as part of this project. They are organized into various sub-directories for better clarity and management.
    - **netezza_queries/**: The queries mainly used in this project.

- **Reports-Apache_Hive-TPC_DS.pdf**: This is the official project report in PDF format detailing the methods, results, and conclusions of the TPC-DS benchmarking tests.

## How to Use

1. Navigate to the `scripts` directory for running any test. For example, if you want to execute a Load Test, navigate to `scripts/test/Load Test/` and run the desired script.
2. Once executed, the results will be generated and saved in the `results` directory under the corresponding sub-directory.
3. If you wish to visualize the results, use the drawing scripts available in the `scripts/draw` directory.
4. For a comprehensive understanding of the project, methods, and conclusions, refer to the project report `Reports-Apache_Hive-TPC_DS.pdf`.

---

We hope this README helps you navigate and understand the structure and content of the TPC-DS project directory. If you have any questions or require further clarifications, please reach out to the project team.

