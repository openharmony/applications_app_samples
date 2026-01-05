# 检查change_info.json文件是否存在且有效
if [ ! -f "change_info.json" ] || [ ! -s "change_info.json" ]; then
    echo "错误: change_info.json 文件不存在或为空" >&2
    exit 1
fi

# 定义要跳过的工程目录数组（可根据需要添加）
skip_compile_list=()

# 从路径中去除"entry"目录
remove_entry_dir() {
    local path="$1"
    # 安全地去除路径中的"/entry"部分
    echo "$path" | sed 's|/entry||g'
}

# 检查路径是否在跳过列表中
should_skip() {
    local path="$1"
    for skip_path in "${skip_compile_list[@]}"; do
        if [[ "$path" == *"$skip_path"* ]]; then
            return 0
        fi
    done
    return 1
}

# 查找模块根目录和最后目录名
find_module_root_and_lastdir() {
    local full_path="$1"
    local dir=$(dirname "$full_path")
    # 向上遍历目录树
    while [[ "$dir" != "." && "$dir" != "/" ]]; do
        # 检查必需文件是否存在
        if [[ -f "$dir/build-profile.json5" ]] && { 
            [[ -f "$dir/hvigorfile.js" ]] || 
            [[ -f "$dir/hvigorfile.ts" ]]; 
        }; then
            # 去除路径中的"entry"目录
            local module_root
            module_root=$(remove_entry_dir "$dir")
            
            # 检查build-profile.json5可读
            if [ ! -r "$module_root/build-profile.json5" ]; then
                echo "警告: 无法读取 $module_root/build-profile.json5" >&2
                return 1
            fi

            # 提取compileSdkVersion
            local compile_sdk_version
            compile_sdk_version=$(grep -o '"compileSdkVersion":\s*[0-9]*' "$module_root/build-profile.json5" | awk '{print $2}' | tr -d ',')
            # 过滤20、23版本sdk
            if [[ -n "$compile_sdk_version" && ("$compile_sdk_version" == "20" || "$compile_sdk_version" == "23" ) ]]; then
                # 检查是否在跳过列表中
                if ! should_skip "$module_root"; then
                    # 提取从app_samples开始的相对路径
                    local relative_path
                    relative_path=$(echo "$module_root" | sed -n 's|.*/app_samples/|app_samples/|p')
                    
                    # 获取路径的最后一部分
                    local last_dir
                    last_dir=$(basename "$relative_path")
                    
                    # 输出结果
                    echo "$relative_path,$last_dir"
                    return 0
                fi
            fi
        fi
        dir=$(dirname "$dir")
    done
    
    return 1
}

# 主处理流程
main() {
    # 创建临时文件
    local temp_file
    temp_file=$(mktemp)
    
    # 提取变更文件路径并处理
    jq -r '
    .. | objects | select(has("changed_file_list")).changed_file_list |
    (.added[]? // empty,
     .modified[]? // empty,
     .deleted[]? // empty,
     .rename[]? | if type == "array" then .[0], .[1] else . end // empty) |
    select(. != null and . != "") |
    select(startswith("code/")) |
    sub("^code/"; "")' change_info.json 2>/dev/null | sort -u | while read -r rel_path; do
        
        # 构建完整路径
        local full_path="./applications/standard/app_samples/code/$rel_path"
        
        # 处理每个文件路径
        find_module_root_and_lastdir "$full_path"
    done | sort -u > "$temp_file"  # 去重并保存到临时文件

    # 检查是否有输出
    if [ -s "$temp_file" ]; then
        cat "$temp_file"
    else
        echo "未找到符合条件的模块" >&2
    fi

    # 清理临时文件
    rm -f "$temp_file"
}

# 执行主函数
main