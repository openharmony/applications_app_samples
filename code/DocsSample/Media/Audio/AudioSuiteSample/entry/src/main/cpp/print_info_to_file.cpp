/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

#include "print_info_to_file.h"
// [Start audioSuite_PrintInfo]
#include <ohaudiosuite/native_audio_suite_base.h>
#include <fcntl.h>
#include <unistd.h>
// [StartExclude audioSuite_PrintInfo]

static OH_AudioSuiteEngine *g_printInfoEngine = nullptr;

napi_value TestPrintInfoToFile(napi_env env, napi_callback_info info)
{
    napi_value result;
    napi_get_boolean(env, false, &result);

    // [EndExclude audioSuite_PrintInfo]
    // engine为已创建的OH_AudioSuiteEngine实例，必须确保`engine`参数有效，否则输出内容为空。
    // pipeline为nullptr时输出所有管线，传入具体管线实例则仅输出该管线。
    OH_AudioSuiteEngine *engine = audioSuiteEngine;
    if (!engine) {
        OH_AudioSuiteEngine_Create(&g_printInfoEngine);
        engine = g_printInfoEngine;
    }

    // 打印编创快照到文件。
    const char *filePath =
        "/storage/Users/currentUser/Download/com.example.audiosuitesample/printfile/audio_snapshot.txt";
    int fd = open(filePath, O_WRONLY | O_CREAT | O_APPEND, 0644);
    if (fd < 0) {
        // 文件打开失败，回退到日志输出。
        // fd < 0表示输出到日志。
        OH_AudioSuite_PrintInfo(engine, nullptr, -1);
        napi_get_boolean(env, true, &result);
        return result;
    }
    
    // 输出所有管线信息到文件。
    // nullptr表示输出engine下所有pipeline，fd为文件描述符。
    OH_AudioSuite_Result ret = OH_AudioSuite_PrintInfo(engine, nullptr, fd);
    close(fd);
    // [End audioSuite_PrintInfo]
    if (ret == AUDIOSUITE_SUCCESS) {
        napi_get_boolean(env, true, &result);
    }
    return result;
}