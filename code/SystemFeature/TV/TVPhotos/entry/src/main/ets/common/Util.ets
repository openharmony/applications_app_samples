import Logger from '../common/Logger';
import { systemDateTime } from '@kit.BasicServicesKit';
import { Context } from '@kit.AbilityKit';
import { intl } from '@kit.LocalizationKit';

const TAG: string = 'common_Util';

export class Util {
  public static readonly MILLISECONDS_PER_SECOND: number = 1000;
  public static readonly SECONDS_PER_MINUTE: number = 60;
  public static readonly SECONDS_PER_HOUR: number = 3600;
  public static readonly SECONDS_PER_DAY: number = 3600 * 24;
  public static readonly ALL_REMAINING_DAYS: number = 30;

  // Format duration
  public static getFormattedDuration(milliSecond: number): string {
    if (milliSecond == null) {
      Logger.error(TAG, 'getFormattedDuration, input is null!');
      return '00:00';
    }
    if (milliSecond <= 0) {
      Logger.error(TAG, 'getFormattedDuration, input is negative number!');
      return '00:00';
    }
    if (milliSecond < Util.MILLISECONDS_PER_SECOND) {
      return '00:01';
    }
    let seconds = Math.floor(milliSecond / Util.MILLISECONDS_PER_SECOND);
    let hourTime: number = Math.floor(seconds / Util.SECONDS_PER_HOUR);
    let minuteTime: number = Math.floor(Math.floor(seconds / Util.SECONDS_PER_MINUTE) % Util.SECONDS_PER_MINUTE);
    let secondTime: number = Math.floor(seconds % Util.SECONDS_PER_MINUTE);
    if (hourTime > 0) {
      return `${hourTime}:${Util.checkTime(minuteTime)}:${Util.checkTime(secondTime)}`;
    } else {
      return `${Util.checkTime(minuteTime)}:${Util.checkTime(secondTime)}`;
    }
  }

  public static getRemainingDays(context: Context, trashTime: number) {
    let currentTime = systemDateTime.getTime(false);
    let time =
      (Util.ALL_REMAINING_DAYS * Util.SECONDS_PER_DAY * Util.MILLISECONDS_PER_SECOND - (currentTime - trashTime)) /
      Util.MILLISECONDS_PER_SECOND;
    let days: number = Math.floor(time / Util.SECONDS_PER_DAY);
    time %= Util.SECONDS_PER_DAY;
    let hours: number = Math.floor(time / Util.SECONDS_PER_HOUR);
    time %= Util.SECONDS_PER_HOUR;
    let minutes: number = Math.floor(time / Util.SECONDS_PER_MINUTE);
    if (days > 0) {
      if (days >= Util.ALL_REMAINING_DAYS) {
        return '';
      }
      return days + context.resourceManager.getStringSync($r('app.string.unit_day'));
    } else if (hours > 0) {
      return hours + context.resourceManager.getStringSync($r('app.string.unit_hour'));
    } else if (minutes > 0) {
      return minutes + context.resourceManager.getStringSync($r('app.string.unit_minute'));
    } else {
      return '';
    }
  }

  //return 年月日
  public static getDateFormatString(time: number): string {
    let dateString = time.toString();
    const year = parseInt(dateString.substring(0, 4), 10);
    const month = parseInt(dateString.substring(4, 6), 10) - 1;
    const day = parseInt(dateString.substring(6, 8), 10);
    const dateObject = new Date(year, month, day);
    let dateFormat = new intl.DateTimeFormat('zh-CN', { dateStyle: 'long' });
    let dateStr = dateFormat.format(dateObject);
    return dateStr;
  }

  public static isToday(time: number): boolean {
    let currentTime = systemDateTime.getTime(false);
    let currentDate = new Date(currentTime);
    const year = currentDate.getFullYear();
    let month = (currentDate.getMonth() + 1).toString();
    let day = currentDate.getDate().toString();
    if (month.length < 2) {
      month = '0' + month;
    }
    if (day.length < 2) {
      day = '0' + day;
    }
    let dateStr = year + month + day;
    return time === Number.parseInt(dateStr);
  }

  public static isYesterday(time: number): boolean {
    let currentTime = systemDateTime.getTime(false);
    let currentDate = new Date(currentTime);
    const year = currentDate.getFullYear();
    let month = (currentDate.getMonth() + 1).toString(); // getMonth() 返回的月份是从0开始的，所以需要加1
    let day = currentDate.getDate().toString();
    if (month.length < 2) {
      month = '0' + month;
    }
    if (day.length < 2) {
      day = '0' + day;
    }
    let dateStr = year + month + day;
    return time === Number.parseInt(dateStr) - 1;
  }

  private static checkTime(time: number): string {
    if (time < 0) {
      Logger.error(TAG, 'checkTime, input is negative number!');
      return '00';
    }
    let formatTime: string = time.toString();
    if (time < 10) {
      let zeroString = '0';
      formatTime = zeroString.concat(formatTime);
    }
    return formatTime;
  }
}