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


export class VirtualDeviceType {
  //设备标识
  public readonly name: string;
  //设备名
  public readonly desc: Resource;
  //设备图标
  public readonly image: Resource;

  constructor(name: string, desc: Resource, image: Resource) {
    this.name = name;
    this.desc = desc;
    this.image = image;
  }
}


export class VirtualDeviceTypes {
  public static BIG_SCREEN: VirtualDeviceType =
    new VirtualDeviceType('BIG_SCREEN', $r('app.string.type_big_screen'), $r('app.media.ic_big_screen'));
  public static CAMERA: VirtualDeviceType =
    new VirtualDeviceType('CAMERA', $r('app.string.type_camera'), $r('app.media.ic_camera'));
  public static CONTROLLER: VirtualDeviceType =
    new VirtualDeviceType('CONTROLLER', $r('app.string.type_controller'), $r('app.media.ic_controller'));
  public static DEVELOPMENT_BOARD: VirtualDeviceType =
    new VirtualDeviceType('DEVELOPMENT_BOARD', $r('app.string.type_controller'), $r('app.media.ic_development_board'));
  public static GATE: VirtualDeviceType =
    new VirtualDeviceType('GATE', $r('app.string.type_gate'), $r('app.media.ic_gate'));
  public static PEN: VirtualDeviceType =
    new VirtualDeviceType('PEN', $r('app.string.type_pen'), $r('app.media.ic_pen'));
  public static POS: VirtualDeviceType =
    new VirtualDeviceType('POS', $r('app.string.type_pos'), $r('app.media.ic_pos'));
  public static PRINTER: VirtualDeviceType =
    new VirtualDeviceType('PRINTER', $r('app.string.type_printer'), $r('app.media.ic_printer'));
  public static SCREEN: VirtualDeviceType =
    new VirtualDeviceType('SCREEN', $r('app.string.type_screen'), $r('app.media.ic_small_screen'));
  public static SOUND: VirtualDeviceType =
    new VirtualDeviceType('SOUND', $r('app.string.type_sound'), $r('app.media.ic_sound'));
  public static STUDENT_CARD: VirtualDeviceType =
    new VirtualDeviceType('STUDENT_CARD', $r('app.string.type_student_card'), $r('app.media.ic_student_card'));
  public static TEST_BOX: VirtualDeviceType =
    new VirtualDeviceType('TEST_BOX', $r('app.string.type_test_box'), $r('app.media.ic_test_box'));
  public static WATCH: VirtualDeviceType =
    new VirtualDeviceType('WATCH', $r('app.string.type_watch'), $r('app.media.ic_watch'));
  //所有设备类型集合
  public static ALL_DEVICE_TYPES_ARR: Array<VirtualDeviceType> = [
    VirtualDeviceTypes.BIG_SCREEN,
    VirtualDeviceTypes.CAMERA,
    VirtualDeviceTypes.CONTROLLER,
    VirtualDeviceTypes.DEVELOPMENT_BOARD,
    VirtualDeviceTypes.GATE,
    VirtualDeviceTypes.PEN,
    VirtualDeviceTypes.POS,
    VirtualDeviceTypes.PRINTER,
    VirtualDeviceTypes.SCREEN,
    VirtualDeviceTypes.SOUND,
    VirtualDeviceTypes.STUDENT_CARD,
    VirtualDeviceTypes.TEST_BOX,
    VirtualDeviceTypes.WATCH,
  ];
}

