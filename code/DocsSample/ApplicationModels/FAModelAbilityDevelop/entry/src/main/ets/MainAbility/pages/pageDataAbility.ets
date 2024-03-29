/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import ability from '@ohos.ability.ability';
import featureAbility from '@ohos.ability.featureAbility';
import { BusinessError } from '@ohos.base';
import ohos_data_ability from '@ohos.data.dataAbility';
import rdb from '@ohos.data.rdb';
import promptAction from '@ohos.promptAction';
import hilog from '@ohos.hilog';

const TAG: string = 'PageDataAbility';
const domain: number = 0xFF00;

@Entry
@Component
struct PageDataAbility {
  private valuesBucket_insert: rdb.ValuesBucket = { name: 'Rose', introduction: 'insert' };
  private valuesBucket_update: rdb.ValuesBucket = { name: 'Rose', introduction: 'update' };
  private crowd = new Array({ name: 'Rose', introduction: 'batchInsert_one' } as rdb.ValuesBucket,
    { name: 'Rose', introduction: 'batchInsert_two' } as rdb.ValuesBucket);
  private columnArray = new Array('id', 'name', 'introduction');
  private predicates = new ohos_data_ability.DataAbilityPredicates();
  private uri = 'dataability:///com.samples.famodelabilitydevelop.DataAbility';
  private DAHelper = featureAbility.acquireDataAbilityHelper(this.uri);

