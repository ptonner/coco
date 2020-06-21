;;; Copyright 2020 Peter Tonner.
; This file is part of coco, which is free software licensed under the
; Expat license. See the LICENSE.

(import [funcparserlib.parser [many maybe]]
      [hy.model-patterns [*]]
      [collections [OrderedDict]])

(eval-and-compile

  (import os pickle)
  (when (not ((. os path exists) ".coco")) (.mkdir os ".coco"))
  (setv coco-cache-loc ((. os path join) ".coco" "coco-cache.pkl")
      coco-cache (if ((. os path exists) coco-cache-loc)
                     (.load pickle coco-cache-loc) {})))

(setv coco-storage {})

(defmacro coco-store [cfg code &optional kind]
  (when (not (in (name cfg) coco-storage)) (assoc coco-storage (name cfg) {}))
  (assoc (get coco-storage (name cfg)) (or kind :bindings) code))
; (defmacro coco-store [cfg code]
;   (assoc coco-storage (name cfg) code))

(defmacro/g! coco-run [init configs &rest body]
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

  ;; run body with applied bindings and drop to REPL on failure
  `(do
     (import [coco.coco [coco-cache]])
     (import [traceback [print_exc]])
     (import [hy.cmdline [HyREPL run_repl]])
     ~@init
     (setv ~@g!bindings)
     ; (assoc coco-cache ~g!bindings ~g!locals)
     (try ~@body
            (except []
              (print (print_exc))
              (run_repl (HyREPL :locals ~g!locals))))))

(defmacro/g! coco [&rest args]

  ;; parse arguments
  (setv g!parser
        (whole [(many SYM)
                (maybe (many (+ FORM FORM)))]))
  (setv g!parsed (.parse g!parser args))

  ;; split into symbols and forms
  (setv g!symbols (get g!parsed 0))
  (setv g!forms {})
  (for [[k v] (get g!parsed 1)]
    (assoc g!forms k v))

  ;; push to run
  `(coco-run
     [~@(+ (lfor bdy g!symbols :if (:init (get coco-storage (name bdy)) :default None)
                 (:init (get coco-storage (name bdy)) :default None))
           (if (in :init g!forms) [(get g!forms :init)] []))]
     [~@(+ (lfor cfg g!symbols :if (:bindings (get coco-storage (name cfg)) :default None)
                 (:bindings (get coco-storage (name cfg)) :default None))
           (if (in :bind g!forms) [(get g!forms :bind)] []))]
      ~@(+ (lfor bdy g!symbols :if (:body (get coco-storage (name bdy)) :default None)
                (:body (get coco-storage (name bdy)) :default None))
           (if (in :body g!forms) [(get g!forms :body)] []))))
