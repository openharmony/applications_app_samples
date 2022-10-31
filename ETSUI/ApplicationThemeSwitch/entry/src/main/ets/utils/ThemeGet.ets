/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { CustomTheme, DefaultTheme } from '../models/ThemeConst'

const CUSTOM_THEME: number = 3 // 3为自定义主题

// 根据全局变量theme来控制模式 theme 0 1 为系统主题浅色、深色 3为自定义主题
// 判断是否是自定义主题 返回对应类
export function getTheme(theme: number) {
  if (theme === CUSTOM_THEME) {
    return CustomTheme
  } else {
    return DefaultTheme
  }
}