  build() {
    Column() {
      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignContent: FlexAlign.Center }) {
          Text($r('app.string.dataAbility_button'))
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
            .margin({ top: 12, bottom: 11, right: 24, left: 24 })
        }
      }
      .width('100%')
      .height(56)
      .justifyContent(FlexAlign.Start)
      .backgroundColor($r('app.color.backGrounding'))


      List({ initialIndex: 0 }) {
        ListItem() {
          Text($r('app.string.insertData'))
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Medium)
            .margin({ top: 19.5, bottom: 9.5 })
            .fontSize(14)
            .width(176)
            .height(22)
            .fontColor($r('app.color.text_color'))
            .opacity(0.6)
        }
        .height(48)
        .width(176)
        .margin({ top: 8, left: 24 })

        ListItemGroup() {
          ListItem() {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
              Text($r('app.string.method_callback'))
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 12.5, left: 12, right: 92 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))

              Image($r('app.media.ic_arrow'))
                .width(24)
                .height(24)
                .margin({ top: 16, right: 6 })
            }
            .onClick(() => {
              // callback方式调用:
              this.DAHelper.insert(this.uri, this.valuesBucket_insert, (error: BusinessError, data: number) => {
                if (error && error.code !== 0) {
                  promptAction.showToast({
                    message: $r('app.string.insert_failed_toast')
                  });
                } else {
                  promptAction.showToast({
                    message: $r('app.string.insert_success_toast')
                  });
                }
                hilog.info(domain, TAG, 'DAHelper insert result: ' + data + ', error: ' + JSON.stringify(error));
              }
              );
            })
          }
          .height(51)
          .width('100%')
          .margin({ top: 4 })

          ListItem() {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
              Text($r('app.string.method_promise'))
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 12, right: 92 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))

              Image($r('app.media.ic_arrow'))
                .width(24)
                .height(24)
                .margin({ top: 16, right: 6 })
            }
            .onClick(() => {
              // promise方式调用(await需要在async方法中使用):
              this.DAHelper.insert(this.uri, this.valuesBucket_insert).then((datainsert) => {
                promptAction.showToast({
                  message: $r('app.string.insert_success_toast')
                });
                hilog.info(domain, TAG, 'DAHelper insert result: ' + datainsert);
              }).catch((error: BusinessError) => {
                promptAction.showToast({
                  message: $r('app.string.insert_failed_toast')
                });
                hilog.error(domain, TAG, `DAHelper insert failed. Cause: ${error.message}`);
              });
            })
          }
          .height(52)
          .width('100%')
          .margin({ bottom: 4 })

        }
        .borderRadius(24)
        .divider({ strokeWidth: 0.5, color: ($r('app.color.backGrounding')), startMargin: 12, endMargin: 12 })
        .height(104)
        .backgroundColor($r('app.color.start_window_background'))
        .margin({ right: 12, left: 12 })

        ListItem() {
          Text($r('app.string.delete_data'))
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Medium)
            .margin({ top: 19.5, bottom: 9.5 })
            .fontSize(14)
            .width(176)
            .height(22)
            .fontColor($r('app.color.text_color'))
            .opacity(0.6)
        }
        .height(48)
        .width(176)
        .margin({ top: 8, left: 24 })

        ListItemGroup() {
          ListItem() {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
              Text($r('app.string.method_callback'))
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 12.5, left: 12, right: 92 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))

              Image($r('app.media.ic_arrow'))
                .width(24)
                .height(24)
                .margin({ top: 16, right: 6 })
            }
            .onClick(() => {
              // callback方式调用:
              this.DAHelper.delete(this.uri, this.predicates, (error, data) => {
                if (error && error.code !== 0) {
                  promptAction.showToast({
                    message: $r('app.string.delete_failed_toast')
                  });
                } else {
                  promptAction.showToast({
                    message: $r('app.string.delete_success_toast')
                  });
                }
                hilog.info(domain, TAG, 'DAHelper delete result: ' + data + ', error: ' + JSON.stringify(error));
              }
              );
            })
          }
          .height(51)
          .width('100%')
          .margin({ top: 4 })

          ListItem() {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
              Text($r('app.string.method_promise'))
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 12, right: 92 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))

              Image($r('app.media.ic_arrow'))
                .width(24)
                .height(24)
                .margin({ top: 16, right: 6 })
            }
            .onClick(() => {
              // promise方式调用(await需要在async方法中使用):
              this.DAHelper.delete(this.uri, this.predicates).then((datadelete) => {
                promptAction.showToast({
                  message: $r('app.string.delete_success_toast')
                });
                hilog.info(domain, TAG, 'DAHelper delete result: ' + datadelete);
              }).catch((error: BusinessError) => {
                promptAction.showToast({
                  message: $r('app.string.delete_failed_toast')
                });
                hilog.error(domain, TAG, `DAHelper delete failed. Cause: ${error.message}`);
              });
            })
          }
          .height(52)
          .width('100%')
          .margin({ bottom: 4 })
        }
        .borderRadius(24)
        .divider({ strokeWidth: 0.5, color: ($r('app.color.backGrounding')), startMargin: 12, endMargin: 12 })
        .height(104)
        .backgroundColor($r('app.color.start_window_background'))
        .margin({ right: 12, left: 12 })

        ListItem() {
          Text($r('app.string.update_data'))
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Medium)
            .margin({ top: 19.5, bottom: 9.5 })
            .fontSize(14)
            .width(176)
            .height(22)
            .fontColor($r('app.color.text_color'))
            .opacity(0.6)
        }
        .height(48)
        .width(176)
        .margin({ top: 8, left: 24 })

        ListItemGroup() {
          ListItem() {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
              Text($r('app.string.method_callback'))
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 12.5, left: 12, right: 92 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))

              Image($r('app.media.ic_arrow'))
                .width(24)
                .height(24)
                .margin({ top: 16, right: 6 })
            }
            .onClick(() => {
              // callback方式调用:
              this.predicates.equalTo('name', 'Rose');
              this.DAHelper.update(this.uri, this.valuesBucket_update, this.predicates, (error, data) => {
                if (error && error.code !== 0) {
                  promptAction.showToast({
                    message: $r('app.string.update_failed_toast')
                  });
                } else {
                  promptAction.showToast({
                    message: $r('app.string.update_success_toast')
                  });
                }
                hilog.info(domain, TAG, 'DAHelper update result: ' + data + ', error: ' + JSON.stringify(error));
              }
              );
            })
          }
          .height(51)
          .width('100%')
          .margin({ top: 4 })

          ListItem() {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
              Text($r('app.string.method_promise'))
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 12, right: 92 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))
              Image($r('app.media.ic_arrow'))
                .width(24)
                .height(24)
                .margin({ top: 16, right: 6 })
            }
            .onClick(() => {
              // promise方式调用(await需要在async方法中使用):
              this.predicates.equalTo('name', 'Rose');
              this.DAHelper.update(this.uri, this.valuesBucket_update, this.predicates).then((dataupdate) => {
                promptAction.showToast({
                  message: $r('app.string.update_success_toast')
                });
                hilog.info(domain, TAG, 'DAHelper update result: ' + dataupdate);
              }).catch((error: BusinessError) => {
                promptAction.showToast({
                  message: $r('app.string.update_failed_toast')
                });
                hilog.error(domain, TAG, `DAHelper update failed. Cause: ${error.message}`);
              });
            })
          }
          .height(52)
          .width('100%')
          .margin({ bottom: 4 })
        }
        .borderRadius(24)
        .divider({ strokeWidth: 0.5, color: ($r('app.color.backGrounding')), startMargin: 12, endMargin: 12 })
        .height(104)
        .backgroundColor($r('app.color.start_window_background'))
        .margin({ right: 12, left: 12 })

        ListItem() {
          Text($r('app.string.query_data'))
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Medium)
            .margin({ top: 19.5, bottom: 9.5 })
            .fontSize(14)
            .width(176)
            .height(22)
            .fontColor($r('app.color.text_color'))
            .opacity(0.6)
        }
        .height(48)
        .width(176)
        .margin({ top: 8, left: 24 })

        ListItemGroup() {
          ListItem() {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
              Text($r('app.string.method_callback'))
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 12.5, left: 12, right: 92 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))

              Image($r('app.media.ic_arrow'))
                .width(24)
                .height(24)
                .margin({ top: 16, right: 6 })
            }
            .onClick(() => {
              // callback方式调用:
              this.predicates.equalTo('name', 'Rose');
              this.DAHelper.query(this.uri, this.columnArray, this.predicates, (error, data) => {
                if (error && error.code !== 0) {
                  promptAction.showToast({
                    message: $r('app.string.query_failed_toast')
                  });
                  hilog.error(domain, TAG, `DAHelper query failed. Cause: ${error.message}`);
                } else {
                  promptAction.showToast({
                    message: $r('app.string.query_success_toast')
                  });
                }
                // ResultSet是一个数据集合的游标，默认指向第-1个记录，有效的数据从0开始。
                while (data.goToNextRow()) {
                  const id = data.getLong(data.getColumnIndex('id'));
                  const name = data.getString(data.getColumnIndex('name'));
                  const introduction = data.getString(data.getColumnIndex('introduction'));
                  hilog.info(domain, TAG, `DAHelper query result:id = [${id}], name = [${name}], introduction = [${introduction}]`);
                }
                // 释放数据集的内存
                data.close();
              }
              );
            })
          }
          .height(51)
          .width('100%')
          .margin({ top: 4 })

          ListItem() {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
              Text($r('app.string.method_promise'))
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 12, right: 92 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))

              Image($r('app.media.ic_arrow'))
                .width(24)
                .height(24)
                .margin({ top: 16, right: 6 })
            }
            .onClick(() => {
              // promise方式调用(await需要在async方法中使用):
              this.predicates.equalTo('name', 'Rose');
              this.DAHelper.query(this.uri, this.columnArray, this.predicates).then((dataquery) => {
                promptAction.showToast({
                  message: $r('app.string.query_success_toast')
                });
                // ResultSet是一个数据集合的游标，默认指向第-1个记录，有效的数据从0开始。
                while (dataquery.goToNextRow()) {
                  const id = dataquery.getLong(dataquery.getColumnIndex('id'));
                  const name = dataquery.getString(dataquery.getColumnIndex('name'));
                  const introduction = dataquery.getString(dataquery.getColumnIndex('introduction'));
                  hilog.info(domain, TAG, `DAHelper query result:id = [${id}], name = [${name}], introduction = [${introduction}]`);
                }
                // 释放数据集的内存
                dataquery.close();
              }).catch((error: BusinessError) => {
                promptAction.showToast({
                  message: $r('app.string.query_failed_toast')
                });
                hilog.error(domain, TAG, `DAHelper query failed. Cause: ${error.message}`);
              });
            })
          }
          .height(52)
          .width('100%')
          .margin({ bottom: 4 })
        }
        .borderRadius(24)
        .divider({ strokeWidth: 0.5, color: ($r('app.color.backGrounding')), startMargin: 12, endMargin: 12 })
        .height(104)
        .backgroundColor($r('app.color.start_window_background'))
        .margin({ right: 12, left: 12 })

        ListItem() {
          Text($r('app.string.batchInsert_data'))
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Medium)
            .margin({ top: 19.5, bottom: 9.5 })
            .fontSize(14)
            .width(176)
            .height(22)
            .fontColor($r('app.color.text_color'))
            .opacity(0.6)
        }
        .height(48)
        .width(176)
        .margin({ top: 8, left: 24 })

        ListItemGroup() {
          ListItem() {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
              Text($r('app.string.method_callback'))
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 12.5, left: 12, right: 92 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))

              Image($r('app.media.ic_arrow'))
                .width(24)
                .height(24)
                .margin({ top: 16, right: 6 })
            }
            .onClick(() => {
              // callback方式调用:
              this.DAHelper.batchInsert(this.uri, this.crowd, (error, data) => {
                if (error && error.code !== 0) {
                  promptAction.showToast({
                    message: $r('app.string.batchInsert_failed_toast')
                  });
                } else {
                  promptAction.showToast({
                    message: $r('app.string.batchInsert_success_toast')
                  });
                }
                hilog.info(domain, TAG, 'DAHelper batchInsert result: ' + data + ', error: ' + JSON.stringify(error));
              }
              );
            })
          }
          .height(51)
          .width('100%')
          .margin({ top: 4 })

          ListItem() {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
              Text($r('app.string.method_promise'))
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 12, right: 92 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))

              Image($r('app.media.ic_arrow'))
                .width(24)
                .height(24)
                .margin({ top: 16, right: 6 })
            }
            .onClick(() => {
              // promise方式调用(await需要在async方法中使用):
              this.DAHelper.batchInsert(this.uri, this.crowd).then((databatchInsert) => {
                promptAction.showToast({
                  message: $r('app.string.batchInsert_success_toast')
                });
                hilog.info(domain, TAG, 'DAHelper batchInsert result: ' + databatchInsert);
              }).catch((error: BusinessError) => {
                promptAction.showToast({
                  message: $r('app.string.batchInsert_failed_toast')
                });
                hilog.error(domain, TAG, `DAHelper batchInsert failed. Cause: ${error.message}`);
              });
            })
          }
          .height(52)
          .width('100%')
          .margin({ bottom: 4 })
        }
        .borderRadius(24)
        .divider({ strokeWidth: 0.5, color: ($r('app.color.backGrounding')), startMargin: 12, endMargin: 12 })
        .height(104)
        .backgroundColor($r('app.color.start_window_background'))
        .margin({ right: 12, left: 12 })

        ListItem() {
          Text($r('app.string.executeBatch_data'))
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Medium)
            .margin({ top: 19.5, bottom: 9.5 })
            .fontSize(14)
            .width(176)
            .height(22)
            .fontColor($r('app.color.text_color'))
            .opacity(0.6)
        }
        .height(48)
        .width(176)
        .margin({ top: 8, left: 24 })

        ListItemGroup() {
          ListItem() {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
              Text($r('app.string.method_callback'))
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 12.5, left: 12, right: 92 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))

              Image($r('app.media.ic_arrow'))
                .width(24)
                .height(24)
                .margin({ top: 16, right: 6 })
            }
            .onClick(() => {
              // callback方式调用:
              let operations: Array<ability.DataAbilityOperation> = [{
                uri: this.uri,
                type: featureAbility.DataAbilityOperationType.TYPE_INSERT,
                valuesBucket: { name: 'Rose', introduction: 'executeBatch' },
                predicates: this.predicates,
                expectedCount: 0,
                predicatesBackReferences: undefined,
                interrupted: true,
              }];
              this.DAHelper.executeBatch(this.uri, operations, (error, data) => {
                if (error && error.code !== 0) {
                  promptAction.showToast({
                    message: $r('app.string.executeBatch_failed_toast')
                  });
                } else {
                  promptAction.showToast({
                    message: $r('app.string.executeBatch_success_toast')
                  });
                }
                hilog.info(domain, TAG, `DAHelper executeBatch, result: ` + JSON.stringify(data) + ', error: ' + JSON.stringify(error));
              });
            })
          }
          .height(51)
          .width('100%')
          .margin({ top: 4 })

          ListItem() {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
              Text($r('app.string.method_promise'))
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 12, right: 92 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))

              Image($r('app.media.ic_arrow'))
                .width(24)
                .height(24)
                .margin({ top: 16, right: 6 })
            }
            .onClick(() => {
              // promise方式调用(await需要在async方法中使用):
              let operations: Array<ability.DataAbilityOperation> = [{
                uri: this.uri,
                type: featureAbility.DataAbilityOperationType.TYPE_INSERT,
                valuesBucket: { name: 'Rose', introduction: 'executeBatch' },
                predicates: this.predicates,
                expectedCount: 0,
                predicatesBackReferences: undefined,
                interrupted: true,
              }];
              this.DAHelper.executeBatch(this.uri, operations).then((dataquery) => {
                promptAction.showToast({
                  message: $r('app.string.executeBatch_success_toast')
                });
                hilog.info(domain, TAG, 'DAHelper executeBatch result: ' + JSON.stringify(dataquery));
              }).catch((error: BusinessError) => {
                promptAction.showToast({
                  message: $r('app.string.executeBatch_failed_toast')
                });
                hilog.error(domain, TAG, `DAHelper executeBatch failed. Cause: ${error.message}`);
              });
            })
          }
          .height(52)
          .width('100%')
          .margin({ bottom: 4 })
        }
        .borderRadius(24)
        .divider({ strokeWidth: 0.5, color: ($r('app.color.backGrounding')), startMargin: 12, endMargin: 12 })
        .height(104)
        .backgroundColor($r('app.color.start_window_background'))
        .margin({ right: 12, left: 12 })
      }
      .height('92%')
      .backgroundColor($r('app.color.backGrounding'))
    }
    .width('100%')
    .margin({ top: 8 })
    .backgroundColor($r('app.color.backGrounding'))
  }
}