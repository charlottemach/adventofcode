#!/usr/bin/env ruby

BRACES = { "(" => ")", "{" => "}", "[" => "]", "<" => ">" }
OPEN = BRACES.keys
CLOSE = BRACES.values

POINTS = { ")" => 3, "]" => 57, "}" => 1197, ">" => 25137 }
POINTSB = { ")" => 1, "]" => 2, "}" => 3, ">" => 4 }

def syntax_error(string)
    tmp = []
    string.each_char do |c|
        if OPEN.include? c
            tmp << c
        elsif CLOSE.include? c
            c == BRACES[tmp.last] ? tmp.pop : (return POINTS[c])
        end
    end
    return 0
end

def complete(string)
    tmp = []
    string.each_char do |c|
        if OPEN.include? c
            tmp << c
        elsif CLOSE.include? c
            if c == BRACES[tmp.last] { tmp.pop }
        end
    end
    tmp = tmp.map { | x | BRACES[x] }.reverse()
    return tmp.reduce(0) { |x,n| x*5 + POINTSB[n] }
end

cntA = 0
cntB = []
File.open("ten.txt").each_line do |line|
    se = syntax_error(line)
    if se == 0
        cntB << complete(line)  
    else
        cntA += se
    end
end
puts cntA
puts cntB.sort[cntB.length()/2]
