package main
import (
    "encoding/csv"
    "fmt"
    "log"
    "os"
    "strconv"
)

func main() {
    var input = readFile("seven.txt")
    var dist [][]int
    var ln = len(input)
    /* A
    dist = make([][]int, ln)
    for i := range dist {
        dist[i] = make([]int, ln)
    }
    for i,a := range input {
        for j,b := range input {
             dist[i][j] = absInt(a-b)
        }
    }*/
    /* B */
    maxInput := getMax(input)
    dist = make([][]int, maxInput)
    for i := range dist {
        dist[i] = make([]int, ln)
    }
    for i,a := range input {
        for j := 0; j<maxInput; j++ {
            dist[j][i] = exp(absInt(a-j))
        }
    }
    var mnR = getRowSum(dist,0)
    for i, _ := range input {
        r := getRowSum(dist,i)
        if r < mnR {
            mnR = r
        }
    }
    fmt.Println(mnR)
}

func readFile(filename string) []int {
    f, err := os.Open(filename)
    if err != nil {
        log.Fatal(err)
    }
    defer f.Close()

    csvReader := csv.NewReader(f)
    records, err := csvReader.ReadAll()
    if err != nil {
        log.Fatal(err)
    }
    var ints []int
    var record = records[0]
    for i := 0; i < len(record); i++ {
        intVar, _ := strconv.Atoi(record[i])
        ints = append(ints, intVar)
    }
    return ints
}

func addUp(ints []int) int{
    res := 0
    for _, n := range ints {
        res += n
    }
    return res
}

func getRowSum(mat[][]int, row int) int {
    return addUp(mat[row])
}

func absInt(x int) int {
   if x < 0 {
      return - x
   }
   return x
}

/* B */
func exp(n int) int {
    res := 0
	if (n > 0) {
		res = n + exp(n-1)
	}
	return res
}

func getMax(n []int) int{
    mx := n[0]
    for _,v := range n{
        if v > mx {
            mx = v
        }
    }
    return mx
}
func printMat(mat [][]int) {
    for _,a := range mat{
        for _,b := range a{
            fmt.Print(b," ")
        }
    fmt.Println()
    }
}
