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

import { LoginEvent, UserDataEvent, UserLibraryDao } from '@ohos/common';
import { LengthMetrics, router } from '@kit.ArkUI';
import { LoginUtil } from '../model/utils/LoginUtil';
import { common } from '@kit.AbilityKit';
import { fileUri } from '@kit.CoreFileKit';
import { HMRouterMgr } from '@hadss/hmrouter';

// 我的页面登录入口
@Component
export struct MineItem {
  @StorageProp(LoginEvent.LOGIN_STORAGE) @Watch('isLoginChange') isLogin: boolean = false;
  @StorageProp(UserDataEvent.USER_DATA_IS_CHANGE) @Watch('isUserDataChange') isUserData: boolean = false;
  @State userName: string = UserLibraryDao.getUserName();
  @State nameFirstCharacter: string = LoginUtil.getFirstValidCharacter(this.userName);
  @State context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  @State userAvatarDao: string = UserLibraryDao.getUserAvatar();
  @State userAvatarPath: string = this.context.filesDir + this.userAvatarDao;
  @State userAvatar: ResourceStr = fileUri.getUriFromPath(this.userAvatarPath);
  @State fontColor: ResourceStr = $r('app.color.default_text_color');
  @State fontSize: ResourceStr = $r('app.string.font_20');
  @State isFontWeight: boolean = false;

  isUserDataChange() {
    if (this.isLogin) {
      this.userName = UserLibraryDao.getUserName();
      this.userAvatarDao = UserLibraryDao.getUserAvatar();
      this.userAvatarPath = this.context.filesDir + this.userAvatarDao;
      this.userAvatar = fileUri.getUriFromPath(this.userAvatarPath);
      if (this.userAvatarDao == '') {
        this.nameFirstCharacter = LoginUtil.getFirstValidCharacter(this.userName);
      }
    }
  }

  isLoginChange() {
    if (this.isLogin) {
      this.userName = UserLibraryDao.getUserName();
      this.userAvatarDao = UserLibraryDao.getUserAvatar();
      this.userAvatarPath = this.context.filesDir + this.userAvatarDao;
      this.userAvatar = fileUri.getUriFromPath(this.userAvatarPath);
      this.nameFirstCharacter = LoginUtil.getFirstValidCharacter(this.userName);
    }
  }

  build() {
    Column() {
      ColumnSplit() {
        Row() {
          if (!this.isLogin) {
            Column() {
              Image($r('app.media.ic_default_avatar'))
                .height($r('app.string.Head_shot_height'))
                .width($r('app.string.Head_shot_width'));
            }
            .clip(true)
            .borderRadius('100%');
          } else {
            if (this.userAvatarDao == '') {
              Column() {
                Text(this.nameFirstCharacter)
                  .fontSize($r('app.string.Head_shot_fontSize'));
              }
              .justifyContent(FlexAlign.Center)
              .backgroundColor(0xe4e7e9)
              .borderRadius('100%')
              .height($r('app.string.Head_shot_height'))
              .width($r('app.string.Head_shot_width'));
            } else {
              Column() {
                Image(this.userAvatar)
                  .objectFit(ImageFit.Auto);
              }
              .justifyContent(FlexAlign.Center)
              .backgroundColor(0xe4e7e9)
              .clip(true)
              .borderRadius('100%')
              .height($r('app.string.Head_shot_height'))
              .width($r('app.string.Head_shot_width'));
            }
          }
          Text(this.isLogin ? this.userName : $r('app.string.click_to_login'))
            .margin({ left: $r('app.string.MineItem_text_margin_left') })
            .fontColor(this.fontColor)
            .fontWeight(this.isFontWeight ? FontWeight.Bold : FontWeight.Medium)
            .fontSize(this.fontSize)
            .focusable(true)
            .focusBox({
              strokeWidth: LengthMetrics.px(0)
            })
            .onFocus(() => {
              this.fontColor = $r('app.color.text_color_white');
              this.fontSize = $r('app.string.font_22');
              this.isFontWeight = true;
            })
            .onBlur(() => {
              this.fontColor = $r('app.color.default_text_color');
              this.fontSize = $r('app.string.font_20');
              this.isFontWeight = false;
            });

          Blank();
          Image($r('app.media.ic_public_arrow_right'))
            .height($r('app.string.font_16'))
            .margin({ right: $r('app.string.Head_shot_arrow_right_margin_right') });
        }.margin({
          top: $r('app.string.Head_shot_margin_top'),
          bottom: $r('app.string.Head_shot_margin_bottom')
        }).width('100%').onClick(() => {
          if (this.isLogin) {

          } else {
            HMRouterMgr.push({
              pageUrl: 'AccountLoginPagePage'
            });
          }
        });
      }
      .margin({
        left: $r('app.string.Head_shot_margin_right'),
        right: $r('app.string.Head_shot_margin_right'),
        top: $r('app.string.Head_shot_ColumnSplit_margin_top'),
        bottom: $r('app.string.Head_shot_ColumnSplit_margin_bottom')
      });
    }
    .backgroundColor(Color.Transparent)
    .borderRadius($r('app.string.List_items_borderRadius'))
    .margin({
      left: $r('app.string.Head_shot_Column_margin_left'),
      right: $r('app.string.Head_shot_Column_margin_right'),
      top: $r('app.string.Head_shot_Column_margin_top'),
      bottom: $r('app.string.Head_shot_Column_margin_bottom')
    });

  }
}


