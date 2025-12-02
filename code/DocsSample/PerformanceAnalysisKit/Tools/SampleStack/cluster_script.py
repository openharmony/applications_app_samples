// [Start sample_stack_cluster]
import re
from collections import Counter, defaultdict
import os
import pandas as pd
import zipfile
import glob
from pathlib import Path

# 日志目录
log_dir = r"D:\log\input"  # 改成你日志目录
# 输出结果
output_file = r"D:\log\stack_summary.txt"
# 匹配堆栈行
stack_line_pattern = re.compile(r'^\s*(#\d+\s+pc\s+[0-9a-f]+.*|#?\d*\s*at .+)$')


# 判断是否是业务栈
def is_business_stack(line):
    line = line.strip()
    return re.match(r'^(#\d+\s+)?at .+\(.+\)$', line) is not None


def process_log_file(path):
    with open(path, "r", encoding="utf-8", errors='ignore') as f:
        lines = f.readlines()

    all_stacks = []
    current_stack = []
    for line in lines:
        if line.startswith("SnapshotTime:"):
            if current_stack:
                all_stacks.append(current_stack)
                current_stack = []
        elif stack_line_pattern.match(line):
            # 忽略无关紧要的系统行
            if re.match(r'#\d+\s+pc\s+[0-9a-f]+$', line.strip()):
                continue
            current_stack.append(line.strip())
    if current_stack:
        all_stacks.append(current_stack)

    # 对同一日志的堆栈进行计数
    stack_counter = Counter()
    for stack in all_stacks:
        business_lines = [line for line in stack if is_business_stack(line)]
        if business_lines:
            key = "\n".join(business_lines[0:5])
        else:
            key = "\n".join(stack)
        stack_counter[key] += 1

    # 只保留出现次数大于5的
    result = {k: v for k, v in stack_counter.items() if v >= 1}
    return result


def remove_lineno(line):
    return re.sub(r'^#\d+\s+', '', line.strip())


def normalize_frame(line: str) -> str:
    """
    去掉无关信息，提取业务栈的关键部分
    """
    line = line.strip()
    # 去掉 "#数字 pc 地址" 或 "#数字 at"
    line = re.sub(r'^#\d+\s+(pc\s+[0-9a-f]+\s+)?', '', line)
    # 去掉行号 (:123:1)
    line = re.sub(r':\d+(:\d+)?', '', line)
    return line


def is_business_frame(line: str) -> bool:
    """
    判断是否是业务栈
    """
    return (
            line.startswith("at ") or
            "/data/storage/" in line
    )


def unzip_all(src_dir, dest_dir):
    # 确保目标目录存在
    os.makedirs(dest_dir, exist_ok=True)

    # 找到所有 zip 文件
    zip_files = glob.glob(os.path.join(src_dir, "*.zip"))

    for zip_path in zip_files:
        # 以 zip 文件名（去掉扩展名）作为子目录
        base_name = os.path.splitext(os.path.basename(zip_path))[0]
        extract_path = os.path.join(dest_dir, base_name)

        os.makedirs(extract_path, exist_ok=True)

        # 解压
        with zipfile.ZipFile(zip_path, "r") as zip_ref:
            zip_ref.extractall(extract_path)

        print(f"✅ 解压完成: {zip_path} → {extract_path}")

    print(f"\n全部解压完成，共 {len(zip_files)} 个 zip 文件。")


def get_cluster(input_dir):
    input_file = os.path.join(input_dir, 'stack_summary.txt')
    # 统计次数和代表性堆栈
    cluster_count = defaultdict(int)
    cluster_sample = {}  # 片段 key -> 代表性完整堆栈

    current_stack = []
    current_count = 0

    with open(input_file, "r", encoding="utf-8") as f:
        for line in f:
            line = line.rstrip()
            if line.startswith("出现次数:"):
                current_count = int(re.search(r'\d+', line).group())
                current_stack = []
            elif line.startswith("=" * 10) or line == "":
                if current_stack:
                    # 找第一个业务栈
                    business_frame = None
                    for frame in current_stack:
                        norm = normalize_frame(frame)
                        if is_business_frame(norm):
                            business_frame = norm
                            break
                    if business_frame:
                        cluster_count[business_frame] += 1
                        if business_frame not in cluster_sample:  # 保存代表性堆栈
                            cluster_sample[business_frame] = "\n".join(current_stack)
                current_stack = []
            else:
                current_stack.append(line)
    output_file = os.path.join(input_dir, '业务栈聚类.txt')
    # 输出到txt
    with open(output_file, "w", encoding="utf-8") as f:
        for top_line, total_count in sorted(cluster_count.items(), key=lambda x: x[1], reverse=True):
            f.write(f"业务栈: {top_line}\n")
            f.write(f"总出现次数: {total_count}\n")
            f.write("代表性完整堆栈:\n")
            f.write(cluster_sample[top_line] + "\n")
            f.write("-" * 80 + "\n")

    print(f"业务栈聚类完成，结果输出到 {output_file}")

    # 输出到excel
    rows = []
    for key, count in sorted(cluster_count.items(), key=lambda x: x[1], reverse=True):
        rows.append({
            "业务栈片段": key,
            "总出现次数": count,
            "代表性完整堆栈": cluster_sample[key]
        })
    output_excel = os.path.join(input_dir, '业务栈聚类.xlsx')
    df = pd.DataFrame(rows)
    df.to_excel(output_excel, index=False)
    print(f"业务栈聚类已导出到 {output_excel}")


def get_stack_summary(log_dir, output_dir):
    all_results = {}
    for root, dirs, files in os.walk(log_dir):
        for filename in files:
            if "freeze-cpuinfo-ext" in filename:
                path = os.path.join(root, filename)
                result = process_log_file(path)
                if result:
                    all_results[path] = result
    folder = Path(output_dir)  #统一转成 Path
    output_file = folder / 'stack_summary.txt'  #自动拼路径
    folder.mkdir(parents=True, exist_ok=True)
    # 输出结果
    with open(output_file, "w", encoding="utf-8") as f:
        for log_file, stacks in all_results.items():
            f.write(f"日志文件: {log_file}\n")
            for stack_text, count in stacks.items():
                f.write(f"出现次数: {count}\n")
                f.write(stack_text + "\n")
                f.write("=" * 80 + "\n")
    print(f"处理完成，结果输出到 {output_file}")


def get_all_result(log_dir, output_dir):
    unzip_all(log_dir, log_dir)
    get_stack_summary(log_dir, output_dir)
    get_cluster(output_dir)


if __name__ == "__main__":
    get_all_result(r"D:\log\input", r"D:\log\output")
// [End sample_stack_cluster]