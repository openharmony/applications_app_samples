'''
#  Copyright (c) 2023 Huawei Device Co., Ltd.
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at

#      http://www.apache.org/licenses/LICENSE-2.0

#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
'''

import datetime
import json
import os
import re
import shutil
import stat
import subprocess
import sys
import time

import paramiko

import LinuxContains


install_fail_dict = {}
install_success_dict = {}
total_hap_num = 0
hap_install_success = 0
hap_install_fail = 0
special_num = 0
special_hap_list = []
depend_config_map = dict

CONFIG_PATH='D:\\window_manager_config.xml'
FINGER_PRINT = '8E93863FC32EE238060BF69A9B37E2608FFFB21F93C862DD511CBAC9F30024B5'
repeat_time = 0
snapshot = 1


def exec_cmd(cmd):
    f = os.popen(f"hdc shell \"{cmd}\"")
    # print(cmd)
    text = f.read()
    f.close()

    
    return text


def exec_cmd_path(cmd, path):
    f = os.popen(f"hdc shell \"{cmd}\" >> {path}")
    # print(cmd)
    text = f.read()
    f.close()
    return text


def exec_cmd_simple(cmd):
    f = os.popen(cmd)
    # print(cmd)
    text = f.read()
    f.close()
    return text

def exists(file_path):
    return os.path.exists(file_path)


def get_haps(local_dir):
    files = os.listdir(local_dir)
    hap_list = []
    for file in files:
        if "_signed" in file:
            hap_list.append(file)
    return hap_list


def install_hap(hap, hap_path, base_dir):
    # print("install " + hap_path + "\\" + hap)
    if not exists(os.path.join(hap_path, hap)):
        return
    install_res = exec_cmd_simple(f"hdc install -r {hap_path}/{hap}"))
    # print(install_res)
    if not install_res.__contains__("msg:install bundle successfully."):
        install_res = install_res.replace("\nAppMod finish\n\n", "")
        install_fail_dict[hap] = install_res
    else:
        exec_cmd_simple(f"echo install {hap} success! >> {base_dir}/auto_test.log")
        install_success_dict[hap] = install_res
    time.sleep(2)


def install_depend_haps(curr_haps, hap_path, base_dir):
    for hap in curr_haps:
        if not depend_config_map.get(hap):
            continue
        depend_haps = depend_config_map.get(hap)
        for depend_hap in depend_haps:
            install_hap(depend_hap, hap_path, base_dir)
        install_depend_haps(depend_haps, hap_path, base_dir)


def get_test_bundle(begin_bundles):
    end_bundles = get_all_bundles()
    return list(set(end_bundles) - set(begin_bundles))


def install_haps(local_hap, hap_path, base_dir):
    for hap in local_hap:
        install_hap(hap, hap_path, base_dir)


def start_log():
    cmd_clean = "rm -r /data/log/hilog/*"
    cmd_start = "hilog -w start -l 1M"
    exec_cmd(cmd_clean)
    exec_cmd(cmd_start)


def stop_log():
    cmd_stop = "hilog -w stop"
    exec_cmd(cmd_stop)


def recv_log(local_log):
    # 输出日志结果
    file_path = local_log
    cmd = f"hdc file recv /data/log/hilog/ {file_path}"
    exec_cmd_simple(cmd)


