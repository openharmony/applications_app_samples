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

import missionManager from '@ohos.app.ability.missionManager';
import { BusinessError } from '@ohos.base';
import image from '@ohos.multimedia.image';
import promptAction from '@ohos.promptAction';
import hilog from '@ohos.hilog';

const DOMAIN_NUMBER: number = 0xFF00;
const TAG: string = 'TaskManager';

@Entry
@Component
struct PageTaskManager {
  private listenerId: number = 0;
  private missionId: number = 0;
  private listener: missionManager.MissionListener = {
    // 任务创建
    onMissionCreated: (mission: number) => {
      hilog.info(DOMAIN_NUMBER, TAG, '--------onMissionCreated-------');
    },
    // 任务销毁
    onMissionDestroyed: (mission: number) => {
      hilog.info(DOMAIN_NUMBER, TAG, '--------onMissionDestroyed-------');
    },
    // 任务快照变化
    onMissionSnapshotChanged: (mission: number) => {
      hilog.info(DOMAIN_NUMBER, TAG, '--------onMissionSnapshotChanged-------');
    },
    // 任务被移动到前台
    onMissionMovedToFront: (mission: number) => {
      hilog.info(DOMAIN_NUMBER, TAG, '--------onMissionMovedToFront-------');
    },
    // 任务图标变化
    onMissionIconUpdated: (mission: number, icon: image.PixelMap) => {
      hilog.info(DOMAIN_NUMBER, TAG, '--------onMissionIconUpdated-------');
    },
    // 任务名称变化
    onMissionLabelUpdated: (mission: number) => {
      hilog.info(DOMAIN_NUMBER, TAG, '--------onMissionLabelUpdated-------');
    },
    // 任务实例被关闭
    onMissionClosed: (mission: number) => {
      hilog.info(DOMAIN_NUMBER, TAG, '--------onMissionClosed-------');
    }
  };

