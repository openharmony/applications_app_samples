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

// [Start view_port_one]
class Tmp {
  public x: number = 0;
  public y: number = 0;
  public width: number = 75;
  public height: number = 75;
}

class TmpOne {
  public x:number = 0;
  public y:number = 0;
  public width:number = 300;
  public height:number = 300;
}

@Entry
@Component
struct viewPort1 {
  viep: Tmp = new Tmp();
  viep1: TmpOne = new TmpOne();

  build() {
    Column() {
      // 画一个宽高都为75的圆
      Text('Original Size Circle')
      Circle({ width: 75, height: 75 }).fill('#E87361')

      Row({ space: 10 }) {
        Column() {
          // 创建一个宽高都为150的shape组件，背景色为黄色，一个宽高都为75的viewPort。
          // 用一个蓝色的矩形来填充viewPort，在viewPort中绘制一个直径为75的圆。
          // 绘制结束，viewPort会根据组件宽高放大两倍。
          Text('Enlarged Circle')
          Shape() {
            Rect().width('100%').height('100%').fill('#0097D4')
            Circle({ width: 75, height: 75 }).fill('#E87361')
          }
          .viewPort(this.viep)
          .width(150)
          .height(150)
          .backgroundColor('#F5DC62')
        }

        Column() {
          // 创建一个宽高都为150的shape组件，背景色为黄色，一个宽高都为300的viewPort。
          // 用一个绿色的矩形来填充viewPort，在viewPort中绘制一个直径为75的圆。
          // 绘制结束，viewPort会根据组件宽高缩小两倍。
          Text('Shrunk Circle')
          Shape() {
            Rect().width('100%').height('100%').fill('#BDDB69')
            Circle({width: 75, height: 75}).fill('#E87361')
          }
          .viewPort(this.viep1)
          .width(150)
          .height(150)
          .backgroundColor('#F5DC62')
        }
      }
    }
  }
}
// [End view_port_one]