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
class IssueHistory {
  public title: string = '';
  public time: string = '';
  public content?: string = '';
}

@Component
export default struct issueReportHistory {
  @Prop issueHistory: IssueHistory[] = [];

  build() {
    Column() {
      if (this.issueHistory?.length) {
        Column() {
          Text($r('app.string.Operation_History'))
            .fontSize('42lpx')
            .fontWeight(600)
            .margin({ left: '72lpx', bottom: '24lpx' });
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .margin({ bottom: '24lpx' });
      }

      Column({ space: '24lpx' }) {
        ForEach(this.issueHistory, (item: IssueHistory, index: number) => {
          Column({ space: '12lpx' }) {
            Row({ space: '24lpx' }) {
              Column() {
                Column() {
                  Column() {
                  }
                  .width('12lpx')
                  .height('12lpx')
                  .border({ width: '3lpx', color: Color.Black, radius: '6lpx' });
                }
                .width('36lpx')
                .height('36lpx')
                .border({ width: '3lpx', color: Color.Black, radius: '18lpx' })
                .alignItems(HorizontalAlign.Center)
                .justifyContent(FlexAlign.Center);

              };

              Text(item.time)
                .fontSize('42lpx')
                .fontWeight(400);
            }
            .width('100%')
            .justifyContent(FlexAlign.Start);

            Row() {
              Text(item.title)
                .fontSize('42lpx')
                .fontWeight(600);
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)
            .padding({ left: '60lpx' });

            Row() {
              Text(item.content)
                .fontSize('42lpx');
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)
            .padding({ left: '60lpx' });
          };
        });
      }
      .margin({ left: '36lpx', right: '36lpx' })
      .padding({
        left: '48lpx',
        right: '48lpx',
        top: '84lpx',
        bottom: '66lpx'
      })
      .backgroundColor(Color.White)
      .borderRadius(10);
    }
    .margin({ top: '66lpx', bottom: '66lpx' });
  }
}