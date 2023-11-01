import argparse
import time
import csv
import re
from os import listdir, path, system

parser = argparse.ArgumentParser(description='Hive Query Execution Script')
parser.add_argument('--query_dir', type=str, required=True, help='Directory containing query files')
parser.add_argument('--results_dir', type=str, required=True, help='Directory for query execution results')
args = parser.parse_args()

query_directory = args.query_dir
results_directory = args.results_dir

print(f"Query files: {listdir(query_directory)}")

# 打开查询执行时间文件以写入 CSV
with open(f"{results_directory}/query_execution_time.csv", "w", newline='') as exec_time_file:
    csv_writer = csv.writer(exec_time_file)
    csv_writer.writerow(["Query Number", "Execution Time (seconds)"])  # 写入标题行

    total_execution_time = 0  # 初始化总的查询执行时间

    for query_file in listdir(query_directory):
        if query_file.endswith(".sql"):
            # 从查询文件名提取编号
            match = re.match(r'q(\d+)\.sql', query_file)
            if match:
                query_number = match.group(1)
            else:
                query_number = "N/A"  # 如果文件名不匹配格式，则使用 "N/A" 作为编号

            query_path = path.join(query_directory, query_file)
            output_file = path.splitext(query_file)[0] + '.txt'
            output_path = path.join(results_directory, output_file)

            # 记录开始时间
            start_time = time.time()

            beeline_cmd = f'beeline -u jdbc:hive2://localhost:10000 -f {query_path} > {output_path}'
            print(beeline_cmd)  # 打印命令
            system(beeline_cmd)

            # 记录结束时间
            end_time = time.time()

            # 计算执行时间（秒）
            execution_time = end_time - start_time
            total_execution_time += execution_time

            print(f"Query {query_file} execution time: {execution_time} seconds")

            # 将执行时间和查询编号写入查询执行时间文件（CSV）
            csv_writer.writerow([query_number, execution_time])

    # 将总的查询执行时间写入运行时间文件
    with open(f"{results_directory}/total_execution_time.txt", "w") as total_time_file:
        total_time_file.write(f"Total Execution Time: {total_execution_time} seconds")

