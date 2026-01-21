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

// [Start Custom_Block_Menus]
// xxx.ets
@Entry
@Component
export struct CustomAndBlockMenus {
  private static readonly CREATE_MENU_ITEM_ID_1: string = 'create1';
  private static readonly CREATE_MENU_ITEM_ID_2: string = 'create2';
  private static readonly PREPARE_MENU_ITEM_ID: string = 'prepare1';
  @State private text: string = 'Text editMenuOptions';
  @State private endIndex: number = 0;
  @State blockCallbackText: string = '';

  // 创建菜单项辅助方法
  private createMenuItem(id: string, content: string): TextMenuItem {
    // $r('app.media.startIcon')需要替换为开发者所需的图像资源文件
    return {
      content: content,
      icon: $r('app.media.startIcon'),
      id: TextMenuItemId.of(id)
    };
  }

  // 查找菜单项索引
  private findMenuItemIndex(menuItems: Array<TextMenuItem>, menuItemId: TextMenuItemId): number {
    return menuItems.findIndex((item: TextMenuItem) => item.id.equals(menuItemId));
  }

  // 创建菜单回调
  private onCreateMenu = (menuItems: Array<TextMenuItem>): Array<TextMenuItem> => {
    const createItem1: TextMenuItem = this.createMenuItem(
      CustomAndBlockMenus.CREATE_MENU_ITEM_ID_1,
      'create1'
    );

    const createItem2: TextMenuItem = this.createMenuItem(
      CustomAndBlockMenus.CREATE_MENU_ITEM_ID_2,
      'create2'
    );

    // 添加自定义菜单项
    menuItems.push(createItem1);
    menuItems.unshift(createItem2);

    // 移除不需要的系统菜单项
    this.removeMenuItemById(menuItems, TextMenuItemId.AI_WRITER);
    this.removeMenuItemById(menuItems, TextMenuItemId.TRANSLATE);

    return menuItems;
  }

  // 移除指定菜单项
  private removeMenuItemById(menuItems: Array<TextMenuItem>, menuItemId: TextMenuItemId): void {
    const targetIndex: number = this.findMenuItemIndex(menuItems, menuItemId);
    if (targetIndex !== -1) {
      menuItems.splice(targetIndex, 1);
    }
  }

  // 菜单项点击回调
  private onMenuItemClick = (menuItem: TextMenuItem, textRange: TextRange): boolean => {
    const menuItemId: TextMenuItemId = menuItem.id;

    // 处理自定义菜单项
    if (menuItemId.equals(TextMenuItemId.of(CustomAndBlockMenus.CREATE_MENU_ITEM_ID_2))) {
      let msg = '拦截 id: create2 start:' + textRange.start + '; end:' + textRange.end;
      this.blockCallbackText = msg
      return true;
    }

    if (menuItemId.equals(TextMenuItemId.of(CustomAndBlockMenus.PREPARE_MENU_ITEM_ID))) {
      let msg = '拦截 id: prepare1 start:' + textRange.start + '; end:+' + textRange.end;
      this.blockCallbackText = msg
      return true;
    }

    // 处理系统菜单项
    if (menuItemId.equals(TextMenuItemId.COPY)) {
      let msg = '拦截 COPY start:' + textRange.start + '; end:' + textRange.end;
      this.blockCallbackText = msg
      return true;
    }

    if (menuItemId.equals(TextMenuItemId.SELECT_ALL)) {
      let msg = '不拦截 SELECT_ALL start:' + textRange.start + '; end:' + textRange.end;
      this.blockCallbackText = msg
      return false;
    }

    return false;
  }
  // 准备菜单回调
  private onPrepareMenu = (menuItems: Array<TextMenuItem>): Array<TextMenuItem> => {
    const prepareItem: TextMenuItem = this.createMenuItem(
      CustomAndBlockMenus.PREPARE_MENU_ITEM_ID,
      `prepare1_${this.endIndex}`
    );

    menuItems.unshift(prepareItem);
    return menuItems;
  }
  // 编辑菜单选项
  @State private editMenuOptions: EditMenuOptions = {
    onCreateMenu: this.onCreateMenu,
    onMenuItemClick: this.onMenuItemClick,
    onPrepareMenu: this.onPrepareMenu
  };
  // 文本选择变化回调
  private onTextSelectionChange = (selectionStart: number, selectionEnd: number): void => {
    this.endIndex = selectionEnd;
  }

  build() {
    NavDestination() {
      Column() {
        Text(this.text)
          .fontSize(20)
          .copyOption(CopyOptions.LocalDevice)
          .editMenuOptions(this.editMenuOptions)
          .margin({ top: 100 })
          .onTextSelectionChange(this.onTextSelectionChange)
        Text(this.blockCallbackText).borderWidth(1)
      }
      .width('90%')
      .margin('5%')
    }
  }
}
// [End Custom_Block_Menus]