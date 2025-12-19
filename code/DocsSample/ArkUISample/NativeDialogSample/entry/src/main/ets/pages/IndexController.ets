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

enum ControllerAttributeType {
  Native_Background_Color = 1, // 背景颜色
  Native_Corner_Radius, // 圆角半径
  Native_Border_Colors, // 边框颜色
  Native_Border_Style, // 边框样式
  Native_Backboard_Shadow, // 背板阴影
  Native_Backboard_CustomShadow, // 自定义背板阴影
  Native_Background_Blur_Style, // 背板模糊材质
  Native_Hover_Mode_Enabled, // 是否响应悬停态
  Native_Hover_Mode_Area, // 悬停态下弹窗默认展示区域
  Native_Focusable, // 是否获取焦点
  Native_Background_Blur_Style_Options, // 背景模糊效果
  Native_Background_Effect, // 弹窗的背景效果参数
  Native_Content_Alignment, // 设置自定义弹窗对齐方式。
  Native_Reset_Content_Alignment, // 重置setContentAlignment方法设置的属性，使用系统默认的对齐方式。
  Native_Modal_Mode, // 设置自定义弹窗是否开启模态样式的弹窗
  Native_Auto_Cancel, // 设置自定义弹窗是否允许通过点击遮罩层退出
  Native_Mask, // 设置自定义弹窗遮罩属性
  Native_Column_Count, // 设置弹窗宽度占栅格宽度的个数
  Native_Custom_Style, // 弹窗容器样式是否可以自定义
  Native_Custom_Animation, // 弹窗容器是否使用自定义弹窗动画
  Native_Keyboard_Avoid_Mode, // 设置自定义弹窗避让键盘模式
  Native_Level_Mode, // 设置弹窗的显示层级
  Native_Level_Unique_Id, // 设置弹窗显示层级页面下的节点id
  Native_Immersive_Mode, // 设置嵌入式弹窗蒙层的显示区域
  Native_Level_Order, //设置自定义弹窗显示的顺序
  Native_Register_OnWill_Dismiss, // 当触发系统定义的返回操作、键盘ESC关闭交互操作时，如果注册了该回调函数，弹窗不会立即关闭，而是由用户决定是否关闭。
  Native_Register_OnWill_Dismiss_With_User_Data, // 注册系统关闭自定义弹窗的监听事件
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
      // 设置弹窗背景色
      MenuItem({ content: '背景颜色：白色' }).width('50%').onChange(() => {
        this.nodeType = ControllerAttributeType.Native_Background_Color;
        this.nodeValue = 0xFFFFFFFF;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'Set the background color to white\n';
        }else{
          this.totalInfo += 'Failed to set background color\n';
        }
      })
      MenuItem({ content: '圆角半径: 15' }).width('50%').onChange(() => {
        this.nodeType = ControllerAttributeType.Native_Corner_Radius;
        this.nodeValue = 15;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'Set the corner radius: 15\n';
        }else{
          this.totalInfo += 'Failed to set border radius\n';
        }
      })
      // 设置自定义弹窗对齐方式
      MenuItem({ content: '设置弹窗对齐方式' }).width('50%').onChange(() => {
        this.nodeValue = 0;
        this.nodeType = ControllerAttributeType.Native_Content_Alignment;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'Top center\n';
        } else {
          this.totalInfo += 'Failed to set contentAlignment\n';
        }
      })
      // 重置setContentAlignment方法设置的属性，使用系统默认的对齐方式。
      MenuItem({ content: '使用系统默认的对齐方式' }).width('50%').onChange(() => {
        this.nodeValue = 1;
        this.nodeType = ControllerAttributeType.Native_Reset_Content_Alignment;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'ARKUI_ALIGNMENT_CENTER\n';
        } else {
          this.totalInfo += 'Failed to reset content alignment\n';
        }
      })
      // 设置自定义弹窗是否开启模态样式的弹窗
      MenuItem({ content: '是否开启模态样式的弹窗', builder: (): void => this.SubMenu_Modal_Mode() }).width('50%')
      // 设置自定义弹窗是否允许通过点击遮罩层退出
      MenuItem({ content: '是否允许通过点击遮罩层退出', builder: (): void => this.SubMenu_Auto_Cancel() }).width('50%')
      // 设置自定义弹窗遮罩属性
      MenuItem({ content: '设置自定义弹窗遮罩属性' }).width('50%').onChange(() => {
        this.nodeValue = 1;
        this.nodeType = ControllerAttributeType.Native_Mask;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'Set the overlay color to red\n';
        } else {
          this.totalInfo += 'Failed to set mask\n';
        }
      })
      // 设置弹窗宽度占栅格宽度的个数
      MenuItem({ content: '设置弹窗宽度占栅格宽度的个数' }).width('50%').onChange(() => {
        this.nodeType = ControllerAttributeType.Native_Column_Count;
        this.nodeValue = 20;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'Set the number of grid widths that the popup occupies to 20\n';
        } else {
          this.totalInfo += 'Failed to set grid column count\n';
        }
      })
      // 弹窗容器样式是否可以自定义
      MenuItem({ content: '弹窗容器样式是否可以自定义', builder: (): void => this.SubMenu_Custom_Style() }).width('50%')

      // 弹窗容器是否使用自定义弹窗动画
      MenuItem({ content: '弹窗容器使用自定义弹窗动画' }).width('50%').onChange(() => {
        this.nodeValue = 1;
        this.nodeType = ControllerAttributeType.Native_Custom_Animation;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'Not actually displayed\n';
        } else {
          this.totalInfo += 'Failed to enable custom animation\n';
        }
      })

      // 当触发系统定义的返回操作、键盘ESC关闭交互操作时，如果注册了该回调函数，弹窗不会立即关闭，而是由用户决定是否关闭。
      MenuItem({ content: '系统返回操作关闭弹窗' }).width('50%').onChange(() => {
        this.nodeValue = 1;
        this.nodeType = ControllerAttributeType.Native_Register_OnWill_Dismiss;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'The system-defined back operation closes the dialog\n';
        } else {
          this.totalInfo += 'Failed to registerOnWillDismiss\n';
        }
      })
      // 注册系统关闭自定义弹窗的监听事件
      MenuItem({ content: '注册系统关闭自定义弹窗的监听事件' }).width('50%').onChange(() => {
        this.nodeValue = 1;
        this.nodeType = ControllerAttributeType.Native_Register_OnWill_Dismiss_With_User_Data;
        this.totalInfo += 'true\n';
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'The system-defined back operation does not close the dialog\n';
        } else {
          this.totalInfo += 'Failed to registerOnWillDismiss\n';
        }
      })
      // 设置弹窗的显示层级。
      MenuItem({ content: '设置弹窗的显示层级', builder: (): void => this.SubMenu_Native_Level_Mode() }).width('50%')
      // 设置弹窗显示层级页面下的节点id
      MenuItem({ content: '设置弹窗显示层级页面下的节点id' }).width('50%').onChange(() => {
        this.nodeType = ControllerAttributeType.Native_Level_Unique_Id;
        this.nodeValue = 0;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'Sets the level uniqueId to 0 for a custom dialog box\n';
        } else {
          this.totalInfo += 'Failed to set level unique id\n';
        }
      })
      // 设置嵌入式弹窗蒙层的显示区域
      MenuItem({ content: '设置嵌入式弹窗蒙层的显示区域' }).width('50%').onChange(() => {
        this.nodeType = ControllerAttributeType.Native_Immersive_Mode
        this.nodeValue = 0;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'ARKUI_IMMERSIVE_MODE_DEFAULT\n';
        } else {
          this.totalInfo += 'Failed to set immersive mode\n';
        }
      })
      //设置自定义弹窗显示的顺序
      MenuItem({ content: '设置自定义弹窗显示的顺序' }).width('50%').onChange(() => {
        this.nodeType = ControllerAttributeType.Native_Level_Order;
        this.nodeValue = 0;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'Set the display order of the custom dialog box to 0\n';
        } else {
          this.totalInfo += 'Failed to set level order\n';
        }
      })
      // 设置自定义弹窗的边框颜色
      MenuItem({ content: '边框颜色：黄色' }).width('50%').onChange(() => {
        this.nodeType = ControllerAttributeType.Native_Border_Colors;
        this.nodeValue = 0xFFFFFF00;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'Set border color to yellow\n';
        }else{
          this.totalInfo += 'Failed to set border color\n';
        }
      })
      // 设置自定义弹窗的边框样式
      MenuItem({ content: '边框样式：点状' }).width('50%').onChange(() => {
        this.nodeType = ControllerAttributeType.Native_Border_Style;
        this.nodeValue = 2;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'Set border style to dotted\n';
        }else{
          this.totalInfo += 'Failed to set border style\n';
        }
      })
      // 设置自定义弹窗的背板阴影
      MenuItem({ content: '背板阴影' }).width('50%').onChange(() => {
        this.nodeType = ControllerAttributeType.Native_Backboard_Shadow;
        this.nodeValue = 0;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'ARKUI_SHADOW_STYLE_OUTER_DEFAULT_LG\n';
        }else{
          this.totalInfo += 'Failed to set shadow\n';
        }
      })
      // 设置自定义弹窗的背板阴影
      MenuItem({ content: '自定义背板阴影' }).width('50%').onChange(() => {
        this.nodeType = ControllerAttributeType.Native_Backboard_CustomShadow;
        this.nodeValue = 0;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'Set custom backboard shadow\n';
        }else{
          this.totalInfo += 'Failed to set custom backboard shadow\n';
        }
      })
      // 设置自定义弹窗的背板模糊材质
      MenuItem({ content: '背板模糊材质' }).width('50%').onChange(() => {
        this.nodeType = ControllerAttributeType.Native_Background_Blur_Style;
        this.nodeValue = 0;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'ARKUI_BLUR_STYLE_COMPONENT_ULTRA_THICK\n';
        }else{
          this.totalInfo += 'Failed to set background blur style\n';
        }
      })
      // 设置自定义弹窗避让键盘模式
      MenuItem({ content: '弹窗避让键盘模式' }).width('50%').onChange(() => {
        this.nodeType = ControllerAttributeType.Native_Keyboard_Avoid_Mode;
        this.nodeValue = 1;
        this.isCreateKey = true;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'Do not avoid keyboard mode\n';
        } else {
          this.totalInfo += 'Failed to set avoid keyboard mode\n';
        }
      })
      // 设置自定义弹窗是否响应悬停态
      MenuItem({ content: '响应悬停' }).width('50%').onChange(() => {
        this.nodeType = ControllerAttributeType.Native_Hover_Mode_Enabled;
        this.nodeValue = 1;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'Effective only on foldable screens\n';
        } else {
          this.totalInfo += 'Failed to SetHoverModeEnabled\n';
        }
      })
      // 设置悬停态下自定义弹窗默认展示区域
      MenuItem({ content: '悬停态下弹窗默认展示区域', builder: (): void => this.SubMenu_Hover_Mode_Area() }).width('50%')
      // 设置自定义弹窗是否获取焦点
      MenuItem({ content: '是否获取焦点', builder: (): void => this.SubMenu_Focusable() }).width('50%')
      // 设置自定义弹窗的背景模糊效果
      MenuItem({ content: '设置弹窗的背景模糊效果' }).width('50%').onChange(() => {
        this.nodeType = ControllerAttributeType.Native_Background_Blur_Style_Options;
        this.nodeValue = 1;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'Set background blur effect for the dialog\n';
        } else {
          this.totalInfo += 'Failed to background blur effect\n';
        }
      })
      // 设置自定义弹窗的背景效果参数
      MenuItem({ content: '设置弹窗的背景效果参数' }).width('50%').onChange(() => {
        this.nodeType = ControllerAttributeType.Native_Background_Effect;
        this.nodeValue = 1;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'Set background effect for the dialog\n';
        } else {
          this.totalInfo += 'Failed to background effect\n';
        }
      })
    }
  }

  @Builder
  SubMenu_Hover_Mode_Area() {
    Menu() {
      MenuItem({ content: '上半屏' }).width('50%').onChange(() => {
        this.nodeType = ControllerAttributeType.Native_Hover_Mode_Area;
        this.nodeValue = 0;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'Popup defaults to upper screen area in hover state\n';
        } else {
          this.totalInfo += 'Failed to set hover mode\n';
        }
      })
    }
    Menu() {
      MenuItem({ content: '下半屏' }).width('50%').onChange(() => {
        this.nodeType = ControllerAttributeType.Native_Hover_Mode_Area;
        this.nodeValue = 1;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'Popup defaults to lower screen area in hover state\n';
        } else {
          this.totalInfo += 'Failed to set hover mode\n';
        }
      })
    }
  }

  @Builder
  SubMenu_Focusable() {
    Menu() {
      MenuItem({ content: '是' }).width('50%').onChange(() => {
        this.nodeType = ControllerAttributeType.Native_Focusable;
        this.nodeValue = 1;
        this.isCreateKey = true;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'Focus acquisition succeeded\n';
        } else {
          this.totalInfo += 'Failed to set focusable\n';
        }
      })
    }
    Menu() {
      MenuItem({ content: '否' }).width('50%').onChange(() => {
        this.nodeType = ControllerAttributeType.Native_Focusable;
        this.nodeValue = 0;
        this.isCreateKey = true;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'Disable focus acquisition\n';
        } else {
          this.totalInfo += 'Failed to set focusable\n';
        }
      })
    }
  }

  @Builder
  SubMenu_Modal_Mode() {
    Menu() {
      MenuItem({ content: '是' }).width('50%').onChange(() => {
        this.nodeValue = 1;
        this.nodeType = ControllerAttributeType.Native_Modal_Mode;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'Set the dialog to modal mode\n';
        } else {
          this.totalInfo += 'Failed to set the dialog to modal mode\n';
        }
      })
    }
    Menu() {
      MenuItem({ content: '否' }).width('50%').onChange(() => {
        this.nodeValue = 0;
        this.nodeType = ControllerAttributeType.Native_Modal_Mode;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'Set the dialog to non-modal mode\n';
        } else {
          this.totalInfo += 'Failed to set the dialog to non-modal mode failed\n';
        }
      })
    }
  }

  @Builder
  SubMenu_Auto_Cancel() {
    Menu() {
      MenuItem({ content: '是' }).width('50%').onChange(() => {
        this.nodeValue = 1;
        this.nodeType = ControllerAttributeType.Native_Auto_Cancel;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'Enable closing the modal via overlay click\n';
        } else {
          this.totalInfo += 'Failed to set auto cancel\n';
        }
      })
    }
    Menu() {
      MenuItem({ content: '否' }).width('50%').onChange(() => {
        this.nodeValue = 0;
        this.nodeType = ControllerAttributeType.Native_Auto_Cancel;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'Disable closing the modal via overlay click\n';
        } else {
          this.totalInfo += 'Failed to set auto cancel\n';
        }
      })
    }
  }

  @Builder
  SubMenu_Custom_Style() {
    Menu() {
      MenuItem({ content: '是' }).width('50%').onChange(() => {
        this.nodeValue = 1;
        this.nodeType = ControllerAttributeType.Native_Custom_Style;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'Customize the pop-up container style to have no border\n';
        } else {
          this.totalInfo += 'Failed to set custom style\n';
        }
      })
    }
    Menu() {
      MenuItem({ content: '否' }).width('50%').onChange(() => {
        this.nodeValue = 0;
        this.nodeType = ControllerAttributeType.Native_Custom_Style;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'Customize the pop-up container style to have border\n';
        } else {
          this.totalInfo += 'Failed to set custom style\n';
        }
      })
    }
  }

  @Builder
  SubMenu_Native_Level_Mode() {
    Menu() {
      MenuItem({ content: 'ARKUI_LEVEL_MODE_OVERLAY' }).width('50%').onChange(() => {
        this.nodeType = ControllerAttributeType.Native_Level_Mode;
        this.nodeValue = 0;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'ARKUI_LEVEL_MODE_OVERLAY\n';
        } else {
          this.totalInfo += 'Failed to set level mode\n';
        }
      })
      MenuItem({ content: 'ARKUI_LEVEL_MODE_EMBEDDED' }).width('50%').onChange(() => {
        this.nodeType = ControllerAttributeType.Native_Level_Mode
        this.nodeValue = 1;
        const result: number = testNapi2.setNativeDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'ARKUI_LEVEL_MODE_EMBEDDED\n';
        } else {
          this.totalInfo += 'Failed to set level mode\n';
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
      // 请将$r('app.string.dialog_controller')替换为实际资源文件，在本示例中该资源文件的value值为"CustomDialogController_CAPI对接示例"
        Text($r('app.string.dialog_controller'))
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
          // 请将$r('app.string.set_properties')替换为实际资源文件，在本示例中该资源文件的value值为"设置属性"
          Button($r('app.string.set_properties'))
            .width('30%')
            .margin(10)
            .bindMenu(this.SubMenuAttributeType)
            .onClick(() => {
              if (!this.printDefaultText) {
                this.totalInfo += 'Default dialog dimensions and border specifications:\n';
                this.totalInfo += 'width: 300vp\n';
                this.totalInfo += 'height: 200vp\n';
                this.totalInfo += 'borderWidth: 2vp\n';
                this.printDefaultText = true;
              }
            })
          // 请将$r('app.string.reset_properties')替换为实际资源文件，在本示例中该资源文件的value值为"重置属性"
          Button($r('app.string.reset_properties'))
            .width('30%')
            .margin(10)
            .onClick(() => {
              testNapi2.resetDialogController();
              this.totalInfo = ' ';
              this.isCreateKey = false;
              this.printDefaultText = false;
            })
            .margin({ left: 70 })
        }
        // 请将$r('app.string.please_input_attribute_value')替换为实际资源文件，在本示例中该资源文件的value值为"Close modal → Set keyboard avoidance"
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
            testNapi2.openNativeDialog();
            if (!this.printDefaultText) {
              this.totalInfo += 'Default dialog dimensions and border specifications:\n';
              this.totalInfo += 'width: 300vp\n';
              this.totalInfo += 'height: 200vp\n';
              this.totalInfo += 'borderWidth: 2vp\n';
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
