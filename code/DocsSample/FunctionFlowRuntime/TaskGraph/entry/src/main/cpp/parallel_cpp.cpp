/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

#include "parallel_cpp.h"

// [Start parallel_dep_cpp]
const int FIB_NUM = 5;

int DependenceCppExec()
{
    // 提交任务
    auto handle_A = ffrt::submit_h([] () { OH_LOG_INFO(LOG_APP, "视频解析"); });
    auto handle_B = ffrt::submit_h([] () { OH_LOG_INFO(LOG_APP, "视频转码"); }, {handle_A});
    auto handle_C = ffrt::submit_h([] () { OH_LOG_INFO(LOG_APP, "视频生成缩略图"); }, {handle_A});
    auto handle_D = ffrt::submit_h([] () { OH_LOG_INFO(LOG_APP, "视频添加水印"); }, {handle_B, handle_C});
    ffrt::submit([] () { OH_LOG_INFO(LOG_APP, "视频发布"); }, {handle_D});

    // 等待所有任务完成
    ffrt::wait();
    return 0;
}
// [End parallel_dep_cpp]
// [Start parallel_fib_cpp]
void Fib(int x, int& y)
{
    if (x <= 1) {
        y = x;
    } else {
        int y1;
        int y2;

        // 提交任务并构建数据依赖
        ffrt::submit([&]() { Fib(x - 1, y1); }, {&x}, {&y1});
        // 斐波那契数列所需递归-2
        ffrt::submit([&]() { Fib(x - 2, y2); }, {&x}, {&y2});

        // 等待任务完成
        ffrt::wait({&y1, &y2});
        y = y1 + y2;
    }
}

int FibCppExec()
{
    int y;
    Fib(FIB_NUM, y);
    std::cout << "Fibonacci(5) is " << y << std::endl;
    OH_LOG_INFO(LOG_APP, "Fibonacci(5) is %{pubilc}d", y);
    return y;
}
// [End parallel_fib_cpp]