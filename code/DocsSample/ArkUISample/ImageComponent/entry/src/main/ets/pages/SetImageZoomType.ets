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

//  设置图片缩放类型页面
//  [Start image_objectfit]
@Entry
@Component
struct ImageScalingType {
  scroller: Scroller = new Scroller();

  build() {
    Scroll(this.scroller) {
      Row() {
        Column() {
          //  $r('app.media.img_2')需要替换为开发者所需的资源文件
          Image($r('app.media.img_2'))
            .width(200)
            .height(150)
            .border({ width: 1 })
            // 使用objectFit属性,使得图片中高度和宽度确认的框内进行缩放
            // 保持宽高比进行缩小或者放大，使得图片完全显示在显示边界内。
            .objectFit(ImageFit.Contain)
            .margin({bottom:25,left:10})
            .overlay('Contain', { align: Alignment.Bottom, offset: { x: 0, y: 20 } })
          //  $r('app.media.img_2')需要替换为开发者所需的资源文件
          Image($r('app.media.img_2'))
            .width(200)
            .height(150)
            .border({ width: 1 })
            // 使用objectFit属性,使得图片中高度和宽度确认的框内进行缩放
            // 保持宽高比进行缩小或者放大，使得图片两边都大于或等于显示边界。
            .objectFit(ImageFit.Cover)
            .margin({bottom:25,left:10})
            .overlay('Cover', { align: Alignment.Bottom, offset: { x: 0, y: 20 } })
          //  $r('app.media.img_2')需要替换为开发者所需的资源文件
          Image($r('app.media.img_2'))
            .width(200)
            .height(150)
            .border({ width: 1 })
            // 使用objectFit属性,使得图片中高度和宽度确认的框内进行缩放
            // 自适应显示。
            .objectFit(ImageFit.Auto)
            .margin({bottom:25,left:10})
            .overlay('Auto', { align: Alignment.Bottom, offset: { x: 0, y: 20 } })
        }

        Column() {
          //  $r('app.media.img_2')需要替换为开发者所需的资源文件
          Image($r('app.media.img_2'))
            .width(200)
            .height(150)
            .border({ width: 1 })
            // 使用objectFit属性,使得图片中高度和宽度确认的框内进行缩放
            // 不保持宽高比进行放大缩小，使得图片充满显示边界。
            .objectFit(ImageFit.Fill)
            .margin({bottom:25,left:10})
            .overlay('Fill', { align: Alignment.Bottom, offset: { x: 0, y: 20 } })
          //  $r('app.media.img_2')需要替换为开发者所需的资源文件
          Image($r('app.media.img_2'))
            .width(200)
            .height(150)
            .border({ width: 1 })
            // 使用objectFit属性,使得图片中高度和宽度确认的框内进行缩放
            // 保持宽高比显示，图片缩小或者保持不变。
            .objectFit(ImageFit.ScaleDown)
            .margin({bottom:25,left:10})
            .overlay('ScaleDown', { align: Alignment.Bottom, offset: { x: 0, y: 20 } })
          //  $r('app.media.img_2')需要替换为开发者所需的资源文件
          Image($r('app.media.img_2'))
            .width(200)
            .height(150)
            .border({ width: 1 })
            // 使用objectFit属性,使得图片中高度和宽度确认的框内进行缩放
            // 保持原有尺寸显示。
            .objectFit(ImageFit.None)
            .margin({bottom:25,left:10})
            .overlay('None', { align: Alignment.Bottom, offset: { x: 0, y: 20 } })
        }
      }
    }
  }
}
//  [End image_objectfit]