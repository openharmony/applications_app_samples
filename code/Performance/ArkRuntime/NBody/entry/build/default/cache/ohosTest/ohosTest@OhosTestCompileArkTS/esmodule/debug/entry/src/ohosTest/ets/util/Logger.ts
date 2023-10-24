import hilog from "@ohos:hilog";
class Logger {
    // ��־��Ӧ�������ʶ����Χ��0x0~0xFFFF
    private domain: number = 0xF811;
    // ָ����־��ʶ������Ϊ�����ַ������������ڱ�ʶ�������ڵ������ҵ����Ϊ
    private prefix: string = '[NBody_OHOSTest]';
    // ��ʽ�ַ�����������־�ĸ�ʽ�����
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
export default new Logger('[NBody_OHOSTest]');
