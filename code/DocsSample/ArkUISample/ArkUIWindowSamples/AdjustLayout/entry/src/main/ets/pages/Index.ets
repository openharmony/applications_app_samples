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

// [Start aspectRatio]
// [Start enableDrag]
// Index.ets
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import hilog from '@ohos.hilog';

const DOMAIN = 0x0000;
const TAG = 'IndexPage';

// [StartExclude aspectRatio]
// [StartExclude enableDrag]
@Entry
@Component
struct Index {
  @StorageLink('WINDOW_ASPECT_RATIO_ENABLED') aspectRatioEnabled: boolean = false;
  @StorageLink('SUB_WINDOW_VISIBILITY_ENABLED')showSubWindowEnabled: boolean = false;
  @StorageLink('SUB_WINDOW_RESIZE_ENABLED') resizeEnabled: boolean = true;
  @StorageLink('SUB_WINDOW_MOVE_ENABLED') moveEnabled: boolean = true;

  @State minWidthText: string = '200';
  @State maxWidthText: string = '1000';
  @State minHeightText: string = '100';
  @State maxHeightText: string = '500';
  @State resultText: string = '等待操作';

  private getMainWindow(): window.Window | undefined {
    return AppStorage.get<window.Window>('MAIN_WINDOW');
  }

  private getSubWindow(): window.Window | undefined {
    return AppStorage.get<window.Window>('SUB_WINDOW');
  }

  /**

   控制子窗口显示隐藏
   */
  private setSubWindowVisibilityEnabled(enabled: boolean): void {
    const subWindow = this.getSubWindow();
    if (!subWindow) {
      this.resultText = '子窗口未创建';
      return;
    }
    if (enabled) {
      subWindow.showWindow().then(() => {
        AppStorage.setOrCreate('SUB_WINDOW_VISIBILITY_ENABLED', enabled);
        this.resultText = '已显示子窗口';
        console.info('drr:Succeeded in show subwindow.');
      }).catch((err: Error) => {
        const businessError = err as BusinessError;
        this.resultText = `显示子窗口失败: ${JSON.stringify(businessError)}`;
        hilog.error(DOMAIN, TAG, `show subwindow failed: ${JSON.stringify(businessError)}`);
      });
    } else {
      subWindow.minimize().then(() => {
        AppStorage.setOrCreate('SUB_WINDOW_VISIBILITY_ENABLED', enabled);
        this.resultText = '已隐藏子窗口';
        console.info('drr:Succeeded in hide subwindow.');
      }).catch((err: Error) => {
        const businessError = err as BusinessError;
        this.resultText = `隐藏子窗口失败: ${JSON.stringify(businessError)}`;
        hilog.error(DOMAIN, TAG, `hide subwindow failed: ${JSON.stringify(businessError)}`);
      });
    }
  }

// [EndExclude enableDrag]
  /**
   通过enableDrag控制子窗口的拖拽缩放功能
   */
  private setSubWindowResizeEnabled(enabled: boolean): void {
    const subWindow = this.getSubWindow();
    if (!subWindow) {
      this.resultText = '子窗口未创建';
      return;
    }

    subWindow.enableDrag(enabled)
      .then(() => {
        AppStorage.setOrCreate<boolean>('SUB_WINDOW_RESIZE_ENABLED', enabled);
        this.resultText = enabled ? '已开启子窗拖拽大小' : '已关闭子窗拖拽大小';
      })
      .catch((err: Error) => {
        const businessError = err as BusinessError;
        this.resultText = `设置拖拽大小失败: ${JSON.stringify(businessError)}`;
        hilog.error(DOMAIN, TAG, `set resize drag failed: ${JSON.stringify(businessError)}`);
      });
  }
// [End enableDrag]

  /**
   通过startMoving控制子窗口的拖拽移动功能
   */
  private setSubWindowMoveEnabled(enabled: boolean): void {
    AppStorage.setOrCreate('SUB_WINDOW_MOVE_ENABLED', enabled);
    this.resultText = enabled ? '已开启子窗拖拽位置' : '已关闭子窗拖拽位置';
  }

// [EndExclude aspectRatio]
  /**
   步骤2：为主窗口设置指定宽高比例
   */
  private setWindowAspectRatioEnabled(enabled: boolean): void {
    const mainWindow = this.getMainWindow();
    if (!mainWindow) {
      this.resultText = '找不到主窗口';
      return;
    }
    if (enabled) {
      const ratio = 1.5;
      // 设置可布局内容宽高比限制
      mainWindow.setContentAspectRatio(ratio)
        .then(() => {
          AppStorage.setOrCreate('WINDOW_ASPECT_RATIO_ENABLED', enabled);
          this.resultText = '已开启比例限制';
        })
        .catch((err: Error) => {
          const businessError = err as BusinessError;
          this.resultText = `设置比例限制失败: ${JSON.stringify(businessError)}`;
          hilog.error(DOMAIN, TAG, `set aspect ratio failed: ${JSON.stringify(businessError)}`);
        });
    } else {
      // 取消可布局内容宽高比限制
      mainWindow.resetAspectRatio()
        .then(() => {
          AppStorage.setOrCreate('WINDOW_ASPECT_RATIO_ENABLED', enabled);
          this.resultText = '已关闭比例限制';
        })
        .catch((err: Error) => {
          const businessError = err as BusinessError;
          this.resultText = `重置比例限制失败: ${JSON.stringify(businessError)}`;
          hilog.error(DOMAIN, TAG, `reset aspect ratio failed: ${JSON.stringify(businessError)}`);
        });
    }
  }
// [End aspectRatio]

