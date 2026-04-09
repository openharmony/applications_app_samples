import BaseModel from '../../../../../../../common/utils/src/main/ets/default/model/BaseModel';
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import { SettingItemStyle } from '../../common/constants/StyleConstants'

const TAG = `SettingItemTvModel`;


@Observed
export class SettingItemTvModel extends BaseModel {
  name: string = '' // 设置名

  chooseDes: ResourceStr = '' // 设置选项选择后的描述

  value: string = '' // 设置值

  isOn: boolean = false // 开关状态

  isSelect: boolean = false // 选中状态

  focusIndex: number = -1

  style: SettingItemStyle = SettingItemStyle.default // item类型

  pageUrl: string = '' // 跳转路径

  imageUrl: string = '' // 描述图片路径

  description: string | Resource = '' // 描述

  ips: string[] = [] //ip地址（包含dns、网关、子网掩码等）

  focusKeys: string[] = [] //当前组件绑定的焦点键

  isSetFocusKey: boolean = false // 是否为当前组件设置focusKey，紧针对SettingItemTvComponent组件的title，值取focusKeys的第一个

  isEnable: boolean = true //设置当前item是否可用

  isNeedBg: boolean = true // 是否需要背景色

  isDisableFocus: boolean = false // 是否禁用当前组件获焦

  isShow: boolean = true

  nameId: string = ''

  itemParam: string = '1';

  arrowVisible: Visibility = Visibility.Visible

  textColor: string = ""

  constructor() {
    super();
    LogUtil.info(`${TAG} init`);
  }

  setIsOn = (isOn: boolean): void => {
    this.isOn = isOn
  }
  setIsSelect = (isSelect: boolean): void => {
    this.isSelect = isSelect
  }
  setValue = (value: string): void => {
    this.value = value;
  }
  setChooseDes = (value: string | Resource): void => {
    this.chooseDes = value
  }

  setStyle = (value: SettingItemStyle): void => {
    this.style = value;
  }

  setIsDisableFocus = (value: boolean): void => {
    this.isDisableFocus = value;
  }

  setIsEnable = (flag: boolean): void => {
    this.isEnable = flag;
  }

  setIsShow = (flag: boolean): void => {
    this.isShow = flag;
  }
}