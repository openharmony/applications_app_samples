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
import { common } from '@kit.AbilityKit';
import { taskPoolExecuteInsert, taskPoolExecuteUpdate } from './TaskPool';
import { promptAction, TipsDialog } from '@kit.ArkUI';
import { i18n } from '@kit.LocalizationKit';
import { CommonConstants } from '../constant/CommonConstant';

const context: common.Context = getContext(this).getApplicationContext();

interface AddressBookEditParam {
  contact: Contact;
  addCallback: (contact: Contact) => void;
  editCallback: (contact: Contact) => void;
}

@Builder
export function AddressBookEditBuilder(name: string, param: AddressBookEditParam) {
  AddressBookEdit({ contact: param.contact, editCallback: param.editCallback, addCallback: param.addCallback });
}

@Component
export struct AddressBookEdit {
  private contact?: Contact;
  private editCallback?: (contact: Contact) => void;
  private addCallback?: (contact: Contact) => void;
  private isEdit: boolean = this.contact?.id ? true : false;
  private result: Contact = new Contact();
  @State isShow: boolean = false;
  @Consume pageInfos: NavPathStack;
  // 通讯录操作弹框
  dialogController: CustomDialogController = new CustomDialogController({
    builder: TipsDialog({
      imageRes: $r('app.media.operate_rdb_in_taskpool_save'),
      imageSize: { width: CommonConstants.CUSTOM_DIALOG_ICON_SIZE, height: CommonConstants.CUSTOM_DIALOG_ICON_SIZE },
      title: this.isEdit ? $r('app.string.operate_rdb_in_taskpool_edit_dialog_title', this.contact?.name) :
      $r('app.string.operate_rdb_in_taskpool_add_dialog_title', this.result?.name),
      content: this.isEdit ? $r('app.string.operate_rdb_in_taskpool_edit_dialog_content') :
      $r('app.string.operate_rdb_in_taskpool_add_dialog_content'),
      primaryButton: {
        value: $r('app.string.operate_rdb_in_taskpool_dialog_confirm_button_text'),
        role: ButtonRole.NORMAL,
        action: () => {
          // 点击完成
          if (this.isEdit) {
            if (isEqual(this.contact, this.result)) {
              promptAction.showToast({ message: $r('app.string.operate_rdb_in_taskpool_no_modify_prompt_text') });
              return;
            }
            // 更新数据操作
            taskPoolExecuteUpdate(context, this.result).then(() => {
              this.pageInfos.pop();
              // 数据库更新成功后 操作列表数据源回调
              this.editCallback!(this.result);
            });
          } else {
            // 单条数据插入操作
            taskPoolExecuteInsert(context, this.result).then(() => {
              this.pageInfos.pop();
              // 数据库插入成功后 操作列表数据源回调
              this.addCallback!(this.result);
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
  navDestinationTitle(name: ResourceStr | string | undefined) {
    Row() {
      Column() {
        Image($r('app.media.operate_rdb_in_taskpool_arrow_left'))
          .width($r('app.integer.operate_rdb_in_taskpool_arrow_left_width'))
          .height($r('app.integer.operate_rdb_in_taskpool_arrow_left_height'))
      }
      .onClick(() => {
        this.pageInfos.pop();
      })
      .justifyContent(FlexAlign.Center)
      .width($r('app.integer.operate_rdb_in_taskpool_arrow_left_background_width'))
      .height($r('app.integer.operate_rdb_in_taskpool_arrow_left_background_height'))
      .borderRadius(CommonConstants.BORDER_RADIUS_PROMINENT)
      .backgroundColor($r('app.color.operate_rdb_in_taskpool_navigation_button_background_color'))

      Text(name)
        .fontWeight(FontWeight.Bold)
        .fontSize($r('app.integer.operate_rdb_in_taskpool_navigation_title_font_size'))
        .margin({ left: $r('app.integer.operate_rdb_in_taskpool_navigation_title_margin_left') })
        .width(AppStorage.get('isFoldable') ? CommonConstants.FOLD_NAVIGATION_TITLE_WIDTH :
        CommonConstants.UNFOLD_NAVIGATION_TITLE_WIDTH)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Column() {
        Image($r('app.media.operate_rdb_in_taskpool_ok'))
          .width($r('app.integer.operate_rdb_in_taskpool_button_ok_width'))
          .height($r('app.integer.operate_rdb_in_taskpool_button_ok_height'))
      }
      .onClick(() => {
        if (!this.result.name) {
          promptAction.showToast({
            message: $r('app.string.operate_rdb_in_taskpool_name_prompt_text'),
          });
          return;
        } else if (!this.result.phone) {
          promptAction.showToast({
            message: $r('app.string.operate_rdb_in_taskpool_phone_prompt_text'),
          });
          return;
        } else if (!this.result.email) {
          promptAction.showToast({
            message: $r('app.string.operate_rdb_in_taskpool_email_prompt_text'),
          });
          return;
        } else if (!this.result.address) {
          promptAction.showToast({
            message: $r('app.string.operate_rdb_in_taskpool_address_prompt_text'),
          });
          return;
        }

        // TODO：知识点：可以通过Transliterator来转换汉字成拼音
        let transliterator = i18n.Transliterator.getInstance('Any-Latn');
        let pinyin = transliterator.transform(this.result.name);

        // TODO：知识点：可以使用“Latin-ASCII”去掉音标
        let transliteratorto = i18n.Transliterator.getInstance('Latin-ASCII');
        let res = transliteratorto.transform(pinyin);
        // 将首字母变成大写
        let categoryLetter = res.slice(0, 1).toUpperCase();
        // 是否为字母A-Z和a-z的正则
        const regex = /^[A-Za-z]$/;
        // 判断是否为字母，是字母则category赋值为大写字母，否则为#
        if (regex.test(categoryLetter)) {
          this.result.category = res.slice(0, 1).toUpperCase();
        } else {
          this.result.category = '#';
        }
        if (this.contact !== null) {
          this.result.id = this.contact!.id;
          this.result.avatar = this.contact!.avatar;
          this.isEdit = true;
        }
        // 弹框弹出
        this.isShow = false;
        this.dialogController.open();

      })
      .justifyContent(FlexAlign.Center)
      .width($r('app.integer.operate_rdb_in_taskpool_confirm_buttom_background_width'))
      .height($r('app.integer.operate_rdb_in_taskpool_confirm_buttom_background_height'))
      .borderRadius(CommonConstants.BORDER_RADIUS_PROMINENT)
      .backgroundColor($r('app.color.operate_rdb_in_taskpool_navigation_button_background_color'))
    }
    .expandSafeArea([SafeAreaType.KEYBOARD])
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      left: $r('app.integer.operate_rdb_in_taskpool_navigation_padding_left'),
      right: $r('app.integer.operate_rdb_in_taskpool_navigation_padding_right')
    })
    .backgroundColor(Color.White)
    .margin({ bottom: $r('app.integer.operate_rdb_in_taskpool_navigation_margin_bottom') })
    .width(CommonConstants.FULL_PERCENT)
    .height($r('app.integer.operate_rdb_in_taskpool_navigation_height'))
  }

  build() {
    NavDestination() {
      Column({ space: CommonConstants.COLUMN_SPACE }) {
        this.navDestinationTitle(this.isEdit ? $r('app.string.operate_rdb_in_taskpool_navigation_edit_text') :
        $r('app.string.operate_rdb_in_taskpool_navigation_add_text'));

        Image(this.contact?.avatar ? $rawfile(this.contact.avatar) : $r('app.media.operate_rdb_in_taskpool_portrait'))
          .height($r('app.integer.operate_rdb_in_taskpool_avatar_height'))
          .width($r('app.integer.operate_rdb_in_taskpool_avatar_width'))
          .margin({ top: $r('app.integer.operate_rdb_in_taskpool_avatar_edit_view_margin_top') })
          .backgroundColor($r('app.color.operate_rdb_in_taskpool_avatar_background_color'))
          .border({
            width: CommonConstants.BORDER_WIDTH_BOLD,
            color: Color.White,
            radius: CommonConstants.BORDER_RADIUS_FULLY
          })
          .onClick(() => {
            promptAction.showToast({
              message: $r('app.string.operate_rdb_in_taskpool_prompt_text'),
            });
          })

        TextInput({ placeholder: $r('app.string.operate_rdb_in_taskpool_text_input_name'), text: this.contact?.name })
          .placeholderColor($r('app.color.operate_rdb_in_taskpool_text_input_placeholder_color'))
          .placeholderFont({
            size: $r('app.integer.operate_rdb_in_taskpool_text_input_font_size'),
            weight: FontWeight.Bold
          })
          .fontSize($r('app.integer.operate_rdb_in_taskpool_text_input_font_size'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.operate_rdb_in_taskpool_text_input_font_color'))
          .height($r('app.integer.operate_rdb_in_taskpool_text_input_height'))
          .borderRadius(CommonConstants.BORDER_RADIUS_MODERATE)
          .margin({
            left: $r('app.integer.operate_rdb_in_taskpool_text_input_margin_left'),
            right: $r('app.integer.operate_rdb_in_taskpool_text_input_margin_right'),
            top: $r('app.integer.operate_rdb_in_taskpool_text_input_margin_top')
          })
          .maxLength(CommonConstants.MAX_LENGTH_SHORT)
          .backgroundColor($r('app.color.operate_rdb_in_taskpool_text_input_background_color'))
          .onChange((value: string) => {
            this.result.name = value;
          })

        Column() {
          TextInput({
            placeholder: $r('app.string.operate_rdb_in_taskpool_text_input_phone'),
            text: this.contact?.phone
          })
            .placeholderColor($r('app.color.operate_rdb_in_taskpool_text_input_placeholder_color'))
            .placeholderFont({
              size: $r('app.integer.operate_rdb_in_taskpool_text_input_font_size'),
              weight: FontWeight.Bold
            })
            .fontSize($r('app.integer.operate_rdb_in_taskpool_text_input_font_size'))
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.operate_rdb_in_taskpool_text_input_font_color'))
            .height($r('app.integer.operate_rdb_in_taskpool_text_input_height'))
            .maxLength(CommonConstants.MAX_LENGTH_MODERATE)
            .borderRadius(CommonConstants.BORDER_RADIUS_MODERATE)
            .backgroundColor($r('app.color.operate_rdb_in_taskpool_text_input_background_color'))
            .onChange((value: string) => {
              this.result.phone = value;
            })

          Divider()
            .strokeWidth(CommonConstants.STROKE_WIDTH)
            .color($r('app.color.operate_rdb_in_taskpool_text_input_devider_color'))
            .padding({
              left: $r('app.integer.operate_rdb_in_taskpool_text_input_devider_padding_left'),
              right: $r('app.integer.operate_rdb_in_taskpool_text_input_devider_padding_right')
            })

          TextInput({
            placeholder: $r('app.string.operate_rdb_in_taskpool_text_input_email'),
            text: this.contact?.email
          })
            .placeholderColor($r('app.color.operate_rdb_in_taskpool_text_input_placeholder_color'))
            .placeholderFont({
              size: $r('app.integer.operate_rdb_in_taskpool_text_input_font_size'),
              weight: FontWeight.Bold
            })
            .fontSize($r('app.integer.operate_rdb_in_taskpool_text_input_font_size'))
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.operate_rdb_in_taskpool_text_input_font_color'))
            .height($r('app.integer.operate_rdb_in_taskpool_text_input_height'))
            .maxLength(CommonConstants.MAX_LENGTH_LONG)
            .borderRadius(CommonConstants.BORDER_RADIUS_MODERATE)
            .backgroundColor($r('app.color.operate_rdb_in_taskpool_text_input_background_color'))
            .onChange((value: string) => {
              this.result.email = value;
            })

          Divider()
            .strokeWidth(CommonConstants.STROKE_WIDTH)
            .color($r('app.color.operate_rdb_in_taskpool_text_input_devider_color'))
            .padding({
              left: $r('app.integer.operate_rdb_in_taskpool_text_input_devider_padding_left'),
              right: $r('app.integer.operate_rdb_in_taskpool_text_input_devider_padding_right')
            })

          TextInput({
            placeholder: $r('app.string.operate_rdb_in_taskpool_text_input_address'),
            text: this.contact?.address
          })
            .placeholderColor($r('app.color.operate_rdb_in_taskpool_text_input_placeholder_color'))
            .placeholderFont({
              size: $r('app.integer.operate_rdb_in_taskpool_text_input_font_size'),
              weight: FontWeight.Bold
            })
            .fontSize($r('app.integer.operate_rdb_in_taskpool_text_input_font_size'))
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.operate_rdb_in_taskpool_text_input_font_color'))
            .height($r('app.integer.operate_rdb_in_taskpool_text_input_height'))
            .maxLength(CommonConstants.MAX_LENGTH_VERY_LONG)
            .borderRadius(CommonConstants.BORDER_RADIUS_MODERATE)
            .backgroundColor($r('app.color.operate_rdb_in_taskpool_text_input_background_color'))
            .onChange((value: string) => {
              this.result.address = value;
            })
        }
        .margin({
          left: $r('app.integer.operate_rdb_in_taskpool_text_input_margin_left'),
          right: $r('app.integer.operate_rdb_in_taskpool_text_input_margin_right'),
        })
        .padding({
          top: $r('app.integer.operate_rdb_in_taskpool_text_input_padding_top'),
          bottom: $r('app.integer.operate_rdb_in_taskpool_text_input_padding_bottom')
        })
        .borderRadius(CommonConstants.BORDER_RADIUS_MODERATE)
        .backgroundColor($r('app.color.operate_rdb_in_taskpool_text_input_background_color'))
      }
    }
    .backgroundColor(Color.White)
    .hideTitleBar(true)
  }
}

/*
 * 判断当前通讯录信息是否有修改
 */
function isEqual(a: Contact | undefined, b: Contact | undefined) {
  if (a === undefined || b === undefined) {
    return false;
  }

  const valuesA: (number | string)[] = Object.values(a);
  const valuesB: (number | string)[] = Object.values(b);

  if (valuesA.length !== valuesB.length) {
    return false;
  }

  for (let value of valuesA) {
    if (!valuesB.includes(value) || valuesA[value] !== valuesB[value]) {
      return false;
    }
  }
  return true;
}

