/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { TitleBar } from '../common/TitleBar';
import { QueryItem } from '../common/QueryItem';
import SearchModel from '../model/SearchModel';
import ContactDataSource from '../common/BasicDataSource';

@Entry
@Component
struct SearchPage {
  private model: SearchModel = new SearchModel();

  build() {
    Column() {
      // 标题栏
      TitleBar({ hasBackPress: true })
      // 条件操作栏
      ConditionOption({ model: this.model })
      // 输入框
      InputArea({ model: this.model })
      // 输入和提示
      DataAndTips({ model: this.model })
    }
  }
}


@Component
struct ConditionOption {
  private model: SearchModel;

  async getData(): Promise<void> {
    await this.model.getData();
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.query_criteria'))
          .fontSize(25)
          .margin({ right: 10 })

        Select([{ value: 'beginsWith', icon: $r('app.media.select') },
          { value: 'endsWith', icon: $r('app.media.select') },
          { value: 'contains', icon: $r('app.media.select') },
          { value: 'greaterThan and lessThan', icon: $r('app.media.select') },
          { value: 'between and notBetween', icon: $r('app.media.select') },
          { value: 'equalTo and notEqualTo', icon: $r('app.media.select') },
          { value: $r('app.string.index_query'), icon: $r('app.media.select') },
          { value: $r('app.string.expression_matching'), icon: $r('app.media.select') }])
          .selected(0)
          .width(320)
          .font({ size: 23, weight: FontWeight.Medium })
          .fontColor($r("app.color.color_182431"))
          .selectedOptionFont({ size: 23, weight: FontWeight.Regular })
          .optionFont({ size: 23, weight: FontWeight.Regular })
          .border({ width: 1, color: $r("app.color.black"), radius: 10 })
          .onSelect((index: number) => {
            this.model.onSelect(index)
          })

        Row().width(180)

      }
      .width("100%")
      .justifyContent(FlexAlign.SpaceBetween)
      .height(80)

      Row() {
        Text($r('app.string.sort_the_results'))
          .fontSize(25)
          .margin({ right: 10 })

        Select([{ value: $r('app.string.ascending'), icon: $r('app.media.Ascending') },
          { value: $r('app.string.descending'), icon: $r('app.media.Descending') }])
          .selected(this.model.searchData.isAscending ? 0 : 1)
          .width(180)
          .font({ size: 23, weight: FontWeight.Medium })
          .fontColor($r("app.color.color_182431"))
          .selectedOptionFont({ size: 23, weight: FontWeight.Regular })
          .optionFont({ size: 23, weight: FontWeight.Regular })
          .border({ width: 1, color: $r("app.color.black"), radius: 10 })
          .onSelect(async (index: number) => {
            this.model.searchData.isAscending = (index == 0);
          })
        Row().width(320)
      }
      .width("100%")
      .justifyContent(FlexAlign.SpaceBetween)
      .height(80)


      Button($r('app.string.search'))
        .fontSize(25)
        .margin({ top: 20 })
        .type(ButtonType.Capsule)
        .onClick(() => {
          this.getData()
        })
    }
    .alignItems(HorizontalAlign.Start)
    .width("80%")

  }
}


@Component
struct InputArea {
  private model: SearchModel;
  @State isDoubleInput: boolean = false;
  @State searchPlaceholder: Resource = $r('app.string.search_placeholder_start');
  @State searchText: string = "";
  @State searchTexts: Array<string> = [];

  aboutToAppear() {
    this.model.onSelectCallback = this.onSelectCallback.bind(this);
  }

  onSelectCallback() {
    this.isDoubleInput = this.model.searchData.isDoubleInput;
    this.searchPlaceholder = this.model.searchData.searchPlaceholder;
    this.searchText = this.model.searchData.searchText;
    this.searchTexts = this.model.searchData.searchTexts;
  }

  aboutToDisappear() {
    this.model.onSelectCallback = undefined;
  }

