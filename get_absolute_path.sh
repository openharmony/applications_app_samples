# 检查change_info.json文件是否存在
if [ ! -f "change_info.json" ]; then
    echo "错误:change_info.json 文件不存在" >&2
    exit 1
fi

# 从路径中去除"entry"目录
remove_entry_dir() {
    local path="$1"
    # 使用sed去除路径中的"/entry"部分
    echo "$path" | sed 's/\/entry//g'
}

# 查找模块根目录
find_module_root() {
    local full_path="$1"
    local dir=$(dirname "$full_path")
    
    # 向上遍历目录树
    while [[ "$dir" != "." && "$dir" != "/" ]]; do
        # 检查目录是否同时包含两个必需文件
        if [[ -f "$dir/build-profile.json5" ]] && { [[ -f "$dir/hvigorfile.js" ]] || [[ -f "$dir/hvigorfile.ts" ]]; }; then
            # 去除路径中的"entry"目录并返回
            remove_entry_dir "$dir"
            return 0
        fi
        dir=$(dirname "$dir")
    done
    
    return 1
}

# 主处理流程
{
    # 提取并处理所有变更的文件路径
    jq -r '
    .. | objects | select(has("changed_file_list")).changed_file_list |
    (.added[]? // empty,
     .modified[]? // empty,
     .deleted[]? // empty,
     .rename[]? | if type == "array" then .[0], .[1] else . end // empty) |
    select(. != null and . != "") |
    select(startswith("code/")) |
    sub("^code/"; "")' change_info.json | sort -u | while read -r rel_path; do
        full_path="./applications/standard/app_samples/code/$rel_path"
        find_module_root "$full_path"
    done
} | sort -u  # 去重
