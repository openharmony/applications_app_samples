/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//import Window from '@ohos.window';

import Log from '../../../../../../../common/src/main/ets/default/Log';
import HeadComponent from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/headComponent';
import NoDisturbComponent from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/noDisturbComponent';
import ItemComponent from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/itemComponent';
import ConfigData from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/common/constants';
import { router as Router } from '@kit.ArkUI';

const TAG = 'NotificationManagement-NoDisturbPre';

@Entry
@Component
export default struct notificationManagenment {
  @State columnMargin: string = '24vp';
  @State headName: Resource = $r('app.string.noDisturb')
  @State refreshRequest: number= 0

  build() {
    Column() {
      GridContainer({
        columns: 12,
        sizeType: SizeType.Auto,
        gutter: vp2px(1) === 2 ? '12vp' : '0vp',
        margin: vp2px(1) === 2 ? '24vp' : '0vp'
      }) {
        Row() {
          Column() {
            HeadComponent({ headName: $headName, isActive: true });
            Row() {
              Text($r('app.string.timing_on'))
                .fontSize($r('app.float.page_phrases_font'))
                .fontColor($r('sys.color.ohos_id_color_text_secondary'))
                .fontWeight(FontWeight.Medium)
                .fontFamily('HarmonyHeiTi-Medium')
                .margin({ top: $r('app.float.page_phrases_padding_t') })
            }
            .align(Alignment.Start)
            .width(ConfigData.WH_100_100)
            .height($r('app.float.page_phrases_height'))
            .padding({ left: $r('sys.float.ohos_id_default_padding_start') })

            Row() {
              NoDisturbComponent({ refreshRequest: this.refreshRequest })
            }
            .align(Alignment.Start)
            .onClick(() => {
              Log.showDebug(TAG, `NoDisturbComponent on click`)
              Router.push({ uri: 'pages/noDisturb' });
            })
            .width(ConfigData.WH_100_100)
            .backgroundColor(Color.White)
            .border({ width: $r('app.float.border_width'), color: Color.White,
              radius: $r('app.float.border_radius') })
          }
          .width(ConfigData.WH_100_100)
          .height(ConfigData.WH_100_100)
          .padding({ left: $r('sys.float.ohos_id_default_padding_start'),
            right: $r('sys.float.ohos_id_default_padding_end') })
          .useSizeType({
            xs: { span: 12, offset: 0 }, sm: { span: 12, offset: 0 },
            md: { span: 12, offset: 0 }, lg: { span: 8, offset: 2 }
          });
        }
        .width(ConfigData.WH_100_100)
        .height(ConfigData.WH_100_100);
      }
      .width(ConfigData.WH_100_100)
      .height(ConfigData.WH_100_100);
    }
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100);
  }

  aboutToAppear(): void{
    Log.showInfo(TAG, `aboutToAppear`)
  }

  aboutToDisappear(): void{
    Log.showInfo(TAG, `aboutToDisappear`)
  }

  onPageShow(): void{
    Log.showInfo(TAG, `onPageShow`)
    this.refreshRequest++;
  }

  onBackPress() {
    Log.showInfo(TAG, `onBackPress`)
  }
}
