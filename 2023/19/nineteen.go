package main
import (
    "fmt"
    "os"

    "strings"
    "strconv"
)

type rng struct {
    min,max  int64
}

type workflow struct {
    rules []rule
    dflt   string
}
	
type rule struct {
    part    string
    lt      bool
    number  int
    to      string
}


func newWorkflow(rules []string, dflt string) *workflow {
   wf := workflow{dflt: dflt} 
   var rs []rule
   for i := range rules {
       s := strings.Split(rules[i],":")
       part := string(s[0][0])
       lt := s[0][1] == '<'
       number,err := strconv.Atoi(s[0][2:])
       if err != nil {
           fmt.Print(err)
       }
       to := s[1]       

       r := &rule{part,lt,number,to}
       rs = append(rs,*r)
   }
   wf.rules = rs
   return &wf
}

func eval(wfs map[string]workflow, wf string,  parts map[string]int) string {
    if wf == "A" || wf == "R" { return wf }
    workflow := wfs[wf]
    for i := range workflow.rules {
        r := workflow.rules[i]
        val := parts[r.part]
        if r.lt {
            if val < r.number {
                return eval(wfs, r.to, parts)
            }
        } else {
            if val > r.number {
                return eval(wfs, r.to, parts)
            }
        }
    }
    return eval(wfs, workflow.dflt, parts)
}

func Split(r rune) bool {
    return r == '{' || r == '}'
}

func getInput(file string) ([]string, map[string]workflow) {
    input,err := os.ReadFile(file)
    if err != nil {
        fmt.Print(err)
    }
    s := strings.Split(string(input), "\n\n")
    lines := strings.Split(s[1],"\n")

    workflows := make(map[string]workflow)
    wfs := strings.Split(s[0],"\n")
    for i := range(wfs) {
        tmp := strings.FieldsFunc(wfs[i], Split)
        rules := strings.Split(tmp[1],",")
        dflt := rules[len(rules)-1]
        rules = rules[:len(rules)-1]
        workflows[tmp[0]] = *newWorkflow(rules, dflt)
    }
    return lines, workflows
}

func copy(from map[string]rng) map[string]rng {
   to := make(map[string]rng)
   for k, v := range from {
      to[k] = v
   }
   return to
}

func dfs(wf string, wfs map[string]workflow, ranges map[string]rng) int64 {
    sum := int64(0)
    if wf == "A" {
        x := ranges["x"]; m := ranges["m"]; a := ranges["a"]; s := ranges["s"]
        return (1+x.max-x.min) * (1+m.max-m.min) * (1+a.max-a.min) * (1+s.max-s.min)
    } else if wf == "R" { return sum }
    rs := wfs[wf].rules
    for i := range rs {
        rangesCopy := copy(ranges)
        r := rs[i]
        partRange := rangesCopy[r.part]
        origRange := ranges[r.part]
        if r.lt { 
            partRange.max = int64(r.number)-1
            origRange.min = int64(r.number)
        } else {
            partRange.min = int64(r.number)+1
            origRange.max = int64(r.number)
        }
        rangesCopy[r.part] = partRange
        ranges[r.part] = origRange
        sum += dfs(r.to, wfs, rangesCopy)
    } 
    sum += dfs(wfs[wf].dflt, wfs, ranges)
    return sum
}

func main() {
    lines,wfs := getInput("input.txt")
    sum := 0
    for i := range lines[:len(lines)-1] {
        parts := make(map[string]int)
           tmp := strings.FieldsFunc(lines[i], Split)
           pp := strings.Split(tmp[0],",")
           for j := range pp {
              l := strings.Split(pp[j],"=")
              n,err := strconv.Atoi(l[1])
              if err != nil {
                 fmt.Print(err)
              }
              parts[l[0]] = n
           }
        if eval(wfs, "in", parts) == "A" {
            for _,n := range parts {
                sum += n
            }
        }
    }
    fmt.Println("A: ",sum)

    ranges := map[string]rng{"x":rng{1,4000},"m":rng{1,4000},"a":rng{1,4000},"s":rng{1,4000}}
    fmt.Println("B: ",dfs("in", wfs, ranges))
}
