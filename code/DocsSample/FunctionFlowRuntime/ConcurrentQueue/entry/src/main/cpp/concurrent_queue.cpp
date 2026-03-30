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

#include "concurrent_queue.h"
// [Start concurrent_c]

const int SLEEP_TIME = 100 * 1000;
const int BANK_CONCURRENCY = 2;

ffrt_queue_t CreateBankSystem(const char *name, int concurrency)
{
    ffrt_queue_attr_t queue_attr;
    (void)ffrt_queue_attr_init(&queue_attr);
    ffrt_queue_attr_set_max_concurrency(&queue_attr, concurrency);

    // 创建一个并发队列
    ffrt_queue_t queue = ffrt_queue_create(ffrt_queue_concurrent, name, &queue_attr);

    // 队列创建完后需要销毁队列属性
    ffrt_queue_attr_destroy(&queue_attr);
    if (!queue) {
        OH_LOG_INFO(LOG_APP, "create queue failed");
        return NULL;
    }

    OH_LOG_INFO(LOG_APP, "create bank system successfully");
    return queue;
}

void DestroyBankSystem(ffrt_queue_t queue_handle)
{
    ffrt_queue_destroy(queue_handle);
    OH_LOG_INFO(LOG_APP, "destroy bank system successfully");
}

void BankBusiness(void *arg)
{
    usleep(SLEEP_TIME);
    const char *data = (const char *)arg;
    OH_LOG_INFO(LOG_APP, "saving or withdraw for %{public}s", data);
}

// 封装提交队列任务函数
ffrt_task_handle_t CommitRequest(ffrt_queue_t bank, void (*func)(void *), const char *name,
    ffrt_queue_priority_t level, int delay)
{
    ffrt_task_attr_t task_attr;
    (void)ffrt_task_attr_init(&task_attr);
    ffrt_task_attr_set_name(&task_attr, name);
    ffrt_task_attr_set_queue_priority(&task_attr, level);
    ffrt_task_attr_set_delay(&task_attr, delay);

    return ffrt_queue_submit_h_f(bank, func, (void*)name, &task_attr);
}

// 封装取消队列任务函数
int CancelRequest(ffrt_task_handle_t request)
{
    return ffrt_queue_cancel(request);
}

// 封装等待队列任务函数
void WaitForRequest(ffrt_task_handle_t task)
{
    ffrt_queue_wait(task);
}

int ConcurrentQueueCExec()
{
    ffrt_queue_t bank = CreateBankSystem("Bank", BANK_CONCURRENCY);
    if (!bank) {
        printf("create bank system failed\n");
        OH_LOG_INFO(LOG_APP, "create bank system failed");
        return -1;
    }

    ffrt_task_handle_t task1 = CommitRequest(bank, BankBusiness, "customer1", ffrt_queue_priority_low, 0);
    ffrt_task_handle_t task2 = CommitRequest(bank, BankBusiness, "customer2", ffrt_queue_priority_low, 0);
    // VIP享受更优先的服务
    ffrt_task_handle_t task3 = CommitRequest(bank, BankBusiness, "customer3 VIP", ffrt_queue_priority_high, 0);
    ffrt_task_handle_t task4 = CommitRequest(bank, BankBusiness, "customer4", ffrt_queue_priority_low, 0);
    ffrt_task_handle_t task5 = CommitRequest(bank, BankBusiness, "customer5", ffrt_queue_priority_low, 0);

    // 取消客户4的服务
    CancelRequest(task4);

    // 等待所有的客户服务完成
    WaitForRequest(task5);
    DestroyBankSystem(bank);

    ffrt_task_handle_destroy(task1);
    ffrt_task_handle_destroy(task2);
    ffrt_task_handle_destroy(task3);
    ffrt_task_handle_destroy(task4);
    ffrt_task_handle_destroy(task5);
    return 0;
}
// [End concurrent_c]