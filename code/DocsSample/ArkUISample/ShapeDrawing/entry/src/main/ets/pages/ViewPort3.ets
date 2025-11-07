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

// [Start view_port_three]
class TmpThree {
  public x: number = -150;
  public y: number = -150;
  public width: number = 300;
  public height: number = 300;
}

@Entry
@Component
struct ViewPort3 {
  viep: TmpThree = new TmpThree();

  build() {
    Column() {
      Shape() {
        Rect().width('100%').height('100%').fill('#0097D4')
        Circle({ width: 150, height: 150 }).fill('#E87361')
      }
      .viewPort(this.viep)
      .width(300)
      .height(300)
      .backgroundColor('#F5DC62')
    }
  }
}
// [End view_port_three]