/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { Contact, ParamObject } from '../model/Contact';
import { promptAction, TipsDialog } from '@kit.ArkUI';
import { taskPoolExecuteDelete } from './TaskPool';
import { common } from '@kit.AbilityKit';
import { CommonConstants } from '../constant/CommonConstant';

const context: common.Context = getContext(this).getApplicationContext();

interface AddressBookDetailParam {
  contact: Contact;
  deleteCallback: (contact: Contact) => void;
  editCallback: (contact: Contact) => void;
}

@Builder
export function AddressBookDetailBuilder(name: string, param: AddressBookDetailParam) {
  AddressBookDetail({contact: param.contact, deleteCallback: param.deleteCallback, editCallback: param.editCallback})
}

@Component
export struct AddressBookDetail {
  // 接收push转场携带的单条通讯录参数
  @Consume pageInfos: NavPathStack;
  private contact?: Contact;
  // 接收push转场携带的删除回调参数
  private deleteCallback?: (contact: Contact) => void;
  // 接收push转场携带的编辑回调参数
  private editCallback?: (contact: Contact) => void;
  @State isShow: boolean = false;
  @State isChange: boolean = false;
  @State sourceData: Contact = new Contact();

  aboutToAppear(): void {
    if (this.contact) {
      this.sourceData = this.contact;
    }
  }

  dialogController: CustomDialogController = new CustomDialogController({
    builder: TipsDialog({
      imageRes: $r('app.media.operate_rdb_in_taskpool_delete'),
      imageSize: { width: CommonConstants.CUSTOM_DIALOG_ICON_SIZE, height: CommonConstants.CUSTOM_DIALOG_ICON_SIZE },
      title: $r('app.string.operate_rdb_in_taskpool_delete_dialog_title', this.sourceData?.name),
      content: $r('app.string.operate_rdb_in_taskpool_delete_dialog_content'),
      primaryButton: {
        value: $r('app.string.operate_rdb_in_taskpool_dialog_delete_button_text'),
        role: ButtonRole.ERROR,
        action: () => {
          if (this.contact) {
            // 数据删除操作
            taskPoolExecuteDelete(context, this.contact).then(() => {
              if (this.sourceData) {
                // 数据库删除成功后 操作列表数据源
                this.pageInfos.pop();
                this.deleteCallback!(this.sourceData)
              }
            });
          }
        },
      },
      secondaryButton: {
        value: $r('app.string.operate_rdb_in_taskpool_dialog_cancel_button_text')
      }
    }),
  })

