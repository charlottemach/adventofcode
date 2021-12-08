content = File.read("eight.txt")

# part A - 1=2,7=3,4=4,8=7
puts ((content.strip().split('\n').map &.partition('|')[2].strip().split(" ")).map &.map &.size).flatten().count {|x| [2,3,4,7].includes?(x)}

# part B - 0,6,9=6 2,3,5=5
lines = content.strip().split('\n').map &.partition('|')
count = 0
lines.each do |line|
    input = line[0].strip().split(" ").sort_by {|w| w.size}.map &.chars.sort().join
    hash = {input[0] => 1, input[1] => 7, input[2] =>4, input[9] =>8 }
    input.each do |inp|
        iset = inp.chars.to_set
        if inp.size == 5
            if hash.key_for(7).chars.to_set.proper_subset_of? iset
                hash[inp] = 3
            elsif (hash.key_for(4).chars.to_set^iset).size == 3
                hash[inp] = 5
            else
                hash[inp] = 2
            end
        end
        if inp.size == 6
            if hash.key_for(3).chars.to_set.proper_subset_of? iset
                hash[inp] = 9
            elsif hash.key_for(1).chars.to_set.proper_subset_of? iset
                hash[inp] = 0
            else
                hash[inp] = 6
            end
        end
    end
    # puts hash
    output = line[2].strip().split(" ").map &.chars.sort().join()
    count = count + output.map { |x| hash[x] }.join.to_i
end
puts count
