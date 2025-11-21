/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "napi/native_api.h"
#include "cstring"
#include <cstdio>
#include <cstdlib>
#include <dirent.h>
#include <fstream>
#include <filemanagement/environment/oh_environment.h>
#include <hilog/log.h>
#include <filemanagement/fileio/oh_fileio.h>
#include <sys/stat.h>

#undef LOG_TAG
#define LOG_TAG "Sample_NDKEnvironment"

std::string g_path = "";

// [Start get_user_download_dir_example]
void GetUserDownloadDirExample()
{
    char *downloadPath = nullptr;
    FileManagement_ErrCode ret = OH_Environment_GetUserDownloadDir(&downloadPath);
    if (ret == 0) {
        OH_LOG_INFO(LOG_APP, "Download Path=%{public}s", downloadPath);
        free(downloadPath);
    } else {
        OH_LOG_ERROR(LOG_APP, "GetDownloadPath fail, error code is %{public}d", ret);
    }
}
// [End get_user_download_dir_example]

static napi_value DoGetUserDownloadDirExample(napi_env env, napi_callback_info info)
{
    GetUserDownloadDirExample();
    return nullptr;
}

// [Start scan_user_download_dir_path_example]
void ScanUserDownloadDirPathExample()
{
    // 获取 download 路径
    char *downloadPath = nullptr;
    FileManagement_ErrCode ret = OH_Environment_GetUserDownloadDir(&downloadPath);
    if (ret == 0) {
        OH_LOG_INFO(LOG_APP, "Download Path=%{public}s", downloadPath);
    } else {
        OH_LOG_ERROR(LOG_APP, "GetDownloadPath fail, error code is %{public}d", ret);
        return;
    }
    // 查看文件夹下的文件
    struct dirent **namelist = nullptr;
    int num = scandir(downloadPath, &namelist, nullptr, nullptr);
    if (num < 0) {
        free(downloadPath);
        OH_LOG_ERROR(LOG_APP, "Failed to scan dir");
        return;
    }

    for (int i = 0; i < num; i++) {
        OH_LOG_INFO(LOG_APP, "%{public}s", namelist[i]->d_name);
    }
    free(downloadPath);
    for (int i = 0; i < num; i++) {
        free(namelist[i]);
    }
    free(namelist);
}
// [End scan_user_download_dir_path_example]

static napi_value DoScanUserDownloadDirPathExample(napi_env env, napi_callback_info info)
{
    ScanUserDownloadDirPathExample();
    return nullptr;
}

// [Start write_user_download_dir_path_example]
void WriteUserDownloadDirPathExample()
{
    // 获取 download 路径
    char *downloadPath = nullptr;
    FileManagement_ErrCode ret = OH_Environment_GetUserDownloadDir(&downloadPath);
    if (ret == 0) {
        OH_LOG_INFO(LOG_APP, "Download Path=%{public}s", downloadPath);
    } else {
        OH_LOG_ERROR(LOG_APP, "GetDownloadPath fail, error code is %{public}d", ret);
        return;
    }
    // 保存文件到 download 目录下
    std::string filePath = std::string(downloadPath) + "/temp.txt";
    free(downloadPath);

    std::ofstream outfile;
    outfile.open(filePath.c_str());
    if (!outfile) {
        OH_LOG_ERROR(LOG_APP, "Failed to open file");
        return;
    }
    std::string msg = "Write a message";
    outfile.write(msg.c_str(), msg.size());
    outfile.close();
}
// [End write_user_download_dir_path_example]

static napi_value DoWriteUserDownloadDirPathExample(napi_env env, napi_callback_info info)
{
    WriteUserDownloadDirPathExample();
    return nullptr;
}

// [Start get_user_download_dir_path_example]
void GetUserDownloadDirPathExample()
{
    char *downloadPath = nullptr;
    FileManagement_ErrCode ret = OH_Environment_GetUserDownloadDir(&downloadPath);
    if (ret == 0) {
        OH_LOG_INFO(LOG_APP, "Download Path=%{public}s", downloadPath);
        free(downloadPath);
    } else {
        OH_LOG_ERROR(LOG_APP, "GetDownloadPath fail, error code is %{public}d", ret);
    }
}
// [End get_user_download_dir_path_example]

