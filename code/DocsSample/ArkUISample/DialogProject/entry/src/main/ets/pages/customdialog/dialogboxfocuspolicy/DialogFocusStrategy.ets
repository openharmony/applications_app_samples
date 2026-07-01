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

// [Start dialog_focus]
@Entry
@Component
export struct Index {
  // [Start dialog_focus_text]
  @State dialogIdIndex: number = 0;
  // 请在resources\base\element\string.json文件中配置name为'dialog_message'，value为非空字符串的资源
  private message: string =
    this.getUIContext().getHostContext()?.resourceManager.getStringByNameSync('dialog_message') as string;
  // 存储所有弹窗延时关闭定时器ID数组，页面销毁统一清除
  private timerIdList: number[] = [];
  // 标记页面是否已销毁，销毁后不再执行弹窗关闭逻辑
  private isPageDestroy: boolean = false;

  @Builder
  customDialogComponent() {
    Column({ space: 5 }) {
      Text(this.message + this.dialogIdIndex)
        .fontSize(30)
    }
    .height(200)
    .padding(5)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  // [End dialog_focus_text]

  /**
   * 页面销毁生命周期：清除所有定时器，防止延时关闭弹窗触发异常、内存泄漏
   */
  aboutToDisappear(): void {
    this.isPageDestroy = true;
    // 遍历清除全部未执行的定时器
    this.timerIdList.forEach(timerId => {
      clearTimeout(timerId);
    });
    this.timerIdList = [];
  }

  build() {
    NavDestination() {
      Column({ space: 5 }) {
        // [Start dialog_focus_text_input]
        TextInput()
          .onChange(() => {
            this.dialogIdIndex++;
            this.getUIContext().getPromptAction().openCustomDialog({
              builder: () => {
                this.customDialogComponent();
              },
              focusable: false
            }).then((dialogId: number) => {
              // 创建延时关闭定时器
              const timerId = setTimeout(() => {
                // 页面已销毁则直接跳过关闭逻辑
                if (this.isPageDestroy) {
                  return;
                }
                this.getUIContext().getPromptAction().closeCustomDialog(dialogId);
                // 关闭弹窗后移除已完成定时器记录
                const idx = this.timerIdList.findIndex(item => item === timerId);
                if (idx > -1) {
                  this.timerIdList.splice(idx, 1);
                }
              }, 3000);
              // 保存定时器ID，页面销毁时统一清理
              this.timerIdList.push(timerId);
            }).catch((err: BusinessError) => {
              console.error(`Failed to open dialog. Error code: ${err.code}`);
            });
          })
        // [End dialog_focus_text_input]
      }.width('100%')
    }
  }
}

// [End dialog_focus]