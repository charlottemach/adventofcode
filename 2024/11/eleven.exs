defmodule Eleven do 

  def read_file do
    f = File.read!("input.txt")
    String.split(String.trim(f), " ")
  end

  def get_stones(inp) do
    inp |> Enum.frequencies()
  end

  def cap(i) do
    Integer.to_string(String.to_integer(i))
  end

  def split(stones) do
    for {num, cnt} <- stones do
      if num == "0" do
        %{"1" => cnt}
      else 
        if rem(String.length(num),2) == 0 do
          l = String.length(num)
          s1 = cap(String.slice(num,0..div(l,2)-1))
          s2 = cap(String.slice(num,div(l,2)..l))
          Map.merge(%{s1 => cnt},%{s2 => cnt}, fn _k, a, b -> a + b end)
        else
          n = Integer.to_string(String.to_integer(num) * 2024)
          %{n => cnt}
        end 
      end
    end
  end

  def blink(stones) do
    mr = fn x,y -> Map.merge(x,y,fn _k,a,b -> a+b end) end
    Enum.reduce(Eleven.split(stones), mr)
  end

  def rec(stones, n) do
    if n == 0 do
      stones |> Map.values |> Enum.sum()
    else
      rec(blink(stones), n-1)
    end
  end
end

lines = Eleven.read_file
stones = Eleven.get_stones(lines)

IO.inspect Eleven.rec(stones,25)
IO.inspect Eleven.rec(stones,75)
