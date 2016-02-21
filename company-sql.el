;; Two modes of operation
;; if we are able to parse the current query complete according to
;; sqlite syntax diagrams www.sqlite.org/docsrc/artifact/61db2a9de59f577c
;; otherwise just complete keywords by prefix, also tables and colums
;; if we can read them from the connected database
;; if no database is connected use already typed names

(require 'cl-lib)
(require 'company)
(require 'company-sqlite)

(defun is-lowercase (str)
  (equal str (downcase str)))

(defun company-sql-keywords (command &optional arg &rest ignored)
  (interactive (list 'interactive))
  (unless company-sqlite-keywords
    (company-sqlite-load-keywords))
  (cl-case command
    (interactive (company-begin-backend 'company-sql-keywords))
    (prefix (and (or (eq major-mode 'sql-mode) (eq major-mode 'sql-interactive-mode))
                 (or (eq sql-product 'ansi) (eq sql-product 'sqlite))
             (company-grab-symbol)))
    (candidates (let ((completions (remove-if-not
                                    (lambda (c) (string-prefix-p arg c 'ignore-case))
                                    company-sqlite-keywords)))
                  (if (is-lowercase arg)
                      (mapcar #'downcase completions)
                    completions)))
    (meta (format "This value is named %s" arg))))

(add-to-list 'company-backends 'company-sql-keywords)
