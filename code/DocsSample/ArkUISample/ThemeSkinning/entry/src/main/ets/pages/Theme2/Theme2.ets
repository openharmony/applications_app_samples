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

// [Start custom_theme]
import { CustomColors, CustomTheme, Theme } from '@kit.ArkUI';

class AppColors implements CustomColors {
  public fontPrimary: ResourceColor = $r('app.color.brand_purple');
  public backgroundEmphasize: ResourceColor = $r('app.color.brand_purple');
}

class AppColorsSec implements CustomColors {
  public fontPrimary: ResourceColor = $r('app.color.brand');
  public backgroundEmphasize: ResourceColor = $r('app.color.brand');
}

class AppTheme implements CustomTheme {
  public colors: AppColors = new AppColors();
}

class AppThemeSec implements CustomTheme {
  public colors: AppColors = new AppColorsSec();
}

@Entry
@Component
struct DisplayPage1 {
  @State customTheme: CustomTheme = new AppTheme();
  @State message: string = 'Set a custom theme style for specific pages';
  count = 0;

  build() {
    WithTheme({ theme: this.customTheme }) {
      Row(){
        Column() {
          Text('WithTheme')
            .fontSize(30)
            .margin({bottom: 10})
          Text(this.message)
            .margin({bottom: 10})
          Button('change theme').onClick(() => {
            this.count++;
            if (this.count > 1) {
              this.count = 0;
            }
            switch (this.count) {
              case 0:
                this.customTheme = new AppTheme();
                break;
              case 1:
                this.customTheme = new AppThemeSec();
                break;
              default:
                break;
            }
          })
        }
        .width('100%')
      }
      .height('100%')
      .width('100%')
    }
  }
}
// [End custom_theme]