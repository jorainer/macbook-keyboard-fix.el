;; Drop it in your load path and (require 'macbook-keyboard-fix).
;; Possibly also (add-hook 'foo-mode-hook 'macbook-keyboard-fix-mode).

;;; Commentary:


;;; Author

;; Johannes Rainer (johannes.rainer@eurac.edu)
(setq delete-keys (make-sparse-keymap))
(define-key delete-keys (kbd "b") "b")
(define-key delete-keys (kbd "B") "B")
(define-key delete-keys (kbd "h") "h")
(define-key delete-keys (kbd "H") "H")

(define-minor-mode macbook-keyboard-fix-mode
  "When active, avoids multiple insertion of certain characters that can happen
   with the new macbook pro keyboards."

  :init-value nil
  :lighter " MF"
  (if macbook-keyboard-fix-mode
      (add-hook 'post-command-hook
                'delete-multi-key)
    (remove-hook 'post-command-hook
                 'delete-multi-key)))

;; alternatively use post-self-insert-hook

(defun delete-multi-key ()
  ;; this worries me
  ;; (if (and (boundp 'linum-mode)
  ;;          (not (eq nil linum-mode)))
  ;;     (linum-schedule))
  (when (and (eq (char-before) last-command-event)
             (not (window-minibuffer-p (selected-window))))
    (let* ((lastkey (lookup-key delete-keys (string (char-before))))
	   (buflen (string-width (buffer-string)))
	   )
      ;; Don't do anything if we're at the beginning of a line or
      ;; the buffer has length < 2
      (when (and (not (bolp)) (> buflen 1))
	(when (stringp lastkey)
	  ;; key is in our map, check if the last character was the same.
	  (when (= (char-before) (char-before (1- (point))))
	    (progn
	      (backward-delete-char 1)
	      )
	    (message "we got double chars: %s" lastkey))
	  )
	)
      )
    )
  )
  
(provide 'macboard-keyboard-fix)
