/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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
// [Start appstorage_page_eight]
import { emitter } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0001;
const TAG: string = '[SampleAppStorage]';

let nextId: number = 0;

class ViewData {
  public title: string;
  public uri: Resource;
  public color: Color = Color.Black;
  public id: number;

  constructor(title: string, uri: Resource) {
    this.title = title;
    this.uri = uri;
    this.id = nextId++;
  }
}

@Entry
@Component
struct Gallery {
  // $r('app.media.startIcon')需要替换为开发者所需的资源文件;
  dataList: Array<ViewData> =
    [new ViewData('flower', $r('app.media.startIcon')), new ViewData('OMG', $r('app.media.startIcon')),
      new ViewData('OMG', $r('app.media.startIcon'))];
  scroller: Scroller = new Scroller();
  private preIndex: number = -1;

  build() {
    Column() {
      Grid(this.scroller) {
        ForEach(this.dataList, (item: ViewData) => {
          GridItem() {
            TapImage({
              uri: item.uri,
              index: item.id
            })
          }.aspectRatio(1)
          .onClick(() => {
            if (this.preIndex === item.id) {
              return;
            }
            let innerEvent: emitter.InnerEvent = { eventId: item.id };
            // 选中态：黑变红
            let eventData: emitter.EventData = {
              data: {
                'colorTag': 1
              }
            };
            emitter.emit(innerEvent, eventData);

            if (this.preIndex != -1) {
              hilog.info(DOMAIN, TAG, `preIndex: ${this.preIndex}, index: ${item.id}, black`);
              let innerEvent: emitter.InnerEvent = { eventId: this.preIndex };
              // 取消选中态：红变黑
              let eventData: emitter.EventData = {
                data: {
                  'colorTag': 0
                }
              };
              emitter.emit(innerEvent, eventData);
            }
            this.preIndex = item.id;
          })
        }, (item: ViewData) => JSON.stringify(item))
      }.columnsTemplate('1fr 1fr')
    }

  }
}

@Component
export struct TapImage {
  @State tapColor: Color = Color.Black;
  private index: number = 0;
  private uri: Resource = {
    id: 0,
    type: 0,
    moduleName: '',
    bundleName: ''
  };

  onTapIndexChange(colorTag: emitter.EventData) {
    if (colorTag.data != null) {
      this.tapColor = colorTag.data.colorTag ? Color.Red : Color.Black;
    }
  }

  aboutToAppear() {
    //定义事件ID
    let innerEvent: emitter.InnerEvent = { eventId: this.index };
    emitter.on(innerEvent, data => {
      this.onTapIndexChange(data);
    });
  }

  build() {
    Column() {
      Image(this.uri)
        .objectFit(ImageFit.Cover)
        .border({ width: 5, style: BorderStyle.Dotted, color: this.tapColor })
    }
  }
}

// [End appstorage_page_eight]