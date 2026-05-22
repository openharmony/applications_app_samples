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

import { display } from '@kit.ArkUI';
import { deviceInfo } from '@kit.BasicServicesKit';

interface IProduct {
  title: string
  content: string
  title1: string
  content1: string
}

@Component
export struct ProductSpecPage {
  @State product: IProduct[] = []
  product_6780: IProduct[] = [
    {
      title: '屏幕尺寸',
      content: '75英寸 4K超清',
      title1: '显示技术',
      content1: 'MiniLED全阵列背光'
    },
    {
      title: '操作系统',
      content: 'OpenHarmony5.1',
      title1: '内存配置',
      content1: '4GB+64GB'
    },
    {
      title: '处理器',
      content: 'GK6780V100',
      title1: '接口配置',
      content1: 'HDMI2.1'
    }
  ]
  product_6320: IProduct[] = [
    {
      title: '屏幕尺寸',
      content: '27英寸 1080P',
      title1: '显示技术',
      content1: 'MiniLED全阵列背光'
    },
    {
      title: '操作系统',
      content: 'OpenHarmony5.1',
      title1: '内存配置',
      content1: '4GB+64GB'
    },
    {
      title: '处理器',
      content: 'GK6320',
      title1: '接口配置',
      content1: 'HDMI2.1'
    }
  ]

  /**
   * 计算屏幕对角线尺寸（英寸）
   */
  getScreenDiagonalInches(): number {
    try {
      const displayInfo = display.getDefaultDisplaySync();
      const width = displayInfo.width;
      const height = displayInfo.height;
      const dpi = displayInfo.densityDPI / displayInfo.densityPixels;

      if (width <= 0 || height <= 0 || dpi <= 0) {
        console.error('屏幕参数无效');
        return 0;
      }

      // 计算对角线像素数
      const diagonalPixels = Math.sqrt(width * width + height * height);

      // 转换为英寸：像素 ÷ DPI = 英寸
      const inches = diagonalPixels / dpi;
      console.log('hsq', 'width', width, 'height', height, 'dpi', dpi, 'diagonalPixels', diagonalPixels, 'inches',
        inches)
      return parseFloat(inches.toFixed(0));
    } catch (error) {
      console.error('获取屏幕尺寸失败:', error);
      return 0;
    }
  }

  aboutToAppear() {
    if (deviceInfo.productModel == 'gk6320v100crb_b_vb') {
      this.product = this.product_6320
    } else {
      this.product = this.product_6780
    }
  }

  build() {
    Column() {
      // 标题
      Text('产品规格')
        .fontSize('64lpx')
        .fontColor(Color.White)
        .fontWeight(700)
        .lineHeight('75lpx')
        .textAlign(TextAlign.Center)
        .margin({ top: '91lpx' })


      // 内容区域
      Row() {
        Row() {
          Image($r('app.media.page1'))
            .width('548lpx')
            .height('318lpx')

        }.alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .width('50%')
        .height('100%')

        // 文字部分
        Column() {
          ForEach(this.product, (item: IProduct, index: number) => {

            Row() {
              Text(`${item.title}`)
                .fontColor('rgba(255,255,255,0.6)')
                .fontSize('26lpx')
                .fontWeight('500')
                .lineHeight('30lpx')
                .textAlign(TextAlign.Start)
                .width('120lpx')
                .margin({ right: '20lpx' })
              Text(`${item.content}`)
                .fontColor('rgba(255,255,255,0.86)')
                .fontSize('30lpx')
                .fontWeight('500')
                .lineHeight('35lpx')
                .textAlign(TextAlign.Start)
                .width('260lpx')
                .margin({ right: '20lpx' })
              Text(`${item.title1}`)
                .fontColor('rgba(255,255,255,0.6)')
                .fontSize('26lpx')
                .fontWeight('500')
                .lineHeight('30lpx')
                .textAlign(TextAlign.Start)
                .width('120lpx')
                .margin({ right: '20lpx' })
              Text(`${item.content1}`)
                .fontColor('rgba(255,255,255,0.86)')
                .fontSize('30lpx')
                .fontWeight('500')
                .lineHeight('35lpx')
                .textAlign(TextAlign.Start)
            }
            .padding({ bottom: '40lpx', top: '40lpx' })

            Divider()
              .width('680lpx')
              .height('2lpx')
              .linearGradient({
                direction: 0,
                colors: [['rgba(255, 255, 255, 0)', 0.0], ['rgba(255, 255, 255, 0.8)', 0.3],
                  ['rgba(255, 255, 255, 0.8)', 0.6], ['rgba(255, 255, 255, 0)', 1]]
              })

          })
          Row() {
            Text(`音效系统`)
              .fontColor('rgba(255,255,255,0.6)')
              .fontSize('26lpx')
              .fontWeight('500')
              .lineHeight('30lpx')
              .textAlign(TextAlign.Start)
              .width('120lpx')
              .margin({ right: '20lpx' })
            Text(`杜比全景音`)
              .fontColor('rgba(255,255,255,0.86)')
              .fontSize('30lpx')
              .fontWeight('500')
              .lineHeight('35lpx')
              .textAlign(TextAlign.Start)
              .margin({ right: '5lpx' })
              .width('240lpx')
              .width('260lpx')
              .margin({ right: '20lpx' })
            Text(`能效等级`)
              .fontColor('rgba(255,255,255,0.6)')
              .fontSize('26lpx')
              .fontWeight('500')
              .lineHeight('30lpx')
              .textAlign(TextAlign.Start)
              .width('120lpx')
              .margin({ right: '20lpx' })
            Text(`一级能效`)
              .fontColor('rgba(255,255,255,0.86)')
              .fontSize('30lpx')
              .fontWeight('500')
              .lineHeight('35lpx')
              .width('260lpx')
              .textAlign(TextAlign.Start)
          }
          .width('613lpx')
          .padding({ bottom: '40lpx', top: '40lpx' })
        }.width('50%')
        .alignItems(HorizontalAlign.Start)

        /*   .linearGradient({
             // 0点方向顺时针旋转为正向角度，线性渐变起始角度的默认值为180°
             colors: [
               [0xf56c6c, 0.0], // 颜色断点1的颜色和比重，对应组件在180°方向上的起始位置
               [0xffffff, 1.0],// 颜色断点2的颜色和比重，对应组件在180°方向上的终点位置
             ]
           })
   */
      }.width('100%')
      .height('600lpx')
      .margin({ top: '50lpx' })

      // .justifyContent(FlexAlign.SpaceBetween)

    }
    .width('100%')
    .height('100%')
    .onBlur(() => {

    })

  }
}