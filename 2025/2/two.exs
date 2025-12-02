defmodule Two do

  def read_file(fl) do
    f = File.read!(fl)
    rs = Enum.map(String.split(String.trim(f), ","), fn x -> String.split(x, "-") end)
    Enum.map(rs, fn range -> Enum.map(range,fn y -> String.to_integer(y) end) end)
  end

## Part one

  def get_invalid(inp) do
    full = Enum.map(inp, fn x -> Enum.to_list(hd(x)..hd(tl(x))) end)
    Enum.map(full, fn x -> Enum.filter(x, fn y -> is_invalid(Integer.to_string(y)) end) end)
  end

  def is_invalid(num) do
    mid = div(String.length(num), 2)
    String.slice(num, 0, mid) == String.slice(num, mid..-1//1)
  end


## Part two

   def get_more_invalid(inp) do
    full = Enum.map(inp, fn x -> Enum.to_list(hd(x)..hd(tl(x))) end)
    Enum.map(full, fn x -> Enum.filter(x, fn y -> is_more_invalid(Integer.to_string(y)) end) end)
  end

  def is_more_invalid(num) do
    if String.length(num) > 1 do
      mid = div(String.length(num), 2)
      Enum.find(1..mid, fn chunk ->
        chunks = Enum.map(Enum.chunk_every(String.graphemes(num), chunk), &Enum.join/1)
        Enum.all?(chunks, fn c -> c == hd(chunks) end)
      end)
    else
      false
    end
  end
end

ranges = Two.read_file("input.txt")
IO.inspect Enum.sum(List.flatten(Two.get_invalid(ranges)))
IO.inspect Enum.sum(List.flatten(Two.get_more_invalid(ranges)))
