; Copyright 2020 Peter Tonner.
; This file is part of coco, which is free software licensed under the Expat
; license. See the LICENSE.

(eval-and-compile (setv coco-storage {}))

(defmacro coco-store [cfg bindings]
  (assoc coco-storage (name cfg) bindings))

(defmacro/g! coco-run [configs &rest body]
  "code is config (is code)."
  (import [collections [OrderedDict]])

  ;; merge configs
  (setv g!bindingsDict (OrderedDict))
  (for [cfg configs]
    (for [[k v] (partition cfg)]
      (assoc g!bindingsDict k v)))
  (setv g!bindings [])
  (for [[k v] (.items g!bindingsDict)] (.extend g!bindings `[~k ~v]))

  ;; build locals in case we fail
  (setv g!locals {}) ;; 
  (for [[k _] (.items g!bindingsDict)] (assoc g!locals (name k) k))

  ;; run body with applied bindings
  `(do
     (import [traceback [print_exc]])
     (import [hy.cmdline [HyREPL run_repl]])
     (setv ~@g!bindings)
     (try ~@body
            (except []
              (print (print_exc))
              (run_repl (HyREPL :locals ~g!locals))))))

(defmacro coco [configs &rest body]
  `(coco-run [~@(lfor cfg configs (if (symbol? cfg) (get coco-storage (name cfg)) cfg))] ~@body))