  private parsePositiveInt(value: string): number | undefined {
    const trimValue = value.trim();

    if (!/^\d+$/.test(trimValue)) {
      return undefined;
    }
    const result = Number.parseInt(trimValue);

    if (!Number.isFinite(result) || result <= 0) {
      return undefined;
    }
    return result;
  }

  /**
   为子窗口设置windowLimits
   */
  private setSubWindowLimits(): void {
    const subWindow = this.getSubWindow();
    if (!subWindow) {
      this.resultText = '子窗口未创建';
      return;
    }

    const minWidth = this.parsePositiveInt(this.minWidthText);
    const maxWidth = this.parsePositiveInt(this.maxWidthText);
    const minHeight = this.parsePositiveInt(this.minHeightText);
    const maxHeight = this.parsePositiveInt(this.maxHeightText);
    if (
      minWidth === undefined ||
        maxWidth === undefined ||
        minHeight === undefined ||
        maxHeight === undefined
    ) {
      this.resultText = '输入非法：windowLimits 必须是正整数';
      return;
    }
    if (minWidth > maxWidth) {
      this.resultText = '输入非法：minWidth 不能大于 maxWidth';
      return;
    }
    if (minHeight > maxHeight) {
      this.resultText = '输入非法：minHeight 不能大于 maxHeight';
      return;
    }

    subWindow.setWindowLimits({
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight
    })
      .then(() => {
        this.resultText =
          `设置成功：width[${minWidth}, ${maxWidth}], height[${minHeight}, ${maxHeight}]`;
      })
      .catch((err: Error) => {
        const businessError = err as BusinessError;
        this.resultText = `设置 windowLimits 失败: ${JSON.stringify(businessError)}`;
        hilog.error(DOMAIN, TAG, `set windowLimits failed: ${JSON.stringify(businessError)}`);
      });
  }

  build() {
    Scroll() {
      Column() {
        Text('Main Window')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)

        Button(this.aspectRatioEnabled ? '关闭主窗比例限制' : '开启主窗比例限制')
          .width('80%')
          .height(40)
          .onClick(() => {
            this.setWindowAspectRatioEnabled(!this.aspectRatioEnabled);
          })

        Button(this.showSubWindowEnabled ? '隐藏子窗' : '显示子窗')
          .width('80%')
          .height(40)
          .margin({ top: 12 })
          .onClick(() => {
            this.setSubWindowVisibilityEnabled(!this.showSubWindowEnabled);
          })

        Button(this.resizeEnabled ? '关闭子窗拖拽大小' : '开启子窗拖拽大小')
          .width('80%')
          .height(40)
          .margin({ top: 12 })
          .onClick(() => {
            this.setSubWindowResizeEnabled(!this.resizeEnabled);
          })

        Button(this.moveEnabled ? '关闭子窗拖拽位置' : '开启子窗拖拽位置')
          .width('80%')
          .height(40)
          .margin({ top: 12 })
          .onClick(() => {
            this.setSubWindowMoveEnabled(!this.moveEnabled);
          })

        Column() {
          Text('子窗口 windowLimits')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 12 })

          Row() {
            Text('minWidth')
              .width(90)
              .fontSize(14)

            TextInput({ text: this.minWidthText })
              .type(InputType.Number)
              .width(160)
              .onChange((value: string) => {
                this.minWidthText = value;
              })

            Text('maxWidth')
              .width(90)
              .fontSize(14)

            TextInput({ text: this.maxWidthText })
              .type(InputType.Number)
              .width(160)
              .onChange((value: string) => {
                this.maxWidthText = value;
              })
          }
          .margin({ top: 8 })

          Row() {
            Text('minHeight')
              .width(90)
              .fontSize(14)

            TextInput({ text: this.minHeightText })
              .type(InputType.Number)
              .width(160)
              .onChange((value: string) => {
                this.minHeightText = value;
              })

            Text('maxHeight')
              .width(90)
              .fontSize(14)

            TextInput({ text: this.maxHeightText })
              .type(InputType.Number)
              .width(160)
              .onChange((value: string) => {
                this.maxHeightText = value;
              })
          }
          .margin({ top: 8 })

          Button('设置子窗口 windowLimits')
            .width('80%')
            .height(44)
            .margin({ top: 16 })
            .onClick(() => {
              this.setSubWindowLimits();
            })
        }
        .width('90%')
        .padding(16)
        .margin({ top: 24 })
        .border({
          width: 1,
          color: '#D0D7DE',
          radius: 12
        })
        .backgroundColor('#FFFFFF')

        Text(this.resultText)
          .id('resultText')
          .fontSize(14)
          .fontColor('#333333')
          .margin({ top: 20 })
          .width('90%')
      }
      .width('100%')
      .padding({ top: 40, bottom: 40 })
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F7FA')
  }
}