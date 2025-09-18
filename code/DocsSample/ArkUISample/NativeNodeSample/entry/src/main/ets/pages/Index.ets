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
import testNapi from 'libentry.so';
import node from '@ohos.arkui.node';

function isValidType(id: number) : boolean {
  if (id !== -1) { // -1 means invalid type
    return true;
  }
  return false;
}

function getNodeType(type: string) : number {
  let ret = -1;
  switch (type) {
    case 'TIME_PICKER':
      ret = 14;
      break;
    case 'TEXT_PICKER':
      ret = 15;
      break;
    case 'CALENDAR_PICKER':
      ret = 16;
      break;
    case 'SLIDER':
      ret = 17;
      break;
    case 'IMAGE_ANIMATOR':
      ret = 19;
      break;
    case 'IMAGE':
      ret = 4;
      break;
    default:
      break;
  }
  return ret;
}

const SUCC_TAG = '创建成功';
const FAIL_TAG = '创建失败';
const CREATE_TAG = '请创建节点';

@Entry
@Component
struct Index {
  @State nodeId: number = -1;
  @State nodeStatus: string = FAIL_TAG;
  @State curNodeType: string = '未设置';
  @State attributeType: string = '未设置';
  @State attributeTypeId: number = -1;
  @State attributeValue: string = '-1';
  @State resultValue: string = '-1';
  @State curAttrStatus: number = -1;

  @Builder
  SubMenuNodeType() {
    Menu() {
      MenuItem({ content: 'TIME_PICKER' }).width('50%').onChange(()=> { this.curNodeType = 'TIME_PICKER'})
      MenuItem({ content: 'TEXT_PICKER'}).width('50%').onChange(()=> { this.curNodeType = 'TEXT_PICKER' })
      MenuItem({ content: 'CALENDAR_PICKER'}).width('50%').onChange(()=> { this.curNodeType = 'CALENDAR_PICKER' })
      MenuItem({ content: 'IMAGE_ANIMATOR'}).width('50%').onChange(()=> { this.curNodeType = 'IMAGE_ANIMATOR' })
      MenuItem({ content: 'IMAGE'}).width('50%').onChange(()=> { this.curNodeType = 'IMAGE' })
      MenuItem({ content: 'SLIDER'}).width('50%').onChange(()=> { this.curNodeType = 'SLIDER' })
    }
  }

