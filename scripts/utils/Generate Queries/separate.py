import os

# 输入文件路径
input_file = '/opt/hive/tpcds-kit/hive_queries/all_ansi_queries.sql'

# 输出目录
output_directory = '/opt/hive/tpcds-kit/hive_queries/ansi_queries'

# 初始化查询编号
query_number = 1

# 用于存储当前查询的内容
current_query = []

with open(input_file, "r") as f:
    for line in f:
        # 如果遇到 "0" 行，表示当前查询结束
        if line.strip() == "0":
            if current_query:
                # 创建查询文件并写入内容
                query_filename = os.path.join(output_directory, f"q{query_number}.sql")
                with open(query_filename, "w") as query_file:
                    query_file.writelines(current_query)
                query_number += 1
                current_query = []  # 重置当前查询
        else:
            current_query.append(line)

# 处理剩余的查询
if current_query:
    query_filename = os.path.join(output_directory, f"q{query_number}.sql")
    with open(query_filename, "w") as query_file:
        query_file.writelines(current_query)

