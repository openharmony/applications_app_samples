import os
import json
import re
import sys
from pathlib import Path

def find_change_info_file():
    """查找并验证change_info.json文件"""
    current_dir = Path.cwd()
    while current_dir != Path('/'):
        change_info_path = current_dir / 'change_info.json'
        if change_info_path.is_file() and change_info_path.stat().st_size > 0:
            return change_info_path
        current_dir = current_dir.parent
    return None

def remove_entry_dir(path):
    """从路径中去除'entry'目录"""
    return str(path).replace('/entry', '')

def find_module_root_and_lastdir(full_path):
    """查找模块根目录和最后目录名"""
    full_path = Path(full_path)
    dir_path = full_path.parent
    
    while dir_path != Path('.').resolve() and dir_path != Path('/'):
        # 检查必需文件是否存在
        build_profile = dir_path / 'build-profile.json5'
        hvigorfile_js = dir_path / 'hvigorfile.js'
        hvigorfile_ts = dir_path / 'hvigorfile.ts'
        
        if build_profile.is_file() and (hvigorfile_js.is_file() or hvigorfile_ts.is_file()):
            # 去除路径中的"entry"目录
            module_root = Path(remove_entry_dir(dir_path))
            
            # 检查build-profile.json5可读
            if not os.access(module_root / 'build-profile.json5', os.R_OK):
                print("[Sample]警告: 无法读取 {}/build-profile.json5".format(module_root), file=sys.stderr)
                return None
            
            # 提取compileSdkVersion
            try:
                with open(module_root / 'build-profile.json5', 'r') as f:
                    content = f.read()
                    match = re.search(r'"compileSdkVersion":\s*(\d+)', content)
                    if match:
                        compile_sdk_version = match.group(1)
                        # 过滤20、23版本sdk
                        if compile_sdk_version in ('20', '23'):
                            # 获取相对路径（相对于当前目录）
                            relative_path = module_root.relative_to(Path.cwd())
                            
                            # 获取路径的最后一部分
                            last_dir = relative_path.name
                            
                            # 输出结果
                            return f"app_samples/{relative_path},{last_dir}"
            except Exception as e:
                print(f"[Sample]警告: 处理build-profile.json5时出错: {e}", file=sys.stderr)
                return None
        
        dir_path = dir_path.parent
    
    return None

def main():
    """主处理流程"""
    # 查找并验证change_info.json文件
    change_info_file = find_change_info_file()
    if not change_info_file:
        print("[Sample]错误: 未找到有效的 change_info.json 文件", file=sys.stderr)
        sys.exit(1)
    
    # 处理单引号：将文件中的单引号替换为双引号
    try:
        with open(change_info_file, 'r') as f:
            change_info_content = f.read().replace("'", '"')
    except Exception as e:
        print(f"[Sample]错误: 读取change_info.json失败: {e}", file=sys.stderr)
        sys.exit(1)
    
    # 解析JSON内容
    try:
        data = json.loads(change_info_content)
    except json.JSONDecodeError as e:
        print(f"[Sample]错误: 解析change_info.json失败: {e}", file=sys.stderr)
        sys.exit(1)
    
    # 存储结果的集合（自动去重）
    results = set()
    
    # 递归查找所有changed_file_list
    def extract_files(obj):
        if isinstance(obj, dict):
            if 'changed_file_list' in obj:
                changed_files = obj['changed_file_list']
                for key in ['added', 'modified', 'deleted']:
                    if key in changed_files and isinstance(changed_files[key], list):
                        for item in changed_files[key]:
                            if item:
                                yield item
                if 'rename' in changed_files:
                    rename = changed_files['rename']
                    if isinstance(rename, list):
                        for item in rename:
                            if isinstance(item, list):
                                for subitem in item:
                                    if subitem:
                                        yield subitem
                            elif item:
                                yield item
            for value in obj.values():
                yield from extract_files(value)
        elif isinstance(obj, list):
            for item in obj:
                yield from extract_files(item)
    
    # 处理每个文件路径
    for rel_path in extract_files(data):
        if not rel_path:
            continue
        
        # 构建完整路径（相对于当前目录）
        full_path = Path.cwd() / rel_path
        
        output = find_module_root_and_lastdir(full_path)
        if output:
            results.add(output)
    
    # 输出结果
    if results:
        for item in sorted(results):
            print(f"{item}")
    else:
        print("[Sample]未找到任何模块", file=sys.stderr)

if __name__ == "__main__":
    main()