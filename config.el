;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here


;; To make relative line nums
(defvar my-linum-current-line-number 0)

(setq linum-format 'my-linum-relative-line-numbers)

(defun my-linum-relative-line-numbers (line-number)
  (let ((test2 (1+ (- line-number my-linum-current-line-number))))
    (propertize
     (number-to-string (cond ((<= test2 0) (1- test2))
                             ((> test2 0) test2)))
     'face 'linum)))

(defadvice linum-update (around my-linum-update)
  (let ((my-linum-current-line-number (line-number-at-pos)))
    ad-do-it))
(ad-activate 'linum-update)

(use-package! haskell-mode
  :mode "\\.hs$"
  :config
  (require 'haskell-mode))

(use-package! writeroom-mode
  :config
  (require 'writeroom-mode))

(use-package! flycheck-haskell
  :config
  (require 'flycheck-haskell)
  (add-hook 'flycheck-mode-hook #'flycheck-haskell-setup))

(use-package! merlin
  :config
  (require 'merlin))

(use-package! tuareg
  :config
  (require 'tuareg))

(use-package! flycheck-ocaml
  :config
  (require 'flycheck-ocaml)
   (with-eval-after-load 'merlin
     ;; Disable Merlin's own error checking
     (setq merlin-error-after-save nil)

     ;; Enable Flycheck checker
     (flycheck-ocaml-setup))

   (add-hook 'tuareg-mode-hook #'merlin-mode)
)
(use-package! typescript-mode
  :config
  (require 'typescript-mode)
  )
(use-package! proof-general
  :config
  (require 'proof-general)
  )
(use-package! coq-commenter
  :config
  (require 'coq-commenter)
   (add-hook 'coq-mode-hook 'coq-commenter-mode)

;;You can set your key with

 (define-key coq-commenter-mode-map
             (kbd "C-;")
             #'coq-commenter-comment-proof-in-region)
 (define-key coq-commenter-mode-map
             (kbd "C-x C-;")
             #'coq-commenter-comment-proof-to-cursor)
 (define-key coq-commenter-mode-map
             (kbd "C-'")
             #'coq-commenter-uncomment-proof-in-region)
 (define-key coq-commenter-mode-map
             (kbd "C-x C-'")
             #'coq-commenter-uncomment-proof-in-buffer)
)
(use-package! racer
  :config
  (require 'racer)
  )
(use-package! rust-mode
  :mode "\\.rs$"
  :config
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
  (flycheck-mode)
  )

(use-package! company-coq
  :config
  (require 'company-coq)

  (with-eval-after-load 'company
    (add-to-list 'company-backends 'company-cabal))
  )

(use-package! company-cabal
  :config
  (require 'company-cabal)

  (with-eval-after-load 'company
    (add-to-list 'company-backends 'company-cabal))
  )

(use-package! company-racer
  :config
  (require 'company-racer)

  (with-eval-after-load 'company
    (add-to-list 'company-backends 'company-racer))
  )

(use-package! mips-mode
  :config
  (require 'mips-mode))

(use-package! elixir-mode
  :config
  (require 'elixir-mode)
  )

(use-package! flycheck-elixir
  :after flycheck-mode
  :config
  (require 'flycheck-elixir))


(use-package! alchemist
  :after elixir-mode
  :config
  (defun rm/alchemist-project-toggle-file-and-tests ()
    "Toggle between a file and its tests in the current window."
    (interactive)
    (if (alchemist-utils-test-file-p)
        (alchemist-project-open-file-for-current-tests 'find-file)
      (rm/alchemist-project-open-tests-for-current-file 'find-file)))

  (defun rm/alchemist-project-open-tests-for-current-file (opener)
    "Visit the test file for the current buffer with OPENER."
    (let* ((filename (file-relative-name (buffer-file-name) (alchemist-project-root)))
           (filename (replace-regexp-in-string "^lib/" "test/" filename))
           (filename (replace-regexp-in-string "^web/" "test/" filename))
           (filename (replace-regexp-in-string "^apps/\\(.*\\)/lib/" "apps/\\1/test/" filename))
           (filename (replace-regexp-in-string "\.ex$" "_test\.exs" filename))
           (filename (format "%s/%s" (alchemist-project-root) filename)))
      (if (file-exists-p filename)
          (funcall opener filename)
        (if (y-or-n-p "No test file found; create one now?")
            (alchemist-project--create-test-for-current-file
             filename (current-buffer))
          (message "No test file found."))))))
(use-package! boogie-friends
  :config
  (setq flycheck-dafny-executable "/opt/dafny/dafny")
  (setq flycheck-boogie-executable "PATH-TO-BOOGIE")
  (setq flycheck-z3-smt2-executable "PATH-TO-Z3")
  (setq flycheck-inferior-dafny-executable "PATH-TO-DafnyServer.exe") ;; Optional
  (setq boogie-friends-profile-analyzer-executable "PATH-TO-Z3-AXIOM-PROFILER") ;; Optional
)

(add-to-list 'load-path "/home/iav/.doom.d/")
(load "redtt.el")

(autoload 'cubicaltt-mode "cubicaltt" "cubical editing mode" t)
(setq auto-mode-alist (append auto-mode-alist '(("\\.ctt$" . cubicaltt-mode))))
(add-to-list 'load-path "/home/iav/.doom.d/")
(load-file "~/.doom.d/cubicaltt.el")

(defun toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
         (next-win-buffer (window-buffer (next-window)))
         (this-win-edges (window-edges (selected-window)))
         (next-win-edges (window-edges (next-window)))
         (this-win-2nd (not (and (<= (car this-win-edges)
                     (car next-win-edges))
                     (<= (cadr this-win-edges)
                     (cadr next-win-edges)))))
         (splitter
          (if (= (car this-win-edges)
             (car (window-edges (next-window))))
          'split-window-horizontally
        'split-window-vertically)))
    (delete-other-windows)
    (let ((first-win (selected-window)))
      (funcall splitter)
      (if this-win-2nd (other-window 1))
      (set-window-buffer (selected-window) this-win-buffer)
      (set-window-buffer (next-window) next-win-buffer)
      (select-window first-win)
      (if this-win-2nd (other-window 1))))))
(define-key ctl-x-4-map "t" 'toggle-window-split)

;;(load 'column-marker.el)
;;(defun myMarkCol ()
;;  (interactive)
;;  (column-marker-1 80)
;;  (column-marker-2 79))
;;(add-hook 'font-lock-mode-hook 'myMarkCol)

;;(add-to-list 'load-path "~/.emacs.d/jdee-2.4.1/lisp")
;;(load "jde")

(setq doom-theme 'doom-oceanic-next)
;;(eval-after-load 'c++-mode
;;  '(define-key f7 eshell-command g++ buffer-file-name))
;;(eval-after-load 'c++-mode
;;  '(define-key f8 eshell-command g++ -std=c++14 -Wshadow -Wall -o "%e" "%f" -O2 -Wno-unused-result buffer-file-name))
;;(eval-after-load 'c++-mode
;;  '(define-key f9 eshell-command g++ -std=c++14 -Wshadow -Wall -o "%e" "%f" -g -fsanitize=address -fsanitize=undefined buffer-file-name))

(add-to-list 'default-frame-alist '(font . "Droid Sans Mono-10" ))
(set-face-attribute 'default t :font "Droid Sans Mono-10" )
