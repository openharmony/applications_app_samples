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

/**
 * 上传下载常量
 */

// 任务常量
export default class TaskConstants {
  public static readonly TASK_MAX: number = 10;
  // 同时开启最大任务数
  public static readonly TASK_PAUSE_MSG: number = -1;
  // 暂停
  public static readonly TASK_RESUME_MSG: number = -2;
  // 继续下载
  public static readonly TASK_NET_PAUSE_MSG: number = -3;
  // 网络异常
  public static readonly TASK_NET_RESUME_MSG: number = -4;
  // 网络恢复
}

// 后台任务区状态
export enum BackgroundTaskState {
  NONE = 0,
  RUNNING = 1,
  PAUSE = 2
}