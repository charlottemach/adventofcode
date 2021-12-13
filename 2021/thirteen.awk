func foldX(arr, foldx) {
    for (d in arr) {
        split(d,coord,",")
        x = coord[1]+0
        y = coord[2]+0
        if (x > foldx){
            xy = (x-2*(x-foldx)) "," y
            arr[xy] = "x"
            xy = x "," y
            delete arr[xy]
        }
    }
}

func foldY(arr, foldy) {
    for (d in arr) {
        split(d,coord,",")
        x = coord[1]+0
        y = coord[2]+0
        if (y > foldy){
            xy = x "," (y-2*(y-foldy))
            arr[xy] = "x"
            xy = x "," y
            delete arr[xy]
        }
    }
}

BEGIN {
  file = "thirteen.txt"
  split("", arr, ":")
  split("", fold, ":")
  i = 0
  while ((getline < file) > 0) {
    if ($0 != ""){
      if ($0 ~ "along") {
        fold[i] = $0
        i += 1
      } else { arr[$0] = "x" }
    }
  }
  # part A:
  # foldX(arr, 665)
  # print length(arr)

  # part B: 
  for (fi in fold){
    split(fold[fi],line," ")
    split(line[3],f,"=")
    if (f[1] == "x") {
      foldX(arr,f[2]+0)
    } else { foldY(arr,f[2]+0) }
  }
  for (i = 0; i <= 10; ++i) {
    for (j = 0; j <= 50; ++j) {
        xy = j "," i
        if (arr[xy] == "x") {
          printf "XX"
        } else { printf "  " }
     }
  } 
}