static napi_value DoGetUserDownloadDirPathExample(napi_env env, napi_callback_info info)
{
    GetUserDownloadDirPathExample();
    return nullptr;
}

// [Start get_user_desktop_dir_path_example]
void GetUserDesktopDirPathExample()
{
    char *desktopPath = nullptr;
    FileManagement_ErrCode ret = OH_Environment_GetUserDesktopDir(&desktopPath);
    if (ret == 0) {
        OH_LOG_INFO(LOG_APP, "Desktop Path=%{public}s", desktopPath);
        free(desktopPath);
    } else {
        OH_LOG_ERROR(LOG_APP, "GetDesktopPath fail, error code is %{public}d", ret);
    }
}
// [End get_user_desktop_dir_path_example]
static napi_value DoGetUserDesktopDirPathExample(napi_env env, napi_callback_info info)
{
    GetUserDesktopDirPathExample();
    return nullptr;
}

// [Start get_user_document_dir_path_example]
void GetUserDocumentDirPathExample()
{
    char *documentPath = nullptr;
    FileManagement_ErrCode ret = OH_Environment_GetUserDocumentDir(&documentPath);
    if (ret == 0) {
        OH_LOG_INFO(LOG_APP, "Document Path=%{public}s", documentPath);
        free(documentPath);
    } else {
        OH_LOG_ERROR(LOG_APP, "GetDocumentPath fail, error code is %{public}d", ret);
    }
}
// [End get_user_document_dir_path_example]

static napi_value DoGetUserDocumentDirPathExample(napi_env env, napi_callback_info info)
{
    GetUserDocumentDirPathExample();
    return nullptr;
}

// [Start get_user_download_dir_size_example]
void GetUserDownloadDirSizeExample()
{
    char *documentPath = nullptr;
    FileManagement_ErrCode ret = OH_Environment_GetUserDocumentDir(&documentPath);
    if (ret == 0) {
        OH_LOG_INFO(LOG_APP, "Document Path=%{public}s", documentPath);
        struct stat fileStat;
        int result = stat(documentPath, &fileStat);
        if (result == 0) {
            OH_LOG_INFO(LOG_APP, "Document Size=%{public}ld", fileStat.st_size);
        } else {
            OH_LOG_ERROR(LOG_APP, "GetDocumentSize fail, error code is %{public}ld", result);
        }
        free(documentPath);
    } else {
        OH_LOG_ERROR(LOG_APP, "GetDocumentPath fail, error code is %{public}d", ret);
    }
}
// [End get_user_download_dir_size_example]

static napi_value DoGetUserDownloadDirSizeExample(napi_env env, napi_callback_info info)
{
    GetUserDownloadDirSizeExample();
    return nullptr;
}

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports)
{
    napi_property_descriptor desc[] = {{"doGetUserDownloadDirExample", nullptr, DoGetUserDownloadDirExample, nullptr,
                                        nullptr, nullptr, napi_default, nullptr},
                                       {"doScanUserDownloadDirPathExample", nullptr, DoScanUserDownloadDirPathExample,
                                        nullptr, nullptr, nullptr, napi_default, nullptr},
                                       {"doWriteUserDownloadDirPathExample", nullptr, DoWriteUserDownloadDirPathExample,
                                        nullptr, nullptr, nullptr, napi_default, nullptr},
                                       {"doGetUserDownloadDirPathExample", nullptr, DoGetUserDownloadDirPathExample,
                                        nullptr, nullptr, nullptr, napi_default, nullptr},
                                       {"doGetUserDesktopDirPathExample", nullptr, DoGetUserDesktopDirPathExample,
                                        nullptr, nullptr, nullptr, napi_default, nullptr},
                                       {"doGetUserDocumentDirPathExample", nullptr, DoGetUserDocumentDirPathExample,
                                        nullptr, nullptr, nullptr, napi_default, nullptr},
                                       {"doGetUserDownloadDirSizeExample", nullptr, DoGetUserDownloadDirSizeExample,
                                        nullptr, nullptr, nullptr, napi_default, nullptr}
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module demoModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = Init,
    .nm_modname = "entry",
    .nm_priv = ((void *)0),
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterEntryModule(void) { napi_module_register(&demoModule); }
