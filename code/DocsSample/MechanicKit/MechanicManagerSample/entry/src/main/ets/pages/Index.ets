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
import { logger } from '../utils/Logger';
import { router } from '@kit.ArkUI';

const TAG = '[Index_Page] ';


@Entry
@Component
struct Index {
  @State message: string = '方向控制 : ';
  @State deviceId: string = '';
  @State deviceIdArr: Array<string> = [''];
  @State deviceName: string = '';

  aboutToAppear(): void {
    logger.info(TAG + 'aboutToAppear in');
  }

  build() {
    Column() {
      Text(this.deviceName)
        .fontSize('20fp')
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .margin({ bottom: 10 })
        .borderRadius($r('sys.float.ohos_id_corner_radius_menu'))

      Button('北向接口')
        .type(ButtonType.Capsule)
        .align(Alignment.Start)
        .onClick(()=>{
          router.pushUrl({url:'pages/ApiTestPage'},()=>{})
        })
        .margin({
          top:50,
          bottom: 15
        })
    }
    .height('100%')
    .width('100%')
  }
}