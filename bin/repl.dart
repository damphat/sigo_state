import 'dart:io';

class Repler {
  String prompt = '>';

  void init() {}

  void help(String cmd) {
    print("\$help");
  }

  void start() {
    init();
    while (true) {
      stdout.write(prompt);
      var src = stdin.readLineSync();
      if (src == null) {
        print('... break');
        exit(1);
      }
      switch (src) {
        case '':
          continue;
        case '?':
        case 'h':
        case 'help':
        case '.help':
          help(src);
          continue;
        case 'exit':
        case 'quit':
          return;
        case 'cls':
        case 'clear':
          for (var i = 0; i < stdout.terminalLines; i++) {
            stdout.writeln();
          }
          continue;
      }
      try {
        var out = process(src);
        print(out);
      } on Error catch (e) {
        print(e.toString());
        print(e.stackTrace);
      }
    }
  }

  String process(String src) {
    return src.toUpperCase();
  }
}

class FunctionRepler extends Repler {
  final String Function(String src) func;

  FunctionRepler(this.func, {String prompt = '>'}) {
    super.prompt = prompt;
  }

  @override
  String process(String src) {
    return func(src);
  }
}

void repl(String Function(String src) f,
    {String prompt = '>', dynamic context}) {
  FunctionRepler(f, prompt: prompt).start();
}
