@Observed
export class PowerItemInfo {
  public icon: string
  public onFocusIcon: string
  public isFocus: boolean
  public name: string
  public operationType: number

  constructor(icon: string, onFocusIcon: string, isFocus: boolean, name: string, operationType: number) {
    this.icon = icon;
    this.onFocusIcon = onFocusIcon;
    this.isFocus = isFocus;
    this.name = name;
    this.operationType = operationType;
  }
}