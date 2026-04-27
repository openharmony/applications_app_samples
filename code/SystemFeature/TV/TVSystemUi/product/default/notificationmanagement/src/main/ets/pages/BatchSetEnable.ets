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
import AppItemComponent from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/view/component/appItemComponent';
import ConfigData from '../common/constants';
import { router as Router } from '@kit.ArkUI'
import ViewModel from '../vm/notificationManagenmentViewModel'
import { BundleItemData } from '../../../../../../../features/managementcomponent/src/main/ets/com/ohos/model/bundleResourceModel';

const TAG = 'NotificationManagement-BatchSetEnable';

@Entry
@Component
export default struct BatchSetEnable {
  @State mViewModel: ViewModel = new ViewModel();
  @StorageLink('appManagementList') appList: BundleItemData[]= [];
  @State headName:Resource =  $r('app.string.batch_Management')

  build() {
    Column() {
      GridContainer({columns:12, sizeType: SizeType.Auto, gutter: vp2px(1) === 2 ? '12vp' : '0vp', margin: vp2px(1) === 2 ? '12vp' : '0vp'}) {
        Row() {
          Column() {
            HeadComponent({ headName: $headName, isActive: true });
            List() {
              ForEach(this.appList, (item: BundleItemData) => {
                ListItem() {
                  AppItemComponent({
                    appIcon: item.appIcon,
                    appTitle: item.appTitle,
                    appSummary: item.appSummary,
                    appValue: item.appValue,
                    appArrow: item.appArrow,
                    appArrowStyle: '',
                    appUri: '',
                    appBundleName:item.appBundleName,
                    appUid:item.appUid,
                    appSwitch:1
                  });
                }
                .height($r('app.float.appitem_item_height'));
              });
            }
            .divider({
              strokeWidth: 1,
              color: $r('app.color.divider_color'),
              startMargin: $r('app.float.divider_margin_l_info'),
              endMargin: $r('app.float.divider_margin_r')
            })
            .width(ConfigData.WH_100_100)
            .layoutWeight(1)
            .padding({ left: $r('app.float.itemComp_padding_l'), right: $r('app.float.itemComp_padding_r') })
            .align(Alignment.Top)
            .backgroundColor(Color.White)
            .visibility(Visibility.Visible)
            .zIndex(0)
            .border({ width: $r('app.float.border_width'), color:Color.White,
              radius:$r('app.float.border_radius') })
            .margin({ top: $r('app.float.itemComp_margin_b') });
          }
          .padding({ left: $r('sys.float.ohos_id_default_padding_start'), right: $r('sys.float.ohos_id_default_padding_start') })
          .width(ConfigData.WH_100_100)
          .flexShrink(1)
          .useSizeType({
            xs: { span: 12, offset: 0 }, sm: { span: 12, offset: 0 },
            md: { span: 12, offset: 0 }, lg: { span: 8, offset: 2 }
          });
        }
        .width(ConfigData.WH_100_100)
      }
    }
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
    .align(Alignment.Center)
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100);
  }

  aboutToAppear(): void{
    Log.showInfo(TAG, `aboutToAppear`)
    this.mViewModel.viewModelInit();
  }

  onBackPress() {
    Log.showInfo(TAG, `onBackPress`)
  }

}