  @Builder
  SubMenuAttributeType() {
    Menu() {
      MenuItem({ content: 'TIME_PICKER', builder: ():void=>this.SubMenu_TIME_PICKER() }).width('50%')
      MenuItem({ content: 'TEXT_PICKER', builder: ():void=>this.SubMenu_TIME_PICKER() }).width('50%')
      MenuItem({ content: 'CALENDAR_PICKER', builder: ():void=>this.SubMenu_TIME_PICKER() }).width('50%')
      MenuItem({ content: 'IMAGE_ANIMATOR', builder: ():void=>this.SubMenu_TIME_PICKER() }).width('50%')
      MenuItem({ content: 'IMAGE', builder: ():void=>this.SubMenu_IMAGE() }).width('50%')
      MenuItem({ content: 'BLOCK_LINEAR_GRADIENT_COLOR' }).width('50%').onChange(()=> {
        this.attributeType = 'BLOCK_LINEAR_GRADIENT_COLOR'
        this.attributeTypeId = 17016
      })
      MenuItem({ content: 'TRACK_LINEAR_GRADIENT_COLOR' }).width('50%').onChange(()=> {
        this.attributeType = 'TRACK_LINEAR_GRADIENT_COLOR'
        this.attributeTypeId = 17017
      })
      MenuItem({ content: 'SELECTED_LINEAR_GRADIENT_COLOR' }).width('50%').onChange(()=> {
        this.attributeType = 'SELECTED_LINEAR_GRADIENT_COLOR'
        this.attributeTypeId = 17018
      })
    }
  }
  // add image attributeType
  @Builder
  SubMenu_IMAGE() {
    Menu() {
      MenuItem({ content: 'SRC' }).width('50%').onChange(()=> {
        this.attributeType = 'SRC'
        this.attributeTypeId = 4000
      })
      MenuItem({ content: 'OBJECT_FIT' }).width('50%').onChange(()=> {
        this.attributeType = 'OBJECT_FIT'
        this.attributeTypeId = 4001
      })
      MenuItem({ content: 'INTERPOLATION' }).width('50%').onChange(()=> {
        this.attributeType = 'INTERPOLATION'
        this.attributeTypeId = 4002
      })
      MenuItem({ content: 'OBJECT_REPEAT' }).width('50%').onChange(()=> {
        this.attributeType = 'OBJECT_REPEAT'
        this.attributeTypeId = 4003
      })
      MenuItem({ content: 'COLOR_FILTER' }).width('50%').onChange(()=> {
        this.attributeType = 'COLOR_FILTER'
        this.attributeTypeId = 4004
      })
      MenuItem({ content: 'AUTO_RESIZE' }).width('50%').onChange(()=> {
        this.attributeType = 'AUTO_RESIZE'
        this.attributeTypeId = 4005
      })
      MenuItem({ content: 'ALT' }).width('50%').onChange(()=> {
        this.attributeType = 'ALT'
        this.attributeTypeId = 4006
      })
      MenuItem({ content: 'DRAGGABLE' }).width('50%').onChange(()=> {
        this.attributeType = 'DRAGGABLE'
        this.attributeTypeId = 4007
      })
      MenuItem({ content: 'RENDER_MODE' }).width('50%').onChange(()=> {
        this.attributeType = 'RENDER_MODE'
        this.attributeTypeId = 4008
      })
      MenuItem({ content: 'FIT_ORIGINAL_SIZE' }).width('50%').onChange(()=> {
        this.attributeType = 'FIT_ORIGINAL_SIZE'
        this.attributeTypeId = 4009
      })
      MenuItem({ content: 'FILL_COLOR' }).width('50%').onChange(()=> {
        this.attributeType = 'FILL_COLOR'
        this.attributeTypeId = 4010
      })
      MenuItem({ content: 'RESIZABLE' }).width('50%').onChange(()=> {
        this.attributeType = 'RESIZABLE'
        this.attributeTypeId = 4011
      })
      MenuItem({ content: 'SYNC_LOAD' }).width('50%').onChange(()=> {
        this.attributeType = 'SYNC_LOAD'
        this.attributeTypeId = 4012
      })
      MenuItem({ content: 'SOURCE_SIZE' }).width('50%').onChange(()=> {
        this.attributeType = 'SOURCE_SIZE'
        this.attributeTypeId = 4013
      })
      MenuItem({ content: 'IMAGE_MATRIX' }).width('50%').onChange(()=> {
        this.attributeType = 'IMAGE_MATRIX'
        this.attributeTypeId = 4014
      })
      MenuItem({ content: 'MATCH_TEXT_DIRECTION' }).width('50%').onChange(()=> {
        this.attributeType = 'MATCH_TEXT_DIRECTION'
        this.attributeTypeId = 4015
      })
      MenuItem({ content: 'COPY_OPTION' }).width('50%').onChange(()=> {
        this.attributeType = 'COPY_OPTION'
        this.attributeTypeId = 4016
      })
      MenuItem({ content: 'ENABLE_ANALYZER' }).width('50%').onChange(()=> {
        this.attributeType = 'ENABLE_ANALYZER'
        this.attributeTypeId = 4017
      })
      MenuItem({ content: 'DYNAMIC_RANGE_MODE' }).width('50%').onChange(()=> {
        this.attributeType = 'DYNAMIC_RANGE_MODE'
        this.attributeTypeId = 4018
      })
      MenuItem({ content: 'HDR_BRIGHTNESS' }).width('50%').onChange(()=> {
        this.attributeType = 'HDR_BRIGHTNESS'
        this.attributeTypeId = 4019
      })
      MenuItem({ content: 'ORIENTATION' }).width('50%').onChange(()=> {
        this.attributeType = 'ORIENTATION'
        this.attributeTypeId = 4020
      })
    }
  }
  @Builder
  SubMenu_TIME_PICKER() {
    Menu() {
      MenuItem({ content: 'SELECTED' }).width('50%').onChange(()=> {
        this.attributeType = 'SELECTED'
        this.attributeTypeId = 14000
      })
      MenuItem({ content: 'USE_MILITARY_TIME' }).width('50%').onChange(()=> {
        this.attributeType = 'USE_MILITARY_TIME'
        this.attributeTypeId = 14001
      })
      MenuItem({ content: 'DISAPPEAR_TEXT_STYLE' }).width('50%').onChange(()=> {
        this.attributeType = 'DISAPPEAR_TEXT_STYLE'
        this.attributeTypeId = 14002
      })
      MenuItem({ content: 'TEXT_STYLE' }).width('50%').onChange(()=> {
        this.attributeType = 'TEXT_STYLE'
        this.attributeTypeId = 14003
      })
      MenuItem({ content: 'SELECTED_TEXT_STYLE' }).width('50%').onChange(()=> {
        this.attributeType = 'SELECTED_TEXT_STYLE'
        this.attributeTypeId = 14004
      })
      MenuItem({ content: 'START' }).width('50%').onChange(()=> {
        this.attributeType = 'START'
        this.attributeTypeId = 14005
      })
      MenuItem({ content: 'END' }).width('50%').onChange(()=> {
        this.attributeType = 'END'
        this.attributeTypeId = 14006
      })
      MenuItem({ content: 'ENABLE_CASCADE' }).width('50%').onChange(()=> {
        this.attributeType = 'ENABLE_CASCADE'
        this.attributeTypeId = 14007
      })
    }
  }

