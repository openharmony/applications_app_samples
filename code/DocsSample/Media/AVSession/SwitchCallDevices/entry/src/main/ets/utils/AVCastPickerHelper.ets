/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

// [Start create_castPickerHelper]
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { avSession } from '@kit.AVSessionKit';

class MyPage {
  private avCastPicker: avSession.AVCastPickerHelper;

  constructor(context: common.UIAbilityContext) {
    this.avCastPicker = new avSession.AVCastPickerHelper(context);
  }

  async selectCastDevice() {
    const avCastPickerOptions: avSession.AVCastPickerOptions = {
      sessionType: 'video',
    };

    this.avCastPicker.select(avCastPickerOptions).then(() => {
      console.info('select successfully');
    }).catch((err: BusinessError) => {
      console.error('AVCastPicker.select failed with err: ${err.code}, ${err.message}');
    });
  }
}
// [End create_castPickerHelper]