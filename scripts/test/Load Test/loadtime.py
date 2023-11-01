import os
import time
import subprocess
import sys

# input dat_dir
dat_dir = sys.argv[1]

# input database_name
database_name = sys.argv[2]

# loadtime.txt dir
loadtime_dir = sys.argv[3]

# connect loadtime_dir and loadtime.txt
loadtime_file = os.path.join(loadtime_dir, "loadtime.txt")

# Beeline connection
beeline_connection = f"jdbc:hive2://localhost:10000/{database_name}"

# SQL scriptlist
sql_scripts = []

sql_scripts.append(f"LOAD DATA INPATH '{dat_dir}/customer_address.dat' INTO TABLE customer_address;")
sql_scripts.append(f"LOAD DATA INPATH '{dat_dir}/customer_demographics.dat' INTO TABLE customer_demographics;")
sql_scripts.append(f"LOAD DATA INPATH '{dat_dir}/date_dim.dat' INTO TABLE date_dim;")
sql_scripts.append(f"LOAD DATA INPATH '{dat_dir}/warehouse.dat' INTO TABLE warehouse;")
sql_scripts.append(f"LOAD DATA INPATH '{dat_dir}/ship_mode.dat' INTO TABLE ship_mode;")
sql_scripts.append(f"LOAD DATA INPATH '{dat_dir}/time_dim.dat' INTO TABLE time_dim;")
sql_scripts.append(f"LOAD DATA INPATH '{dat_dir}/reason.dat' INTO TABLE reason;")
sql_scripts.append(f"LOAD DATA INPATH '{dat_dir}/income_band.dat' INTO TABLE income_band;")
sql_scripts.append(f"LOAD DATA INPATH '{dat_dir}/item.dat' INTO TABLE item;")
sql_scripts.append(f"LOAD DATA INPATH '{dat_dir}/store.dat' INTO TABLE store;")
sql_scripts.append(f"LOAD DATA INPATH '{dat_dir}/call_center.dat' INTO TABLE call_center;")
sql_scripts.append(f"LOAD DATA INPATH '{dat_dir}/customer.dat' INTO TABLE customer;")
sql_scripts.append(f"LOAD DATA INPATH '{dat_dir}/web_site.dat' INTO TABLE web_site;")
sql_scripts.append(f"LOAD DATA INPATH '{dat_dir}/store_returns.dat' INTO TABLE store_returns;")
sql_scripts.append(f"LOAD DATA INPATH '{dat_dir}/household_demographics.dat' INTO TABLE household_demographics;")
sql_scripts.append(f"LOAD DATA INPATH '{dat_dir}/web_page.dat' INTO TABLE web_page;")
sql_scripts.append(f"LOAD DATA INPATH '{dat_dir}/promotion.dat' INTO TABLE promotion;")
sql_scripts.append(f"LOAD DATA INPATH '{dat_dir}/catalog_page.dat' INTO TABLE catalog_page;")
sql_scripts.append(f"LOAD DATA INPATH '{dat_dir}/inventory.dat' INTO TABLE inventory;")
sql_scripts.append(f"LOAD DATA INPATH '{dat_dir}/catalog_returns.dat' INTO TABLE catalog_returns;")
sql_scripts.append(f"LOAD DATA INPATH '{dat_dir}/web_returns.dat' INTO TABLE web_returns;")
sql_scripts.append(f"LOAD DATA INPATH '{dat_dir}/web_sales.dat' INTO TABLE web_sales;")
sql_scripts.append(f"LOAD DATA INPATH '{dat_dir}/catalog_sales.dat' INTO TABLE catalog_sales;")
sql_scripts.append(f"LOAD DATA INPATH '{dat_dir}/store_sales.dat' INTO TABLE store_sales;")


start_time = time.time()

# connect beeline
combined_script = "\n".join(script.replace('dat_dir', dat_dir) for script in sql_scripts)
print("Executing SQL scripts...")
subprocess.call(["beeline", "-u", beeline_connection, "-e", combined_script])

# calculate total_time
end_time = time.time()
total_time = end_time - start_time

print(f"SQL scripts executed, total time: {total_time} seconds")

# write to file
with open(loadtime_file, "w") as file:
    file.write(f"Total execution time: {total_time} seconds")

