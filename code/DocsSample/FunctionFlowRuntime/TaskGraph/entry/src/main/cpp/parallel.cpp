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

#include "parallel.h"

// [Start parallel_dep_c]
void FuncTaskA(void* arg)
{
    OH_LOG_INFO(LOG_APP, "视频解析");
    printf("视频解析\n");
}

void FuncTaskB(void* arg)
{
    OH_LOG_INFO(LOG_APP, "视频转码");
    printf("视频转码\n");
}

void FuncTaskC(void* arg)
{
    OH_LOG_INFO(LOG_APP, "视频生成缩略图");
    printf("视频生成缩略图\n");
}

void FuncTaskD(void* arg)
{
    OH_LOG_INFO(LOG_APP, "视频添加水印");
    printf("视频添加水印\n");
}

void FuncTaskE(void* arg)
{
    OH_LOG_INFO(LOG_APP, "视频发布");
    printf("视频发布\n");
}

int DependenceCExec()
{
    // 提交任务A
    ffrt_task_handle_t hTaskA = ffrt_submit_h_f(FuncTaskA, NULL, NULL, NULL, NULL);

    // 提交任务B和C
    ffrt_dependence_t taskA_deps[] = {{ffrt_dependence_task, hTaskA}};
    ffrt_deps_t dTaskA = {1, taskA_deps};
    ffrt_task_handle_t hTaskB = ffrt_submit_h_f(FuncTaskB, NULL, &dTaskA, NULL, NULL);
    ffrt_task_handle_t hTaskC = ffrt_submit_h_f(FuncTaskC, NULL, &dTaskA, NULL, NULL);

    // 提交任务D
    ffrt_dependence_t taskBC_deps[] = {{ffrt_dependence_task, hTaskB}, {ffrt_dependence_task, hTaskC}};
    ffrt_deps_t dTaskBC = {2, taskBC_deps};
    ffrt_task_handle_t hTaskD = ffrt_submit_h_f(FuncTaskD, NULL, &dTaskBC, NULL, NULL);

    // 提交任务E
    ffrt_dependence_t taskD_deps[] = {{ffrt_dependence_task, hTaskD}};
    ffrt_deps_t dTaskD = {1, taskD_deps};
    ffrt_submit_f(FuncTaskE, NULL, &dTaskD, NULL, NULL);

    // 等待所有任务完成
    ffrt_wait();

    ffrt_task_handle_destroy(hTaskA);
    ffrt_task_handle_destroy(hTaskB);
    ffrt_task_handle_destroy(hTaskC);
    ffrt_task_handle_destroy(hTaskD);
    return 0;
}
// [End parallel_dep_c]
// [Start parallel_fib_c]
const int FIB_NUM = 5;
typedef struct {
    int x;
    int* y;
} FibFfrtS;

void FibFfrt(void* arg)
{
    FibFfrtS* p = (FibFfrtS*)arg;
    int x = p->x;
    int* y = p->y;

    if (x <= 1) {
        *y = x;
    } else {
        int y1;
        int y2;
        FibFfrtS s1 = {x - 1, &y1};
        FibFfrtS s2 = {x - 2, &y2};

        // 构建数据依赖
        ffrt_dependence_t dx_deps[] = {{ffrt_dependence_data, &x}};
        ffrt_deps_t dx = {1, dx_deps};
        ffrt_dependence_t dy1_deps[] = {{ffrt_dependence_data, &y1}};
        ffrt_deps_t dy1 = {1, dy1_deps};
        ffrt_dependence_t dy2_deps[] = {{ffrt_dependence_data, &y2}};
        ffrt_deps_t dy2 = {1, dy2_deps};
        ffrt_dependence_t dy12_deps[] = {{ffrt_dependence_data, &y1}, {ffrt_dependence_data, &y2}};
        ffrt_deps_t dy12 = {2, dy12_deps};

        // 分别提交任务
        ffrt_submit_f(FibFfrt, &s1, &dx, &dy1, NULL);
        ffrt_submit_f(FibFfrt, &s2, &dx, &dy2, NULL);

        // 等待任务完成
        ffrt_wait_deps(&dy12);
        *y = y1 + y2;
    }
}

int FibCExec()
{
    int r;
    FibFfrtS s = {FIB_NUM, &r};
    ffrt_dependence_t dr_deps[] = {{ffrt_dependence_data, &r}};
    ffrt_deps_t dr = {1, dr_deps};
    ffrt_submit_f(FibFfrt, &s, NULL, &dr, NULL);

    // 等待任务完成
    ffrt_wait_deps(&dr);
    OH_LOG_INFO(LOG_APP, "Fibonacci result: %{public}d", r);
    printf("Fibonacci(5) is %d\n", r);
    return r;
}
// [End parallel_fib_c]