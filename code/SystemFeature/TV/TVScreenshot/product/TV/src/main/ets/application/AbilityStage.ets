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
import { AbilityStage } from '@kit.AbilityKit';
import Log from '../common/Log';

const TAG = 'MyAbilityStage';

/**
 * MyAbilityStage 是整个 HAP 包的生命周期管理类。
 * 它在 HAP 包加载时首先被实例化，早于任何 Ability 的启动。
 * 这种机制允许开发者在应用启动的最早期进行全局资源的初始化，如日志库配置、监控埋点启动等。
 */
export default class MyAbilityStage extends AbilityStage {
  /**
   * 当 AbilityStage 实例创建时触发。
   * 业务背景：应用进程刚启动，正在准备运行环境。
   * 原理：在此处打印日志作为应用启动的第一个锚点，有助于在复杂的系统启动日志中快速定位本应用的初始化时机。
   */
  onCreate(): void {
    Log.showInfo(TAG, 'MyAbilityStage onCreate is called');
  }
}
