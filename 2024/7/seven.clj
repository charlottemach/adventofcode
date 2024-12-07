(ns seven.core
  (:gen-class))
(require '[clojure.string :as str])

(defn parse-num [s]
   (Long. (re-find  #"\d+" s)))

(defn get-total[ln]
  (parse-num (first (str/split ln #": "))))

(defn get-numbers [ln]
  (map parse-num (str/split (first (rest (str/split ln #": "))) #" ")))

(defn combine [n1 n2]
  (parse-num (str n1 n2)))

(defn up [cur left max]
  (if (> cur max) false 
    (if (empty? left) (= cur max)
      (let [next (first left)]
        (or (up (+ cur next) (rest left) max)
        (up (* cur next) (rest left) max))))))

(defn concat-up [cur left max]
  (if (> cur max) false 
    (if (empty? left) (= cur max)
      (let [next (first left)]
        (or (concat-up (+ cur next) (rest left) max)
        (concat-up (* cur next) (rest left) max)
        (concat-up (combine cur next) (rest left) max))))))

(defn is-valid [f]
  (fn [ln] 
    (let [[total nums][(get-total ln) (get-numbers ln)]]
    (if (f (first nums) (rest nums) total) total 0))))

(defn -main
  [& args]
(with-open [r (clojure.java.io/reader "input.txt")]
  (let [data (line-seq r)]
    ;; (prn data)
    (prn (str "A: " (reduce + (map (is-valid up) data))))
    (prn (str "B: " (reduce + (map (is-valid concat-up) data))))
)))
