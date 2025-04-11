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

import router from '@ohos.router'

interface listItem {
  router?: string;
  name: string;
  description?: string;
}

let demandList: listItem[] = [
  {
    name: "设置图片缩放类型",
    description: "通过objectFit属性使图片缩放到高度和宽度确定的框内",
    router: "pages/SetImageZoomType",
  },
  {
    name: "图片插值",
    description: "当原图分辨率较低并且放大显示时，图片会模糊出现锯齿。这时可以使用interpolation属性对图片进行插值，使图片显示得更清晰",
    router: "pages/ImageInterpolation",
  },
  {
    name: "设置图片重复样式",
    description: "通过objectRepeat属性设置图片的重复样式方式，重复样式请参考ImageRepeat枚举说明",
    router: "pages/SetImageRepetitionStyle",
  },
  {
    name: "设置图片渲染模式",
    description: "通过renderMode属性设置图片的渲染模式为原色或黑白",
    router: "pages/SetImageRenderingMode",
  },
  {
    name: "设置图片解码尺寸",
    description: "通过sourceSize属性设置图片解码尺寸，降低图片的分辨率",
    router: "pages/SetImageDecodingSize",
  },
  {
    name: "为图片添加滤镜效果",
    description: "通过colorFilter修改图片的像素颜色，为图片添加滤镜",
    router: "pages/AddFilterEffectsToImages",
  },
  {
    name: "事件调用",
    description: "通过在Image组件上绑定onComplete事件，图片加载成功后可以获取图片的必要信息",
    router: "pages/EventCall",
  },
]

@Entry
@Component
struct Index {
  @State bgColor: ResourceColor = "#39b5fa";

  build() {
    Column() {
      Text($r('app.string.ImageShow'))
        .height('8.00%')
        .width("100%")
        .textAlign(TextAlign.Center)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .backgroundColor(this.bgColor)
        .fontColor(Color.White)

      Column() {
        List({ space: 20, initialIndex: 0 }) {
          ForEach(demandList, (listitem: listItem, index: number) => {
            ListItem() {
              Column({ space: 10 }) {
                Text(listitem.name)
                  .fontSize(20)
                  .fontColor(this.bgColor)
                  .maxLines(1)

                Text(listitem.description)
                  .width("100%")
              }
              .margin({ bottom: index >= demandList.length - 1 ? 100 : 0 })
              .padding({
                top: '3%',
                right: '10.00%',
                bottom: '5%',
                left: '10.00%'
              })
              .width('100%')
              .constraintSize({ minHeight: 100 })
              .borderRadius(10)
              .backgroundColor(0xFFFFFF)
              .onClick(() => {
                if (!!listitem.router) {
                  router.pushUrl({ url: listitem.router })
                }
              })
            }
          })
        }
        .listDirection(Axis.Vertical) // 排列方向
        .scrollBar(BarState.Off)
        .friction(0.6)
        .divider({
          strokeWidth: 2,
          color: 0xFFFFFF,
          startMargin: 20,
          endMargin: 20
        }) // 每行之间的分界线
        .edgeEffect(EdgeEffect.Spring) // 边缘效果设置为Spring
        .width('90%')
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#fff4f3f3')
      .padding({ top: 5 })
    }
  }
}