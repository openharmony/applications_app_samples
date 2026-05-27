/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import { MedicalAdvice } from './MedicalAdvice';
import { Drug } from './Drug';
import { router } from '@kit.ArkUI';
import { PatientData, ResultObject, Patient } from '../../viewmodel/OrderExecution/ConfigData';
import http from '@ohos.net.http';
import Net from '../../viewmodel/OrderExecution/netConfig';


let patientsList: Patient[] = [];

function get(deptId: string): Promise<Array<Patient> | null> {
  let httpGetRequest = http.createHttp();
  httpGetRequest.on('headersReceive', (header) => {
    console.info('Get header: ' + JSON.stringify(header));
  });

  return new Promise((resolve, reject) => {
    let promise = httpGetRequest.request('http://' + Net.getInstance().ip +
      '/app-gateway/patient-biz/patient-list/by-not-null-bed-pda?deptId=' + deptId, {
      method: http.RequestMethod.GET,
      connectTimeout: 60000,
      readTimeout: 60000,
      header: {
        'Content-Type': 'application/json'
      }
    });
    promise.then((data) => {
      let resultObject = JSON.parse(data.result as string) as ResultObject;
      if (resultObject && Array.isArray(resultObject.data)) {
        let patients: Patient[] = resultObject.data.map((item: PatientData) => Patient.fromJSON(item));
        // 现在 patients 是 Patient 类的实例数组，你可以进行进一步的操作
        patients.forEach((patient) => {
          patientsList.push(patient);
        });
        resolve(patients);
      } else {
        console.error('Expected resultObject.data to be an array');
        resolve(null);
      }
    }).catch((err: Error) => {
      console.info('Get error:' + JSON.stringify(err));
      reject(err);
    });
  });
}


export let name: Patient;

let i = 0;

@Entry
@Component
export default struct PatientList {
  @State patientsList: Patient[] = [];

  async aboutToAppear(): Promise<void> {
    try {
      const data = await get(Net.getInstance().deptId);
      if (data != null) {
        this.patientsList = data;
      }
    } catch (error) {
      console.error('Error fetching data: ' + error);
    }
  }

  @State currentIndex: number = 0;

  @Builder
  build() {
    Column() {
      Row() {
      }.backgroundColor('#6fa7ff').width('100%').height(50).justifyContent(FlexAlign.Center);

      Row() {
        Text('患者列表')
          .height(40)
          .border({
            width: 0.5,
            color: Color.White,
            radius: {
              bottomLeft: 5,
              bottomRight: 0,
              topRight: 0,
              topLeft: 5
            }
          })
          .fontSize(20)
          .fontColor(this.currentIndex === 0 ? $r('app.color.nurse_blue') : Color.White)
          .backgroundColor(this.currentIndex === 0 ? Color.White : '')
          .padding({ left: 10, right: 10 });
        Text('我的患者')
          .height(40)
          .border({
            width: 0.5,
            color: Color.White,
            radius: {
              bottomLeft: 0,
              bottomRight: 5,
              topRight: 5,
              topLeft: 0
            }
          })
          .fontSize(20)
          .fontColor(this.currentIndex === 1 ? $r('app.color.nurse_blue') : Color.White)
          .backgroundColor(this.currentIndex === 1 ? Color.White : '')
          .padding({ left: 10, right: 10 })
          .onClick(() => {
            i = i + 1;
            if (i > 10) {
              i = 0;
              router.pushUrl({
                url: 'pages/OrderExecution/test'
              });
            }
          });
      }
      .backgroundColor('#6fa7ff')
      .borderRadius({ bottomLeft: 10, bottomRight: 10 })
      .width('100%')
      .height(80)
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Top)
      .padding({ top: 5 });

      Stack({ alignContent: Alignment.TopStart }) {
        Column() {
          //列表
          List({ space: 5, initialIndex: 0 }) {
            ForEach(this.patientsList, (item: Patient) => {
              ListItem() {
                Column() {
                  Row() {
                    Row() {
                      Circle({ width: 24, height: 24 }).fill(Color.White);
                      Text(item.bedName)
                        .fontSize(18)
                        .fontWeight(600)
                        .fontColor($r('app.color.nurse_blue'))
                        .width(24)
                        .height(24)
                        .textAlign(TextAlign.Center)
                        .position({ x: 0 })
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis });
                    };

                    Text(item.patientName)
                      .fontSize(20)
                      .fontWeight(600)
                      .fontColor($r('app.color.nurse_blue'))
                      .lineHeight(24)
                      .width('30%')
                      .maxLines(2)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                      .margin({ left: 15, right: 50 });
                    Text(item.illnessStatus).fontSize(18).fontColor(Color.Gray).lineHeight(24);

                  }
                  .onClick(() => {
                    name = item;
                    router.pushUrl({
                      url: 'pages/OrderExecution/MedicalAdvice'
                    });
                  })
                  .width('96%')
                  .padding({
                    top: 20,
                    bottom: 20,
                    left: 5,
                    right: 5
                  })
                  .margin({ left: 5, right: 5 })
                  .border({
                    width: { bottom: 1 },
                    color: { bottom: '#f2f2f2' },
                    style: {
                      bottom: BorderStyle.Solid,
                    }
                  });

                  Divider().strokeWidth(1).color(Color.White).margin({ top: 5 });
                };
              };
            });
          }
          .listDirection(Axis.Vertical) // 排列方向
          .edgeEffect(EdgeEffect.None) // 滑动到边缘无效果
          .chainAnimation(false) // 联动特效关闭
          .onScrollIndex((firstIndex: number, lastIndex: number) => {
            console.info('first' + firstIndex);
            console.info('last' + lastIndex);
          })
          .width('100%')
          .height('100%')
          .padding(5);
        }.width('100%').height('85%');
      };

    }.backgroundColor('#f1f2f6');
  }
}