def test_install_hap_with_error_snapshot(uninstall_bundles, base_dir):
    with open(LinuxContains.FA_MODAL_AND_LOWER_CASE_LIST,'r',encoding='utf-8') as fp:
        FA_Python_Obj=json.load(fp)
        is_stage_model=0
        for key,value in FA_Python_Obj.items():
            for bundle_name in uninstall_bundles:
                # print("key:  "+key)
                bundle_name=bundle_name.strip()
                if bundle_name==key:
                    is_stage_model=is_stage_model+1
            if is_stage_model == 0:
                cmd = r"hdc shell aa test -b {} -p com.example.entry_test -m entry_test -s unittest /ets/TestRunner/OpenHarmonyTestRunner -s timeout 30000000 "
            else:
                cmd=  r"hdc shell aa test -b {} -p com.example.entry_test -m entry_test -s unittest OpenHarmonyTestRunner -s timeout 30000000 "
    path = f"{base_dir}/auto_test.log"
    if len(uninstall_bundles) != 1:
        exec_cmd_simple("echo uninstall_bundles:{0}, >> {1}".format(uninstall_bundles, path))
    for bundle in uninstall_bundles:
        bundle = bundle.strip()
        exec_cmd_simple("echo ================start {0} ui test================{1} >> {2}".format(bundle,
                                                                                                  datetime.datetime.now().strftime(
                                                                                                      '%Y-%m-%d %H:%M:%S'),
                                                                                                  path))
        # print("test " + bundle)
        tmp_cmd = cmd.format(bundle)
        # print(tmp_cmd)
        p = subprocess.Popen(tmp_cmd, shell=True, close_fds=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE,
                             stderr=subprocess.PIPE, encoding="utf-8")
        current = "-1"
        auto_log = open(f"{base_dir}/auto_test.log", mode='a')
        while True:
            line = p.stdout.readline()
            auto_log.writelines(line)
            if line and "current" in line:
                nums = re.findall(r"\d+", line)
                if (len(nums) == 0):
                    current = "0"
                else:
                    current = nums[0]
            if line and "stack" in line:
                exec_cmd_simple(
                    f"hdc shell snapshot_display -f /data/snapshot/{bundle}_{current}.jpeg")
            if line == '' and p.poll() != None:
                break
        exec_cmd_simple(f"hdc file recv /data/snapshot/. {base_dir}/snapshot")
        exec_cmd_simple("hdc shell rm -rf /data/snapshot/*")
        auto_log.flush()
        auto_log.close()
        time.sleep(5)


def test_install_hap(test_bundles, base_dir):
    cmd = r"aa test -b {} -p com.example.entry_test -m entry_test -s unittest OpenHarmonyTestRunner -s timeout 30000000"
    path = f"{base_dir}/auto_test.log"
    for bundle in test_bundles:
        bundle = bundle.strip()
        if bundle == 'ohos.samples.launcher':
            cmd_launcher = 'hdc shell aa start -b ohos.samples.launcher -a MainAbility'
            os.system(cmd_launcher)
        exec_cmd_simple(f"echo ================start {bundle} ui test================{datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')} >> {path}")
        # print("test " + bundle)
        tmp_cmd = cmd.format(bundle)
        exec_cmd_path(tmp_cmd, path)
        time.sleep(5)


def uninstall_bundles(install_bundles):
    for bundle in install_bundles:
        # print("uninstall " + bundle)
        uninstall_res = exec_cmd_simple(f"hdc uninstall {bundle}")


def clear_dir(dir_path):
    if os.path.exists(dir_path):
        shutil.rmtree(dir_path)
    os.makedirs(dir_path)


def clear_file(file_path):
    if os.path.exists(file_path):
        os.remove(file_path)
    os.system(r"type nul>{}".format(file_path))


def get_all_bundles():
    bundles = exec_cmd("bm dump -a")
    bundles = bundles.splitlines()
    del bundles[0]
    return bundles


def batch_install(haps, base_dir):
    start_log()
    exec_cmd_simple("hdc shell power-shell setmode 602")
    # exec_cmd_simple("hdc shell setenforce 0")
    exec_cmd_simple("hdc shell param set persist.ace.testmode.enabled 1")
    exec_cmd_simple("hdc shell mkdir /data/snapshot")
    limit = 2
    count = 0
    time = 0                                                                  
    cur_batch_hap = []
    special_haps = LinuxContains.SPECIAL_HAP.split(";")
    target_paths = LinuxContains.TARGET_PATH.split(";")
    begin_bundles = get_all_bundles()
    while time <= repeat_time:
        for hap in haps:
        
            isTargetPath = False
            for target_path in target_paths:
                if hap.startswith(target_path):
                    isTargetPath = True
            if not isTargetPath:
                continue

            isSpecialSkip = False
            for special_hap in special_haps:
                if special_hap in hap:
                    global special_num
                    isSpecialSkip = True
                    special_hap_list.append(hap)
                    special_num = special_num + 1
                    break
            if isSpecialSkip:
                continue

            cur_batch_hap.append(hap)
            count = count + 1
            if count == limit:
                install_haps(cur_batch_hap, LinuxContains.SIGN_HAP_PATH, base_dir)
                test_bundles = get_test_bundle(begin_bundles)
                install_depend_haps(cur_batch_hap, LinuxContains.SIGN_HAP_PATH, base_dir)
                all_install_bundles = get_test_bundle(begin_bundles)
                if snapshot == 0:
                    test_install_hap(test_bundles, base_dir)
                else:
                    test_install_hap_with_error_snapshot(test_bundles, base_dir)
                count = 0
                uninstall_bundles(all_install_bundles)
                cur_batch_hap.clear()
        if len(cur_batch_hap) != 0:
            install_haps(cur_batch_hap, LinuxContains.SIGN_HAP_PATH, base_dir)
            test_bundles = get_test_bundle(begin_bundles)
            install_depend_haps(cur_batch_hap, LinuxContains.SIGN_HAP_PATH, base_dir)
            all_install_bundles = get_test_bundle(begin_bundles)
            if snapshot == 0:
                test_install_hap(test_bundles, base_dir)
            else:
                test_install_hap_with_error_snapshot(test_bundles, base_dir)
            uninstall_bundles(all_install_bundles)
            cur_batch_hap.clear()
        time += 1
    stop_log()
    recv_log(base_dir + "/")


