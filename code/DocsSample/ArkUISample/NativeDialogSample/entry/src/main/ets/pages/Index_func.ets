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
import { hilog } from '@kit.PerformanceAnalysisKit';
import { common } from '@kit.AbilityKit';

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
  @Builder
  SubMenuAttributeType() {
    Menu() {
      MenuItem({ content: '背景颜色：红色' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Background_Color;
        this.nodeValue = 0xFFFF0000;
        const result : number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
      })
      MenuItem({ content: '圆角半径: 15' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Corner_Radius;
        this.nodeValue = 15;
        const result : number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
      })
      MenuItem({ content: '边框颜色：黄色' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Border_Colors;
        this.nodeValue = 0xFFFFFF00;
        const result : number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);

      })
      MenuItem({ content: '边框样式：点状' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Border_Style;
        this.nodeValue = 2;
        const result : number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
      })
      MenuItem({ content: '背板阴影' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Backboard_shadow;
        this.nodeValue = 0;
        const result : number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'ARKUI_SHADOW_STYLE_OUTER_DEFAULT_LG\n';
        }else{
          this.totalInfo += 'Failed to SetShadow\n';
        }
      })
      // 设置自定义弹窗的背板阴影
      MenuItem({ content: '自定义背板阴影' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Backboard_CustomShadow
        this.nodeValue = 0;
        const result : number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'Set custom backboard shadow\n';
        }else{
          this.totalInfo += 'Failed to SetCustomShadow\n';
        }
      })
      MenuItem({ content: '轻薄材质模糊' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Background_Blur_Style;
        this.nodeValue = 4;
        const result : number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'ARKUI_BLUR_STYLE_BACKGROUND_REGULAR\n';
        }else{
          this.totalInfo += 'Failed to SetBackgroundBlurStyle\n';
        }
      })
      MenuItem({ content: '对齐模式：垂直居中开始'}).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Align_mode;
        this.nodeValue = 3;
        testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
      })
      MenuItem({ content: '是否开启模态样式', builder: ():void=>this.SubMenu_Modal_Mode() }).width('50%')
      MenuItem({ content: '遮罩层退出', builder: ():void=>this.SubMenu_Auto_Cancel() }).width('50%')
      MenuItem({ content: '弹窗是否在子窗口显示此弹窗', builder: ():void=>this.SubMenu_Subwindow_Mode() }).width('50%')
      MenuItem({ content: '自定义弹窗遮罩属性', builder: ():void=>this.SubMenu_Mask() }).width('50%')
      MenuItem({ content: '避让键盘的模式', builder: ():void=>this.SubMenu_Keyboard_Avoid_Mode() }).width('50%')
      MenuItem({ content: '是否响应悬停态' }).width('50%').onChange(()=> {
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

      MenuItem({ content: '背景模糊效果', builder: ():void=>this.SubMenu_Background_Blur_Style_Options() }).width('50%')
      MenuItem({ content: '背景效果参数', builder: ():void=>this.SubMenu_Background_Effect() }).width('50%')

      MenuItem({ content: '设置弹窗的显示层级', builder: ():void=>this.SubMenu_Level_Mode() }).width('50%')
      MenuItem({ content: '设置弹窗显示层级页面下的节点id', builder: ():void=>this.SubMenu_Level_Unique_Id() }).width('50%')
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
        const result : number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'Set the dialog to modal mode\n';
        }else{
          this.totalInfo += 'Failed to set the dialog to modal mode\n';
        }
      })
      MenuItem({ content: '关闭' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Modal_Mode;
        this.nodeValue = 0;
        const result : number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
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
        const result : number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'Configure the dialog to dismiss on mask layer click\n';
        }else{
          this.totalInfo += 'Failed to configure the dialog to dismiss on mask layer click\n';
        }
      })
      MenuItem({ content: '关闭' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Auto_Cancel;
        this.nodeValue = 0;
        const result : number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
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
        testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
      })
      MenuItem({ content: '关闭' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Subwindow_Mode;
        this.nodeValue = 0;
        testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
      })
    }
  }

  @Builder
  SubMenu_Mask() {
    Menu() {
      MenuItem({ content: '遮罩属性' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Mask;
        this.nodeValue = 1;
        const result : number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'Set mask property to red\n';
        }else{
          this.totalInfo += 'Failed to set mask property\n';
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
        testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        this.isCreateKey = true;
      })
      MenuItem({ content: '不避让' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Keyboard_Avoid_Mode;
        this.nodeValue = 1;
        testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        this.isCreateKey = true;
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
          this.totalInfo += 'Effective only on foldable screens\n';
        } else {
          this.totalInfo += 'Failed to SetHoverModeEnabled\n';
        }
      })
    }
    Menu() {
      MenuItem({ content: '上半屏' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Hover_Mode_Area;
        this.nodeValue = 1;
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'Effective only on foldable screens\n';
        } else {
          this.totalInfo += 'Failed to SetHoverModeEnabled\n';
        }
      })
    }
  }

  @Builder
  SubMenu_Background_Blur_Style_Options() {
    Menu() {
      MenuItem({ content: '是' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Background_Blur_Style_Options;
        this.nodeValue = 1;
        const result: number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0) {
          this.totalInfo += 'Set background blur effect for the dialog\n';
        } else {
          this.totalInfo += 'Failed to SetBackgroundBlurStyleOptions\n';
        }
      })
    }
  }

  @Builder
  SubMenu_Background_Effect() {
    Menu() {
      MenuItem({ content: '是' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Background_Effect;
        this.nodeValue = 1;
        testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
      })
    }
  }

  @Builder
  SubMenu_Level_Mode() {
    Menu() {
      MenuItem({ content: 'ARKUI_LEVEL_MODE_OVERLAY' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Level_Mode;
        this.nodeValue = 0;
        const result : number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'ARKUI_LEVEL_MODE_OVERLAY\n';
        }else{
          this.totalInfo += 'Failed to SetLevelMode\n';
        }
      })
      MenuItem({ content: 'ARKUI_LEVEL_MODE_EMBEDDED' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Level_Mode;
        this.nodeValue = 1;
        const result : number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'ARKUI_LEVEL_MODE_EMBEDDED\n';
        }else{
          this.totalInfo += 'Failed to SetLevelMode\n';
        }
      })
    }
  }

  @Builder
  SubMenu_Level_Unique_Id() {
    Menu() {
      MenuItem({ content: '0' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Level_Unique_Id;
        this.nodeValue = 0;
        const result : number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'SetLevelUniqueId succeeded\n';
        }else{
          this.totalInfo += 'ailed to SetLevelUniqueId\n';
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
        const result : number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'ARKUI_IMMERSIVE_MODE_DEFAULT\n';
        }else{
          this.totalInfo += 'Failed to SetImmersiveMode\n';
        }
      })
      MenuItem({ content: 'ARKUI_IMMERSIVE_MODE_EXTEND' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Immersive_Mode;
        this.nodeValue = 1;
        const result : number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'ARKUI_IMMERSIVE_MODE_EXTEND\n';
        }else{
          this.totalInfo += 'Failed to SetImmersiveMode\n';
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
        const result : number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'Registered already\n';
        }else{
          this.totalInfo += 'Failed to RegisterOnWillDismissCallback\n';
        }
      })
      MenuItem({ content: '否' }).width('50%').onChange(()=> {
        this.nodeType = CustomDialogAttributeType.Should_Block_Dismiss;
        this.nodeValue = 0
        testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        const result : number = testNapi2.setCustomDialog(this.nodeType, this.nodeValue);
        if (result === 0){
          this.totalInfo += 'Not registered\n'
        }else{
          this.totalInfo += 'Failed to RegisterOnWillDismissCallback\n';
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
      Text('OpenCustomDialog_CAPI对接示例')
        .fontColor(0x0000FF)
        .height('10%')
        .fontSize(24)
        .margin(10)
        .fontWeight(FontWeight.Bold)
      Column({ space: 10 }) {
        Text('配置弹窗属性')
          .fontSize(20)
          .fontColor(0xCCCCCC)
          .width('100%')
          .margin({ left: 10 })
        Row() {
          Button('设置属性')
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
          Button('重置属性')
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
        Text('属性设置结果： \n' + this.totalInfo)
          .fontSize(15)
          .fontColor(0xCCCCCC)
          .height(40)
          .width('100%')
          .margin({ left: 10 })
        Text('弹框状态： \n' + this.stateInfos)
          .fontSize(20)
          .fontColor(0xCCCCCC)
          .width('100%')
          .margin({ left: 400 })
        TextInput({ placeholder: 'input your password...' })
          .width('95%')
          .height(40)
          .margin(20)
          .type(InputType.Password)
          .maxLength(9)
          .showPasswordIcon(true)
          .visibility(this.isCreateKey?Visibility.Visible:Visibility.Hidden)
        Button('点此打开弹窗')
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
      }.margin({
        top: 27,
        left: 12,
        right: 12
      })
      .height('100%')
      .width('100%')
    }
    .width('100%')
    .height('100%')
  }
}