  @Builder
  navDestinationTitle(name: string | undefined) {
    Row() {
      Column() {
        Image($r('app.media.operate_rdb_in_taskpool_arrow_left'))
          .width($r('app.integer.operate_rdb_in_taskpool_arrow_left_width'))
          .height($r('app.integer.operate_rdb_in_taskpool_arrow_left_height'))
      }
      .justifyContent(FlexAlign.Center)
      .width($r('app.integer.operate_rdb_in_taskpool_arrow_left_background_width'))
      .height($r('app.integer.operate_rdb_in_taskpool_arrow_left_background_height'))
      .borderRadius(CommonConstants.BORDER_RADIUS_PROMINENT)
      .backgroundColor($r('app.color.operate_rdb_in_taskpool_navigation_button_background_color'))
      .onClick(() => {
        this.pageInfos.pop();
        if (this.isChange) {
          this.isChange = false;
          this.editCallback!(this.sourceData)
        }
      })

      Text(name)
        .fontWeight(FontWeight.Bold)
        .fontSize($r('app.integer.operate_rdb_in_taskpool_navigation_title_font_size'))
        .margin({ left: $r('app.integer.operate_rdb_in_taskpool_navigation_title_margin_left') })
        .width(AppStorage.get('isFoldable') ? CommonConstants.FOLD_NAVIGATION_TITLE_WIDTH :
        CommonConstants.UNFOLD_NAVIGATION_TITLE_WIDTH)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Button({ type: ButtonType.Normal, stateEffect: false }) {
        Image($r('app.media.operate_rdb_in_taskpool_more'))
          .width($r('app.integer.operate_rdb_in_taskpool_button_right_width'))
          .height($r('app.integer.operate_rdb_in_taskpool_button_right_height'))
      }
      .backgroundColor(Color.White)
      .height($r('app.integer.operate_rdb_in_taskpool_button_right_back_ground_height'))
      .onClick(() => {
        this.isShow = true;
      })
      .bindSheet($$this.isShow, this.operateBuilder(), {
        height: $r('app.integer.operate_rdb_in_taskpool_bind_sheet_height'),
        backgroundColor: Color.White,
        showClose: false
      })
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width(CommonConstants.FULL_PERCENT)
    .height($r('app.integer.operate_rdb_in_taskpool_navigation_height'))
    .backgroundColor(Color.White)
    .margin({ bottom: $r('app.integer.operate_rdb_in_taskpool_navigation_margin_bottom') })
  }

  @Builder
  phoneBuilder() {
    Row() {
      Column() {
        Text(this.sourceData.phone)
          .fontSize($r('app.integer.operate_rdb_in_taskpool_detail_content_font_size'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.operate_rdb_in_taskpool_detail_content_text_color'))
          .width(CommonConstants.HALF_PERCENT)
          .height($r('app.integer.operate_rdb_in_taskpool_detail_content_height'))

        Text($r('app.string.operate_rdb_in_taskpool_detail_phone'))
          .fontSize($r('app.integer.operate_rdb_in_taskpool_detail_title_font_size'))
          .fontColor($r('app.color.operate_rdb_in_taskpool_detail_title_text_color'))
          .width(CommonConstants.HALF_PERCENT)
          .height($r('app.integer.operate_rdb_in_taskpool_detail_title_height'))
      }

      Button({ type: ButtonType.Normal }) {
        Image($r('app.media.operate_rdb_in_taskpool_phone'))
          .width($r('app.integer.operate_rdb_in_taskpool_detail_icon_width'))
          .height($r('app.integer.operate_rdb_in_taskpool_detail_icon_height'))
      }
      .backgroundColor($r('app.color.operate_rdb_in_taskpool_button_background_color_green'))
      .width($r('app.integer.operate_rdb_in_taskpool_detail_icon_button_width'))
      .height($r('app.integer.operate_rdb_in_taskpool_detail_item_button_height'))
      .borderRadius(CommonConstants.BORDER_RADIUS_SOFT)
      .onClick(() => {
        promptAction.showToast({
          message: $r('app.string.operate_rdb_in_taskpool_prompt_text')
        });
      })

      Button({ type: ButtonType.Normal }) {
        Image($r('app.media.operate_rdb_in_taskpool_message'))
          .width($r('app.integer.operate_rdb_in_taskpool_detail_icon_width'))
          .height($r('app.integer.operate_rdb_in_taskpool_detail_icon_height'))
      }
      .backgroundColor($r('app.color.operate_rdb_in_taskpool_button_background_color_blue'))
      .width($r('app.integer.operate_rdb_in_taskpool_detail_icon_button_width'))
      .height($r('app.integer.operate_rdb_in_taskpool_detail_item_button_height'))
      .borderRadius(CommonConstants.BORDER_RADIUS_SOFT)
      .onClick(() => {
        promptAction.showToast({
          message: $r('app.string.operate_rdb_in_taskpool_prompt_text')
        });
      })
    }
    .height($r('app.integer.operate_rdb_in_taskpool_detail_item_height'))
    .width(CommonConstants.FULL_PERCENT)
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ top: $r('app.integer.operate_rdb_in_taskpool_phone_margin_top') })
  }

  @Builder
  videoBuilder() {
    Row() {
      Text($r('app.string.operate_rdb_in_taskpool_detail_video'))
        .fontSize($r('app.integer.operate_rdb_in_taskpool_detail_content_font_size'))
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.operate_rdb_in_taskpool_detail_content_text_color'))
        .width(CommonConstants.HALF_PERCENT)
        .height($r('app.integer.operate_rdb_in_taskpool_video_button_height'))

      Button({ type: ButtonType.Normal }) {
        Image($r('app.media.operate_rdb_in_taskpool_video'))
          .width($r('app.integer.operate_rdb_in_taskpool_detail_icon_width'))
          .height($r('app.integer.operate_rdb_in_taskpool_detail_icon_height'))
      }
      .backgroundColor($r('app.color.operate_rdb_in_taskpool_button_background_color_red'))
      .width($r('app.integer.operate_rdb_in_taskpool_detail_icon_button_width'))
      .height($r('app.integer.operate_rdb_in_taskpool_detail_item_button_height'))
      .borderRadius(CommonConstants.BORDER_RADIUS_SOFT)
      .onClick(() => {
        promptAction.showToast({
          message: $r('app.string.operate_rdb_in_taskpool_prompt_text')
        });
      })
    }
    .height($r('app.integer.operate_rdb_in_taskpool_detail_item_height'))
    .width(CommonConstants.FULL_PERCENT)
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ top: $r('app.integer.operate_rdb_in_taskpool_detail_item_margin_top') })
  }

  @Builder
  emailBuilder() {
    Column() {
      Text(this.sourceData.email)
        .fontSize($r('app.integer.operate_rdb_in_taskpool_detail_content_font_size'))
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.operate_rdb_in_taskpool_detail_content_text_color'))
        .width(CommonConstants.FULL_PERCENT)
        .height($r('app.integer.operate_rdb_in_taskpool_detail_content_height'))

      Text($r('app.string.operate_rdb_in_taskpool_detail_email'))
        .fontSize($r('app.integer.operate_rdb_in_taskpool_detail_title_font_size'))
        .fontColor($r('app.color.operate_rdb_in_taskpool_detail_title_text_color'))
        .width(CommonConstants.FULL_PERCENT)
        .height($r('app.integer.operate_rdb_in_taskpool_detail_title_height'))
    }
    .height($r('app.integer.operate_rdb_in_taskpool_detail_item_height'))
    .width(CommonConstants.FULL_PERCENT)
    .margin({ top: $r('app.integer.operate_rdb_in_taskpool_detail_item_margin_top') })
  }

  @Builder
  addressBuilder() {
    Column() {
      Text(this.sourceData.address)
        .fontSize($r('app.integer.operate_rdb_in_taskpool_detail_content_font_size'))
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.operate_rdb_in_taskpool_detail_content_text_color'))
        .width(CommonConstants.FULL_PERCENT)
        .height($r('app.integer.operate_rdb_in_taskpool_detail_content_height'))

      Text($r('app.string.operate_rdb_in_taskpool_detail_address'))
        .fontSize($r('app.integer.operate_rdb_in_taskpool_detail_title_font_size'))
        .fontColor($r('app.color.operate_rdb_in_taskpool_detail_title_text_color'))
        .width(CommonConstants.FULL_PERCENT)
        .height($r('app.integer.operate_rdb_in_taskpool_detail_title_height'))
    }
    .height($r('app.integer.operate_rdb_in_taskpool_detail_item_height'))
    .width(CommonConstants.FULL_PERCENT)
    .margin({ top: $r('app.integer.operate_rdb_in_taskpool_detail_item_margin_top') })
  }

  @Builder
  operateBuilder() {
    Column() {
      Button($r('app.string.operate_rdb_in_taskpool_dialog_edit_button_text'),
        { type: ButtonType.Normal, stateEffect: false })
        .fontSize($r('app.integer.operate_rdb_in_taskpool_dialog_button_font_size'))
        .width(CommonConstants.FULL_PERCENT)
        .fontColor($r('app.color.operate_rdb_in_taskpool_button_background_color_blue'))
        .height($r('app.integer.operate_rdb_in_taskpool_dialog_button_height'))
        .backgroundColor(Color.White)
        .onClick(() => {
          this.isShow = false;
          // 点击进入编辑页面
          this.pageInfos.pushDestinationByName('AddressBookEdit', {
            contact: this.contact,
            addCallback: null,
            editCallback: (contact: Contact) => {
              if (contact) {
                this.sourceData = contact;
                this.contact = contact;
                this.isChange = true;
              }
            }
          })
        })

      Divider()
        .width(CommonConstants.FULL_PERCENT)
        .height($r('app.integer.operate_rdb_in_taskpool_dialog_divider_line_height'))
        .backgroundColor($r('app.color.operate_rdb_in_taskpool_dialog_divider_line_color'))

      Button($r('app.string.operate_rdb_in_taskpool_dialog_delete_button_text'),
        { type: ButtonType.Normal, stateEffect: false })
        .fontColor($r('app.color.operate_rdb_in_taskpool_button_background_color_red'))
        .fontSize($r('app.integer.operate_rdb_in_taskpool_dialog_button_font_size'))
        .width(CommonConstants.FULL_PERCENT)
        .height($r('app.integer.operate_rdb_in_taskpool_dialog_button_height'))
        .backgroundColor(Color.White)
        .onClick(() => {
          this.isShow = false;
          this.dialogController.open()
        })

      Divider()
        .width(CommonConstants.FULL_PERCENT)
        .height($r('app.integer.operate_rdb_in_taskpool_dialog_divider_line_height'))
        .backgroundColor($r('app.color.operate_rdb_in_taskpool_dialog_divider_line_color'))

      Button($r('app.string.operate_rdb_in_taskpool_dialog_cancel_button_text'),
        { type: ButtonType.Normal, stateEffect: false })
        .fontColor($r('app.color.operate_rdb_in_taskpool_button_background_color_gray'))
        .fontSize($r('app.integer.operate_rdb_in_taskpool_dialog_button_font_size'))
        .width(CommonConstants.FULL_PERCENT)
        .height($r('app.integer.operate_rdb_in_taskpool_dialog_button_height'))
        .backgroundColor(Color.White)
        .onClick(() => {
          this.isShow = false;
        })
    }
    .padding({ top: $r('app.integer.operate_rdb_in_taskpool_operate_builder_padding_top') })
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
  }

  build() {
    NavDestination() {
      Column() {
        // 导航栏
        this.navDestinationTitle(this.sourceData.name)
        if (this.sourceData.avatar) {
          // 头像
          Image($rawfile(this.sourceData.avatar))
            .width($r('app.integer.operate_rdb_in_taskpool_avatar_width'))
            .height($r('app.integer.operate_rdb_in_taskpool_avatar_height'))
            .backgroundColor($r('app.color.operate_rdb_in_taskpool_avatar_background_color'))
            .border({
              width: CommonConstants.BORDER_WIDTH_BOLD,
              color: Color.White,
              radius: CommonConstants.BORDER_RADIUS_FULLY
            })
        } else {
          // 无头像
          Text(this.sourceData.category)
            .fontSize($r('app.integer.operate_rdb_in_taskpool_avatar_font_size'))
            .fontColor($r('app.color.operate_rdb_in_taskpool_detail_title_text_color'))
            .fontWeight(FontWeight.Bolder)
            .textAlign(TextAlign.Center)
            .backgroundColor($r('app.color.operate_rdb_in_taskpool_avatar_background_color'))
            .width($r('app.integer.operate_rdb_in_taskpool_avatar_width'))
            .height($r('app.integer.operate_rdb_in_taskpool_avatar_height'))
            .border({
              width: CommonConstants.BORDER_WIDTH_BOLD,
              color: Color.White,
              radius: CommonConstants.BORDER_RADIUS_FULLY
            })
        }
        // 姓名
        Text(this.sourceData.name)
          .fontSize($r('app.integer.operate_rdb_in_taskpool_name_font_size'))
          .fontColor($r('app.color.operate_rdb_in_taskpool_detail_content_text_color'))
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Center)
          .width(CommonConstants.FULL_PERCENT)
          .height($r('app.integer.operate_rdb_in_taskpool_name_height'))
          .margin({ top: $r('app.integer.operate_rdb_in_taskpool_name_margin_top') })

        this.phoneBuilder();
        this.videoBuilder();
        this.emailBuilder();
        this.addressBuilder();
      }
      .padding({
        left: $r('app.integer.operate_rdb_in_taskpool_detail_padding_left'),
        right: $r('app.integer.operate_rdb_in_taskpool_detail_padding_right')
      })
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
    }
    .backgroundColor(Color.White)
    .hideTitleBar(true)
  }
}