def handle_test_log(base_dir):
    file = open(f"{base_dir}/auto_test.log", encoding='utf-8', errors='ignore')
    p_num = 0
    fail_num = 0
    success_num = 0
    test_exp_num = 0
    test_pass_num = 0
    test_fail_num = 0
    test_error_num = 0
    died_num = 0
    fail_dict = []
    died_dict = []
    curr_name = ""
    has_result = 1
    for x in file:
        if x.startswith(r"================start"):
            if (has_result == 0):
                fail_num = fail_num + 1
                fail_dict.append(curr_name)
            else:
                has_result = 0
            p_num = p_num + 1
            curr_name = x.split(" ")[1]
        if x.startswith(r"OHOS_REPORT_RESULT"):
            has_result = 1
            nums = re.findall(r"\d+", x)
            if len(nums) == 4 or len(nums) == 5:
                if nums[0] == nums[3] and int(nums[0]) != 0:
                    success_num = success_num + 1
                else:
                    fail_num = fail_num + 1
                    fail_dict.append(curr_name)
                test_exp_num = test_exp_num + int(nums[0])
                test_fail_num = test_fail_num + int(nums[1])
                test_error_num = test_error_num + int(nums[2])
                test_pass_num = test_pass_num + int(nums[3])
            else:
                fail_num = fail_num + 1
                fail_dict.append(curr_name)
        elif x.__contains__("App died"):
            has_result = 1
            died_num = died_num + 1
            died_dict.append(curr_name)

    file.close()

    error_log = open(f"{base_dir}/auto_test.log", mode='a')
    error_log.writelines(
        f"共完成测试项目 {int(p_num + special_num / 2)}个,成功{success_num}个，失败{fail_num}个，异常中止(App died){died_num}个，特殊应用跳过{int(special_num / 2)}个\n")
    
    error_log.writelines(
        f"共完成测试用例 {test_exp_num}个,成功{test_pass_num}个，失败{test_fail_num}个，错误{test_error_num}个\n")
    print(f"successNum:{success_num} failNum:{fail_num} diedNum:{died_num} specialNum:{int(special_num / 2)} testNum:{test_exp_num} testSuccessNum:{test_pass_num} testFailNum:{test_fail_num} testErrorNum:{test_error_num}")
    if len(fail_dict) > 0:
        error_log.writelines("失败工程BundleName如下：\n")
        for x in fail_dict:
            error_log.writelines("     " + x + "\n")
    if len(died_dict) > 0:
        error_log.writelines("异常中止(App died)工程BundleName如下：\n")
        for x in died_dict:
            error_log.writelines("     " + x + "\n")
    error_log.writelines(f"安装失败项目数量:{len(install_fail_dict)}\n")
    for i in install_fail_dict:
        error_log.writelines(f'{i} : {install_fail_dict[i]}')
    if len(special_hap_list) > 0:
        error_log.writelines(f"特殊安装跳过Hap数量:{special_num}\n")
        for i in special_hap_list:
            error_log.writelines(i + "\n")
    error_log.flush()
    error_log.close()
    if fail_num != 0 or died_num != 0 or len(install_fail_dict) != 0:
        print ('test failed !!')
    else:
        return ('test success !!')

def init_out():
    base_dir = sys.path[0]
    out_path = f"{base_dir}/ui_test_out/{datetime.datetime.now().strftime('%Y%m%d')}")
    print(out_path)
    clear_dir(out_path)
    for log_dir in ['errorLog','successLog','SampleSignHap','auto_test.log','hilog','snapshot']:
        clear_dir(f"{out_path}/{log_dir}")
    return out_path


