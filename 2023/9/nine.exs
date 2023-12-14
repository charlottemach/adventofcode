defmodule Nine do 

  def read_file do
    f = File.read!("input.txt")
    String.split(String.trim(f), "\n")
  end

  def sequence(lines) do
    m = Enum.map(lines, fn ln ->
      l = Enum.map(String.split(ln, " "), fn s -> String.to_integer(s) end)
      get_next(l, List.last(l))
    end)
    Enum.sum(m)
  end

  def seq([]), do: []
  def seq([ _h ]), do: []
  def seq([ h1, h2 | tail ]), do: [ h2-h1 ] ++ seq([h2]++tail)

  def get_next(ns, pred) do
    if Enum.all?(ns, fn n -> n==0 end) do
      pred
    else
      nxt = seq(ns)
      get_next(nxt, pred+List.last(nxt))
    end
  end


  def sequence_b(lines) do
    m = Enum.map(lines, fn ln ->
      l = Enum.map(String.split(ln, " "), fn s -> String.to_integer(s) end)
      diffs = get_prev(l, [List.first(l)])
      List.foldr(diffs, 0, fn x, acc -> x-acc end)
    end)
    Enum.sum(m)
  end
  
  def get_prev(ns, pred) do
    if Enum.all?(ns, fn n -> n==0 end) do
      pred
    else
      prev = seq(ns)
      get_prev(prev, pred++[List.first(prev)])
    end
  end
 
end

lines = Nine.read_file
IO.puts Nine.sequence(lines)
IO.puts Nine.sequence_b(lines)
