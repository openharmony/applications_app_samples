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

// [Start app_theme]
import { CustomColors, CustomTheme } from '@kit.ArkUI';

export class AppColors implements CustomColors {
  // 自定义主题色
  public brand: ResourceColor = '#FF75D9';
  // 使用$r，让一级警示色在深色和浅色模式下，设置为不同的颜色
  public warning: ResourceColor = $r('app.color.start_window_background');
}

export class AppTheme implements CustomTheme {
  public colors: AppColors = new AppColors();
}

export let gAppTheme: CustomTheme = new AppTheme();
// [End app_theme]