;;; package --- Summary
;;; Commentary:
;;; Louis' Emacs init file
;;; Code:

;; Install straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
          (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
         (bootstrap-version 5))
    (unless (file-exists-p bootstrap-file)
        (with-current-buffer
            (url-retrieve-synchronously
                "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
                'silent 'inhibit-cookies)
            (goto-char (point-max))
            (eval-print-last-sexp)))
    (load bootstrap-file nil 'nomessage))

;; Install use-package
(straight-use-package 'use-package)

;; Configure use-package to use straight.el by default
(use-package straight
    :custom (straight-use-package-by-default t))

;; Do not clutter my directories with emacs backup files
(setq
    make-backup-files nil
    auto-save-default nil
    create-lockfiles nil)

;; keyboard shortcuts (keybindings)
;; https://www.masteringemacs.org/article/mastering-key-bindings-emacs

(global-set-key (kbd "C-x ;") 'comment-line)

;; Minor modes keys usually override global keys, so if you don't want such behavior, use function bind-key* instead
(bind-key* "C-c /" #'comment-dwim)

(use-package emacs
    :config
    (load-theme 'modus-operandi) ;; OR (load-theme 'modus-vivendi)
    :bind ("<f5>" . modus-themes-toggle))

(use-package diminish)
(use-package delight)
(use-package bind-key)
(use-package magit)
(use-package eglot)
(use-package s)
(use-package dash)
(use-package eglot)

(use-package exec-path-from-shell
    :if (memq window-system '(mac ns x))
    :config
    (exec-path-from-shell-initialize))

(when (daemonp)
    (use-package exec-path-from-shell
    :config
    (exec-path-from-shell-initialize)))

(use-package undo-tree
    :diminish
    :bind (("C-c _" . undo-tree-visualize))
    :config
    (global-undo-tree-mode +1)
    (unbind-key "M-_" undo-tree-map))

(use-package multiple-cursors
    :bind (("C-c C-e m" . #'mc/edit-lines)
              ("C-c C-e d" . #'mc/mark-all-dwim)))

(use-package xref
    :bind (("s-r" . #'xref-find-references)
              ("s-[" . #'xref-go-back)
              ("C-<down-mouse-2>" . #'xref-go-back)
              ("s-]" . #'xref-go-forward)))

(use-package eldoc
    :diminish
    :bind ("s-d" . #'eldoc)
    :custom (eldoc-echo-area-prefer-doc-buffer t))

(use-package company
    :config
    (global-company-mode))

(use-package editorconfig
    :config
    (editorconfig-mode 1))

(use-package add-node-modules-path)

;; (use-package prettier-js)
(use-package prettier
    :config
    (global-prettier-mode))

(use-package consult
    :bind (("C-c h" . consult-history)
              ("C-c m" . consult-mode-command)
              ("C-c k" . consult-kmacro)
              ;; C-x bindings (ctl-x-map)
              ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
              ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
              ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
              ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
              ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
              ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
              ;; Custom M-# bindings for fast register access
              ("M-#" . consult-register-load)
              ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
              ("C-M-#" . consult-register)
              ;; Other custom bindings
              ("M-y" . consult-yank-pop)                ;; orig. yank-pop
              ("<help> a" . consult-apropos)            ;; orig. apropos-command
              ;; M-g bindings (goto-map)
              ("M-g e" . consult-compile-error)
              ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
              ("M-g g" . consult-goto-line)             ;; orig. goto-line
              ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
              ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
              ("M-g m" . consult-mark)
              ("M-g k" . consult-global-mark)
              ("M-g i" . consult-imenu)
              ("M-g I" . consult-imenu-multi)
              ;; M-s bindings (search-map)
              ("M-s d" . consult-find)
              ("M-s D" . consult-locate)
              ("M-s g" . consult-grep)
              ("M-s G" . consult-git-grep)
              ("M-s r" . consult-ripgrep)
              ("M-s l" . consult-line)
              ("M-s L" . consult-line-multi)
              ("M-s m" . consult-multi-occur)
              ("M-s k" . consult-keep-lines)
              ("M-s u" . consult-focus-lines)
              ;; Isearch integration
              ("M-s e" . consult-isearch-history)
              :map isearch-mode-map
              ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
              ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
              ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
              ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
              ;; Minibuffer history
              :map minibuffer-local-map
              ("M-s" . consult-history)                 ;; orig. next-matching-history-element
              ("M-r" . consult-history))                ;; orig. previous-matching-history-element

    ;; Enable automatic preview at point in the *Completions* buffer. This is
    ;; relevant when you use the default completion UI.
    :hook (completion-list-mode . consult-preview-at-point-mode)

    ;; The :init configuration is always executed (Not lazy)
    :init

    ;; Optionally configure the register formatting. This improves the register
    ;; preview for `consult-register', `consult-register-load',
    ;; `consult-register-store' and the Emacs built-ins.
    (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

    ;; Optionally tweak the register preview window.
    ;; This adds thin lines, sorting and hides the mode line of the window.
    (advice-add #'register-preview :override #'consult-register-window)

    ;; Use Consult to select xref locations with preview
    (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

    ;; Configure other variables and modes in the :config section,
    ;; after lazily loading the package.
    :config

    ;; Optionally configure preview. The default value
    ;; is 'any, such that any key triggers the preview.
    ;; (setq consult-preview-key 'any)
    ;; (setq consult-preview-key (kbd "M-."))
    ;; (setq consult-preview-key (list (kbd "<S-down>") (kbd "<S-up>")))
    ;; For some commands and buffer sources it is useful to configure the
    ;; :preview-key on a per-command basis using the `consult-customize' macro.
    (consult-customize
        consult-theme
        :preview-key '(:debounce 0.2 any)
        consult-ripgrep consult-git-grep consult-grep
        consult-bookmark consult-recent-file consult-xref
        consult--source-bookmark consult--source-recent-file
        consult--source-project-recent-file
        :preview-key (kbd "M-."))

    ;; Optionally configure the narrowing key.
    ;; Both < and C-+ work reasonably well.
    (setq consult-narrow-key "<") ;; (kbd "C-+")

    ;; Optionally make narrowing help available in the minibuffer.
    ;; You may want to use `embark-prefix-help-command' or which-key instead.
    ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

    ;; By default `consult-project-function' uses `project-root' from project.el.
    ;; Optionally configure a different project root function.
    ;; There are multiple reasonable alternatives to chose from.
  ;;;; 1. project.el (the default)
    ;; (setq consult-project-function #'consult--default-project--function)
  ;;;; 2. projectile.el (projectile-project-root)
    ;; (autoload 'projectile-project-root "projectile")
    ;; (setq consult-project-function (lambda (_) (projectile-project-root)))
  ;;;; 3. vc.el (vc-root-dir)
    ;; (setq consult-project-function (lambda (_) (vc-root-dir)))
  ;;;; 4. locate-dominating-file
    ;; (setq consult-project-function (lambda (_) (locate-dominating-file "." ".git")))
    )

(use-package consult-flycheck)

(use-package consult-eglot
    :bind (:map eglot-mode-map ("s-t" . #'consult-eglot-symbols)))

(use-package vertico
    :init
    (vertico-mode)
    (setq vertico-cycle t))

(use-package orderless
    :init
    ;; Configure a custom style dispatcher (see the Consult wiki)
    ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
    ;;       orderless-component-separator #'orderless-escapable-split-on-space)
    (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

;; -----
;; Rust
;; -----

(use-package rust-mode
    :defer t
    :custom
    (rust-format-on-save t)
    (lsp-rust-server 'rust-analyzer))

;; --------
;; Golang
;; --------

(use-package go-mode
    :defer t
    :config
    (add-hook 'before-save-hook #'gofmt-before-save))

(use-package go-snippets :defer t)

(defun fix-messed-up-gofmt-path ()
    (interactive)
    (setq gofmt-command (string-trim (shell-command-to-string "which gofmt"))))

(use-package gotest
    :bind (:map go-mode-map
              ("C-c a t" . #'go-test-current-test)))

;; -----------
;; Python
;; -----------

(use-package blacken
    :hook ((python-mode . blacken-mode)))

;; --------------------
;; Typescript Development with Tree Sitter and LSP
;; https://vxlabs.com/2022/06/12/typescript-development-with-emacs-tree-sitter-and-lsp-in-2022/
;; ---------------------

(use-package tree-sitter
    :config
    ;; activate tree-sitter on any buffer containing code for which it has a parser available
    (global-tree-sitter-mode)
    ;; you can easily see the difference tree-sitter-hl-mode makes for python, ts or tsx
    ;; by switching on and off
    (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package tree-sitter-langs
    :after tree-sitter)


(use-package typescript-mode
    :after tree-sitter
    :init
    (setq-default js-indent-level 2)
    (add-hook 'typescript-mode-hook #'add-node-modules-path))

;; (use-package typescript-mode
;;   :after tree-sitter
;;   :init
;;   (add-hook 'typescript-mode-hook #'add-node-modules-path)
;;   (add-hook 'typescript-mode-hook #'prettier-mode)
;;   :config
;;   ;; we choose this instead of tsx-mode so that eglot can automatically figure out language for server
;;   ;; see https://github.com/joaotavora/eglot/issues/624 and https://github.com/joaotavora/eglot#handling-quirky-servers
;;   (define-derived-mode typescriptreact-mode typescript-mode
;;     "TypeScript TSX")

;;   ;; use our derived mode for tsx files
;;   (add-to-list 'auto-mode-alist '("\\.tsx?\\'" . typescriptreact-mode))
;;   ;; by default, typescript-mode is mapped to the treesitter typescript parser
;;   ;; use our derived mode to map both .tsx AND .ts -> typescriptreact-mode -> treesitter tsx
;;   (add-to-list 'tree-sitter-major-mode-language-alist '(typescriptreact-mode . tsx)))

;; https://github.com/orzechowskid/tsi.el/
;; great tree-sitter-based indentation for typescript/tsx, css, json
;; (use-package tsi
;;     :after tree-sitter
;;     :straight (tsi :type git :host github :repo "orzechowskid/tsi.el")
;;   ;; define autoload definitions which when actually invoked will cause package to be loaded
;;   :commands (tsi-typescript-mode tsi-json-mode tsi-css-mode)
;;   :init
;;   (add-hook 'typescript-mode-hook (lambda () (tsi-typescript-mode 1)))
;;   (add-hook 'json-mode-hook (lambda () (tsi-json-mode 1)))
;;   (add-hook 'css-mode-hook (lambda () (tsi-css-mode 1)))
;;   (add-hook 'scss-mode-hook (lambda () (tsi-scss-mode 1))))

;; ------------------------------------------------------------------
;; auto-format different source code files extremely intelligently
;; https://github.com/radian-software/apheleia
;; ------------------------------------------------------------------

(use-package apheleia
    :config
    (apheleia-global-mode t))

;; ---------------------------------------------------------
;; Make clipboard copy and paste works on macosx terminal
;; ---------------------------------------------------------

(defun copy-from-osx ()
    (shell-command-to-string "pbpaste"))

(defun paste-to-osx (text &optional push)
    (let ((process-connection-type nil))
        (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
            (process-send-string proc text)
            (process-send-eof proc))))

(setq interprogram-cut-function 'paste-to-osx)
(setq interprogram-paste-function 'copy-from-osx)

;; -----------------------
;; Misc
;; ------------------------

(use-package yaml-mode :defer t)
(use-package dockerfile-mode :defer t)
(use-package toml-mode :defer t)

(use-package markdown-mode
    :bind (:map markdown-mode-map ("C-c C-s a" . markdown-table-align))
    :mode ("\\.md$" . gfm-mode))

(use-package restclient
    :mode ("\\.restclient$" . restclient-mode))

(straight-use-package
    '(popon :type git :repo "https://codeberg.org/akib/emacs-popon.git"))

(straight-use-package
    '(corfu-terminal
         :type git
         :repo "https://codeberg.org/akib/emacs-corfu-terminal.git"))

(straight-use-package
    '(corfu-doc-terminal
         :type git
         :repo "https://codeberg.org/akib/emacs-corfu-doc-terminal.git"))

(unless (display-graphic-p) (corfu-terminal-mode +1))
(unless (display-graphic-p) (corfu-doc-terminal-mode +1))

(use-package corfu
    ;; Optional customizations
    ;; :custom
    ;; (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
    ;; (corfu-auto t)                 ;; Enable auto completion
    ;; (corfu-separator ?\s)          ;; Orderless field separator
    ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
    ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
    ;; (corfu-preview-current nil)    ;; Disable current candidate preview
    ;; (corfu-preselect-first nil)    ;; Disable candidate preselection
    ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
    ;; (corfu-echo-documentation nil) ;; Disable documentation in the echo area
    ;; (corfu-scroll-margin 5)        ;; Use scroll margin

    ;; Enable Corfu only for certain modes.
    ;; :hook ((prog-mode . corfu-mode)
    ;;        (shell-mode . corfu-mode)
    ;;        (eshell-mode . corfu-mode))

    ;; Recommended: Enable Corfu globally.
    ;; This is recommended since Dabbrev can be used globally (M-/).
    ;; See also `corfu-excluded-modes'.
    :init
    (global-corfu-mode))

;; A few more useful configurations...
(use-package emacs
    :init
    ;; TAB cycle if there are only few candidates
    (setq completion-cycle-threshold 3)

    ;; Emacs 28: Hide commands in M-x which do not apply to the current mode.
    ;; Corfu commands are hidden, since they are not supposed to be used via M-x.
    ;; (setq read-extended-command-predicate
    ;;       #'command-completion-default-include-p)

    ;; Enable indentation+completion using the TAB key.
    ;; `completion-at-point' is often bound to M-TAB.
    (setq tab-always-indent 'complete))

(use-package kind-icon
    :after corfu
    :custom
    (kind-icon-default-face 'corfu-default) ; to compute blended backgrounds correctly
    :config
    (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(provide 'init)
;;; init.el ends here
