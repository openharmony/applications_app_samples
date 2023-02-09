/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

class DialogUtil {
  showAlertDialog(message: ResourceStr, primaryButton: ResourceStr, primaryButtonAction: () => void, secondaryButton: ResourceStr, secondaryButtonAction: () => void) {
    AlertDialog.show({
      message: message,
      alignment: DialogAlignment.Bottom,
      gridCount: 4,
      offset: { dx: 0, dy: -12 },
      primaryButton: {
        value: primaryButton,
        fontColor: Color.Red,
        action: primaryButtonAction
      },
      secondaryButton: {
        value: secondaryButton,
        fontColor: Color.Blue,
        action: secondaryButtonAction
      }
    })
  }
}

export const dialogUtil = new DialogUtil()