/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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
 
/*
 * 基于 wrapBuilder 和 WrappedBuilder 的简单页面示例
 * 功能：展示包装后的 @Builder 方法调用及动态更新
 */
// [Start wrapbuilder_page_one]
declare function wrapBuilder<Args extends Object[]>(builder: (...args: Args) => void): WrappedBuilder<Args>;

// 1. 全局 @Builder 方法（符合 wrapBuilder 全局限制）
@Builder
function simpleTextBuilder(content: string, size: number) {
  Text(content)
    .fontSize(size)
    .fontColor('#333')
    .padding(5);
}

@Builder
function simpleButtonBuilder(text: string, bgColor: string) {
  Button(text)
    .fontSize(14)
    .backgroundColor(bgColor)
    .padding({ left: 15, right: 15, top: 6, bottom: 6 })
    .borderRadius(4);
}

// 2. 用 wrapBuilder 包装全局 @Builder，定义数组
let wrappedText: WrappedBuilder<[string, number]> = wrapBuilder(simpleTextBuilder);
let wrappedBtn1: WrappedBuilder<[string, string]> = wrapBuilder(simpleButtonBuilder);
let wrappedBtn2: WrappedBuilder<[string, string]> = wrapBuilder(simpleButtonBuilder);
const buttonBuilders: WrappedBuilder<[string, string]>[] = [wrappedBtn1, wrappedBtn2];

// 3. 主页面组件（@Entry 必须有单一根容器）
@Entry
@Component
struct WrapBuilderSimplePage {
  // 动态数据（用 @State 管理状态更新）
  @State info: string = 'initial information';
  @State textSize: number = 16;

  build() {
    // 唯一根容器：所有子组件必须嵌套在这个 Column 内部
    Column({ space: 20 }) {
      // 1. 标题（子组件，正确嵌套在根 Column 内）
      Text('wrapBuilder simple example')
        .fontSize(20)
        .fontWeight('bold') // 用字符串避免枚举问题
        .margin({ bottom: 10 });

      // 2. 包装后的文本展示（子组件，嵌套在根 Column 内）
      Column() {
        Text('Display of wrapped text:')
          .fontSize(14)
          .fontColor('#666')
          .margin({ bottom: 8 });

        wrappedText.builder(this.info, this.textSize);
      }
      .padding(10)
      .backgroundColor('#f0f0f0')
      .borderRadius(6);

      // 3. 交互按钮（子组件，嵌套在根 Column 内）
      Row({ space: 15 }) {
        // 按钮1：修改内容
        Column() {
          buttonBuilders[0].builder('modify the content', '#4e5969');
        }
        .onClick(() => {
          this.info = 'the updated content';
          this.textSize = 18;
        });

        // 按钮2：重置
        Column() {
          buttonBuilders[1].builder('reset', '#f56c6c');
        }
        .onClick(() => {
          this.info = 'initial information';
          this.textSize = 16;
        });
      }
    }
    // 根 Column 的属性（紧跟在根容器代码块之后）
    .width('100%')
    .height('100%')
    .padding(20)
  } // 闭合 build() 方法
} // 闭合 struct 组件
// [End wrapbuilder_page_one]