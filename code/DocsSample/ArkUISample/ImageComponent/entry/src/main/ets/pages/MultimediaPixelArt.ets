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

// 多媒体像素图页面
// [Start multimedia_pixel]
import { http } from '@kit.NetworkKit';
import { image } from '@kit.ImageKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN = 0x0001;
const TAG = 'Sample_imagecomponent';

@Entry
@Component
struct HttpExample {
  outData: http.HttpResponse | undefined = undefined;
  code: http.ResponseCode | number | undefined = undefined;
  @State image: PixelMap | undefined = undefined; // 创建PixelMap状态变量

  // 使用createHttp接口将加载的网络图片返回的数据解码成PixelMap格式，再显示在Image组件上
  aboutToAppear(): void {
    http.createHttp().request('xxx://xxx.xxx.xxx/example.png', // 需要替换为开发者所需的资源文件，资源文件中的value值请替换为真实路径
      (error: BusinessError, data: http.HttpResponse) => {
        if (error) {
          hilog.error(DOMAIN, TAG, `hello http request failed. Code: ${error.code}, message: ${error.message}`);
          return;
        };
        this.outData = data;
        // 将网络地址成功返回的数据，编码转码成pixelMap的图片格式
        if (http.ResponseCode.OK === this.outData.responseCode) {
          let imageData: ArrayBuffer = this.outData.result as ArrayBuffer;
          let imageSource: image.ImageSource = image.createImageSource(imageData);
          let options: image.DecodingOptions = {
            'desiredPixelFormat': image.PixelMapFormat.RGBA_8888,
          };
          imageSource.createPixelMap(options).then((pixelMap: PixelMap) => {
            this.image = pixelMap;
          });
        };
      });
  };

  build() {
    Column() {
      // 显示图片
      Image(this.image)
        .height(100)
        .width(100)
    }
  }
}
// [End multimedia_pixel]