import BaseModel from './BaseModel';
import { SettingItemStyle } from './StyleConstants'

const TAG = `SettingItemTvModel`;


@Observed
export class SettingItemTvModel extends BaseModel {
  public name: string = '' // 设置名

  public chooseDes: ResourceStr = '' // 设置选项选择后的描述

  public value: string = '' // 设置值

  public isOn: boolean = false // 开关状态

  public isSelect: boolean = false // 选中状态

  public focusIndex: number = -1

  public style: SettingItemStyle = SettingItemStyle.default // item类型

  public pageUrl: string = '' // 跳转路径

  public imageUrl: string = '' // 描述图片路径

  public description: string | Resource = '' // 描述

  public ips: string[] = [] //ip地址（包含dns、网关、子网掩码等）

  public focusKeys: string[] = [] //当前组件绑定的焦点键

  public isSetFocusKey: boolean = false // 是否为当前组件设置focusKey，紧针对SettingItemTvComponent组件的title，值取focusKeys的第一个

  public isEnable: boolean = true //设置当前item是否可用

  public isNeedBg: boolean = true // 是否需要背景色

  public isDisableFocus: boolean = false // 是否禁用当前组件获焦

  public isShow: boolean = true

  public nameId: string = ''

  public itemParam: string = '1';

  public arrowVisible: Visibility = Visibility.Visible

  public textColor: string = ''

  constructor() {
    super();
    console.info(`${TAG} init`);
  }

  public setIsOn = (isOn: boolean): void => {
    this.isOn = isOn
  }
  public setIsSelect = (isSelect: boolean): void => {
    this.isSelect = isSelect
  }
  public setValue = (value: string): void => {
    this.value = value;
  }
  public setChooseDes = (value: string | Resource): void => {
    this.chooseDes = value
  }

  public setStyle = (value: SettingItemStyle): void => {
    this.style = value;
  }

  public setIsDisableFocus = (value: boolean): void => {
    this.isDisableFocus = value;
  }

  public setIsEnable = (flag: boolean): void => {
    this.isEnable = flag;
  }

  public setIsShow = (flag: boolean): void => {
    this.isShow = flag;
  }
}