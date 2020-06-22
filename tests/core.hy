(require [coco.coco [coco-store coco coco-reset]])

(defn test-binding []
  (coco-reset)
  (coco-store test-binding [a 1 b (+ a 1)])
  (coco test-binding :body (assert (= b 2))))

(defn test-multiple-binding []
  (coco-reset)
  (coco-store test-binding [a 1 b (+ a 1)])
  (coco-store test-binding2 [a 3])
  (coco test-binding test-binding2 :body (assert (= b 4))))
