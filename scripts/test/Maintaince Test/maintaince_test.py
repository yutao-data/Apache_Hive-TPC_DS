import argparse
import time
import csv
import re
import concurrent.futures
from os import listdir, path, system

def execute_query(query_file, query_directory, results_directory, user_id):
    if query_file.endswith(".sql"):
        match = re.match(r'q(\d+)\.sql', query_file)
        query_number = match.group(1) if match else "N/A"

        query_path = path.join(query_directory, query_file)
        output_file = f"{path.splitext(query_file)[0]}_user{user_id}.txt"
        output_path = path.join(results_directory, output_file)

        start_time = time.time()

        beeline_cmd = f'beeline -u jdbc:hive2://localhost:10000/01gb -f {query_path} > /dev/null 2>&1'
        system(beeline_cmd)

        end_time = time.time()
        execution_time = end_time - start_time

        with open("{}/query_execution_time.csv".format(results_directory), "a", newline='') as exec_time_file:
            csv_writer = csv.writer(exec_time_file)
            csv_writer.writerow([user_id, query_number, execution_time])
        print(f"Finished Query {query_number} by User {user_id} costs {execution_time} seconds")

        return query_number, execution_time, user_id

def main():
    parser = argparse.ArgumentParser(description='Hive Query Execution Script')
    args = parser.parse_args()

    query_directory = '/opt/hive/tpcds-kit/hive_queries/netezza_queries'
    results_directory = '/scripts/results/throughput_test_4stream_2_2'

    query_files = listdir(query_directory)
    print(f"Query files: {listdir(query_directory)}")

    results = []

    with open("{}/query_execution_time.csv".format(results_directory), "a", newline='') as exec_time_file:
        csv_writer = csv.writer(exec_time_file)
        csv_writer.writerow(["User ID", "Query Number", "Execution Time (seconds)"])


    with concurrent.futures.ThreadPoolExecutor(max_workers=4) as executor:
        for _ in range(4):
            futures = []
            user_id = 1
            for query_file in query_files:
                futures.append(executor.submit(execute_query, query_file, query_directory, results_directory, user_id))
                user_id = user_id % 4 + 1 



if __name__ == "__main__":
    main()

