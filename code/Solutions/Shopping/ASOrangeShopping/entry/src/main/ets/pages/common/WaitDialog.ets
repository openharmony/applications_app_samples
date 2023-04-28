/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

@CustomDialog
export struct WaitDialog {
  public showTime: number = 1500;
  private controller: CustomDialogController;

  aboutToAppear() {
    setTimeout(() => {
      this.controller.close();
    }, this.showTime);
  }

  build() {
    Column() {
      LoadingProgress()
        .size({ width: 60, height: 60 })
    }
    .size({ width: 100, height: 100 })
    .borderRadius(20)
  }
}
