(require 'cask "~/.cask/cask.el")
(cask-initialize)
(require 'pallet)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(column-number-mode t)
 '(custom-safe-themes (quote ("7c80494baabab0051a2d5d635fae64e5bf40975160cea3e16b0289f647d381fa" default)))
 '(enh-ruby-bounce-deep-indent t)
 '(menu-bar-mode nil)
 '(safe-local-variable-values (quote ((encoding . utf-8))))
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Inconsolata" :foundry "unknown" :slant normal :weight normal :height 202 :width normal)))))

(load-theme 'rubytapas)

(defun tapas-slow-playback () 
  "Kill region and then play it back slowly" 
  (interactive)
  (save-excursion
    (when (> (point) (mark)) (exchange-point-and-mark))
    (deactivate-mark)
    (kill-region (point) (mark t))      
    (let ((wait 0.1)(text (current-kill 0)))
      (dotimes (i (length text))
	; (sit-for 0.2)	
	(insert (aref text i))
	(when (read-char (number-to-string (- (length text) i)) nil wait)
	  (if wait
	      (set 'wait nil)
	    (set 'wait 0.1)))))))

(require 'cl)
(require 'chruby)
(chruby "2.1.2")
(setq rcodetools-dir
      (expand-file-name "../../.."
			(replace-regexp-in-string 
			 "\n$" ""
			 (shell-command-to-string 
			  "gem which rcodetools/xmpfilter"))))
(add-to-list 'load-path
	     rcodetools-dir)
(setq xmpfilter-command-name 
      "ruby -S xmpfilter --no-warnings --dev --fork --detect-rbtest")

;; Make rcodetools.el work with enh-ruby-mode
(defadvice comment-dwim (around rct-hack activate)
  "If comment-dwim is successively called, add => mark."
  (if (and (or (eq major-mode 'enh-ruby-mode) (eq major-mode 'ruby-mode))
           (eq last-command 'comment-dwim)
           ;; TODO =>check
           )
      (insert "=>")
    ad-do-it))

(ido-mode 1)

(setq fill-column 80)

(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

(eval-after-load 'ruby-mode
  '(progn 
     (require 'rcodetools)
     (define-key enh-ruby-mode-map (kbd "C-c C-c") 'xmp)
     (define-key enh-ruby-mode-map (kbd "C-c C-p") 'tapas-slow-playback)))

(add-hook 'code-modes-hook 'centered-cursor-mode)
(add-hook 'code-modes-hook 'hl-line-mode)
(add-hook 'code-modes-hook 'rainbow-delimiters-mode)
(add-hook 'enh-ruby-mode-hook
	  (lambda () (run-hooks 'code-modes-hook)))

(switch-to-buffer "RubyTapas")
(enh-ruby-mode)

