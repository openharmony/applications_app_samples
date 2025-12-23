/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import testNapi2 from 'libnativerender.so';

enum CustomDialogAttributeType {
  Background_Color = 1, // 背景颜色
  Corner_Radius, // 圆角半径
  Border_Colors, // 边框颜色
  Border_Style, // 边框样式
  Backboard_shadow, // 背板阴影
  Backboard_CustomShadow, // 自定义背板阴影
  Background_Blur_Style, // 背板模糊材质
  Align_mode, // 对齐模式
  Modal_Mode, // 模态样式
  Auto_Cancel, // 遮罩层退出
  Subwindow_Mode, // 弹窗是否在子窗口显示此弹窗
  Mask, // 自定义弹窗遮罩属性
  Keyboard_Avoid_Mode, // 弹窗的键盘避让模式
  Hover_Mode_Enabled, // 是否响应悬停态
  Hover_Mode_Area, // 悬停态下弹窗默认展示区域
  Background_Blur_Style_Options, // 背景模糊效果
  Background_Effect, // 弹窗的背景效果参数
  Level_Mode, // 设置弹窗的显示层级
  Level_Unique_Id, // 设置弹窗显示层级页面下的节点id
  Immersive_Mode, // 设置嵌入式弹窗蒙层的显示区域
  Should_Block_Dismiss, // 设置需要屏蔽系统关闭弹窗行为
};

