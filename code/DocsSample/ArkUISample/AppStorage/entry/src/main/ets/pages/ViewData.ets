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
// [Start appstorage_page_seven]
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0001;
const TAG: string = '[SampleAppStorage]';

class ViewData {
  public title: string;
  public uri: Resource;
  public color: Color = Color.Black;

  constructor(title: string, uri: Resource) {
    this.title = title;
    this.uri = uri;
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

  build() {
    Column() {
      Grid(this.scroller) {
        ForEach(this.dataList, (item: ViewData, index?: number) => {
          GridItem() {
            TapImage({
              uri: item.uri,
              index: index
            })
          }.aspectRatio(1)

        }, (item: ViewData, index?: number) => {
          return JSON.stringify(item) + index;
        })
      }.columnsTemplate('1fr 1fr')
    }

  }
}

@Component
export struct TapImage {
  @StorageLink('tapIndex') @Watch('onTapIndexChange') tapIndex: number = -1;
  @State tapColor: Color = Color.Black;
  private index: number = 0;
  private uri: Resource = {
    id: 0,
    type: 0,
    moduleName: '',
    bundleName: ''
  };

  // 判断是否被选中
  onTapIndexChange() {
    if (this.tapIndex >= 0 && this.index === this.tapIndex) {
      hilog.info(DOMAIN, TAG, `tapindex: ${this.tapIndex}, index: ${this.index}, red`);
      this.tapColor = Color.Red;
    } else {
      hilog.info(DOMAIN, TAG, `tapindex: ${this.tapIndex}, index: ${this.index}, black`);
      this.tapColor = Color.Black;
    }
  }

  build() {
    Column() {
      Image(this.uri)
        .objectFit(ImageFit.Cover)
        .onClick(() => {
          this.tapIndex = this.index;
        })
        .border({ width: 5, style: BorderStyle.Dotted, color: this.tapColor })
    }

  }
}

// [End appstorage_page_seven]