  @Builder
  SubMenu_TEXT_PICKER() {
    Menu() {
      MenuItem({ content: 'OPTION_RANGE' }).width('50%').onChange(()=> {
        this.attributeType = 'OPTION_RANGE'
        this.attributeTypeId = 15000
      })
      MenuItem({ content: 'OPTION_SELECTED' }).width('50%').onChange(()=> {
        this.attributeType = 'OPTION_SELECTED'
        this.attributeTypeId = 15001
      })
      MenuItem({ content: 'OPTION_VALUE' }).width('50%').onChange(()=> {
        this.attributeType = 'OPTION_VALUE'
        this.attributeTypeId = 15002
      })
      MenuItem({ content: 'DISAPPEAR_TEXT_STYLE' }).width('50%').onChange(()=> {
        this.attributeType = 'DISAPPEAR_TEXT_STYLE'
        this.attributeTypeId = 15003
      })
      MenuItem({ content: 'TEXT_STYLE' }).width('50%').onChange(()=> {
        this.attributeType = 'TEXT_STYLE'
        this.attributeTypeId = 15004
      })
      MenuItem({ content: 'SELECTED_TEXT_STYLE' }).width('50%').onChange(()=> {
        this.attributeType = 'SELECTED_TEXT_STYLE'
        this.attributeTypeId = 15005
      })
      MenuItem({ content: 'SELECTED_INDEX' }).width('50%').onChange(()=> {
        this.attributeType = 'SELECTED_INDEX'
        this.attributeTypeId = 15006
      })
      MenuItem({ content: 'CAN_LOOP' }).width('50%').onChange(()=> {
        this.attributeType = 'CAN_LOOP'
        this.attributeTypeId = 15007
      })
      MenuItem({ content: 'DEFAULT_PICKER_ITEM_HEIGHT' }).width('50%').onChange(()=> {
        this.attributeType = 'DEFAULT_PICKER_ITEM_HEIGHT'
        this.attributeTypeId = 15008
      })
      MenuItem({ content: 'COLUMN_WIDTHS' }).width('50%').onChange(()=> {
        this.attributeType = 'COLUMN_WIDTHS'
        this.attributeTypeId = 15009
      })
      MenuItem({ content: 'ENABLE_HAPTIC_FEEDBACK' }).width('50%').onChange(()=> {
        this.attributeType = 'ENABLE_HAPTIC_FEEDBACK'
        this.attributeTypeId = 15010
      })
      MenuItem({ content: 'SELECTED_BACKGROUND_STYLE' }).width('50%').onChange(()=> {
        this.attributeType = 'SELECTED_BACKGROUND_STYLE'
        this.attributeTypeId = 15011
      })
    }
  }

  @Builder
  SubMenu_CALENDAR_PICKER() {
    Menu() {
      MenuItem({ content: 'HINT_RADIUS' }).width('50%').onChange(()=> {
        this.attributeType = 'HINT_RADIUS'
        this.attributeTypeId = 16000
      })
      MenuItem({ content: 'SELECTED_DATE' }).width('50%').onChange(()=> {
        this.attributeType = 'SELECTED_DATE'
        this.attributeTypeId = 16001
      })
      MenuItem({ content: 'EDGE_ALIGNMENT' }).width('50%').onChange(()=> {
        this.attributeType = 'EDGE_ALIGNMENT'
        this.attributeTypeId = 16002
      })
      MenuItem({ content: 'TEXT_STYLE' }).width('50%').onChange(()=> {
        this.attributeType = 'TEXT_STYLE'
        this.attributeTypeId = 16003
      })
      MenuItem({ content: 'START' }).width('50%').onChange(()=> {
        this.attributeType = 'START'
        this.attributeTypeId = 16004
      })
      MenuItem({ content: 'END' }).width('50%').onChange(()=> {
        this.attributeType = 'END'
        this.attributeTypeId = 16005
      })
      MenuItem({ content: 'DISABLED_DATE_RANGE' }).width('50%').onChange(()=> {
        this.attributeType = 'DISABLED_DATE_RANGE'
        this.attributeTypeId = 16006
      })
      MenuItem({ content: 'MARK_TODAY' }).width('50%').onChange(()=> {
        this.attributeType = 'MARK_TODAY'
        this.attributeTypeId = 16007
      })
    }
  }

