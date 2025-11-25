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

import { hiTraceMeter } from '@kit.PerformanceAnalysisKit';
import { ifaa } from '@kit.OnlineAuthenticationKit';

/**
 * “IFAA免密认证获取匿名化ID” - 反例：使用同步接口getAnonymousIdSync
 */

// 开发者需要按照IIFAA的TLV格式构造入参，并转换为Uint8Array参数；此处arg需要开发者替换为真实入参。
let arg = new Uint8Array([0]);

@Entry
@Component
export struct GetAnonymousIdSync {
  @State message: string = 'getAnonymousIdSync';

  build() {
    RelativeContainer() {
      Text(this.message)
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .onClick(()=>{
          hiTraceMeter.startTrace('getAnonymousIdSync', 1);
          let getAnonIdResult: Uint8Array = ifaa.getAnonymousIdSync(arg);
          hiTraceMeter.finishTrace('getAnonymousIdSync', 1);
        })
    }
    .height('100%')
    .width('100%')
  }
}