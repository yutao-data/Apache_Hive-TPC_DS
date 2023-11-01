#!/bin/bash

# 设置文件夹路径
folder_path="/opt/1Gdataforsplit"

# 循环处理文件夹中的所有 .dat 文件
for file in "$folder_path"/*.dat; do
    if [ -f "$file" ]; then
        # 获取文件名（不包含路径）
        file_name=$(basename "$file")

        # 使用 split 命令分割文件成三等分
        split -n 2 "$file" "$file_name.part"

        # 移动生成的分割文件到指定位置
        mv "$file_name.part"* /opt/tpcds_data0.5GB/
    fi
done

