/*
 * Copyright (c) 2024-2025 Huawei Device Co., Ltd.
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

// [Start form_host_index]
import { HashMap, HashSet } from '@kit.ArkTS';
import { formHost, formInfo, formObserver } from '@kit.FormKit';
import { bundleMonitor } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import hilog from '@ohos.hilog';

const TAG: string = 'FormHost';
const DOMAIN_NUMBER: number = 0xFF00;

@Entry
@Component
struct formHostSample {
  // 卡片尺寸枚举。
  static FORM_DIMENSIONS_MAP = [
    '1*2',
    '2*2',
    '2*4',
    '4*4',
    '1*1',
    '6*4',
  ]
  // 模拟卡片尺寸。
  static FORM_SIZE = [
    [120, 60], // 1*2
    [120, 120], // 2*2
    [240, 120], // 2*4
    [240, 240], // 4*4
    [60, 60], // 1*1
    [240, 360],// 6*4
  ]
  // $r('app.string.Host')需要替换为开发者所需的资源文件
  @State message: Resource | string = $r('app.string.Host');
  formCardHashMap: HashMap<string, formInfo.FormInfo> = new HashMap();
  @State showFormPicker: boolean = false;
  // $r('app.string.formOperation')需要替换为开发者所需的资源文件
  @State operation: Resource | string = $r('app.string.formOperation');
  @State index: number = 2;
  @State space: number = 8;
  @State arrowPosition: ArrowPosition = ArrowPosition.END;
  formIds: HashSet<string> = new HashSet();
  currentFormKey: string = '';
  focusFormInfo: formInfo.FormInfo = {
    bundleName: '',
    moduleName: '',
    abilityName: '',
    name: '',
    displayName: '',
    displayNameId: 0,
    description: '',
    descriptionId: 0,
    type: formInfo.FormType.eTS,
    jsComponentName: '',
    // [StartExclude form_host_index]
    colorMode: formInfo.ColorMode.MODE_AUTO,
    // [EndExclude form_host_index]
    isDefault: false,
    updateEnabled: false,
    formVisibleNotify: true,
    scheduledUpdateTime: '',
    formConfigAbility: '',
    updateDuration: 0,
    defaultDimension: 6,
    supportDimensions: [],
    supportedShapes: [],
    customizeData: {},
    isDynamic: false,
    transparencyEnabled: false
  }
  formInfoRecord: TextCascadePickerRangeContent[] = [];
  // $r('app.string.formType')需要替换为开发者所需的资源文件
  pickerBtnMsg: Resource | string = $r('app.string.formType');
  @State showForm: boolean = true;
  @State selectFormId: string = '0';
  @State pickDialogIndex: number = 0;

  aboutToAppear(): void {
    try {
      // 检查系统是否准备好。
      formHost.isSystemReady().then(() => {
        hilog.info(DOMAIN_NUMBER, TAG, 'formHost isSystemReady success');

        // 订阅通知卡片不可见的事件和卡片可见通知事件。
        let notifyInvisibleCallback = (data: formInfo.RunningFormInfo[]) => {
          hilog.info(DOMAIN_NUMBER, TAG, `form change invisibility, data: ${JSON.stringify(data)}`);
        }
        let notifyVisibleCallback = (data: formInfo.RunningFormInfo[]) => {
          hilog.info(DOMAIN_NUMBER, TAG, `form change visibility, data: ${JSON.stringify(data)}`);
        }
        formObserver.on('notifyInvisible', notifyInvisibleCallback);
        formObserver.on('notifyVisible', notifyVisibleCallback);

        // 注册监听应用的安装事件。
        try {
          bundleMonitor.on('add', (bundleChangeInfo) => {
            hilog.info(DOMAIN_NUMBER, TAG,
              `bundleName : ${bundleChangeInfo.bundleName} userId : ${bundleChangeInfo.userId}`);
            this.getAllBundleFormsInfo();
          })
        } catch (errData) {
          let message = (errData as BusinessError).message;
          let errCode = (errData as BusinessError).code;
          hilog.error(DOMAIN_NUMBER, TAG, `errData is errCode:${errCode}  message:${message}`);
        }
        // 注册监听应用的更新事件。
        try {
          bundleMonitor.on('update', (bundleChangeInfo) => {
            hilog.info(DOMAIN_NUMBER, TAG,
              `bundleName : ${bundleChangeInfo.bundleName} userId : ${bundleChangeInfo.userId}`);
            this.getAllBundleFormsInfo();
          })
        } catch (errData) {
          let message = (errData as BusinessError).message;
          let errCode = (errData as BusinessError).code;
          hilog.error(DOMAIN_NUMBER, TAG, `errData is errCode:${errCode}  message:${message}`);
        }
        // 注册监听应用的卸载事件。
        try {
          bundleMonitor.on('remove', (bundleChangeInfo) => {
            hilog.info(DOMAIN_NUMBER, TAG,
              `bundleName : ${bundleChangeInfo.bundleName} userId : ${bundleChangeInfo.userId}`);
            this.getAllBundleFormsInfo();
          })
        } catch (errData) {
          let message = (errData as BusinessError).message;
          let errCode = (errData as BusinessError).code;
          hilog.error(DOMAIN_NUMBER, TAG, `errData is errCode:${errCode}  message:${message}`);
        }
      }).catch((error: BusinessError) => {
        hilog.error(DOMAIN_NUMBER, TAG, `error, code: ${error.code}, message: ${error.message}`);
      });
    } catch (error) {
      hilog.error(DOMAIN_NUMBER, TAG,
        `catch error, code: ${(error as BusinessError).code}, message: ${(error as BusinessError).message}`);
    }
  }

  aboutToDisappear(): void {
    // 删除所有卡片。
    this.formIds.forEach((id) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'delete all form');
      formHost.deleteForm(id);
    });
    // 注销监听应用的安装。
    try {
      bundleMonitor.off('add');
    } catch (errData) {
      let message = (errData as BusinessError).message;
      let errCode = (errData as BusinessError).code;
      hilog.error(DOMAIN_NUMBER, TAG, `errData is errCode:${errCode}  message:${message}`);
    }
    // 注销监听应用的更新。
    try {
      bundleMonitor.off('update');
    } catch (errData) {
      let message = (errData as BusinessError).message;
      let errCode = (errData as BusinessError).code;
      hilog.error(DOMAIN_NUMBER, TAG, `errData is errCode:${errCode}  message:${message}`);
    }
    // 注销监听应用的卸载。
    try {
      bundleMonitor.off('remove');
    } catch (errData) {
      let message = (errData as BusinessError).message;
      let errCode = (errData as BusinessError).code;
      hilog.error(DOMAIN_NUMBER, TAG, `errData is errCode:${errCode}  message:${message}`);
    }
    // 取消订阅通知卡片不可见和通知卡片可见事件。
    formObserver.off('notifyInvisible');
    formObserver.off('notifyVisible');
  }

  // 将所有卡片信息存入formHapRecordMap中。
  getAllBundleFormsInfo() {
    this.formCardHashMap.clear();
    this.showFormPicker = false;
    let formHapRecordMap: HashMap<string, formInfo.FormInfo[]> = new HashMap();
    this.formInfoRecord = [];
    formHost.getAllFormsInfo().then((formList: Array<formInfo.FormInfo>) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'getALlFormsInfo size:' + formList.length);
      for (let formItemInfo of formList) {
        let formBundleName = formItemInfo.bundleName;
        if (formHapRecordMap.hasKey(formBundleName)) {
          formHapRecordMap.get(formBundleName).push(formItemInfo)
        } else {
          let formInfoList: formInfo.FormInfo[] = [formItemInfo];
          formHapRecordMap.set(formBundleName, formInfoList);
        }
      }
      for (let formBundle of formHapRecordMap.keys()) {
        let bundleFormInfo: TextCascadePickerRangeContent = {
          text: formBundle,
          children: []
        }
        let bundleFormList: formInfo.FormInfo[] = formHapRecordMap.get(formBundle);
        bundleFormList.forEach((formItemInfo) => {
          let dimensionName = formHostSample.FORM_DIMENSIONS_MAP[formItemInfo.defaultDimension - 1];
          bundleFormInfo.children?.push({ text: formItemInfo.name + '#' + dimensionName });
          this.formCardHashMap.set(formBundle + "#" + formItemInfo.name + '#' + dimensionName, formItemInfo);
        })
        this.formInfoRecord.push(bundleFormInfo);
      }
      this.formCardHashMap.forEach((formItem: formInfo.FormInfo) => {
        hilog.info(DOMAIN_NUMBER, TAG, `formCardHashmap: ${JSON.stringify(formItem)}`);
      })
      this.showFormPicker = true;
    })
  }

  build() {
    Column() {
      Text(this.message)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)

      Divider().vertical(false).color(Color.Black).lineCap(LineCapStyle.Butt).margin({ top: 10, bottom: 10 })

      Row() {
        // 点击查询所有卡片信息。
        // $r('app.string.inquiryForm')需要替换为开发者所需的资源文件
        Button($r('app.string.inquiryForm'))
          .onClick(() => {
            this.getAllBundleFormsInfo();
          })

        // 点击按钮弹出选择界面，点击确定后，添加默认尺寸的所选卡片。
        // $r('app.string.selectAddForm')需要替换为开发者所需的资源文件
        Button($r('app.string.selectAddForm'))
          .enabled(this.showFormPicker)
          .onClick(() => {
            hilog.info(DOMAIN_NUMBER, TAG, 'TextPickerDialog: show()');
            TextPickerDialog.show({
              range: this.formInfoRecord,
              selected: this.pickDialogIndex,
              canLoop: false,
              disappearTextStyle: { color: Color.Red, font: { size: 10, weight: FontWeight.Lighter } },
              textStyle: { color: Color.Black, font: { size: 12, weight: FontWeight.Normal } },
              selectedTextStyle: { color: Color.Blue, font: { size: 12, weight: FontWeight.Bolder } },
              onAccept: (result: TextPickerResult) => {
                this.currentFormKey = result.value[0] + "#" + result.value[1];
                this.pickDialogIndex = result.index[0]
                hilog.info(DOMAIN_NUMBER, TAG,
                  `TextPickerDialog onAccept： ${this.currentFormKey}, ${this.pickDialogIndex}`);
                if (!this.formCardHashMap.hasKey(this.currentFormKey)) {
                  hilog.error(DOMAIN_NUMBER, TAG, `invalid formItemInfo by form key`);
                  return;
                }
                this.showForm = true;
                this.focusFormInfo = this.formCardHashMap.get(this.currentFormKey);
              },
              onCancel: () => {
                hilog.info(DOMAIN_NUMBER, TAG, `TextPickerDialog : onCancel()`);
              },
              onChange: (result: TextPickerResult) => {
                this.pickerBtnMsg = result.value[0] + '#' + result.value[1];
                hilog.info(DOMAIN_NUMBER, TAG, `TextPickerDialog:onChange:` + this.pickerBtnMsg);
              }
            })
          })
          .margin({ left: 10 })
      }
      .margin({ left: 10 })

      Divider().vertical(false).color(Color.Black).lineCap(LineCapStyle.Butt).margin({ top: 10, bottom: 10 })

      if (this.showForm) {
        Text(this.pickerBtnMsg)
          .margin({ top: 10, bottom: 10 })
      }

      if (this.showForm) {
        Text('formId： ' + this.selectFormId)
          .margin({ top: 10, bottom: 10 })

        // 卡片组件。
        FormComponent({
          id: Number.parseInt(this.selectFormId),
          name: this.focusFormInfo.name,
          bundle: this.focusFormInfo.bundleName,
          ability: this.focusFormInfo.abilityName,
          module: this.focusFormInfo.moduleName,
          dimension: this.focusFormInfo.defaultDimension,
          temporary: false,
        })
          .size({
            width: formHostSample.FORM_SIZE[this.focusFormInfo.defaultDimension - 1][0],
            height: formHostSample.FORM_SIZE[this.focusFormInfo.defaultDimension - 1][1],
          })
          .borderColor(Color.Black)
          .borderRadius(10)
          .borderWidth(1)
          .onAcquired((form: FormCallbackInfo) => {
            hilog.info(DOMAIN_NUMBER, TAG, `onAcquired: ${JSON.stringify(form)}`);
            this.selectFormId = form.id.toString();
            this.formIds.add(this.selectFormId);
          })
          .onRouter(() => {
            hilog.info(DOMAIN_NUMBER, TAG, `onRouter`);
          })
          .onError((error) => {
            hilog.error(DOMAIN_NUMBER, TAG, `onError: ${JSON.stringify(error)}`);
            this.showForm = false;
          })
          .onUninstall((info: FormCallbackInfo) => {
            this.showForm = false;
            hilog.info(DOMAIN_NUMBER, TAG, `onUninstall: ${JSON.stringify(info)}`);
            this.formIds.remove(this.selectFormId);
          })

        // select列表，列出部分formHost接口功能。
        Row() {
          // $r('app.string.xxx')需要替换为开发者所需的资源文件
          Select([{ value: $r('app.string.deleteForm') },
            { value: $r('app.string.updateForm') },
            { value: $r('app.string.visibleForms') },
            { value: $r('app.string.invisibleForms') },
            { value: $r('app.string.enableFormsUpdate') },
            { value: $r('app.string.disableFormsUpdate') },
          ])
            .selected(this.index)
            .value(this.operation)
            .font({ size: 16, weight: 500 })
            .fontColor('#182431')
            .selectedOptionFont({ size: 16, weight: 400 })
            .optionFont({ size: 16, weight: 400 })
            .space(this.space)
            .arrowPosition(this.arrowPosition)
            .menuAlign(MenuAlignType.START, { dx: 0, dy: 0 })
            .optionWidth(200)
            .optionHeight(300)
            .onSelect((index: number, text?: string | Resource) => {
              hilog.info(DOMAIN_NUMBER, TAG, 'Select:' + index);
              this.index = index;
              if (text) {
                this.operation = text;
              }
            })

          // 根据select列表所选的功能，对当前卡片执行对应操作。
          // $r('app.string.execute')需要替换为开发者所需的资源文件
          Button($r('app.string.execute'), {
            type: ButtonType.Capsule
          })
            .fontSize(16)
            .onClick(() => {
              switch (this.index) {
                case 0:
                  try {
                    formHost.deleteForm(this.selectFormId, (error: BusinessError) => {
                      if (error) {
                        hilog.error(DOMAIN_NUMBER, TAG,
                          `deleteForm error, code: ${error.code}, message: ${error.message}`);
                      } else {
                        hilog.info(DOMAIN_NUMBER, TAG, 'formHost deleteForm success');
                      }
                    });
                  } catch (error) {
                    hilog.error(DOMAIN_NUMBER, TAG,
                      `deleteForm catch error, code: ${(error as BusinessError).code}, message: ${(error as BusinessError).message}`);
                  }
                  this.showForm = false;
                  this.selectFormId = '';
                  break;
                case 1:
                  try {
                    // [Start request_form]
                    formHost.requestForm(this.selectFormId, (error: BusinessError) => {
                      if (error) {
                        hilog.error(DOMAIN_NUMBER, TAG,
                          `requestForm error, code: ${error.code}, message: ${error.message}`);
                      }
                    });
                    // [End request_form]
                  } catch (error) {
                    hilog.error(DOMAIN_NUMBER, TAG,
                      `requestForm catch error, code: ${(error as BusinessError).code}, message: ${(error as BusinessError).message}`);
                  }
                  break;
                case 2:
                  try {
                    formHost.notifyVisibleForms([this.selectFormId], (error: BusinessError) => {
                      if (error) {
                        hilog.error(DOMAIN_NUMBER, TAG,
                          `notifyVisibleForms error, code: ${error.code}, message: ${error.message}`);
                      } else {
                        hilog.info(DOMAIN_NUMBER, TAG, 'notifyVisibleForms success');
                      }
                    });
                  } catch (error) {
                    hilog.error(DOMAIN_NUMBER, TAG,
                      `notifyVisibleForms catch error, code: ${(error as BusinessError).code}, message: ${(error as BusinessError).message}`);
                  }
                  break;
                case 3:
                  try {
                    formHost.notifyInvisibleForms([this.selectFormId], (error: BusinessError) => {
                      if (error) {
                        hilog.error(DOMAIN_NUMBER, TAG,
                          `notifyInvisibleForms error, code: ${error.code}, message: ${error.message}`);
                      } else {
                        hilog.info(DOMAIN_NUMBER, TAG, 'notifyInvisibleForms success');
                      }
                    });
                  } catch (error) {
                    hilog.error(DOMAIN_NUMBER, TAG,
                      `notifyInvisibleForms catch error, code: ${(error as BusinessError).code}, message: ${(error as BusinessError).message}`);
                  }
                  break;
                case 4:
                  try {
                    formHost.enableFormsUpdate([this.selectFormId], (error: BusinessError) => {
                      if (error) {
                        hilog.error(DOMAIN_NUMBER, TAG,
                          `enableFormsUpdate error, code: ${error.code}, message: ${error.message}`);
                      }
                    });
                  } catch (error) {
                    hilog.error(DOMAIN_NUMBER, TAG,
                      `enableFormsUpdate catch error, code: ${(error as BusinessError).code}, message: ${(error as BusinessError).message}`);
                  }
                  break;
                case 5:
                  try {
                    formHost.disableFormsUpdate([this.selectFormId], (error: BusinessError) => {
                      if (error) {
                        hilog.error(DOMAIN_NUMBER, TAG,
                          `disableFormsUpdate error, code: ${error.code}, message: ${error.message}`);
                      } else {
                        hilog.info(DOMAIN_NUMBER, TAG, 'disableFormsUpdate success');
                      }
                    });
                  } catch (error) {
                    hilog.error(DOMAIN_NUMBER, TAG,
                      `disableFormsUpdate catch error, code: ${(error as BusinessError).code}, message: ${(error as BusinessError).message}`);
                  }
                  break;
              }
            })
        }
        .margin({
          top: 20,
          bottom: 10
        })
      }
    }
  }
}

// [End form_host_index]
