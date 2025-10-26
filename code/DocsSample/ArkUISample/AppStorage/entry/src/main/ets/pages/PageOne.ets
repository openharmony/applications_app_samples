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
@Entry
@Component
struct StorageDemoPage {
  // 存储实例与关联对象
  private storage: LocalStorage = new LocalStorage();
  private link1: SubscribedAbstractProperty<number> = AppStorage.link('propA');
  private link2: SubscribedAbstractProperty<number> = AppStorage.link('propA');
  private prop: SubscribedAbstractProperty<number> = AppStorage.prop('propA');

  // 状态变量用于UI展示
  @State appPropA: number = 0;
  @State localPropA: number = 0;
  @State link1Val: number = 0;
  @State link2Val: number = 0;
  @State propVal: number = 0;

  aboutToAppear() {
    // 初始化存储
    AppStorage.setOrCreate('propA', 47);
    this.storage.setOrCreate('propA', 17);
    this.updateDisplayValues();
  }

  // 更新UI展示值
  private updateDisplayValues() {
    this.appPropA = AppStorage.get<number>('propA')!;
    this.localPropA = this.storage.get<number>('propA')!;
    this.link1Val = this.link1.get();
    this.link2Val = this.link2.get();
    this.propVal = this.prop.get();
  }

  build() {
    List() {
      // 标题
      ListItem() {
        Text('存储同步演示')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .padding(10)
      }

      // AppStorage区域
      ListItem() {
        List() {
          ListItem() {
            Text('AppStorage (propA)')
              .fontSize(18)
              .fontColor('#0066CC')
              .padding(5)
          }
          ListItem() {
            Text(`当前值: ${this.appPropA}`)
              .padding({ left: 10 })
          }
          ListItem() {
            Text(`link1: ${this.link1Val} | link2: ${this.link2Val} | prop: ${this.propVal}`)
              .fontSize(14)
              .padding({ left: 10 })
          }
          ListItem() {
            List({ space: 5 }) {
              ListItem() {
                Button('link1.set(48)')
                  .onClick(() => {
                    this.link1.set(48);
                    this.updateDisplayValues();
                  })
                  .backgroundColor('#0066CC')
                  .fontSize(12)
              }
              ListItem() {
                Button('prop.set(1)')
                  .onClick(() => {
                    this.prop.set(1);
                    this.updateDisplayValues();
                  })
                  .backgroundColor('#0066CC')
                  .fontSize(12)
              }
              ListItem() {
                Button('link1.set(49)')
                  .onClick(() => {
                    this.link1.set(49);
                    this.updateDisplayValues();
                  })
                  .backgroundColor('#0066CC')
                  .fontSize(12)
              }
            }
            .padding({ left: 10, top: 5, bottom: 5 })
          }
        }
        .backgroundColor('#FFFFFF')
        .borderRadius(5)
        .margin(5)
      }

      // LocalStorage区域
      ListItem() {
        List() {
          ListItem() {
            Text('LocalStorage (propA)')
              .fontSize(18)
              .fontColor('#FF6600')
              .padding(5)
          }
          ListItem() {
            Text(`当前值: ${this.localPropA}`)
              .padding({ left: 10 })
          }
          ListItem() {
            Button('storage.set(101)')
              .onClick(() => {
                this.storage.set('propA', 101);
                this.localPropA = this.storage.get<number>('propA')!;
              })
              .backgroundColor('#FF6600')
              .fontSize(12)
              .padding({ left: 10, top: 5, bottom: 5 })
          }
        }
        .backgroundColor('#FFFFFF')
        .borderRadius(5)
        .margin(5)
      }

      // 同步规则说明
      ListItem() {
        Text('规则:\n1. AppStorage与LocalStorage独立\n2. link双向同步，prop单向同步')
          .fontSize(14)
          .padding(10)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}