def add_permission(bundle_name, finger_print):
    KEY_NAME = 'install_list'
    f = open(LinuxContains.INSTALL_LIST_CAPABILITY, 'r')
    if bundle_name in f.read():
        with open(LinuxContains.INSTALL_LIST_CAPABILITY, "r", encoding="utf-8") as f:
            old_data = json.load(f)
            # print(bundle_name + " 已存在，需要修改权限")
            for i in old_data[KEY_NAME]:
                if i['bundleName'] == bundle_name:
                    i['app_signature'][0] = finger_print
        with open(LinuxContains.INSTALL_LIST_CAPABILITY, "w", encoding="utf-8") as f:
            json.dump(old_data, f)

    else:
        # 追加权限
        permission_fields = {
            "bundleName": bundle_name,
            "app_signature": [finger_print],
            "allowAppUsePrivilegeExtension": True
        }
        with open(LinuxContains.INSTALL_LIST_CAPABILITY, "r", encoding="utf-8") as f:
            old_data = json.load(f)
            # 这里就是那个列表List
            old_data[KEY_NAME].append(permission_fields)
            # print(bundle_name + " 不存在，需要追加权限")
        with open(LinuxContains.INSTALL_LIST_CAPABILITY, "w", encoding="utf-8") as f:
            json.dump(old_data, f)


def pull_list():
    cmd_pull = "hdc shell mount -o rw,remount / & hdc file recv /system/etc/app/install_list_capability.json"
    os.system(cmd_pull)


def push_list():
    cmd_push = "hdc shell mount -o rw,remount /  & hdc file send install_list_capability.json /system/etc/app/install_list_capability.json & hdc shell chmod 777 /system/etc/app/install_list_capability.json & hdc shell reboot"
    # print(cmd_push)
    os.system(cmd_push)
    time.sleep(40)  # 等待重启
    cmd_unlock = 'hdc shell power-shell wakeup & hdc shell uinput -T -m 100 200 100 900 600 & hdc shell power-shell setmode 602'  # 亮屏并解锁屏幕
    # print("设置屏幕常亮")
    # print(cmd_unlock)
    os.system(cmd_unlock)


def load_config_to_dict(config_file):
    with open(config_file, encoding='utf-8') as a:
        # 读取文件
        global depend_config_map
        depend_config_map = json.load(a)
        # print(type (depend_config_map))


def replace_enable(file,old_str,new_str):
    with open(file, "r", encoding="utf-8") as f1,open("%s.bak" % file, "w", encoding="utf-8") as f2:
        for line in f1:
            if old_str in line:
                line = line.replace(old_str, new_str)
            f2.write(line)
    os.remove(file)
    os.rename("%s.bak" % file, file)


def pull_config():
    cmd=f'hdc shell mount -o rw,remount / & hdc file recv system/etc/window/resources/window_manager_config.xml {LinuxContains.SAVE_XML_PATH}'
    os.system(cmd)


def push_config():
    cmd=f'hdc file send {LinuxContains.SAVE_XML_PATH}/window_manager_config.xml system/etc/window/resources/window_manager_config.xml'


if __name__ == '__main__':
    load_config_to_dict(LinuxContains.COMBIN_CONFIG)
    # print(depend_config_map)

    # 创建ui_test_out文件夹及子文件夹
    out_base = init_out()
    # pull_config()
    # replace_enable(CONFIG_PATH,'decor enable="false"','decor enable="true"')
    # push_config()

    # 拉install_list_capability.json
    pull_list()

    # 特殊安装应用，添加权限
    with open(LinuxContains.SPECIAL_LIST,'r',encoding='utf-8') as fp:
        python_obj=json.load(fp)
        for key,value in python_obj.items():
            add_permission(value[0],FINGER_PRINT)
    
    # 推install_list_capability.json，重启解锁
    push_list()
    # sftp_from_remote("{0}\\SampleSignHap".format(out_base), "{0}\\errorLog".format(out_base),
    #                  "{0}\\successLog".format(out_base))
    haps = get_haps(LinuxContains.SIGN_HAP_PATH)
    total_hap_num = len(haps) / 2
    batch_install(haps, out_base)
    handle_test_log(out_base)