  build() {
    // 搜索输入框
    if (!this.isDoubleInput) {
      Row() {
        Image($r('app.media.search_gray'))
          .height('100%')
          .width(40)
          .margin({ left: 16 })
          .objectFit(ImageFit.Contain)

        TextInput({ placeholder: this.searchPlaceholder, text: this.searchText })
          .height('85%')
          .width('80%')
          .fontSize(25)
          .margin({ right: 10 })
          .backgroundColor($r("app.color.color_fa"))
          .enableKeyboardOnFocus(false)
          .onChange((value: string) => {
            this.model.searchData.searchText = value
          })
      }
      .width('80%')
      .height(80)
      .border({ radius: 45 })
      .margin({ top: 10 })
    } else {
      Row() {
        Column() {
          TextInput({ placeholder: $r('app.string.search_placeholder_age1'), text: this.searchTexts[0] })
            .height('85%')
            .width('95%')
            .fontSize(25)
            .margin({ right: 10, top: 5 })
            .backgroundColor($r("app.color.color_fa"))
            .enableKeyboardOnFocus(false)
            .onChange((value: string) => {
              this.model.searchData.searchTexts[0] = value
            })
        }
        .width('40%')
        .height(80)
        .border({ radius: 45 })
        .margin({ top: 10 })

        Column() {
          Text('——')
            .margin({ top: 5 })
        }
        .width('10%')

        Column() {
          TextInput({ placeholder: $r('app.string.search_placeholder_age1'), text: this.searchTexts[1] })
            .height('85%')
            .width('95%')
            .fontSize(25)
            .margin({ right: 10, top: 5 })
            .backgroundColor($r("app.color.color_fa"))
            .enableKeyboardOnFocus(false)
            .onChange((value: string) => {
              this.model.searchData.searchTexts[1] = value
            })
        }
        .width('40%')
        .height(80)
        .border({ radius: 45 })
        .margin({ top: 10 })
      }.width("80%")
    }

  }
}

@Component
struct DataAndTips {
  private model: SearchModel;
  private contacts: ContactDataSource = new ContactDataSource([]);
  private otherContacts: ContactDataSource = new ContactDataSource([]);
  @State contactsCount: number = 0;
  @State otherContactsCount: number = 0;
  @State searchTips: Array<string> = [];

  aboutToAppear() {
    this.model.onDataCallback = this.onDataCallback.bind(this);
  }

  onDataCallback(): void {
    this.contactsCount = this.model.queryData.length;
    this.contacts.replaceDataArray(this.model.queryData);
    this.otherContactsCount = this.model.queryOtherData.length;
    this.otherContacts.replaceDataArray(this.model.queryOtherData);
    this.searchTips = this.model.searchData.searchTips;
  }

  aboutToDisappear() {
    this.model.onDataCallback = undefined
  }

  build() {
    List() {
      if (this.searchTips[0] && this.searchTips[0].length > 0) {
        ListItem() {
          Row() {
            Text(this.searchTips[0])
              .fontSize(18)
              .fontColor($r("app.color.grey"))
          }
          .width('100%')
          .justifyContent(FlexAlign.Start)
          .padding({ left: 16 })
        }

        if (this.contactsCount === 0) {
          ListItem() {
            Row() {
              Text($r('app.string.no_data'))
                .fontSize(18)
                .fontColor($r("app.color.grey"))
            }
            .width('100%')
            .justifyContent(FlexAlign.Center)
            .padding({ left: 16 })
          }
        } else {
          LazyForEach(this.contacts, item => {
            ListItem() {
              QueryItem({ contact: item })
            }
          }, item => item.name)
        }
      }

      if (this.searchTips[1] && this.searchTips[1].length > 0) {
        ListItem() {
          Row() {
            Text(this.searchTips[1])
              .fontSize(18)
              .fontColor($r("app.color.grey"))
          }
          .width('100%')
          .justifyContent(FlexAlign.Start)
          .padding({ left: 16 })
        }

        if (this.otherContactsCount == 0) {
          ListItem() {
            Row() {
              Text($r('app.string.no_data'))
                .fontSize(18)
                .fontColor($r("app.color.grey"))
            }
            .width('100%')
            .justifyContent(FlexAlign.Center)
            .padding({ left: 16 })
          }
        } else {
          LazyForEach(this.otherContacts, item => {
            ListItem() {
              QueryItem({ contact: item })
            }
          }, item => item.name)
        }
      }
    }
    .layoutWeight(1)
    .width("80%")
    .divider({ strokeWidth: 1, color: $r("app.color.grey"), startMargin: 16, endMargin: 16 })
    .alignListItem(ListItemAlign.Center)
  }
}