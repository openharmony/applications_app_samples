/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import nativeRender from 'libnativerender.so';

class MyXComponentController extends XComponentController{
  onSurfaceCreated(surfaceId: string): void {
    console.info(`onSurfaceCreated surfaceId: ${surfaceId}`);
    nativeRender.SetSurfaceId(BigInt(surfaceId));
  }
  onSurfaceChanged(surfaceId: string, rect: SurfaceRect): void {
    console.info(`onSurfaceChanged surfaceId: ${surfaceId}, rect: ${JSON.stringify(rect)}}`);
    nativeRender.ChangeSurface(BigInt(surfaceId), rect.surfaceWidth, rect.surfaceHeight);
  }
  onSurfaceDestroyed(surfaceId: string): void {
    console.info(`onSurfaceDestroyed surfaceId: ${surfaceId}`);
    nativeRender.DestroySurface(BigInt(surfaceId));
  }
}

@Entry
@Component
struct Index {
  @State currentStatus: string = "index";
  xComponentController: XComponentController = new MyXComponentController();
  build() {
    Column() {
      Row() {
        Text('Native XComponent Sample')
          .fontSize('24fp')
          .fontWeight(500)
          .margin({
            left: 24,
            top: 12
          })
      }
      .margin({ top: 24 })
      .width('100%')
      .height(56)

      Column({ space: 10 }) {
        XComponent({
          type: XComponentType.SURFACE,
          controller: this.xComponentController
        })
        Text(this.currentStatus)
          .fontSize('24fp')
          .fontWeight(500)
      }
      .onClick(() => {
        let surfaceId = this.xComponentController.getXComponentSurfaceId();
        nativeRender.ChangeColor(BigInt(surfaceId));
        let hasChangeColor: boolean = false;
        if (nativeRender.GetXComponentStatus(BigInt(surfaceId))) {
          hasChangeColor = nativeRender.GetXComponentStatus(BigInt(surfaceId)).hasChangeColor;
        }
        if (hasChangeColor) {
          this.currentStatus = "change color";
        }
      })
      .margin({
        top: 27,
        left: 12,
        right: 12
      })
      .height('40%')
      .width('90%')
      Row() {
        Button('Draw Star')
          .fontSize('16fp')
          .fontWeight(500)
          .margin({ bottom: 24 })
          .onClick(() => {
            let surfaceId = this.xComponentController.getXComponentSurfaceId();
            nativeRender.DrawPattern(BigInt(surfaceId));
            let hasDraw: boolean = false;
            if (nativeRender.GetXComponentStatus(BigInt(surfaceId))) {
              hasDraw = nativeRender.GetXComponentStatus(BigInt(surfaceId)).hasDraw;
            }
            if (hasDraw) {
              this.currentStatus = "draw star";
            }
          })
          .width('53.6%')
          .height(40)
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Bottom)
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}