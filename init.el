;; set font size
(set-face-attribute 'default nil :height 110)

; spell check
(setq ispell-program-name "aspell")
    ; could be ispell as well, depending on your preferences
(setq ispell-dictionary "english")
    ; this can obviously be set to any language your spell-checking program supports

(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-buffer)

;; ========== Enable Line and Column Numbering ==========

;; Show line-number in the mode line
(line-number-mode 1)

;; Show column-number in the mode line
(column-number-mode 1)

;; ===== Turn on Auto Fill mode automatically in all modes =====

;; Auto-fill-mode the the automatic wrapping of lines and insertion of
;; newlines when the cursor goes over the column limit.

;; This should actually turn on auto-fill-mode by default in all major
;; modes. The other way to do this is to turn on the fill for specific modes
;; via hooks.

(setq auto-fill-mode 1)

; shortcut to toggle auto fill mode
(global-set-key (kbd "C-c q") 'auto-fill-mode)

; == abbrev mode ==
(setq abbrev-file-name             ;; tell emacs where to read abbrev
        "~/.emacs.d/abbrev_defs")    ;; definitions from...
(setq save-abbrevs t)              ;; save abbrevs when files are saved
                                     ;; you will be asked before the abbreviations are saved
(if (file-exists-p abbrev-file-name)
        (quietly-read-abbrev-file)) ;; read abbrev file if exists
(setq default-abbrev-mode t) ;; enable abbrev mode by default in all modes

; ========= flymake - auto latex syntax check =========
;(require 'flymake)
;
;(defun flymake-get-tex-args (file-name)
;  (list "pdflatex" (list "-file-line-error" "-draftmode" "-interaction=nonstopmode" file-name)))
;(add-hook 'LaTeX-mode-hook 'flymake-mode)

; ========= auto-complete ========
(add-to-list 'load-path "/home/ipcv15/.emacs.d/")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "/home/ipcv15/.emacs.d//ac-dict")
(ac-config-default)

; ======== auto-complete-latex ======
(require 'auto-complete-latex)
(setq ac-l-dict-directory "/home/ipcv15/.emacs.d//ac-l-dict/")
(add-to-list 'ac-modes 'latex-mode)
(add-hook 'latex-mode-hook 'ac-l-setup)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#ad7fa8" "#8cc4ff" "#eeeeec"])
 '(column-number-mode t)
 '(custom-enabled-themes nil)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

; ========================= org mode =======================
;; The following lines are always needed. Choose your own keys.
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode)) ; not needed since Emacs 22.2
(add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
;============================================================




;; enable c++ mode for cuda .cu files
;; (add-to-list 'auto-mode-alist '("\\.cu\\'" . c++-mode))

;; ===================== cudamode starts =====================
;; ===========================================================
;; http://www.emacswiki.org/emacs/CudaMode

;; Note: The interface used in this file requires CC Mode 5.30 or
;; later.

;;; Code:

(require 'cc-mode)

;; These are only required at compile time to get the sources for the
;; language constants.  (The cc-fonts require and the font-lock
;; related constants could additionally be put inside an
;; (eval-after-load "font-lock" ...) but then some trickery is
;; necessary to get them compiled.)
(eval-when-compile
  (require 'cc-langs)
  (require 'cc-fonts))


(eval-and-compile
  ;; Make our mode known to the language constant system.  Use C
  ;; mode as the fallback for the constants we don't change here.
  ;; This needs to be done also at compile time since the language
  ;; constants are evaluated then.
  (c-add-language 'cuda-mode 'c++-mode))

;; cuda has no boolean but a string and a vector type.
(c-lang-defconst c-primitive-type-kwds
  "Primitive type keywords.  As opposed to the other keyword lists, the
keywords listed here are fontified with the type face instead of the
keyword face.

If any of these also are on `c-type-list-kwds', `c-ref-list-kwds',
`c-colon-type-list-kwds', `c-paren-nontype-kwds', `c-paren-type-kwds',
`c-<>-type-kwds', or `c-<>-arglist-kwds' then the associated clauses
will be handled.

Do not try to modify this list for end user customizations; the
`*-font-lock-extra-types' variable, where `*' is the mode prefix, is
the appropriate place for that."
  cuda 
  (append 
   '("dim3" 
	 "char1" "uchar1" "char2" "uchar2" "char3" "uchar3" "char4" "uchar4"
	 "short1" "ushort1" "short2" "ushort2" "short3" "ushort3" "short4" "ushort4"
	 "int1" "uint1" "int2" "uint2" "int3" "uint3" "int4" "uint4"
	 "long1" "ulong1" "long2" "ulong2" "long3" "ulong3" "long4" "ulong4"
	 "float1" "float2"  "float3" "float4" 
	 "double1" "double2" )
   ;; Use append to not be destructive on the
   ;; return value below.
   (append
	(c-lang-const c-primitive-type-kwds)
	nil)))

(c-lang-defconst c-type-modifier-keywds
  "Type modifier keywords.  These can occur almost anywhere in types
but they don't build a type of themselves.  Unlike the keywords on
`c-primitive-type-kwds', they are fontified with the keyword face and
not the type face."
  cuda
    (append 
      '("__device__", "__global__", "__shared__", "__host__", "__constant__") 
      (c-lang-const c-type-modifier-keywds) 
      nil))

(c-lang-defconst c-other-op-syntax-tokens
  "List of the tokens made up of characters in the punctuation or
parenthesis syntax classes that have uses other than as expression
operators."
  cuda
  (append '("#" "##"	; Used by cpp.
	    "::" "..." "<<<" ">>>")
	  (c-lang-const c-other-op-syntax-tokens)))

(c-lang-defconst c-primary-expr-kwds
  "Keywords besides constants and operators that start primary expressions."
  cuda  '("gridDim" "blockIdx" "blockDim" "threadIdx" "warpSize"))

(c-lang-defconst c-paren-nontype-kwds
  "Keywords that may be followed by a parenthesis expression that doesn't
contain type identifiers."
  cuda       nil
  (c c++) '(;; GCC extension.
	    "__attribute__"
	    ;; MSVC extension.
	    "__declspec"))

(defcustom cuda-font-lock-extra-types nil
  "*List of extra types (aside from the type keywords) to recognize in Cuda mode.
Each list item should be a regexp matching a single identifier.")

(defconst cuda-font-lock-keywords-1 
  (c-lang-const c-matchers-1 cuda)
  "Minimal highlighting for CUDA mode.")

(defconst cuda-font-lock-keywords-2 
  (c-lang-const c-matchers-2 cuda)
  "Fast normal highlighting for CUDA mode.")

(defconst cuda-font-lock-keywords-3 
  (c-lang-const c-matchers-3 cuda)
  "Accurate normal highlighting for CUDA mode.")

(defvar cuda-font-lock-keywords cuda-font-lock-keywords-3
  "Default expressions to highlight in CUDA mode.")

(defvar cuda-mode-syntax-table nil
  "Syntax table used in cuda-mode buffers.")
(or cuda-mode-syntax-table
    (setq cuda-mode-syntax-table
      (funcall (c-lang-const c-make-mode-syntax-table cuda))))

(defvar cuda-mode-abbrev-table nil
  "Abbreviation table used in cuda-mode buffers.")

(c-define-abbrev-table 'cuda-mode-abbrev-table
  ;; Keywords that if they occur first on a line might alter the
  ;; syntactic context, and which therefore should trig reindentation
  ;; when they are completed.
  '(("else" "else" c-electric-continued-statement 0)
    ("while" "while" c-electric-continued-statement 0)))

(defvar cuda-mode-map (let ((map (c-make-inherited-keymap)))
              ;; Add bindings which are only useful for CUDA
              map)
  "Keymap used in cuda-mode buffers.")

(easy-menu-define cuda-menu cuda-mode-map "CUDA Mode Commands"
          ;; Can use `cuda' as the language for `c-mode-menu'
          ;; since its definition covers any language.  In
          ;; this case the language is used to adapt to the
          ;; nonexistence of a cpp pass and thus removing some
          ;; irrelevant menu alternatives.
          (cons "CUDA" (c-lang-const c-mode-menu cuda)))

;;;###Autoload
(add-to-list 'auto-mode-alist '("\\.cu\\'" . cuda-mode))

;;;###autoload
(defun cuda-mode ()
  "Major mode for editing CUDA Cuda is a C like language extension
for mixed native/GPU coding created by NVIDA
 
The hook `c-mode-common-hook' is run with no args at mode
initialization, then `cuda-mode-hook'.

Key bindings:
\\{cuda-mode-map}"
  (interactive)
  (kill-all-local-variables)
  (c-initialize-cc-mode t)
  (set-syntax-table cuda-mode-syntax-table)
  (setq major-mode 'cuda-mode
    mode-name "Cuda"
    local-abbrev-table cuda-mode-abbrev-table
    abbrev-mode t)
  (use-local-map c-mode-map)
  ;; `c-init-language-vars' is a macro that is expanded at compile
  ;; time to a large `setq' with all the language variables and their
  ;; customized values for our language.
  (c-init-language-vars cuda-mode)
  ;; `c-common-init' initializes most of the components of a CC Mode
  ;; buffer, including setup of the mode menu, font-lock, etc.
  ;; There's also a lower level routine `c-basic-common-init' that
  ;; only makes the necessary initialization to get the syntactic
  ;; analysis and similar things working.
  (c-common-init 'cuda-mode)
  (easy-menu-add cuda-menu)
  (run-hooks 'c-mode-common-hook)
  (run-hooks 'cuda-mode-hook)
  (setq font-lock-keywords-case-fold-search t)
  (c-update-modeline))

 
(provide 'cuda-mode)
;; ===================== cuda mode ends ===============================
;; ====================================================================


;; ============== initialize colour theme == (not working)
;(require 'color-theme)
;(color-theme-initialize)
;(misterioso)
(load-theme 'misterioso t)
