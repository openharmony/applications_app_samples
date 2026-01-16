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

// [Start How_To_Fix_Incorrect_Character_Display_Show_Effect]
@Extend(Text)
function styleDirection() {
  .width(80)
  .height(30)
  .backgroundColor('rgb(0, 74, 175)')
  .textAlign(TextAlign.Center)
}

@Extend(Text)
function styleTextAlign() {
  .width(80)
  .height(30)
  .backgroundColor('rgb(39, 135, 217)')
  .textAlign(TextAlign.Center)
}

@Extend(Text)
function textStyle() {
  .width(300)
  .height(30)
  .backgroundColor('rgb(240, 250, 255)')
}

interface directionConfig {
  dir: Direction,
  align: TextAlign,
  textKey: string
}

@Entry
@Component
export struct HowToFixIncorrectCharacterDisplayShowEffectExample {
  @State text1: string = '(+86)123 4567 890中文';
  @State text2: string = '(+86)123 4567 890اللغة العربية';
  private directionConfig: directionConfig[] = [
    { dir: Direction.Ltr, align: TextAlign.Start, textKey: this.text1 },
    { dir: Direction.Ltr, align: TextAlign.End, textKey: this.text1 },
    { dir: Direction.Rtl, align: TextAlign.Start, textKey: this.text1 },
    { dir: Direction.Rtl, align: TextAlign.End, textKey: this.text1 },
    { dir: Direction.Ltr, align: TextAlign.Start, textKey: this.text2 },
    { dir: Direction.Ltr, align: TextAlign.End, textKey: this.text2 },
    { dir: Direction.Rtl, align: TextAlign.Start, textKey: this.text2 },
    { dir: Direction.Rtl, align: TextAlign.End, textKey: this.text2 }
  ];

  build() {
    NavDestination() {
      Scroll() {
        Column({ space: 5 }) {
          // 标题行保持不变
          Row() {
            Text('direction').styleDirection()
            Text('textAlign').styleTextAlign()
            Text('text').textStyle().textAlign(TextAlign.Center)
          }

          // 使用ForEach重构内容行
          ForEach(this.directionConfig, (item: directionConfig, index) => {
            Column() {
              Row() {
                Text(item.dir === Direction.Ltr ? 'Ltr' : 'Rtl').styleDirection()
                Text(item.align === TextAlign.Start ? 'Start' : 'End').styleTextAlign()
                Text(item.textKey)
                  .direction(item.dir)
                  .textAlign(item.align)
                  .textStyle()
              }

              // 在第四个元素后插入空白
              if (index === 3) {
                Blank().height(10)
              }
            }
          })
        }
        .padding(20)
      }
      .scrollable(ScrollDirection.Horizontal)
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.How_To_Fix_Incorrect_Character_Display_Show_Effect'))
  }
}

// [End How_To_Fix_Incorrect_Character_Display_Show_Effect]