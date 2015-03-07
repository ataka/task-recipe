;;; task-recipe.el --- Task Recipe
;; -*- Mode: Emacs-Lisp -*-

;; Copyright (c) 2015  Masayuki Ataka

;; Author: Masayuki Ataka <masayuki.ataka@gmail.com>
;; URL: https://github.com/ataka/task-recipe

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, you can either send email to this
;; program's maintainer or write to: The Free Software Foundation,
;; Inc.; 59 Temple Place, Suite 330; Boston, MA 02111-1307, USA.

;;; Code:

(defvar task-recipe-alist nil)

(defun task-recipe-create-tasks (recipe due)
  (interactive (list (let ((completion-ignore-case t)
			   (recipe-name (completing-read "Task Recipe: " task-recipe-alist)))
		       (cdr (assoc recipe-name task-recipe-alist)))
		     (read-string (format-time-string "Due (%Y-%m-%d %H:%M:%S): "))))
  (let (task-list)
    (dolist (task-template recipe task-list)
      (let ((task (car task-template))
	    (due-template (cdr task-template)))
	(setq task-list (cons (cons task (task-template-set-due due due-template)) task-list))))))

(defun task-template-print-tasks ()
  (interactive)
  (let ((task-list (call-interactively 'task-recipe-create-tasks)))
    (dolist (task task-list)
      (insert (format "・%s: %s\n" (format-time-string "%Y-%m-%d" (cdr task)) (car task))))))

(defun task-template-set-due (due due-template)
  (let ((due-time (apply #'encode-time
			 (parse-time-string
			  (if (string-match "[0-9]+-[01][0-9]-[0-3][0-9] [0-2][09]:" due) due (concat due " 00:00:00"))))))
    (time-add due-time (days-to-time due-template))))

(defun task-recipe-create-recipe (title)
  (interactive "sTask Recipe Name: ")
  (let ((creating t)
	(recipe '()))
    (while creating
      (setq recipe (cons (call-interactively 'task-recipe-create-template) recipe))
      (setq creating (not (y-or-n-p "Finish create task recipe?"))))
    (list title due recipe))


(defun task-recipe-create-template (title due)
  (interactive "sTask: \nsTemplate Due: ")
  (list title due))

(provide 'task-recipe)

;;; clmemo.el ends here
