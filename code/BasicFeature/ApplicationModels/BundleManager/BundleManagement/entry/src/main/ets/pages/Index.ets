/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { BusinessError } from '@kit.BasicServicesKit';
import { bundleManager, overlay, defaultAppManager } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = 'testTag';
const DOMAIN_NUMBER: number = 0xFF00;

export interface GroupMsg {
  title: Resource | string,
  list: ButtonMsg[]
}

export interface ButtonMsg {
  text: Resource | string,
  callback?: () => void
}

@Entry
@Component
struct Index {
  @State buttons: GroupMsg[] = [
    {
      title: $r('app.string.GetBundleInfoCurrentApplication'),
      list: [
        {
          text: $r('app.string.GetBundleInfo'),
          callback: () => {
            let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT;
            try {
              bundleManager.getBundleInfoForSelf(bundleFlags).then((data) => {
                hilog.info(DOMAIN_NUMBER, TAG, 'getBundleInfoForSelf success. Data: %{public}s',
                  JSON.stringify(data));
                promptAction.showToast({
                  message: JSON.stringify(data), duration: 3000
                });
              }).catch((err: BusinessError) => {
                hilog.error(DOMAIN_NUMBER, TAG, 'getBundleInfoForSelf failed. Cause: %{public}s', err.message);
              });
            } catch (err) {
              let message = (err as BusinessError).message;
              hilog.error(DOMAIN_NUMBER, TAG, 'getBundleInfoForSelf failed: %{public}s', message);
            }
          }
        },
        {
          text: $r('app.string.GetBundleInfoSync'),
          callback: () => {
            let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_REQUESTED_PERMISSION;
            try {
              let data = bundleManager.getBundleInfoForSelfSync(bundleFlags);
              hilog.info(DOMAIN_NUMBER, TAG, 'getBundleInfoForSelfSync success: %{public}s', JSON.stringify(data));
              promptAction.showToast({
                message: JSON.stringify(data), duration: 3000
              });
            } catch (err) {
              let message = (err as BusinessError).message;
              hilog.error(DOMAIN_NUMBER, TAG, 'getBundleInfoForSelfSync failed: %{public}s', message);
            }
          }
        }
      ]
    },
    {
      title: $r('app.string.GetConfiguration'),
      list: [
        {
          text: $r('app.string.GetConfigurationJson'),
          callback: () => {
            let moduleName = 'entry';
            let abilityName = 'EntryAbility';
            let metadataName = 'ohos.ability.shortcuts';
            try {
              bundleManager.getProfileByAbility(moduleName, abilityName, metadataName, (err, data) => {
                if (err) {
                  hilog.error(DOMAIN_NUMBER, TAG, 'getProfileByAbility failed. Cause: %{public}s', err.message);
                } else {
                  hilog.info(DOMAIN_NUMBER, TAG, 'getProfileByAbility success: %{public}s', JSON.stringify(data));
                  promptAction.showToast({
                    message: JSON.stringify(data), duration: 3000
                  });
                }
              });
            } catch (err) {
              let message = (err as BusinessError).message;
              hilog.error(DOMAIN_NUMBER, TAG, 'getProfileByAbility failed. Cause: %{public}s', message);
            }
          }
        },
        {
          text: $r('app.string.GetConfigurationArray'),
          callback: () => {
            let moduleName = 'entry';
            let extensionAbilityName = 'NewUIExtAbility';
            let metadataName = 'ohos.ability.NewUIExtAbility';
            try {
              bundleManager.getProfileByExtensionAbility(moduleName, extensionAbilityName, metadataName,
                (err, data) => {
                  if (err) {
                    hilog.error(DOMAIN_NUMBER, TAG, 'getProfileByExtensionAbility failed: %{public}s', err.message);
                  } else {
                    hilog.info(DOMAIN_NUMBER, TAG, 'getProfileByExtensionAbility success: %{public}s',
                      JSON.stringify(data));
                    promptAction.showToast({
                      message: JSON.stringify(data), duration: 3000
                    });
                  }
                });
            } catch (err) {
              let message = (err as BusinessError).message;
              hilog.error(DOMAIN_NUMBER, TAG, 'getProfileByExtensionAbility failed: %{public}s', message);
            }
          }
        },
        {
          text: $r('app.string.GetConfigurationJsonSync'),
          callback: () => {
            let moduleName = 'entry';
            let extensionAbilityName = 'NewUIExtAbility';
            let metadataName = 'ohos.ability.NewUIExtAbility';
            try {
              let data = bundleManager.getProfileByExtensionAbilitySync(moduleName, extensionAbilityName);
              hilog.info(DOMAIN_NUMBER, TAG, 'getProfileByExtensionAbilitySync successfully. Data: %{public}s',
                JSON.stringify(data));
              promptAction.showToast({
                message: JSON.stringify(data), duration: 3000
              });
            } catch (err) {
              let message = (err as BusinessError).message;
              hilog.error(DOMAIN_NUMBER, TAG, 'getProfileByExtensionAbilitySync failed. Cause: %{public}s', message);
            }

            try {
              let data = bundleManager.getProfileByExtensionAbilitySync(moduleName, extensionAbilityName, metadataName);
              hilog.info(DOMAIN_NUMBER, TAG, 'getProfileByExtensionAbilitySync successfully. Data: %{public}s',
                JSON.stringify(data));
            } catch (err) {
              let message = (err as BusinessError).message;
              hilog.error(DOMAIN_NUMBER, TAG, 'getProfileByExtensionAbilitySync failed. Cause: %{public}s', message);
            }
          }
        },
      ]
    },
    {
      title: $r('app.string.VerifyFile'),
      list: [
        {
          text: $r('app.string.VerifyFile'),
          callback: () => {
            let abcPaths: Array<string> = ['/data/storage/el1/bundle/modules.abc'];
            try {
              bundleManager.verifyAbc(abcPaths, true).then((data) => {
                hilog.info(DOMAIN_NUMBER, TAG, 'verifyAbc successfully' + JSON.stringify(data));
                promptAction.showToast({
                  message: 'success', duration: 3000
                });
              }).catch((err: BusinessError) => {
                hilog.error(DOMAIN_NUMBER, TAG, 'verifyAbc err: %{public}s', err.message);
              })
            } catch (err) {
              let message = (err as BusinessError).message;
              hilog.error(DOMAIN_NUMBER, TAG, 'verifyAbc failed: %{public}s', message);
            }
          }
        },
        {
          text: $r('app.string.DeleteFile'),
          callback: () => {
            let abcPath: string = '/data/storage/el1/bundle/modules.abc';
            try {
              bundleManager.deleteAbc(abcPath).then(() => {
                hilog.info(DOMAIN_NUMBER, TAG, 'deleteAbc successfully');
                promptAction.showToast({
                  message: 'success', duration: 3000
                });
              }).catch((err: BusinessError) => {
                hilog.error(DOMAIN_NUMBER, TAG, 'deleteAbc failed. err: %{public}s', err.message);
              });
            } catch (err) {
              let message = (err as BusinessError).message;
              hilog.error(DOMAIN_NUMBER, TAG, 'deleteAbc failed. Cause: %{public}s', message);
            }
          }
        },
      ]
    },
    {
      title: $r('app.string.VerifyLink'),
      list: [
        {
          text: $r('app.string.VerifyLinkOpened'),
          callback: () => {
            try {
              let link = 'http://';
              let data = bundleManager.canOpenLink(link);
              hilog.info(DOMAIN_NUMBER, TAG, 'canOpenLink successfully: %{public}s', JSON.stringify(data));
              promptAction.showToast({
                message: JSON.stringify(data), duration: 3000
              });
            } catch (err) {
              let message = (err as BusinessError).message;
              hilog.error(DOMAIN_NUMBER, TAG, 'canOpenLink failed: %{public}s', message);
            }
          }
        },
      ]
    },
    {
      title: $r('app.string.DetermineDefaultApplications'),
      list: [
        {
          text: $r('app.string.DetermineDefaultApplication'),
          callback: () => {
            defaultAppManager.isDefaultApplication(defaultAppManager.ApplicationType.BROWSER)
              .then((data) => {
                hilog.info(DOMAIN_NUMBER, TAG, 'Operation successful. IsDefaultApplication ? ' + JSON.stringify(data));
                promptAction.showToast({
                  message: JSON.stringify(data), duration: 3000
                });
              }).catch((error: BusinessError) => {
              hilog.error(DOMAIN_NUMBER, TAG, 'Operation failed. Cause: ' + JSON.stringify(error));
            });
          }
        },
        {
          text: $r('app.string.DetermineDefaultApplicationSync'),
          callback: () => {
            try {
              let data = defaultAppManager.isDefaultApplicationSync(defaultAppManager.ApplicationType.AUDIO)
              hilog.info(DOMAIN_NUMBER, TAG, 'Operation successful. IsDefaultApplicationSync ? ' +
              JSON.stringify(data));
              promptAction.showToast({
                message: JSON.stringify(data), duration: 3000
              });
            } catch (error) {
              hilog.error(DOMAIN_NUMBER, TAG, 'Operation failed. Cause: ' + JSON.stringify(error));
            }
            ;
          }
        },
      ]
    },
    {
      title: $r('app.string.SetOverlayStatus'),
      list: [
        {
          text: $r('app.string.SetDisableEnableStatus'),
          callback: () => {
            let moduleName = 'libraryOverlay';
            let isEnabled = true;
            try {
              overlay.setOverlayEnabled(moduleName, isEnabled)
                .then(() => {
                  hilog.info(DOMAIN_NUMBER, TAG, 'setOverlayEnabled success');
                  promptAction.showToast({
                    message: 'setOverlayEnabled success'
                  });
                }).catch((err: BusinessError) => {
                hilog.error(DOMAIN_NUMBER, TAG, 'setOverlayEnabled failed due to err code: ' + err.code + ' ' +
                  'message:' + err.message);
              });
            } catch (err) {
              let code = (err as BusinessError).code;
              let message = (err as BusinessError).message;
              hilog.error(DOMAIN_NUMBER, TAG, 'setOverlayEnabled failed due to err code: ' + code + ' ' +
                'message:' + message);
            }
          },
        }
      ]
    },
    {
      title: $r('app.string.ObtainOverlayModuleInfo'),
      list: [
        {
          text: $r('app.string.ObtainOverlayModuleInfoInformation'),
          callback: () => {
            let moduleName = 'libraryRuntimeOverlay';
            (async () => {
              try {
                let overlayModuleInfo = await overlay.getOverlayModuleInfo(moduleName);
                hilog.info(DOMAIN_NUMBER, TAG, 'overlayModuleInfo is ' + JSON.stringify(overlayModuleInfo));
                promptAction.showToast({
                  message: JSON.stringify(overlayModuleInfo), duration: 3000
                });
              } catch (err) {
                let code = (err as BusinessError).code;
                let message = (err as BusinessError).message;
                hilog.error(DOMAIN_NUMBER, TAG, 'getOverlayModuleInfo err code : ' + code + ' ' + 'message :' +
                  message);
              }
            })();
          },
        },
        {
          text: $r('app.string.ObtainMultipleOverlayModuleInfoInformation'),
          callback: () => {
            let targetModuleName = 'entry';
            (async () => {
              try {
                let overlayModuleInfos = await overlay.getTargetOverlayModuleInfos(targetModuleName);
                hilog.info(DOMAIN_NUMBER, TAG, 'overlayModuleInfos are ' + JSON.stringify(overlayModuleInfos));
                promptAction.showToast({
                  message: JSON.stringify(overlayModuleInfos), duration: 3000
                });
              } catch (err) {
                let code = (err as BusinessError).code;
                let message = (err as BusinessError).message;
                hilog.error(DOMAIN_NUMBER, TAG, 'getTargetOverlayModuleInfos err code : ' + code + ' ' + 'message :' +
                  message);
              }
            })();
          },
        }
      ]
    }
  ]

