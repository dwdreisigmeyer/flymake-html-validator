;;; flymake-html-validator.el
;;; Make flymake work with Validator.nu.  This requires php4 or php5.
;;
;; Copyright (C) 2011 David Dreisigmeyer <dwdreisigmeyer@gmail.com>
;;
;; Author: David Dreisigmeyer <dwdreisigmeyer@gmail.com>
;; URL: https://github.com/dwdreisigmeyer/emacs.d/blob/master/site-lisp/validators/flymake-html-validator.el
;;
;; Created: 5 JAN 2012
;; Version: 0.1
;;
;; Package-Requires: flymake (Works with Emacs 24.0 version) and, php4 or php5.
;;
;;
;; This file is not part of GNU Emacs.
;; However, it is distributed under the same license.
;;
;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; How to use this.
;;
;; Install validator.nu from
;;
;; http://about.validator.nu/
;;
;; You must start this running before you can use flymake.
;; The default address for validator.nu is localhost:8888.
;; If you wish to change this do:
;;
;; (setq validator-address "your-html-checker-address")
;;
;; Make sure this address is correct because flymake will not warn if it is wrong.
;; I have this installed in the same directory as the default validator-script:
;; 
;; ~/emacs.d/site-lisp/validators/
;;
;; From here cd into checker and then do:
;;
;; python build/build.py run
;;
;; By default the included php script validator-nu.php should be located
;; in "~/.emacs.d/site-lisp/validators/".  That can be changed
;; by doing:
;;
;; (setq validator-script "path/to/the/script")
;;
;; Make sure to chmod +x the script.
;;
;; Add the following lines to your emacs config:
;;
;; (require 'flymake-html-validator)
;; (add-hook 'html-mode-hook 'flymake-mode)
;;
;; This worked on OS X 10.1 with Emacs 24.0.


(require 'flymake)

(defcustom validator-address "localhost:8888"
  "Address for running validator.nu."
  :type 'string
  :group 'flymake-html-validator)

(defcustom validator-script "~/.emacs.d/site-lisp/validators/"
  "Location of the php script."
  :type 'string
  :group 'flymake-html-validator)

(defun flymake-html-validator-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
		     'flymake-create-temp-inplace))
	 (local-file (file-relative-name
		      temp-file
		      (file-name-directory buffer-file-name))))		      
    (list (expand-file-name "validator-nu.php" validator-script)
	  (list local-file validator-address))))

(setq flymake-allowed-file-name-masks
      (cons '(".+\\.html$"
	      flymake-html-validator-init
	      flymake-simple-cleanup
	      flymake-get-real-file-name)
	    flymake-allowed-file-name-masks))

(setq flymake-err-line-patterns
      (cons '("\\([[:digit:]]+\\) :-: \\(.*\\)$" nil 1 nil 2)
	    flymake-err-line-patterns))
	    
(add-hook 'html-mode-hook 'flymake-mode)
(provide 'flymake-html-validator)

