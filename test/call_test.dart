main() {
  final ls = [
    1,
    "2",
    false,
    () => 1,
    () => false,
  ];
  for (dynamic ln in ls) {
    print("# ln: ${ln}");
    print(true && (ln is Function) ? ln.call() : ln);
    print(false || (ln is Function) ? ln.call() : ln);
    print("# =============");
  }
}
