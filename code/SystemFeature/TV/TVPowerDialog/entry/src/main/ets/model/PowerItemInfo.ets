@Observed
export class PowerItemInfo {
  icon: string
  onFocusIcon: string
  isFocus: boolean
  name: string
  operationType: number

  constructor(icon: string, onFocusIcon: string, isFocus: boolean, name: string, operationType: number) {
    this.icon = icon;
    this.onFocusIcon = onFocusIcon;
    this.isFocus = isFocus;
    this.name = name;
    this.operationType = operationType;
  }
}