  @Builder
  SubMenu_IMAGE_ANIMATOR() {
    Menu() {
      MenuItem({ content: 'IMAGES' }).width('50%').onChange(()=> {
        this.attributeType = 'IMAGES'
        this.attributeTypeId = 19000
      })
      MenuItem({ content: 'STATE' }).width('50%').onChange(()=> {
        this.attributeType = 'STATE'
        this.attributeTypeId = 19001
      })
      MenuItem({ content: 'DURATION' }).width('50%').onChange(()=> {
        this.attributeType = 'DURATION'
        this.attributeTypeId = 19002
      })
      MenuItem({ content: 'REVERSE' }).width('50%').onChange(()=> {
        this.attributeType = 'REVERSE'
        this.attributeTypeId = 19003
      })
      MenuItem({ content: 'FIXED_SIZE' }).width('50%').onChange(()=> {
        this.attributeType = 'FIXED_SIZE'
        this.attributeTypeId = 19004
      })
      MenuItem({ content: 'FILL_MODE' }).width('50%').onChange(()=> {
        this.attributeType = 'FILL_MODE'
        this.attributeTypeId = 19005
      })
      MenuItem({ content: 'ITERATION' }).width('50%').onChange(()=> {
        this.attributeType = 'ITERATION'
        this.attributeTypeId = 19006
      })
    }
  }


  build() {
    Column() {
      Text('native_node功能示例')
        .fontSize(24)
        .margin(10)
        .fontWeight(FontWeight.Bold)
        .height('10%')
      Row() {
        Column() {
          Button('选择节点类型:')
            .width('50%')
            .margin({ left: 10 })
            .bindMenu(this.SubMenuNodeType)
          Text(`当前类型: ${this.curNodeType}`)
            .fontSize(14)
            .margin(10)
          Text(`当前状态: ${this.nodeStatus}`)
            .fontSize(14)
            .margin(10)

          Row() {
            Button('创建')
              .width('30%')
              .margin(10)
              .onClick(() => {
                // 先将之前创建的节点清理
                testNapi.removeOldNode(this.nodeId);
                this.nodeId = -1;
                // 创建新节点
                this.nodeId = testNapi.createNativeNode(getNodeType(this.curNodeType))
                this.nodeStatus = (this.nodeId == -1) ? FAIL_TAG : SUCC_TAG;
              })
            Button('重置')
              .width('30%')
              .margin(10)
              .onClick(() => {
                // 重置新节点
                this.nodeId = testNapi.resetNativeNodeAttribute(this.nodeId, getNodeType(this.curNodeType),
                  this.attributeTypeId)
                this.nodeStatus = (this.nodeId == -1) ? FAIL_TAG : SUCC_TAG;
                console.log("----- resetNativeNodeAttribute",this.nodeId)
              })
            Button('清理')
              .width('30%')
              .margin(10)
              .onClick(() => {
                testNapi.removeOldNode(this.nodeId);
                this.nodeId = -1;
                this.nodeStatus = FAIL_TAG;
                this.attributeType = '未设置';
              })

          }

        }
        .width('50%')

        Column() {
          Button('选择节点属性:')
            .width('50%')
            .margin({ left: 10 })
            .bindMenu(this.SubMenuAttributeType)
          Text(`当前属性类型: ${this.attributeType}`)
            .fontSize(14)
            .margin(10)
          Text(`返回错误码: ${this.curAttrStatus}`)
            .fontSize(14)
            .margin(5)
          // 添加用户输入框
          Row() {
            Text('属性值:')
              .alignSelf(ItemAlign.End)
              .fontSize(14)
            TextInput({ placeholder: '请输入属性值', text: this.attributeValue })
              .width('60%')
              .height(40)
              .onChange((value: string) => {
                this.attributeValue = value;
              })
          }
          .width('100%')
          .margin(20)
          .justifyContent(FlexAlign.End)

          Button('设置属性值')
            .margin(25)
            .alignSelf(ItemAlign.End)
            .onClick(
              () => {
                this.curAttrStatus = -1;
                this.curAttrStatus = testNapi.setNativeNodeAttribute(this.nodeId, getNodeType(this.curNodeType),
                  this.attributeTypeId, this.attributeValue);
                console.log("----- setNativeNodeAttribute ",this.nodeId, getNodeType(this.curNodeType),
                  this.attributeTypeId, this.attributeValue)
              }
            )
          Button('获取属性值')
            .margin(20)
            .alignSelf(ItemAlign.End)
            .onClick(
              () => {
                this.resultValue = testNapi.getNativeNodeAttribute(this.nodeId, getNodeType(this.curNodeType),
                  this.attributeTypeId);
                console.log("-----getNativeNodeAttribute:",this.resultValue)
              }
            )
          Text(`返回值: ${this.resultValue}`)
            .fontSize(14)
            .margin(5)
        }
        .width('50%')
      }
      .height('30%')

      XComponent({
        id: "xComponent",
        type: XComponentType.NODE,
        libraryname: "entry"
      }).onAppear(()=> {
      })
        .position({x:10,y:300})
      .width('60%')
      .height('40%')
    }
  }
}
