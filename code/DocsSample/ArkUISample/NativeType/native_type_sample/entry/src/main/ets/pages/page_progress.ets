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
import ProgressNapi from 'libentry.so';
import { NodeContent } from '@kit.ArkUI';

enum ProgressType {
  LINEAR = 0,
  RING = 1,
  ECLIPSE,
  SCALE_RING,
  CAPSULE,
}
interface LinearProgressStyle {
  scanEffect?: boolean; // 扫描效果开关
  smoothEffect?: boolean; // 平滑效果开关
  strokeWidth?: number; // 线宽
  strokeRadius?: number; // 圆角半径
  // 可根据实际需求扩展其他属性，如颜色、进度值等
}

@Entry
@Component
struct Index {
  private nodeContent: Content = new NodeContent();
  @State progressType: string = '未设置';
  @State status: string = '';
  @State styleOption: string = '';
  @State progressValue: number = 0;
  @State customStyle: LinearProgressStyle = {
    scanEffect: true,
    smoothEffect: true,
    strokeWidth: 10,
    strokeRadius: 10
  };

  @Builder
  SubMenuProgressType() {
    Menu() {
      MenuItem({ content: 'ARKUI_PROGRESS_TYPE_LINEAR' }).width('50%').onChange(()=> {
        this.progressType = 'ARKUI_PROGRESS_TYPE_LINEAR';ProgressNapi.setProgressType(ProgressType.LINEAR)
      })
      MenuItem({ content: 'ARKUI_PROGRESS_TYPE_RING'}).width('50%').onChange(()=> {
        this.progressType = 'ARKUI_PROGRESS_TYPE_RING' ;ProgressNapi.setProgressType(ProgressType.RING)
      })
      MenuItem({ content: 'ARKUI_PROGRESS_TYPE_ECLIPSE'}).width('50%').onChange(()=> {
        this.progressType = 'ARKUI_PROGRESS_TYPE_ECLIPSE' ;ProgressNapi.setProgressType(ProgressType.ECLIPSE)
      })
      MenuItem({ content: 'ARKUI_PROGRESS_TYPE_SCALE_RING'}).width('50%').onChange(()=> {
        this.progressType = 'ARKUI_PROGRESS_TYPE_SCALE_RING' ;ProgressNapi.setProgressType(ProgressType.SCALE_RING)
      })
      MenuItem({ content: 'ARKUI_PROGRESS_TYPE_CAPSULE'}).width('50%').onChange(()=> {
        this.progressType = 'ARKUI_PROGRESS_TYPE_CAPSULE' ;ProgressNapi.setProgressType(ProgressType.CAPSULE)
      })
    }
  }

  build() {
    Row() {
      Column() {
        Row() {
          Column() {
            Row() {
              Text($r('app.string.Smooth_effect'))
              Toggle({ type: ToggleType.Switch, isOn: true })
                .onChange((isOn) => {
                  this.customStyle.smoothEffect  = isOn;
                })
              Text($r('app.string.Scan_effect'))
              Toggle({ type: ToggleType.Switch, isOn: true })
                .onChange((isOn) => {
                  this.customStyle.scanEffect = isOn;
                })
            }
            Row() {
              Text($r('app.string.Stroke_width'))
              TextInput()
                .type(InputType.Number)
                .onChange((value) => {
                  this.customStyle.strokeWidth = parseInt(value);
                })
                .width(100)
            }
            Row() {
              Text($r('app.string.Stroke_radius'))
              TextInput()
                .type(InputType.Number)
                .onChange((value) => {
                  this.customStyle.strokeRadius = parseInt(value);
                })
                .width(100)
            }
            Button($r('app.string.Select_node_type'))
              .height(50)
              .width('50%')
              .margin({ left: 10 })
              .bindMenu(this.SubMenuProgressType)
            Text(`${this.progressType}`)
              .fontSize(14)
              .margin(10)
            Button($r('app.string.Set_style_option'))
              .height(50)
              .width('50%')
              .margin({ left: 10 })
              .onClick(() => {
                if (this.progressType == 'ARKUI_PROGRESS_TYPE_LINEAR') {
                  ProgressNapi.setProgressLinearStyleOption(this.customStyle.scanEffect,
                    this.customStyle.smoothEffect, this.customStyle.strokeWidth, this.customStyle.strokeRadius);
                } else {
                  this.status = 'please set the progress indicator type to linear';
                }
              })
            Text(this.status)
              .fontSize(14)
              .margin(10)
          }
        }
        Row() {
          Button($r('app.string.Get_style_option'))
            .height(50)
            .width('50%')
            .onClick(() => {
              this.styleOption = ProgressNapi.getProgressLinearStyleOptionAndDestroy();
              console.log('styleOption   ' + this.styleOption);
            })
            .margin({ top: 5, bottom: 5 })
        }
        Text('styleOption:   '+this.styleOption)
          .fontSize(14)
          .margin(10)
        Row() {
          Text($r('app.string.Input_progress_value'))
          TextInput()
            .type(InputType.Number)
            .onChange((value) => {
              this.progressValue = parseInt(value);
            })
            .width(100)
        }
        .padding({bottom: 5})
        Button($r('app.string.Set_progress_value'))
          .height(50)
          .width('50%')
          .onClick(() => {
            ProgressNapi.setProgressValue(this.progressValue);
          })
          .margin({ bottom: 10 })
        Button($r('app.string.Back'))
          .height(50)
          .width('50%')
          .onClick(() => {
            this.getUIContext().getRouter().back();
          })
          .margin({ bottom: 10 })
        ContentSlot(this.nodeContent)
      }
      .width('100%')
    }
    .height('100%')
  }
  async aboutToAppear() {
    ProgressNapi.setContentHandle(this.nodeContent);
    ProgressNapi.createProgress();
  }
  async aboutToDisappear() {
    ProgressNapi.clearNodes();
  }
}
