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
import { sizeCalc } from '../common/SizeCalc';

/**
 * ScreenRecorderDialog 组件定义了截屏保存时的提示浮层。
 * 它采用简洁的横向布局，整合了图标、品牌文字和动态提示信息。
 * 这种浮层设计能够非侵入性地提供操作反馈，是提升应用易用性的关键组件。
 */
@Entry
@Component
struct ScreenRecorderDialog {
  // 使用 StorageProp 实时同步全局的保存进度或状态提示。
  @StorageProp('saveTipStr') saveTip: string = '';

  /**
   * 组件挂载前的初始化逻辑。
   * 业务背景：确保在 UI 渲染的第一时间就能展示正确的状态信息。
   */
  aboutToAppear(): void {
    this.saveTip = AppStorage.get('saveTipStr') || ''
  }

  build() {
    Row() {
      Row() {
        Image($r('app.media.jietu'))
          .width(`${sizeCalc(60)}px`)
        Text('截屏')
          .fontColor(Color.White)
          .fontSize(`${sizeCalc(36)}px`)
          .fontWeight(FontWeight.Medium)
          .margin({ left: `${sizeCalc(12)}px` })
        // 使用分隔线在紧凑的 UI 中清晰划分功能区和信息区。
        Divider()
          .vertical(true)
          .strokeWidth(`${sizeCalc(1)}px`)
          .height(`${sizeCalc(36)}px`)
          .color(Color.White)
          .margin({ left: `${sizeCalc(12)}px`, right: `${sizeCalc(12)}px` })
      }
      Text(this.saveTip)
        .fontColor(Color.White)
        .fontSize(`${sizeCalc(36)}px`)
        .fontWeight(FontWeight.Medium)
      // 空行占位，配合 SpaceBetween 实现左右两端的极致布局平衡。
      Row() {}
    }
    .padding({
      left: `${sizeCalc(43)}px`,
      right: `${sizeCalc(43)}px`,
      top: `${sizeCalc(20)}px`,
      bottom: `${sizeCalc(20)}px`
    })
    .size({ width: '100%', height: '100%' })
    .justifyContent(FlexAlign.SpaceBetween)
    // 采用带透明度的深色背景，确保在任何复杂的背景内容上都能清晰阅读提示文字。
    .backgroundColor('#B33A3F62')
    .borderRadius(`${sizeCalc(24)}px`)
  }
}
