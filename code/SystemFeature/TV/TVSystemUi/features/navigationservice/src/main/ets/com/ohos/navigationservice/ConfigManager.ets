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
 

const  STORAGE_NAVIGATION_TYPE = 'navigationType';

// ConfigManager 在导航栏启动时将 navigationType 初始化为 3（TV 三键导航模式），
// 固定写入 AppStorage 而非从配置文件读取，是因为 TV 形态不支持用户切换导航模式，
// 硬编码可避免配置文件缺失或读取失败时出现导航栏布局异常。
export class ConfigManager{

  constructor() {
  }

  initConfig() {
    let mLayoutConfig = AppStorage.setAndLink('navigationType', 0);
    // 覆盖写入 3，强制使用 TV 专用三键导航布局，确保大屏遥控器操作模式下按键与 UI 区域严格对应。
    mLayoutConfig.set(3);
  }

}

let configManager = new ConfigManager();
export default configManager as ConfigManager;
