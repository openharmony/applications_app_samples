import { logger } from '../util/Logger';

export class AppLog {
  private myName: string;

  constructor(tag: string) {
    this.myName = tag;
  }

  public log = (msg: string): string => {
    const logMessage = this.myName + ' ' + msg;
    logger.info(this.myName + ' ' + msg);
    return logMessage;
  }
  public check_result = (msg: string, res: object | number | string): string => {
    if (typeof res == 'object') {
      if (res != null) {
        return this.log(msg + ` success !`);
      } else {
        return this.log(msg + ` failed returning with a null object.`);
      }
    } else if (typeof res == 'number') {
      return this.log(msg + ` return: ` + res);
    } else if (typeof res == 'string') {
      return this.log(msg + ` success, result is ` + res);
    } else {
      return this.log(msg + ` unknown result type`);
    }
  }
}
