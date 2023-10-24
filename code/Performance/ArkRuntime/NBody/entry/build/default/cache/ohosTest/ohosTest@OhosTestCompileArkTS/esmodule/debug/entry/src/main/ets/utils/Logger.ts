import hilog from "@ohos:hilog";
class Logger {
    // 日志对应的领域标识，范围是0x0~0xFFFF
    private domain: number = 0xF811;
    // 指定日志标识，可以为任意字符串，建议用于标识调用所在的类或者业务行为
    private prefix: string = '[NBody]';
    // 格式字符串，用于日志的格式化输出
    private format: string = '%{public}s, %{public}s';
    constructor(prefix: string) {
        this.prefix = prefix;
    }
    debug(...args: string[]): void {
        hilog.debug(this.domain, this.prefix, this.format, args);
    }
    info(...args: string[]): void {
        hilog.info(this.domain, this.prefix, this.format, args);
    }
    warn(...args: string[]): void {
        hilog.warn(this.domain, this.prefix, this.format, args);
    }
    error(...args: string[]): void {
        hilog.error(this.domain, this.prefix, this.format, args);
    }
}
export default new Logger('[NBody]');
