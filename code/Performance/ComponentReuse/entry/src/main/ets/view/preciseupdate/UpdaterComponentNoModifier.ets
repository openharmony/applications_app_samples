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
import { ColorModel, FriendMoment } from '../../model/BasicDataSource';
import { ColorData } from '../../model/ColorData';

/**
 * 使用AttributeUpdater精准控制组件属性的刷新，避免组件不必要的属性刷新 - 反例
 */

const TAG: string = 'UpdaterComponentNoModifier'

@Component
export struct UpdaterComponentNoModifier {
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
            OneMomentNoModifier({ color: colorModel.color, text: colorModel.text })
              .onClick(() => {
                hilog.info(0x0000, TAG, `my id is ${colorModel.id}`);
              })
          }
        }, (moment: FriendMoment) => moment.id)
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
export struct OneMomentNoModifier {
  @State text: string = '';
  color: string | number | Resource | Color = '';

  aboutToReuse(params: Record<string, Object>): void {
    this.color = params.color as string;
    this.text = params.text as string;
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
          .fontColor(this.color) // 此处使用属性直接进行刷新，会造成Text所有属性都刷新
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
function getUpdaterComponentNoModifier(name: string): void {
  if (name === Constants.NAV_DESTINATION_ITEM_1_1) {
    NavDestination() {
      UpdaterComponentNoModifier()
    }
    .title(title())
    .backgroundColor('#F1F3F5')
  }
}

@Builder
function title() {
  Text($r('app.string.nav_destination_item1_2'))
    .fontSize(20)
    .fontColor($r('sys.color.font_primary'))
    .fontWeight(FontWeight.Bold)
    .margin({
      left: 8,
      top: 16
    })
    .maxLines(1)
    .textOverflow({ overflow: TextOverflow.MARQUEE })
    .lineHeight(24)
}

export const wrappedBuilderUpdaterComponentNoModifier: WrappedBuilder<[string]> =
  wrapBuilder(getUpdaterComponentNoModifier);