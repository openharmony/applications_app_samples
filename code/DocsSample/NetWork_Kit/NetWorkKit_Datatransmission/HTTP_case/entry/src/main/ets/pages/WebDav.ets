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

// [Start HTTP_webDav]
import { http } from '@kit.NetworkKit';
import { ComponentId } from '../common/CommonConstant';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct Index {
  proppatchXml = `example_proppatchXml`; // 修改资源Xml
  lockXml: string = `example_lockXml`; // 加锁Xml
  lockToken: string = '';

  build() {
    Column({ space: 5 }) {
      Button($r('app.string.HTTP_WEBDAV_PUT'))
        .id(ComponentId.HTTP_WEBDAV_PUT)
        .onClick(async () => {
          let httpRequest = http.createHttp();
          let file = 'example';
          httpRequest.request('EXAMPLE_URL' + 'example.txt',
            {
              expectDataType: http.HttpDataType.STRING,
              extraData: file, // 上传文件内容
              header: { 'Content-Type': 'text/plain; charset=utf-8', 'Content-Length': file.length.toString() },
              customMethod: 'PUT' // WebDav协议PUT请求方式
            },
            (err: Error, data: http.HttpResponse) => {
              if (!err) {
                hilog.info(0x0000, 'testTag', 'Result:' + data.result);
                hilog.info(0x0000, 'testTag', 'code:' + data.responseCode);
                hilog.info(0x0000, 'testTag', 'header:' + JSON.stringify(data.header));
                httpRequest.destroy();
              } else {
                hilog.error(0x0000, 'testTag', 'error:' + JSON.stringify(err));
                httpRequest.destroy();
              }
            })
        })

      Button($r('app.string.HTTP_WEBDAV_GET'))
        .id(ComponentId.HTTP_WEBDAV_GET)
        .onClick(() => {
          let httpRequest = http.createHttp();
          httpRequest.request('EXAMPLE_URL' + 'example.txt',
            {
              expectDataType: http.HttpDataType.STRING,
              customMethod: 'GET' // WebDav协议GET请求方式
            },
            (err: Error, data: http.HttpResponse) => {
              if (!err) {
                hilog.info(0x0000, 'testTag', 'Result:' + data.result.toString());
                hilog.info(0x0000, 'testTag', 'code:' + data.responseCode);
                hilog.info(0x0000, 'testTag', 'header:' + JSON.stringify(data.header));
                httpRequest.destroy();
              } else {
                hilog.error(0x0000, 'testTag', 'error:' + JSON.stringify(err));
                httpRequest.destroy();
              }
            })
        })

      Button($r('app.string.HTTP_WEBDAV_MKCOL'))
        .id(ComponentId.HTTP_WEBDAV_MKCOL)
        .onClick(() => {
          let httpRequest = http.createHttp();
          httpRequest.request('EXAMPLE_URL' + 'example/',
            {
              expectDataType: http.HttpDataType.STRING,
              customMethod: 'MKCOL' // WebDav协议MKCOL请求方式
            },
            (err: Error, data: http.HttpResponse) => {
              if (!err) {
                hilog.info(0x0000, 'testTag', 'Result:' + data.result);
                hilog.info(0x0000, 'testTag', 'code:' + data.responseCode);
                hilog.info(0x0000, 'testTag', 'header:' + JSON.stringify(data.header));
                httpRequest.destroy();
              } else {
                hilog.error(0x0000, 'testTag', 'error:' + JSON.stringify(err));
                httpRequest.destroy();
              }
            })
        })

      Button($r('app.string.HTTP_WEBDAV_DELETE'))
        .id(ComponentId.HTTP_WEBDAV_DELETE)
        .onClick(() => {
          let httpRequest = http.createHttp();
          httpRequest.request('EXAMPLE_URL' + 'example/',
            {
              expectDataType: http.HttpDataType.STRING,
              header: { 'Content-Type': 'text/xml' },
              customMethod: 'DELETE' // WebDav协议DELETE请求方式
            },
            (err: Error, data: http.HttpResponse) => {
              if (!err) {
                hilog.info(0x0000, 'testTag', 'Result:' + data.result);
                hilog.info(0x0000, 'testTag', 'code:' + data.responseCode);
                hilog.info(0x0000, 'testTag', 'header:' + JSON.stringify(data.header));
                httpRequest.destroy();
              } else {
                hilog.error(0x0000, 'testTag', 'error:' + JSON.stringify(err));
                httpRequest.destroy();
              }
            })
        })

      Button($r('app.string.HTTP_WEBDAV_COPY'))
        .id(ComponentId.HTTP_WEBDAV_COPY)
        .onClick(() => {
          let httpRequest = http.createHttp();
          httpRequest.request('EXAMPLE_URL' + 'example.txt',
            {
              expectDataType: http.HttpDataType.STRING,
              header: { 'Destination': 'EXAMPLE_URL' + 'new_example.txt' },
              customMethod: 'COPY' // WebDav协议COPY请求方式
            },
            (err: Error, data: http.HttpResponse) => {
              if (!err) {
                hilog.info(0x0000, 'testTag', 'Result:' + data.result);
                hilog.info(0x0000, 'testTag', 'code:' + data.responseCode);
                hilog.info(0x0000, 'testTag', 'header:' + JSON.stringify(data.header));
                httpRequest.destroy();
              } else {
                hilog.error(0x0000, 'testTag', 'error:' + JSON.stringify(err));
                httpRequest.destroy();
              }
            })
        })

      Button($r('app.string.HTTP_WEBDAV_MOVE'))
        .id(ComponentId.HTTP_WEBDAV_MOVE)
        .onClick(() => {
          let httpRequest = http.createHttp();
          httpRequest.request('EXAMPLE_URL' + 'example.txt',
            {
              expectDataType: http.HttpDataType.STRING,
              header: { 'Destination': 'EXAMPLE_URL' + 'reNameText.txt' },
              customMethod: 'MOVE' // WebDav协议MOVE请求方式
            },
            (err: Error, data: http.HttpResponse) => {
              if (!err) {
                hilog.info(0x0000, 'testTag', 'Result:' + data.result);
                hilog.info(0x0000, 'testTag', 'code:' + data.responseCode);
                hilog.info(0x0000, 'testTag', 'header:' + JSON.stringify(data.header));
                httpRequest.destroy();
              } else {
                hilog.error(0x0000, 'testTag', 'error:' + JSON.stringify(err));
                httpRequest.destroy();
              }
            })
        })

      Button($r('app.string.HTTP_WEBDAV_PROPPATCH'))
        .id(ComponentId.HTTP_WEBDAV_PROPPATCH)
        .onClick(() => {
          let httpRequest = http.createHttp();
          httpRequest.request('EXAMPLE_URL' + 'example.txt',
            {
              extraData: this.proppatchXml,
              expectDataType: http.HttpDataType.STRING,
              header: { 'Content-Type': 'application/xml; charset=utf-8', 'Depth': 'infinity' },
              customMethod: 'PROPPATCH' // WebDav协议PROPPATCH请求方式
            },
            (err: Error, data: http.HttpResponse) => {
              if (!err) {
                hilog.info(0x0000, 'testTag', 'Result:' + data.result);
                hilog.info(0x0000, 'testTag', 'code:' + data.responseCode);
                hilog.info(0x0000, 'testTag', 'header:' + JSON.stringify(data.header));
                httpRequest.destroy();
              } else {
                hilog.error(0x0000, 'testTag', 'error:' + JSON.stringify(err));
                httpRequest.destroy();
              }
            })
        })

      Button($r('app.string.HTTP_WEBDAV_PROPFIND'))
        .id(ComponentId.HTTP_WEBDAV_PROPFIND)
        .onClick(() => {
          let httpRequest = http.createHttp();
          httpRequest.request('EXAMPLE_URL' + 'example.txt',
            {
              expectDataType: http.HttpDataType.STRING,
              header: {
                'Content-Type': 'text/xml',
                'Depth': '0'
              },
              customMethod: 'PROPFIND' // WebDav协议PROPFIND请求方式
            },
            (err: Error, data: http.HttpResponse) => {
              if (!err) {
                hilog.info(0x0000, 'testTag', 'Result:' + data.result);
                hilog.info(0x0000, 'testTag', 'code:' + data.responseCode);
                hilog.info(0x0000, 'testTag', 'header:' + JSON.stringify(data.header));
                httpRequest.destroy();
              } else {
                hilog.error(0x0000, 'testTag', 'error:' + JSON.stringify(err));
                httpRequest.destroy();
              }
            })
        })

      Button($r('app.string.HTTP_WEBDAV_LOCK'))
        .id(ComponentId.HTTP_WEBDAV_LOCK)
        .onClick(() => {
          let httpRequest = http.createHttp();
          httpRequest.request('EXAMPLE_URL' + 'example.txt',
            {
              extraData: this.lockXml,
              expectDataType: http.HttpDataType.STRING,
              header: {
                'Content-Type': 'application/xml',
                'Depth': '0',
              },
              customMethod: 'LOCK' // WebDav协议LOCK请求方式
            },
            (err: Error, data: http.HttpResponse) => {
              if (!err) {
                let lockTokenRegex = /<D:href>(urn:uuid:[a-fA-F0-9\-]+)<\/D:href>/;
                let statusMatch: RegExpMatchArray | null = (data.result as string).match(lockTokenRegex);
                if (statusMatch) {
                  this.lockToken = statusMatch[1];
                }
                hilog.info(0x0000, 'testTag', 'Result:' + data.result);
                hilog.info(0x0000, 'testTag', 'code:' + data.responseCode);
                hilog.info(0x0000, 'testTag', 'header:' + JSON.stringify(data.header));
                hilog.info(0x0000, 'testTag', 'lockToken:' + this.lockToken);
                httpRequest.destroy();
              } else {
                hilog.error(0x0000, 'testTag', 'error:' + JSON.stringify(err));
                httpRequest.destroy();
              }
            })
        })

      Button($r('app.string.HTTP_WEBDAV_UNLOCK'))
        .id(ComponentId.HTTP_WEBDAV_UNLOCK)
        .onClick(() => {
          let httpRequest = http.createHttp();
          httpRequest.request('EXAMPLE_URL' + 'example.txt',
            {
              header: {
                'Content-Length': '0',
                'Lock-Token': this.lockToken, // 加锁时返回密钥
                'Depth': '0'
              },
              customMethod: 'UNLOCK' // WebDav协议UNLOCK请求方式
            },
            (err: Error, data: http.HttpResponse) => {
              if (!err) {
                hilog.info(0x0000, 'testTag', 'Result:' + data.result);
                hilog.info(0x0000, 'testTag', 'code:' + data.responseCode);
                hilog.info(0x0000, 'testTag', 'header:' + JSON.stringify(data.header));
                httpRequest.destroy();
              } else {
                hilog.error(0x0000, 'testTag', 'error:' + JSON.stringify(err));
                httpRequest.destroy();
              }
            })
        })

      Button($r('app.string.HTTP_WEBDAV_UNKNOWN'))
        .id(ComponentId.HTTP_WEBDAV_UNKNOWN)
        .onClick(() => {
          let httpRequest = http.createHttp();
          httpRequest.request('EXAMPLE_URL',
            {
              customMethod: 'UNKNOWN' // 非WebDav协议请求方式
            },
            (err: Error, data: http.HttpResponse) => {
              if (!err) {
                hilog.info(0x0000, 'testTag', 'Result:' + data.result);
                hilog.info(0x0000, 'testTag', 'code:' + data.responseCode);
                hilog.info(0x0000, 'testTag', 'header:' + JSON.stringify(data.header));
                httpRequest.destroy();
              } else {
                hilog.error(0x0000, 'testTag', 'error:' + JSON.stringify(err));
                httpRequest.destroy();
              }
            })
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}
// [End HTTP_webDav]