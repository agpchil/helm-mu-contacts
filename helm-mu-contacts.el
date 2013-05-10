;;; helm-mu-contacts.el --- Mu contacts source for helm

;; This file is not part of Emacs

;; Copyright (C) 2013 Andreu Gil Pàmies
;; Based on ido-select-recipient snippet from Jacek Generowicz

;; Filename: helm-mu-contacts.el
;; Version: 0.1
;; Author: Andreu Gil Pàmies <agpchil@gmail.com>
;; Created: 07-05-2013
;; Description: Mu contacts source for helm
;; URL: http://github.com/agpchil/helm-mu-contacts

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Usage:
;; (require 'helm-mu-contacts)
;; (define-key message-mode-map (kbd "C-c C-f c") 'helm-mu-contacts)

;;; Commentary:

;;; Code:
(defvar helm-mu-contacts-cmd "mu cfind --format=csv |sort"
  "External command to fetch the contacts.")

(defun helm-mu-contacts-fetch-csv ()
  "Fetch the csv contacts and return them in a list."
  (remove-if (lambda (string) (= 0 (length string)))
             (split-string (shell-command-to-string helm-mu-contacts-cmd)
                           "\n")))

(defun helm-mu-contacts-list ()
  "Return a list of mu contacts in a readable format."
  (mapcar
   (lambda (contact-string)
     (let* ((data (split-string contact-string ","))
            (name (when (> (length (car data)) 0)
                    (car data)))
            (address (cadr data)))
       (if name
           (format "%s <%s>" name address)
         address)))
   (helm-mu-contacts-fetch-csv)))

(defun helm-mu-contacts-init ()
  "Initialize buffer with all contacts of mu."
  (helm-init-candidates-in-buffer 'global (helm-mu-contacts-list)))

(defun helm-mu-contacts-insert-action (candidate)
  "Insert CANDIDATE in current buffer."
  (with-helm-current-buffer
    (insert candidate)))

(defvar helm-source-mu-contacts
  `((name . "MU contacts")
    (init . helm-mu-contacts-init)
    (candidates-in-buffer)
    (keymap . ,helm-generic-files-map)
    (help-message . helm-generic-file-help-message)
    (mode-line . helm-generic-file-mode-line-string)
    (action
     ("Insert contact" . (lambda (candidate)
                           (helm-mu-contacts-insert-action candidate))))))

(defun helm-mu-contacts ()
  "Preconfigured `helm` for mu contacts."
  (interactive)
  (helm
   :sources '(helm-source-mu-contacts)
   :buffer  "helm-mu-contacts"))

(provide 'helm-mu-contacts)
;;; helm-mu-contacts.el ends here
