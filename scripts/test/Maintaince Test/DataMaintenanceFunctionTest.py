import subprocess
import time
import sys

# 获取传递给脚本的参数
if len(sys.argv) != 4:
    print("Usage: python DataMaintenanceFunctionTest.py <SQL_FILE> <DATABASE_NAME> <RESULT_DIRECTORY>")
    sys.exit(1)

sql_file = sys.argv[1]
database_name = sys.argv[2]
result_directory = sys.argv[3]

# 准备执行的Beeline命令
beeline_command = f"beeline -u jdbc:hive2://localhost:10000 -e 'use {database_name}; source {sql_file};'"

# 记录开始时间
start_time = time.time()

# 执行Beeline命令
try:
    subprocess.check_call(beeline_command, shell=True)
    execution_time = time.time() - start_time
except subprocess.CalledProcessError:
    print("Error: Beeline command execution failed.")
    sys.exit(1)

# 记录结束时间
end_time = time.time()

# 记录执行时间到结果文件
result_file = f"{result_directory}/DataMaintenanceFunctionResult.txt"
with open(result_file, "a") as f:
    f.write(f"SQL File: {sql_file}\n")
    f.write(f"Start Time: {time.strftime('%Y-%m-%d %H:%M:%S', time.gmtime(start_time))}\n")
    f.write(f"End Time: {time.strftime('%Y-%m-%d %H:%M:%S', time.gmtime(end_time))}\n")
    f.write(f"Total Execution Time: {execution_time:.2f} seconds\n")
    f.write("\n")

print("SQL script execution completed.")

