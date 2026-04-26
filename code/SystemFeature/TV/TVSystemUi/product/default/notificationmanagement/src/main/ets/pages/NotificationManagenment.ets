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
import HeadComponent
  from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/headComponent';
import NoDisturbComponent
  from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/noDisturbComponent';
import ItemComponent
  from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/itemComponent';
import ConfigData from '../common/constants';
import AppLstComponent
  from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/appLstComponent';
import { router as Router } from '@kit.ArkUI';
import ViewModel from '../vm/notificationManagenmentViewModel'
import Notification
  from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/model/notificationListener';
import SwitchComponent
  from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/switchComponent';

const TAG = 'NotificationManagement-Main';

@Entry
@Component
export default struct notificationManagenment {
  @State columnMargin: string = '12vp';
  @State mViewModel: ViewModel = new ViewModel();
  @State headName: Resource = $r('app.string.notification')
  @State title: Resource = $r('app.string.batch_Management')
  @State arrow: Resource = $r('app.media.ic_settings_arrow')
  @State itemStr: string = ''
  @State allowDistribut: Resource = $r('app.string.allowDistribut')
  @State allowDistributDescribe: Resource = $r('app.string.allowDistributDescribe')

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
            HeadComponent({ headName: $headName, isActive: true })
            Column() {
              Row() {
                Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
                  Column() {
                    Text($r('app.string.noDisturb'))
                      .fontSize($r('sys.float.ohos_id_text_size_body1'))
                      .fontColor($r('app.color.itemComp_title_color'))
                      .textAlign(TextAlign.Start)
                      .fontWeight(FontWeight.Bold)
                      .height($r('app.float.itemComp_height'))
                      .padding({ left: $r('sys.float.ohos_id_default_padding_start') })
                  }
                  .flexShrink(1)
                  .align(Alignment.Start)
                  .alignItems(HorizontalAlign.Start)

                  Row() {
                    if (this.mViewModel.isEffective) {
                      Text($r('app.string.noDisturb_opened'))
                        .fontSize($r('sys.float.ohos_id_text_size_body1'))
                        .fontColor($r('app.color.itemComp_title_color'))
                        .align(Alignment.End)
                        .margin({ right: $r('app.float.noDisturb_text_margin_right') })
                        .fontWeight(FontWeight.Medium)
                    } else {
                      Text($r('app.string.noDisturb_closed'))
                        .fontSize($r('sys.float.ohos_id_text_size_body1'))
                        .fontColor($r('app.color.itemComp_title_color'))
                        .align(Alignment.End)
                        .margin({ right: $r('app.float.noDisturb_text_margin_right') })
                        .fontWeight(FontWeight.Medium)
                    }
                    Image($r('app.media.ic_settings_arrow'))
                      .align(Alignment.End)
                      .width($r('app.float.itemComp_image_width'))
                      .height($r('app.float.itemComp_image_height'))
                  }
                  .padding({ right: $r('sys.float.ohos_id_default_padding_end') })
                  .flexShrink(0)
                  .align(Alignment.End)
                  .alignItems(VerticalAlign.Center)
                }
                .width(ConfigData.WH_100_100)
                .height($r('app.float.itemComp_height'))
                .border({ width: $r('app.float.border_width'), color: Color.White,
                  radius: $r('app.float.border_radius') })
                .backgroundColor(Color.White)
              }
              .height($r('app.float.itemComp_height'))
              .margin({ top: $r('app.float.noDisturb_margin_lf') })
              .align(Alignment.Start)
              .onClick(() => {
                Log.showDebug(TAG, `NoDisturbComponent on click`)
                Router.push({ uri: 'pages/noDisturbPre' });
              })
              .width(ConfigData.WH_100_100)
              .flexShrink(0)

              Divider()
                .color($r('app.color.divider_color'))
                .strokeWidth(1)
                .padding({
                  left: $r('sys.float.ohos_id_default_padding_start'),
                  right: $r('sys.float.ohos_id_default_padding_end')
                })

              Row() {
                SwitchComponent({
                  title: $allowDistribut,
                  describe: this.allowDistributDescribe,
                  initializationAction: (): Promise<boolean | undefined> => this.switchComponentInit(),
                  settingAction: (params): void => this.switchComponentSet(params)
                })
              }.margin({ bottom: $r('app.float.noDisturb_margin_lf') })
            }
            .backgroundColor(Color.White)
            .border({ width: $r('app.float.border_width'), color: Color.White,
              radius: $r('app.float.border_radius') })
            .margin({ top: $r('app.float.page_notice_title_margin_t') });

            Row() {
              Text($r('app.string.notificationManagement'))
                .fontColor($r('sys.color.ohos_id_color_text_secondary'))
                .fontSize($r('sys.float.ohos_id_text_size_body2'))
                .fontWeight(FontWeight.Medium)
                .fontFamily('HarmonyHeiTi-Medium')
                .margin({ top: $r('app.float.page_phrases_padding_t') })
            }.align(Alignment.Start)
            .width(ConfigData.WH_100_100)
            .height($r('app.float.page_phrases_height'))
            .padding({ left: $r('sys.float.ohos_id_default_padding_start') })

            Row() {
              ItemComponent({ title: $title, value: $itemStr, arrow: $arrow })
            }.onClick(() => {
              Log.showDebug(TAG, `BatchManagement on click`)
              Router.push({ uri: 'pages/batchSetEnable' });
            }).width(ConfigData.WH_100_100)
            .flexShrink(0)

            Column() {
              AppLstComponent()
            }.width(ConfigData.WH_100_100)
            .layoutWeight(1)
            .margin({ top: $r('app.float.applist_margin_t') });

          }
          .width(ConfigData.WH_100_100)
          .height(ConfigData.WH_100_100)
          .padding({
            left: $r('sys.float.ohos_id_default_padding_start'),
            right: $r('sys.float.ohos_id_default_padding_end')
          })
          .useSizeType({
            xs: { span: 12, offset: 0 }, sm: { span: 12, offset: 0 },
            md: { span: 12, offset: 0 }, lg: { span: 8, offset: 2 }
          });

        }
        .width(ConfigData.WH_100_100)
        .height(ConfigData.WH_100_100);
      }
      .width(ConfigData.WH_100_100)
      .height(ConfigData.WH_100_100)
      .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    }
  }

  aboutToAppear(): void {
    Log.showDebug(TAG, `aboutToAppear`)
    this.mViewModel.viewModelInit();
  }

  aboutToDisappear(): void {
    Log.showDebug(TAG, `aboutToDisappear`)
  }

  onPageShow(): void {
    Log.showDebug(TAG, `onPageShow`)
    this.mViewModel.refreshNoDisturbState();
  }

  onBackPress() {
    Log.showDebug(TAG, `onBackPress`)
  }

  switchComponentInit() {
    Log.showDebug(TAG, `switchComponentInit`)
    return Notification.isDistributedEnabled();
  }

  switchComponentSet(params: boolean) {
    Log.showDebug(TAG, `switchComponentSet`)
    Notification.enableDistributed(params);
  }
}