// 我的详情页面头像
@Component
export struct MineAvatarItem {
  @State nameFirstCharacter: string = LoginUtil.getFirstValidCharacter(UserLibraryDao.getUserName());
  @StorageProp(UserDataEvent.USER_DATA_IS_CHANGE) @Watch('isUserDataChange') isUserData: boolean = false;
  @State context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  @State userAvatarDao: string = UserLibraryDao.getUserAvatar();
  @State userAvatarPath: string = this.context.filesDir + this.userAvatarDao;
  @State userAvatar: ResourceStr = fileUri.getUriFromPath(this.userAvatarPath);

  isUserDataChange() {
    this.userAvatarDao = UserLibraryDao.getUserAvatar();
    this.userAvatarPath = this.context.filesDir + this.userAvatarDao;
    this.userAvatar = fileUri.getUriFromPath(this.userAvatarPath);
    if (this.userAvatarDao == '') {
      this.nameFirstCharacter = LoginUtil.getFirstValidCharacter(UserLibraryDao.getUserName());
    }
  }

  build() {
    Column() {
      ColumnSplit() {
        Row() {
          if (this.userAvatarDao == '') {
            Column() {
              Text(this.nameFirstCharacter)
                .fontSize($r('app.string.Head_shot_fontSize'));
            }
            .justifyContent(FlexAlign.Center)
            .backgroundColor(0xe4e7e9)
            .borderRadius('100%')
            .height($r('app.string.Head_shot_height'))
            .width($r('app.string.Head_shot_width'));
          } else {
            Column() {
              Image(this.userAvatar)
                .objectFit(ImageFit.Auto);
            }
            .justifyContent(FlexAlign.Center)
            .backgroundColor(0xe4e7e9)
            .clip(true)
            .borderRadius('100%')
            .height($r('app.string.Head_shot_height'))
            .width($r('app.string.Head_shot_width'));
          }
          Blank();
          Button($r('app.string.modify_profile_picture'))
            .margin({ right: $r('app.string.Head_shot_Modify_Button_margin_right') })
            .fontColor(Color.Blue)
            .backgroundColor(0xe4e7e9)
            .onClick(() => {
              LoginUtil.avatarModification();
            });
        }.margin({
          top: $r('app.string.Head_shot_margin_top'),
          bottom: $r('app.string.Head_shot_margin_bottom'),
          left: $r('app.string.Head_shot_margin_left'),
          right: $r('app.string.Head_shot_margin_right')
        })
        .width('100%');
      }
      .margin({
        left: $r('app.string.Head_shot_ColumnSplit_margin_left'),
        right: $r('app.string.Head_shot_ColumnSplit_margin_right'),
        top: $r('app.string.Head_shot_ColumnSplit_margin_top'),
        bottom: $r('app.string.Head_shot_ColumnSplit_margin_bottom')
      });
    }
    .backgroundColor(Color.White)
    .borderRadius($r('app.string.List_items_borderRadius'))
    .margin({
      left: $r('app.string.Head_shot_Column_margin_left'),
      right: $r('app.string.Head_shot_Column_margin_right'),
      top: $r('app.string.Head_shot_Column_margin_top'),
      bottom: $r('app.string.Head_shot_Column_margin_bottom')
    });
  }
}

// 带文件图标和信息加修改
@Component
export struct MineMessageItem {
  name: Resource | string = '';
  @Link message: Resource | string;
  @State @Watch('messageChange') changeMessage: Resource | string = '';
  dialogControllerFileDetails: CustomDialogController = new CustomDialogController({
    builder: ConfirmationPopup({
      message: this.changeMessage,
      name: this.name,
      confirm: (() => {
      })
    }),
  });

  messageChange() {
    this.message = this.changeMessage;
  }

  build() {
    Row() {
      Text(this.name);
      Blank();
      Text(this.message).fontSize($r('app.string.MineMessageItem_message_fontSize')).fontColor(0x808080);
      Image($r('app.media.ic_public_arrow_right'))
        .height($r('app.string.font_16'))
        .margin({ right: $r('app.string.MineMessageItem_arrow_right_margin_right') });
    }.margin($r('app.string.MineMessageItem_margin')).width('100%').onClick(() => {
      this.dialogControllerFileDetails.open();
    });
  }
}

@CustomDialog
struct ConfirmationPopup {
  name: Resource | string = '';
  @Link message: Resource | string;
  @State inputMessage: string = '';
  controller?: CustomDialogController;
  cancel: () => void = () => {
  };
  confirm: () => void = () => {
  };

  build() {
    Column() {
      Text($r('app.string.are_you_want_to_change_the', this.name)) {
      }
      .fontSize($r('app.string.MineMessageItem_Popup_fontSize'))
      .margin({
        top: $r('app.string.MineMessageItem_Popup_text_margin_top'),
        bottom: $r('app.string.MineMessageItem_Popup_text_margin_bottom')
      });

      Column() {
        TextInput({ placeholder: '', text: this.inputMessage })
          .height($r('app.string.MineMessageItem_Popup_TextInput_height'))
          .width('90%')
          .onChange((value: string) => {
            this.inputMessage = value;
          });
      };

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button($r('app.string.cancel'))
          .onClick(() => {
            this.cancel;
            this.controller?.close();
          }).backgroundColor(0xffffff).fontColor(Color.Black);
        Button($r('app.string.ok'))
          .onClick(() => {
            this.message = this.inputMessage;
            this.controller?.close();
          }).backgroundColor(0xffffff).fontColor(Color.Red);
      }.margin({ bottom: $r('app.string.MineMessageItem_Popup_Confirmation_margin_bottom') });
    };
  }
}