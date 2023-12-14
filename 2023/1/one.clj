(ns one.core
  (:gen-class))
(require '[clojure.string :as str])

(defn filter-nums [ln]
  (str/replace ln #"[^\d]" ""))

(defn get-first [ln]
  (re-find #"\d" (filter-nums ln)))

(defn get-last [ln]
  (re-find #"\d$" (filter-nums ln)))

(defn a [data]
  (reduce + 
       (map 
         #(Integer/parseInt (str (get-first %) (get-last %))) 
         data)))

(defn text-to-num [ln]
   (str/replace (str/replace (str/replace 
   (str/replace (str/replace (str/replace 
   (str/replace (str/replace (str/replace ln 
     #"one" "on1e") #"two" "tw2o") #"three" "thr3ee")
     #"four" "fo4ur") #"five" "fi5ve") #"six" "si6x")
     #"seven" "sev7en") #"eight" "ei8ght") #"nine" "ni9ne")
)
                
(defn b [data]
  (reduce + 
       (map 
         #(Integer/parseInt (str (get-first (text-to-num %)) (get-last (text-to-num %)))) 
         data)))

(defn -main
  [& args]
(with-open [r (clojure.java.io/reader "input.txt")]
  (let [data (line-seq r)]
     (prn (str "A: " (a data)))
     (prn (str "B: " (b data)))
)))
