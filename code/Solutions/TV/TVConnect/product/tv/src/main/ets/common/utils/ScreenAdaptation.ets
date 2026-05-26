export function scale(resource: number): number {
  const multiplier = AppStorage.get<boolean>('is4k') ? 2 : 1;
  return resource * multiplier;
}
