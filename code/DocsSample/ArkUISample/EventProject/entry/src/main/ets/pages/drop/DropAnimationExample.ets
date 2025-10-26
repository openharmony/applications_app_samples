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

//[Start dropAnimationExample_start]
import { unifiedDataChannel, uniformTypeDescriptor } from '@kit.ArkData';
export const DropAnimationRoutePrefix: string = 'dropAnimation';

@Entry
@Component
export struct DropAnimationExample {
  @Consume pathStack: NavPathStack;
  @State targetImage: string = '';
  @State imageWidth: number = 100;
  @State imageHeight: number = 100;
  @State imgState: Visibility = Visibility.Visible;

  customDropAnimation =
    () => {
      this.getUIContext().animateTo({ duration: 1000, curve: Curve.EaseOut, playMode: PlayMode.Normal }, () => {
        this.imageWidth = 200;
        this.imageHeight = 200;
        this.imgState = Visibility.None;
      })
    }
  build() {
    NavDestination() {
      Row() {
        Column() {
          // $r('app.media.app_icon')需要替换为开发者所需的图像资源文件
          Image($r('app.media.app_icon'))
            .width(100)
            .height(100)
            .draggable(true)
            .margin({ left: 15, top: 40 })
            .visibility(this.imgState)
            .onDragStart((event) => {
            })
            .onDragEnd((event) => {
              if (event.getResult() === DragResult.DRAG_SUCCESSFUL) {
                console.info('Drag Success');
              } else if (event.getResult() === DragResult.DRAG_FAILED) {
                console.info('Drag failed');
              }
            })
        }.width('45%')
        .height('100%')

        Column() {
          Text('Drag Target Area')
            .fontSize(20)
            .width(180)
            .height(40)
            .textAlign(TextAlign.Center)
            .margin(10)
            .backgroundColor('rgb(240,250,255)')
          Column() {
            Image(this.targetImage)
              .width(this.imageWidth)
              .height(this.imageHeight)
          }
          .draggable(true)
          .margin({ left: 15 })
          .border({ color: Color.Black, width: 1 })
          .allowDrop([uniformTypeDescriptor.UniformDataType.IMAGE])
          .onDrop((dragEvent: DragEvent) => {
            let records: Array<unifiedDataChannel.UnifiedRecord> = dragEvent.getData().getRecords();
            let rect: Rectangle = dragEvent.getPreviewRect();
            this.imageWidth = Number(rect.width);
            this.imageHeight = Number(rect.height);
            this.targetImage = (records[0] as unifiedDataChannel.Image).imageUri;
            dragEvent.useCustomDropAnimation = true;
            dragEvent.executeDropAnimation(this.customDropAnimation)
          })
          .width(this.imageWidth)
          .height(this.imageHeight)
        }.width('45%')
        .height('100%')
        .margin({ left: '5%' })
      }
      .height('100%')
      .width('100%')
    }
    .backgroundColor('#f1f3f5')
    .title('', {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
    .title($r('app.string.Pages_Index_DropAnimation'))
  }
}
//[End dropAnimationExample_start]