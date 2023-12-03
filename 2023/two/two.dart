import 'dart:async';
import 'dart:io';
import 'dart:convert';


bool possible(String ln, Map<String,int> m) {
  var draws = ln.split(':')[1].split(';');
  for (var pairs in draws) {
    for (var pair in pairs.split(',')) {
      var p = pair.split(' ');
      if (int.parse(p[1]) > m[p[2]]!) {
        return false;
      };
    };
  };
  return true;
}

int power(String ln) {
  var draws = ln.split(':')[1].split(';');
  var min = Map<String,int>.from(<String, int>{'red':0,'green':0,'blue':0});
  for (var pairs in draws) {
    for (var pair in pairs.split(',')) {
      var p = pair.split(' ');
      var val = int.parse(p[1]);
      if (val > min[p[2]]!) {
        min[p[2]] = val;
      };
    };
  };
  var r = min['red']!;
  var g = min['green']!;
  var b = min['blue']!;
  return r * g * b;
}


void main() async {
  var total = 0; 
  var sum = 0;
  var index = 1;
  var mp = Map<String,int>.from(<String, int>{'red':12,'green':13,'blue':14});
  final contents = await File("input.txt").readAsString();

  contents.trim().split('\n').forEach((l) {
    if (possible(l, mp)) {
      total += index;
    };
    sum += power(l);
    index++;
  });

  print('A: $total');
  print('B: $sum');
}
