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
  title: ResourceStr;
  content: ResourceStr;
  title1: ResourceStr;
  content1: ResourceStr;
}

@Component
export struct ProductSpecPage {
  @State product: IProduct[] = [];
  product_6780: IProduct[] = [
    {
      title: $r('app.string.product_screen_size'),
      content: $r('app.string.product_75inch_4k'),
      title1: $r('app.string.product_display_tech'),
      content1: $r('app.string.product_miniled_backlight')
    },
    {
      title: $r('app.string.product_os'),
      content: $r('app.string.product_openharmony'),
      title1: $r('app.string.product_memory_config'),
      content1: $r('app.string.product_4gb_64gb')
    },
    {
      title: $r('app.string.product_processor'),
      content: $r('app.string.product_gk6780'),
      title1: $r('app.string.product_interface_config'),
      content1: $r('app.string.product_hdmi21')
    }
  ];
  product_6320: IProduct[] = [
    {
      title: $r('app.string.product_screen_size'),
      content: $r('app.string.product_27inch_1080p'),
      title1: $r('app.string.product_display_tech'),
      content1: $r('app.string.product_miniled_backlight')
    },
    {
      title: $r('app.string.product_os'),
      content: $r('app.string.product_openharmony'),
      title1: $r('app.string.product_memory_config'),
      content1: $r('app.string.product_4gb_64gb')
    },
    {
      title: $r('app.string.product_processor'),
      content: $r('app.string.product_gk6320'),
      title1: $r('app.string.product_interface_config'),
      content1: $r('app.string.product_hdmi21')
    }
  ];

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
        console.error('Invalid screen parameters');
        return 0;
      }

      // 计算对角线像素数
      const diagonalPixels = Math.sqrt(width * width + height * height);

      // 转换为英寸：像素 ÷ DPI = 英寸
      const inches = diagonalPixels / dpi;
      console.log('hsq', 'width', width, 'height', height, 'dpi', dpi, 'diagonalPixels', diagonalPixels, 'inches',
        inches);
      return parseFloat(inches.toFixed(0));
    } catch (error) {
      console.error('Failed to get screen size:', error);
      return 0;
    }
  }

  aboutToAppear() {
    if (deviceInfo.productModel == 'gk6320v100crb_b_vb') {
      this.product = this.product_6320;
    } else {
      this.product = this.product_6780;
    }
  }

  build() {
    Column() {
      // 标题
      Text($r('app.string.Product_Specifications'))
        .fontSize('64lpx')
        .fontColor(Color.White)
        .fontWeight(700)
        .lineHeight('75lpx')
        .textAlign(TextAlign.Center)
        .margin({ top: '91lpx' });


      // 内容区域
      Row() {
        Row() {
          Image($r('app.media.page1'))
            .width('548lpx')
            .height('318lpx');

        }.alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .width('50%')
        .height('100%');

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
                .margin({ right: '20lpx' });
              Text(`${item.content}`)
                .fontColor('rgba(255,255,255,0.86)')
                .fontSize('30lpx')
                .fontWeight('500')
                .lineHeight('35lpx')
                .textAlign(TextAlign.Start)
                .width('260lpx')
                .margin({ right: '20lpx' });
              Text(`${item.title1}`)
                .fontColor('rgba(255,255,255,0.6)')
                .fontSize('26lpx')
                .fontWeight('500')
                .lineHeight('30lpx')
                .textAlign(TextAlign.Start)
                .width('120lpx')
                .margin({ right: '20lpx' });
              Text(`${item.content1}`)
                .fontColor('rgba(255,255,255,0.86)')
                .fontSize('30lpx')
                .fontWeight('500')
                .lineHeight('35lpx')
                .textAlign(TextAlign.Start);
            }
            .padding({ bottom: '40lpx', top: '40lpx' });

            Divider()
              .width('680lpx')
              .height('2lpx')
              .linearGradient({
                direction: 0,
                colors: [['rgba(255, 255, 255, 0)', 0.0], ['rgba(255, 255, 255, 0.8)', 0.3],
                  ['rgba(255, 255, 255, 0.8)', 0.6], ['rgba(255, 255, 255, 0)', 1]]
              });

          });
          Row() {
            Text($r('app.string.Sound_system'))
              .fontColor('rgba(255,255,255,0.6)')
              .fontSize('26lpx')
              .fontWeight('500')
              .lineHeight('30lpx')
              .textAlign(TextAlign.Start)
              .width('120lpx')
              .margin({ right: '20lpx' });
            Text($r('app.string.Dolby_Atmos'))
              .fontColor('rgba(255,255,255,0.86)')
              .fontSize('30lpx')
              .fontWeight('500')
              .lineHeight('35lpx')
              .textAlign(TextAlign.Start)
              .margin({ right: '5lpx' })
              .width('240lpx')
              .width('260lpx')
              .margin({ right: '20lpx' });
            Text($r('app.string.energy_efficiency_rating'))
              .fontColor('rgba(255,255,255,0.6)')
              .fontSize('26lpx')
              .fontWeight('500')
              .lineHeight('30lpx')
              .textAlign(TextAlign.Start)
              .width('120lpx')
              .margin({ right: '20lpx' });
            Text($r('app.string.Class_1_Energy_Efficiency'))
              .fontColor('rgba(255,255,255,0.86)')
              .fontSize('30lpx')
              .fontWeight('500')
              .lineHeight('35lpx')
              .width('260lpx')
              .textAlign(TextAlign.Start);
          }
          .width('613lpx')
          .padding({ bottom: '40lpx', top: '40lpx' });
        }.width('50%')
        .alignItems(HorizontalAlign.Start);

      }.width('100%')
      .height('600lpx')
      .margin({ top: '50lpx' });

    }
    .width('100%')
    .height('100%')
    .onBlur(() => {

    });

  }
}