  build() {
    Column() {
      Row() {
        Text($r('app.string.interface'))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
      }.height(56)
      .padding({ left: 26, right: 26 })
      .width('100%')

      Column() {
        List({ space: 0, initialIndex: 0 }) {
          ForEach(this.buttons, (groupItem: GroupMsg, groupIndex: Number) => {
            ListItem() {
              Text(groupItem.title) {
              }
              .borderRadius(0)
              .backgroundColor($r('app.color.backGrounding'))
              .padding({ left: 12, right: 12, top: 8 })
              .width('100%')
              .height(25)
            }

            ListItemGroup() {
              ForEach(groupItem.list, (item: ButtonMsg, index: Number) => {
                ListItem() {
                  Flex({ direction: FlexDirection.Column }) {
                    Row() {
                      Flex({ justifyContent: FlexAlign.SpaceBetween, alignContent: FlexAlign.Center }) {
                        Text(item.text) {
                        }.fontSize(18)
                        .textAlign(TextAlign.Start)
                        .fontWeight(700)
                      }
                    }
                    .width('100%')
                    .height('99%')
                    .id('key' + index)

                    if (groupItem.list.length == 3) {
                      if (index < 2) {
                        Row() {
                        }
                        .width('100%')
                        .height('1%')
                        .backgroundColor($r('app.color.backGrounding'))
                      }
                    }
                    if (groupItem.list.length == 2) {
                      if (index < 1) {
                        Row() {
                        }
                        .width('100%')
                        .height('1%')
                        .backgroundColor($r('app.color.backGrounding'))
                      }
                    }
                  }
                }
                .height(48)
                .onClick(item.callback)
              })
            }
            .width('100%')
            .borderRadius(24)
            .backgroundColor($r('sys.color.ohos_id_color_foreground_contrary'))
            .padding({ left: 12, right: 12, top: 4, bottom: 4 })
            .margin({ top: 10, bottom: 10 })
          })
        }
        .listDirection(Axis.Vertical) // 排列方向
        .scrollBar(BarState.Off)
        .friction(0.6)
        .edgeEffect(EdgeEffect.Spring) // 边缘效果设置为Spring
        .onScrollIndex((firstIndex: number, lastIndex: number, centerIndex: number) => {
          hilog.info(DOMAIN_NUMBER, TAG, 'first' + firstIndex);
          hilog.info(DOMAIN_NUMBER, TAG, 'last' + lastIndex);
          hilog.info(DOMAIN_NUMBER, TAG, 'center' + centerIndex);
        })
        .onScrollIndex((scrollOffset: number, scrollState: ScrollState) => {
          hilog.info(DOMAIN_NUMBER, TAG, `onScroll scrollState = ScrollState` + scrollState + `, scrollOffset = ` +
            scrollOffset);
        })
        .padding({ left: 12, right: 12 })
      }
      .width('100%')
      .height(700)
      .backgroundColor($r('app.color.backGrounding'))
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.backGrounding'))
  }
}