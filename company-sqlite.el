;; parse sqlite diagrams data to generate lisp date structures
(defvar company-sqlite-keywords nil)

(defconst company-sqlite-keywords-file "raw/sqlite-keywords")

(defun company-sqlite-load-keywords ()
  (with-temp-buffer
    (insert-file-contents company-sqlite-keywords-file)
    (setq company-sqlite-keywords (split-string (buffer-string) "\n"))))
