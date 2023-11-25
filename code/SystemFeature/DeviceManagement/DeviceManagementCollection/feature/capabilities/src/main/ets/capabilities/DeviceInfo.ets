/*
 * Copyright (c) 2023 Fujian Newland Auto-ID Tech.Co.,Ltd.
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

import { ListModel } from '../model/ListModel'
import { DeviceUtil } from '../util/DeviceUtil'
import { RadiusColumn } from '../components/RadiusColumn'
import { getString } from '@ohos/common/src/main/ets/util/ResourceUtil';

@Extend(Text) function fancy() {
  .textAlign(TextAlign.Start)
  .fontColor($r('sys.color.ohos_id_color_text_primary'))
  .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
  .fontWeight(FontWeight.Regular)
};

@Extend(Text) function fancyRight() {
  .textAlign(TextAlign.End)
  .fontColor($r('app.color.battery_info_value_text'))
  .fontSize($r('sys.float.ohos_id_text_size_sub_title3'))
};

@Component
export struct DeviceInfo {
  @State table: ListModel[] = [
    new ListModel(getString($r('app.string.device_type')), DeviceUtil.deviceType),
    new ListModel(getString($r('app.string.manufacture')), DeviceUtil.manufacture),
    new ListModel(getString($r('app.string.brand')), DeviceUtil.brand),
    new ListModel(getString($r('app.string.marker_name')), DeviceUtil.markerName),
    new ListModel(getString($r('app.string.product_series')), DeviceUtil.productSeries),
    new ListModel(getString($r('app.string.product_model')), DeviceUtil.productModel),
    new ListModel(getString($r('app.string.software_model')), DeviceUtil.softwareModel),
    new ListModel(getString($r('app.string.hardware_model')), DeviceUtil.hardwareModel),
    new ListModel(getString($r('app.string.hardware_profile')), DeviceUtil.hardwareProfile),
    new ListModel(getString($r('app.string.serial')), DeviceUtil.serial),
    new ListModel(getString($r('app.string.bootloader_version')), DeviceUtil.bootloaderVersion),
    new ListModel(getString($r('app.string.abi_list')), DeviceUtil.abiList),
    new ListModel(getString($r('app.string.security_patch_tag')), DeviceUtil.securityPatchTag),
    new ListModel(getString($r('app.string.display_version')), DeviceUtil.displayVersion),
    new ListModel(getString($r('app.string.incremental_version')), DeviceUtil.incrementalVersion),
    new ListModel(getString($r('app.string.os_release_type')), DeviceUtil.osReleaseType),
    new ListModel(getString($r('app.string.os_full_name')), DeviceUtil.osFullName),
    new ListModel(getString($r('app.string.major_version')), DeviceUtil.majorVersion),
    new ListModel(getString($r('app.string.senior_version')), DeviceUtil.seniorVersion),
    new ListModel(getString($r('app.string.featureVersion')), DeviceUtil.featureVersion),
    new ListModel(getString($r('app.string.build_version')), DeviceUtil.buildVersion),
    new ListModel(getString($r('app.string.sdk_api_version')), DeviceUtil.sdkApiVersion),
    new ListModel(getString($r('app.string.first_api_version')), DeviceUtil.firstApiVersion),
    new ListModel(getString($r('app.string.version_id')), DeviceUtil.versionId),
    new ListModel(getString($r('app.string.build_type')), DeviceUtil.buildType),
    new ListModel(getString($r('app.string.build_user')), DeviceUtil.buildUser),
    new ListModel(getString($r('app.string.build_host')), DeviceUtil.buildHost),
    new ListModel(getString($r('app.string.build_time')), DeviceUtil.buildTime),
    new ListModel(getString($r('app.string.build_root_hash')), DeviceUtil.buildRootHash),
    new ListModel(getString($r('app.string.udid')), DeviceUtil.udid)
  ];

  build() {
    List() {
      ForEach(this.table, (item: ListModel) => {
        ListItem() {
          RadiusColumn() {
            Row() {
              Text(item.title)
                .fancy()
                .width('30%')
              Blank()
              Text(item.getValue())
                .fancyRight()
                .width('67%')
            }
            .padding(px2vp(12))
          }
        }
      })
    }
    .margin({ top: 12, bottom: 12 })
    .width('100%')
  }
}