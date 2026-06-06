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

interface PageRoute {
  router: string;
  name: string;
  description: string;
}

let demandList: PageRoute[] = [
  {
    name: 'MaterialState配置示例',
    description: '通过配置MaterialState调整组件系统材质行为，获取MaterialInfo信息。',
    router: 'pages/immersiveLightSense/MaterialInfo',
  },
  {
    name: 'Column通用属性设置材质',
    description: '通过通用属性systemMaterial为Column组件设置ULTRA_THIN沉浸式系统材质。',
    router: 'pages/immersiveLightSense/ColumnMaterial',
  },
  {
    name: 'Button交互形变',
    description: '为Button组件设置ULTRA_THIN样式和interactive交互形变效果，按压时产生弹性形变。',
    router: 'pages/immersiveLightSense/ButtonInteractive',
  },
  {
    name: '光感交互反馈',
    description: '为圆形Row组件同时开启interactive交互形变和lightEffect光感交互反馈。',
    router: 'pages/immersiveLightSense/LightEffect',
  },
  {
    name: 'Toast系统材质',
    description: '通过showToast设置THIN样式的沉浸式系统材质，Toast弹出时呈现材质效果。',
    router: 'pages/immersiveLightSense/ToastMaterial',
  },
  {
    name: 'Popup系统材质',
    description: '通过bindPopup设置THIN样式的沉浸式系统材质，气泡弹窗呈现材质效果。',
    router: 'pages/immersiveLightSense/PopupMaterial',
  },
  {
    name: 'Tips系统材质',
    description: '通过bindTips设置THIN样式的沉浸式系统材质，悬浮提示呈现材质效果。',
    router: 'pages/immersiveLightSense/TipsMaterial',
  },
  {
    name: 'bindSheet系统材质',
    description: '通过bindSheet设置ULTRA_THICK样式的沉浸式系统材质，半模态页面呈现模糊和材质效果。',
    router: 'pages/immersiveLightSense/SheetMaterial',
  },
  {
    name: 'Menu系统材质',
    description: '通过bindMenu设置THICK样式的沉浸式系统材质，弹出菜单呈现材质效果和弹出动效。',
    router: 'pages/immersiveLightSense/MenuMaterial',
  },
  {
    name: '关闭组件材质',
    description: '通过设置Material.empty单独关闭组件的沉浸式系统材质。',
    router: 'pages/immersiveLightSense/CloseMaterial',
  },
  {
    name: '五种材质样式展示',
    description: '展示ULTRA_THIN、THIN、REGULAR、THICK、ULTRA_THICK五种沉浸式系统材质样式的效果。',
    router: 'pages/immersiveLightSense/AllStyles',
  },
  {
    name: '自动反色',
    description: '通过colorInvert自动反色功能，使文字颜色自动适配材质到背景色的反色。',
    router: 'pages/immersiveLightSense/ColorInvert',
  }
];

@Entry
@Component
struct Index {
  build() {
    Column() {
      Text($r('app.string.EntryAbility_label'))
        .height('8%')
        .width('100%')
        .textAlign(TextAlign.Center)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .backgroundColor($r('app.color.Title_Back'))
        .fontColor($r('app.color.Title_TextColor'))
      Column() {
        List({ space: 20, initialIndex: 0 }) {
          ForEach(demandList, (item: PageRoute, index: number) => {
            ListItem() {
              Column({ space: 10 }) {
                Text(item.name)
                  .fontSize(18)
                  .fontColor($r('app.color.Index_first'))
                  .maxLines(1)
                  .fontWeight(FontWeight.Medium)
                Text(item.description)
                  .width('100%')
                  .fontSize(14)
                  .fontColor($r('app.color.start_window_background'))
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
              }
              .margin({ bottom: index >= demandList.length - 1 ? 100 : 0 })
              .padding({
                top: '3%',
                right: '10%',
                bottom: '5%',
                left: '10%'
              })
              .width('100%')
              .constraintSize({ minHeight: 80 })
              .borderRadius(16)
              .backgroundColor($r('app.color.Index_Column'))
              .onClick(() => {
                this.getUIContext().getRouter().pushUrl({ url: item.router });
              })
            }
          })
        }
        .listDirection(Axis.Vertical)
        .scrollBar(BarState.Off)
        .friction(0.6)
        .divider({
          strokeWidth: 2,
          color: 0xFFFFFF,
          startMargin: 20,
          endMargin: 20
        })
        .edgeEffect(EdgeEffect.Spring)
        .width('90%')
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('app.color.Index_backgroundColor'))
      .padding({ top: 5 })
    }
  }
}
