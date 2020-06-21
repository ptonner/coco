(import [hy.models [HySymbol]])

(defn main [&rest args]
  (setv args
        (parse-args
            [["experiment" :help "Experiment to run (directory under experiments/)"]
            ["command" :help "command to run (.hy file in the experiment directory)"]]
            :description "Run an experiment command"))

  (setv imprt `(import [~(HySymbol (.replace args.experiment "/" "."))
                        [~(HySymbol args.command)]]))
  (eval imprt))
