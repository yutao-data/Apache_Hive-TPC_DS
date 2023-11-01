import argparse
import time
import csv
import re
import os
from os import listdir, path, system

parser = argparse.ArgumentParser(description='Hive Query Execution Script')
args = parser.parse_args()

query_directory = '/opt/hive/tpcds-kit/hive_queries/netezza_queries68'
results_directory = '/scripts/results/run_1gb_6times_2'

#for i in range(1,7):
#    os.makedirs(os.path.join(results_directory,f"run{i}", exist_ok=True)

#print("Query files: {}".format(os.listdir(query_directory)))


with open("{}/query_execution_time.csv".format(results_directory), "w", newline='') as exec_time_file:
    csv_writer = csv.writer(exec_time_file)
    csv_writer.writerow(["Query Number", "Execution Time (seconds)"])  

    for query_file in listdir(query_directory):
        if query_file.endswith(".sql"):
       
            match = re.match(r'q(\d+)\.sql', query_file)
            if match:
                query_number = match.group(1)
            else:
                query_number = "N/A"  


            for run_number in range(1,7):
                query_path = path.join(query_directory, query_file)
                output_file = path.splitext(query_file)[0] + f'_run{run_number}.txt'
                output_path = path.join(results_directory, f"run{run_number}", output_file)

             
                start_time = time.time()
                beeline_cmd = f'beeline -u jdbc:hive2://localhost:10000/03gb -f {query_path} > /dev/null 2>&1'
                #print(beeline_cmd)  
                system(beeline_cmd)

             
                end_time = time.time()

             
                execution_time = end_time - start_time
                print(f"Query {query_file} execution time: {execution_time} seconds")

             
                csv_writer.writerow([query_number, execution_time])

