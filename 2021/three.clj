(require ['clojure.string :as 'str])

(defn get-lines [file] (str/split-lines (slurp file)))
(def lines (get-lines "three.txt"))

;; part a
(println (* (read-string (str "2r" (clojure.string/join "" (for [i (range (count (first lines)))] (if (> (reduce + (map #(Character/digit (nth % i) 10) lines)) (/ (count lines) 2)) 1 0))))) (read-string (str "2r" (clojure.string/join "" (for [i (range (count (first lines)))] (if (> (reduce + (map #(Character/digit (nth % i) 10) lines)) (/ (count lines) 2)) 0 1)))))))

;; part b

; returns column of nth position
(defn col [lines n] (map #(Character/digit (nth % n) 10) lines))
;; compares most common char (1/0) with char in that line
(defn oxy [lines n line] (== (if (>= (reduce + (col lines n)) (/ (count lines) 2)) 1 0) (Character/digit (nth line n) 10)))
(defn co2 [lines n line] (== (if (>= (reduce + (col lines n)) (/ (count lines) 2)) 0 1) (Character/digit (nth line n) 10)))

(defn gen [lines ind prot]
    (if (== (count lines) 1)
        (read-string (str "2r" (first lines))) 
        (recur (filterv #(prot lines ind %) lines) (+ ind 1) prot)))
(println (* (gen lines 0 oxy) (gen lines 0 co2)))
