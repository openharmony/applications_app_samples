export const tcpConnect: (addr: string, port: number) => number;

export const startVpn: (tunFd: number, tunnelFd: number) => number;

export const stopVpn: (tunnelFd: number) => number;