@Entry
@Component
struct Index {
  @Provide nodeValue: number = -1;
  @Provide nodeType: number = -1;
  @Provide totalInfo: string = '';
  @State isCreateKey: boolean = false; // 是否创建键盘
  @State stateInfos: string = '';
  @State printDefaultText: boolean = false; // 是否打印默认文本
  @Provide place: string = '';
  @Builder
  SubMenuAttributeType() {
    Menu() {
      MenuItem({ content: '背景颜色：红色' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Background_Color;
        this.nodeValue = 0xFFFF0000;
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'Set the background color to red\n';
        }else{
          this.totalInfo += 'Failed to set background color\n';
        }
      })
      MenuItem({ content: '圆角半径: 15' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Corner_Radius;
        this.nodeValue = 15;
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'Set the corner radius: 15\n';
        }else{
          this.totalInfo += 'Failed to set border radius\n';
        }
      })
      MenuItem({ content: '边框颜色：黄色' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Border_Colors;
        this.nodeValue = 0xFFFFFF00;
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'Set border color to yellow\n';
        }else{
          this.totalInfo += 'Failed to set border color\n';
        }
      })
      MenuItem({ content: '边框样式：点状' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Border_Style;
        this.nodeValue = 2;
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'Set border style to dotted\n';
        }else{
          this.totalInfo += 'Failed to set border style\n';
        }
      })
      MenuItem({ content: '背板阴影' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Backboard_shadow;
        this.nodeValue = 0;
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'ARKUI_SHADOW_STYLE_OUTER_DEFAULT_LG\n';
        }else{
          this.totalInfo += 'Failed to set shadow\n';
        }
      })
      // 设置自定义弹窗的背板阴影
      MenuItem({ content: '自定义背板阴影' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Backboard_CustomShadow
        this.nodeValue = 0;
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'Set custom backboard shadow\n';
        }else{
          this.totalInfo += 'Failed to set custom backboard shadow\n';
        }
      })
      MenuItem({ content: '轻薄材质模糊' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Background_Blur_Style;
        this.nodeValue = 4;
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'ARKUI_BLUR_STYLE_BACKGROUND_REGULAR\n';
        }else{
          this.totalInfo += 'Failed to set background blur style\n';
        }
      })
      MenuItem({ content: '对齐模式：底部开始'}).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Align_mode;
        this.nodeValue = 3;
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'Align content from the bottom\n';
        } else {
          this.totalInfo += 'Failed to set alignment\n';
        }
      })
      MenuItem({ content: '是否开启模态样式', builder: ():void=>this.SubMenu_Modal_Mode() }).width('50%')
      MenuItem({ content: '遮罩层退出', builder: ():void=>this.SubMenu_Auto_Cancel() }).width('50%')
      MenuItem({ content: '弹窗是否在子窗口显示此弹窗', builder: ():void=>this.SubMenu_Subwindow_Mode() }).width('50%')
      MenuItem({ content: '自定义弹窗遮罩属性' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Mask;
        this.nodeValue = 1;
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'Set mask property to red\n';
        }else{
          this.totalInfo += 'Failed to set mask property\n';
        }
      })
      MenuItem({ content: '避让键盘的模式', builder: ():void=>this.SubMenu_Keyboard_Avoid_Mode() }).width('50%')
      MenuItem({ content: '响应悬停' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Hover_Mode_Enabled;
        this.nodeValue = 1;
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'Effective only on foldable screens\n';
        } else {
          this.totalInfo += 'Failed to SetHoverModeEnabled\n';
        }
      })
      MenuItem({ content: '悬停态下弹窗默认展示区域', builder: ():void=>this.SubMenu_Hover_Mode_Area() }).width('50%')
      MenuItem({ content: '背景模糊效果' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Background_Blur_Style_Options;
        this.nodeValue = 1;
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'Set background blur effect for the dialog\n';
        } else {
          this.totalInfo += 'Failed to background blur effect\n';
        }
      })
      MenuItem({ content: '背景效果参数' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Background_Effect;
        this.nodeValue = 1;
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'Set background effect for the dialog\n';
        } else {
          this.totalInfo += 'Failed to background effect\n';
        }
      })
      MenuItem({ content: '设置弹窗的显示层级', builder: ():void=>this.SubMenu_Level_Mode() }).width('50%')
      MenuItem({ content: '设置弹窗显示层级页面下的节点id：0' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Level_Unique_Id;
        this.nodeValue = 0;
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'Set the level unique id to 0\n';
        }else{
          this.totalInfo += 'Failed to set level unique id\n';
        }
      })
      MenuItem({ content: '设置嵌入式弹窗蒙层的显示区域', builder: ():void=>this.SubMenu_Immersive_Mode() }).width('50%')
      MenuItem({ content: '注册系统关闭自定义弹窗的监听事件', builder: ():void=>this.SubMenu_Register_OnWill_Dismiss_Callback() }).width('50%')
    }
  }

  @Builder
  SubMenu_Modal_Mode() {
    Menu() {
      MenuItem({ content: '开启' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Modal_Mode;
        this.nodeValue = 1;
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'Set the dialog to modal mode\n';
        }else{
          this.totalInfo += 'Failed to set the dialog to modal mode\n';
        }
      })
      MenuItem({ content: '关闭' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Modal_Mode;
        this.nodeValue = 0;
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'Set the dialog to non-modal mode\n';
        }else{
          this.totalInfo += 'Failed to set the dialog to non-modal mode failed\n';
        }
      })
    }
  }

  @Builder
  SubMenu_Auto_Cancel() {
    Menu() {
      MenuItem({ content: '开启' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Auto_Cancel;
        this.nodeValue = 1;
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'Configure the dialog to dismiss on mask layer click\n';
        }else{
          this.totalInfo += 'Failed to configure the dialog to dismiss on mask layer click\n';
        }
      })
      MenuItem({ content: '关闭' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Auto_Cancel;
        this.nodeValue = 0;
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'Configure the dialog to dismiss on mask layer click\n';
        }else{
          this.totalInfo += 'Failed to configure the dialog to dismiss on mask layer click\n';
        }
      })
    }
  }

  @Builder
  SubMenu_Subwindow_Mode() {
    Menu() {
      MenuItem({ content: '开启' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Subwindow_Mode;
        this.nodeValue = 1;
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'Set the pop-up window to display this pop-up window in a child window\n';
        }else{
          this.totalInfo += 'Failed to set subwindow mode\n';
        }
      })
      MenuItem({ content: '关闭' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Subwindow_Mode;
        this.nodeValue = 0;
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'Do not set up a pop-up window to display this pop-up window in a child window\n';
        }else{
          this.totalInfo += 'Failed to set subwindow mode\n';
        }
      })
    }
  }

  @Builder
  SubMenu_Keyboard_Avoid_Mode() {
    Menu() {
      MenuItem({ content: '避让' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Keyboard_Avoid_Mode;
        this.nodeValue = 0;
        this.isCreateKey = true;
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'Avoid keyboard mode\n';
        } else {
          this.totalInfo += 'Failed to set avoid keyboard mode\n';
        }
      })
      MenuItem({ content: '不避让' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Keyboard_Avoid_Mode;
        this.nodeValue = 1;
        this.isCreateKey = true;
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'Do not avoid keyboard mode\n';
        } else {
          this.totalInfo += 'Failed to set avoid keyboard mode\n';
        }
      })
    }
  }

  @Builder
  SubMenu_Hover_Mode_Area() {
    Menu() {
      MenuItem({ content: '上半屏' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Hover_Mode_Area;
        this.nodeValue = 0;
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'Popup defaults to upper screen area in hover state\n';
        } else {
          this.totalInfo += 'Failed to set hover mode\n';
        }
      })
    }
    Menu() {
      MenuItem({ content: '下半屏' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Hover_Mode_Area;
        this.nodeValue = 1;
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'Popup defaults to lower screen area in hover state\n';
        } else {
          this.totalInfo += 'Failed to set hover mode\n';
        }
      })
    }
  }

  @Builder
  SubMenu_Level_Mode() {
    Menu() {
      MenuItem({ content: 'ARKUI_LEVEL_MODE_OVERLAY' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Level_Mode;
        this.nodeValue = 0;
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'ARKUI_LEVEL_MODE_OVERLAY\n';
        }else{
          this.totalInfo += 'Failed to set level mode\n';
        }
      })
      MenuItem({ content: 'ARKUI_LEVEL_MODE_EMBEDDED' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Level_Mode;
        this.nodeValue = 1;
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'ARKUI_LEVEL_MODE_EMBEDDED\n';
        }else{
          this.totalInfo += 'Failed to set level mode\n';
        }
      })
    }
  }

  @Builder
  SubMenu_Immersive_Mode() {
    Menu() {
      MenuItem({ content: 'ARKUI_IMMERSIVE_MODE_DEFAULT' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Immersive_Mode;
        this.nodeValue = 0;
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'ARKUI_IMMERSIVE_MODE_DEFAULT\n';
        }else{
          this.totalInfo += 'Failed to set immersive mode\n';
        }
      })
      MenuItem({ content: 'ARKUI_IMMERSIVE_MODE_EXTEND' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Immersive_Mode;
        this.nodeValue = 1;
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'ARKUI_IMMERSIVE_MODE_EXTEND\n';
        }else{
          this.totalInfo += 'Failed to set immersive mode\n';
        }
      })
    }
  }

  @Builder
  SubMenu_Register_OnWill_Dismiss_Callback() {
    Menu() {
      MenuItem({ content: '是' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Should_Block_Dismiss;
        this.nodeValue = 1;
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'Registered already\n';
        }else{
          this.totalInfo += 'Failed to register OnWillDismissCallback\n';
        }
      })
      MenuItem({ content: '否' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Should_Block_Dismiss;
        this.nodeValue = 0
        testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'Not registered\n'
        }else{
          this.totalInfo += 'Failed to register OnWillDismissCallback\n';
        }
      })
    }
  }

  onPageShow(): void {
    testNapi2.setNapiCallback({
      fromNapiCallWithStringParam: (value: string): void => {
        this.stateInfos = value;
      }
    });
  }

  build() {
    Column() {
      // 请将$r('app.string.open_custom_dialog')替换为实际资源文件，在本示例中该资源文件的value值为"OpenCustomDialog_CAPI对接示例"
        Text($r('app.string.open_custom_dialog'))
          .fontColor(0x0000FF)
          .height('10%')
          .fontSize(15)
          .margin(10)
          .fontWeight(FontWeight.Bold)
      Column({ space: 10 }) {
        // 请将$r('app.string.configure_popup_properties')替换为实际资源文件，在本示例中该资源文件的value值为"配置弹窗属性"
        Text($r('app.string.configure_popup_properties'))
          .fontSize(20)
          .fontColor(0xCCCCCC)
          .width('100%')
          .margin({ left: 10 })
        Row() {
          // 请将$r('app.string.return_dialog')替换为实际资源文件，在本示例中该资源文件的value值为"设置属性"
          Button($r('app.string.set_properties'))
            .width('30%')
            .margin(10)
            .bindMenu(this.SubMenuAttributeType)
            .onClick(() => {
              if(!this.printDefaultText){
                this.totalInfo +='Default dialog dimensions and border specifications:\n';
                this.totalInfo +='width: 300vp\n';
                this.totalInfo +='height: 200vp\n';
                this.totalInfo +='borderWidth: 2vp\n';
                this.printDefaultText = true;
              }
            })
          // 请将$r('app.string.reset_properties')替换为实际资源文件，在本示例中该资源文件的value值为"重置属性"
          Button($r('app.string.reset_properties'))
            .width('30%')
            .margin(10)
            .onClick(() => {
              testNapi2.CloseCustomDialog();
              this.totalInfo =' ';
              this.isCreateKey = false;
              this.printDefaultText = false;
            })
            .margin({ left: 70 })
        }
        /* 请将$r('app.string.please_input_attribute_value')替换为实际资源文件，
           在本示例中该资源文件的value值为"Close modal → Set keyboard avoidance" */
        TextInput({ placeholder: $r('app.string.please_input_attribute_value') })
          .placeholderColor(Color.Red)
          .width('100%')
          .height(40)
          .margin(10)
          .type(InputType.Password)
          .maxLength(15)
          .showPasswordIcon(true)
          .visibility(this.isCreateKey?Visibility.Visible:Visibility.Hidden)
        // 请将$r('app.string.dialog_state')替换为实际资源文件，在本示例中该资源文件的value值为"弹框状态： "
        Text($r('app.string.dialog_state'))
          .fontSize(15)
          .fontColor(0xCCCCCC)
          .width('100%')
          .height(5)
          .margin({ left: 10 })
        Text(this.place + this.stateInfos)
          .fontSize(15)
          .height(10)
          .fontColor(0xCCCCCC)
          .width('100%')
          .margin({ left: 10 })
        // 请将$r('app.string.settings_result')替换为实际资源文件，在本示例中该资源文件的value值为"属性设置结果： "
        Text($r('app.string.settings_result'))
          .fontSize(15)
          .fontColor(0xCCCCCC)
          .height(5)
          .width('100%')
          .margin({ left: 10 })
        Text(this.place+ this.totalInfo)
          .fontSize(15)
          .fontColor(0xCCCCCC)
          .height(5)
          .width('100%')
          .margin({ left: 10 })
        // 请将$r('app.string.open_dialog')替换为实际资源文件，在本示例中该资源文件的value值为"点此打开弹窗"
        Button($r('app.string.open_dialog'))
          .width('40%')
          .height('10%')
          .margin(150)
          .onClick(() => {
            testNapi2.openCustomDialog();
            if(!this.printDefaultText){
              this.totalInfo +='Default dialog dimensions and border specifications:\n';
              this.totalInfo +='width: 300vp\n';
              this.totalInfo +='height: 200vp\n';
              this.totalInfo +='borderWidth: 2vp\n';
              this.printDefaultText = true;
            }
          })
        // 请将$r('app.string.return_dialog')替换为实际资源文件，在本示例中该资源文件的value值为"返回"
        Button($r('app.string.return_dialog'))
          .width('40%')
          .height('8%')
          .margin({top: -130})
          .onClick(() => {
            this.getUIContext().getRouter().back();
          })
      }
      .height('100%')
      .width('100%')
    }
    .width('100%')
    .height('100%')
  }
}
