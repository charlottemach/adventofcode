import java.io.File
import java.util.Collections

fun main() {
    
    val input = File("one.txt").readText()
    a(input)
    b(input)

}

fun a(input: String){

    var elves = input.split("\n\n").dropLast(1)
    var max = 0
    for (elf in elves) {
        val s = elf.split("\n").map{it.toInt()}.sum()
	if (s > max) {
            max = s
        }
    }
    println(max)
}

fun b(input: String){

    var elves = input.split("\n\n").dropLast(1)
    var top = arrayListOf<Int>()
    for (elf in elves) {
        top.add(elf.split("\n").map{it.toInt()}.sum())
    }
    Collections.sort(top)
    println(top.takeLast(3).sum())
}
