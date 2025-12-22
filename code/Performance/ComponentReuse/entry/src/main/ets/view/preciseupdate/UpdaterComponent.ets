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

import hilog from '@ohos.hilog';
import { AttributeUpdater } from '@ohos.arkui.modifier';
import { Constants } from '../../common/Constants';
import { ColorModel } from '../../model/BasicDataSource';
import { ColorData } from '../../model/ColorData';

/**
 * 使用AttributeUpdater精准控制组件属性的刷新，避免组件不必要的属性刷新 - 正例
 */

const TAG: string = 'UpdaterComponent'

export class MyTextUpdater extends AttributeUpdater<TextAttribute> {
  private color: string | number | Resource | Color = '';

  constructor(color: string | number | Resource | Color) {
    super();
    this.color = color;
  }

  initializeModifier(instance: TextAttribute): void {
    instance.fontColor(this.color); // 差异化更新
  }
}

@Component
export struct UpdaterComponent {
  private colorData: ColorData = new ColorData(this.getUIContext().getHostContext());
  private readonly LIST_CACHE_COUNT: number = 5;
  private readonly LIST_SPACE: number = 18;

  aboutToAppear(): void {
    this.colorData.getColorData();
  }

  build() {
    Column() {
      List({ space: this.LIST_SPACE }) {
        LazyForEach(this.colorData, (colorModel: ColorModel) => {
          ListItem() {
            OneMoment({ color: colorModel.color, text: colorModel.text })
              .onClick(() => {
                hilog.info(0x0000, TAG, `my id is ${colorModel.id}`);
              })
          }
        }, (color: ColorModel) => color.id)
      }
      .cachedCount(this.LIST_CACHE_COUNT)
      .margin({ top: 8 })
      .width(Constants.LAYOUT_MAX)
      .height(Constants.LAYOUT_MAX)
    }
  }
}

@Reusable
@Component
export struct OneMoment {
  @State text: string = '';
  color: string | number | Resource | Color = '';
  textUpdater: MyTextUpdater | null = null;

  aboutToAppear(): void {
    this.textUpdater = new MyTextUpdater(this.color);
  }

  aboutToReuse(params: Record<string, Object>): void {
    this.color = params.color as string;
    this.text = params.text as string;
    this.textUpdater?.attribute?.fontColor(this.color);
  }

  build() {
    Column() {
      Text(this.text)
        .fontSize(18)
        .textAlign(TextAlign.Center)
        .fontWeight(500)
        .lineHeight(24)
        .fontColor(Color.Black)
        .opacity(0.6)
      Column() {
        Text('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')
          .attributeModifier(this.textUpdater) // 采用attributeUpdater来对需要更新的fontColor属性进行精准刷新，避免不必要的属性刷新。
          .textAlign(TextAlign.Center)
          .fontStyle(FontStyle.Normal)
          .fontSize(13)
          .lineHeight(30)
          .opacity(0.6)
          .margin({ top: 10 })
          .fontWeight(30)
          .clip(false)
          .backgroundBlurStyle(BlurStyle.NONE)
          .foregroundBlurStyle(BlurStyle.NONE)
          .borderWidth(1)
          .borderColor(Color.Pink)
          .borderStyle(BorderStyle.Solid)
      }
      .borderRadius(16)
      .margin({ top: 14 })
      .padding({
        left: 16,
        right: 16,
        top: 8,
        bottom: 8
      })
      .backgroundColor('#0D000000')
    }
    .alignItems(HorizontalAlign.Start)
    .margin({
      left: 16,
      right: 16
    })
  }
}

@Builder
function getUpdaterComponent(name: string): void {
  if (name === Constants.NAV_DESTINATION_ITEM_1) {
    NavDestination() {
      UpdaterComponent()
    }
    .title(title())
    .backgroundColor('#F1F3F5')
  }
}

@Builder
function title() {
  Text($r('app.string.nav_destination_item1'))
    .fontSize(20)
    .fontColor($r('sys.color.font_primary'))
    .fontWeight(FontWeight.Bold)
    .margin({
      left: 8,
      top: 16
    })
    .maxLines(1)
    // .textOverflow({ overflow: TextOverflow.MARQUEE })
    .lineHeight(24)
}

export const wrappedBuilderUpdaterComponent: WrappedBuilder<[string]> =
  wrapBuilder(getUpdaterComponent);