  build() {
    Column() {
      Row() {
        Flex({ justifyContent: FlexAlign.Start, alignContent: FlexAlign.Center }) {
          Text($r('app.string.taskmanager_button'))
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
            .margin({ top: 12 , bottom: 11 , right: 24 , left: 24})
        }
      }
      .width('100%')
      .height(56)
      .justifyContent(FlexAlign.Start)
      .backgroundColor($r('app.color.backGrounding'))


      List({ initialIndex: 0 }) {
        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.register_button'))
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 84 })

          }
          .onClick(() => {
            // 1.注册任务变化通知
            this.listenerId = missionManager.on('mission', this.listener);
            promptAction.showToast({
              message: $r('app.string.register_success_toast')
            });
            hilog.info(DOMAIN_NUMBER, TAG, `missionManager.on success, listenerId = ${this.listenerId}`);
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 8, right: 12, left: 12 })


        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.obtain_button'))
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 84 })
          }
          .onClick(() => {
            // 2.获取系统最近20个任务
            missionManager.getMissionInfos('', 20, (error: BusinessError, missions: Array<missionManager.MissionInfo>) => {
              hilog.info(DOMAIN_NUMBER, TAG, 'getMissionInfos is called, error = ' + JSON.stringify(error));
              hilog.info(DOMAIN_NUMBER, TAG, 'size = ' + missions.length);
              hilog.info(DOMAIN_NUMBER, TAG, 'missions = ' + JSON.stringify(missions));

              // 判断系统最近任务中是否包含etsclock
              for (let i = 0;i < missions.length; i++) {
                if (missions[i].want.bundleName === 'ohos.samples.etsclock') {
                  promptAction.showToast({
                    message: $r('app.string.obtain_success_toast')
                  });
                  hilog.info(DOMAIN_NUMBER, TAG, `getMissionInfos.find etsclock, missionId  = ${missions[i].missionId}`);
                  this.missionId = missions[i].missionId;
                  return;
                }
              }
              promptAction.showToast({
                message: $r('app.string.obtain_failed_toast')
              });
            });
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.obtain_one_button'))
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 84 })
          }
          .onClick(() => {
            // 3.获取单个任务的详细信息()
            missionManager.getMissionInfo('', this.missionId).then((data: missionManager.MissionInfo) => {
              promptAction.showToast({
                message: JSON.stringify(data.want.bundleName)
              });
              hilog.info(DOMAIN_NUMBER, TAG, `getMissionInfo successfully. Data: ${JSON.stringify(data)}`);
            }).catch((error: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, `getMissionInfo failed. Cause: ${error.message}`);
            });
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.obtain_snapshot_button'))
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 84 })

          }
          .onClick(() => {
            // 4.获取任务快照
            missionManager.getMissionSnapShot('', this.missionId, (error: BusinessError, snapshot: missionManager.MissionSnapshot) => {
              if (error === null) {
                promptAction.showToast({
                  message: $r('app.string.obtain_snapshot_success_toast')
                });
              }
              hilog.info(DOMAIN_NUMBER, TAG, 'getMissionSnapShot is called, error = ' + JSON.stringify(error));
              hilog.info(DOMAIN_NUMBER, TAG, 'bundleName = ' + snapshot.ability.bundleName);
            })
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })


        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.obtain_low_snapshot_button'))
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 84 })
          }
          .onClick(() => {
            // 5.获取低分辨任务快照
            missionManager.getLowResolutionMissionSnapShot('', this.missionId, (error: BusinessError, snapshot: missionManager.MissionSnapshot) => {
              if (error === null) {
                promptAction.showToast({
                  message: $r('app.string.obtain_low_snapshot_success_toast')
                });
              }
              hilog.info(DOMAIN_NUMBER, TAG, 'getLowResolutionMissionSnapShot is called, error = ' + JSON.stringify(error));
              hilog.info(DOMAIN_NUMBER, TAG, 'bundleName = ' + snapshot.ability.bundleName);
            })
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.lock_button'))
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 84 })
          }
          .onClick(() => {
            // 6-1 加锁任务
            missionManager.lockMission(this.missionId).then(() => {
              promptAction.showToast({
                message: $r('app.string.lock_success_toast')
              });
              hilog.info(DOMAIN_NUMBER, TAG, 'lockMission is called ');
            });
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.unlock_button'))
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 84 })

          }
          .onClick(() => {
            // 6-2 解锁任务
            missionManager.unlockMission(this.missionId).then(() => {
              promptAction.showToast({
                message: $r('app.string.unlock_success_toast')
              });
              hilog.info(DOMAIN_NUMBER, TAG, 'unlockMission is called ');
            });
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })


        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.front_button'))
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 84 })
          }
          .onClick(() => {
            // 7.把任务切到前台
            missionManager.moveMissionToFront(this.missionId).then(() => {
              hilog.info(DOMAIN_NUMBER, TAG, 'moveMissionToFront is called ');
            });
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.delete_button'))
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 84 })
          }
          .onClick(() => {
            // 8.删除单个任务
            missionManager.clearMission(this.missionId).then(() => {
              promptAction.showToast({
                message: $r('app.string.delete_success_toast')
              });
              hilog.info(DOMAIN_NUMBER, TAG, 'clearMission is called ');
            });
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.delete_all_button'))
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 84 })
          }
          .onClick(() => {
            // 9.删除全部任务
            missionManager.clearAllMissions().catch((err: BusinessError) => {
              hilog.info(DOMAIN_NUMBER, TAG, `${err.code}`);
            });
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

        ListItem() {
          Row() {
            Row(){
              Text($r('app.string.unregister_button'))
                .textAlign(TextAlign.Start)
                .fontWeight(FontWeight.Medium)
                .margin({ top: 13, bottom: 13, left: 0, right: 8 })
                .fontSize(16)
                .width(232)
                .height(22)
                .fontColor($r('app.color.text_color'))
            }
            .height(48)
            .width('100%')
            .borderRadius(24)
            .margin({ top: 4, bottom: 4, left: 12, right: 84 })
          }
          .onClick(() => {
            // 10.解注册任务变化通知
            missionManager.off('mission', this.listenerId, (error: BusinessError) => {
              if (error === null) {
                promptAction.showToast({
                  message: $r('app.string.unregister_success_toast')
                });
              }
              hilog.info(DOMAIN_NUMBER, TAG, 'unregisterMissionListener');
            })
          })
        }
        .height(56)
        .backgroundColor($r('app.color.start_window_background'))
        .borderRadius(24)
        .margin({ top: 12, right: 12, left: 12 })

      }
      .height('92%')
      .backgroundColor($r('app.color.backGrounding'))
    }
    .width('100%')
    .margin({ top: 8 })
    .backgroundColor($r('app.color.backGrounding'))
  }
}