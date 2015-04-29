;;; Compiled snippets and support files for `js-mode'
;;; Snippet definitions:
;;;
(yas-define-snippets 'js-mode
                     '(("be" "beforeEach(function(){\n$0\n});" "before-each" nil nil nil nil "direct-keybinding" nil)
                       (".then" ".then(function(${1:value}) {\n$0\n});" "chain-then" nil nil nil nil "direct-keybinding" nil)
                       ("desc" "describe('${1:description}', function(){\n$0\n});" "describe" nil nil nil nil "direct-keybinding" nil)
                       ("ib-anal" "  analytics: Em.inject.service('google-analytics')," "inject analytics" nil nil nil nil "direct-keybinding" nil)
                       ("ib-assert" "logger.assert('${2:description}', ${1:condition});$0" "ib-assert" nil nil nil nil "direct-keybinding" nil)
                       ("ib-data" "import ibottaData from 'ibotta-web/utils/ibotta-data';" "import ibotta data" nil nil nil nil "direct-keybinding" nil)
                       ("ib-element" "import ModelElementIdMixin from 'ibotta-web/mixins/model-element-id';\n" "model element id" nil nil nil nil "direct-keybinding" nil)
                       ("ib-env" "import ENV from 'ibotta-web/config/environment;" "import environment" nil nil nil nil "direct-keybinding" nil)
                       ("ib-logger" "import logger from 'ibotta-web/utils/logger';\n" "import logger" nil nil nil nil "direct-keybinding" nil)
                       ("ib-session" "  session: Em.inject.service('session')," "inject session" nil nil nil nil "direct-keybinding" nil)
                       ("ib-static" "import staticConstants from 'ibotta-web/utils/static-constants';\n" "import static constants" nil nil nil nil "direct-keybinding" nil)
                       ("ib-utils" "import ibottaUtilities from 'ibotta-web/utils/ibotta-utilities';" "import utilities" nil nil nil nil "direct-keybinding" nil)
                       ("its" "it('${1:description}', function(){\n$0\n});" "it synchronous" nil nil nil nil "direct-keybinding" nil)
                       ("then" "${1:promise}.then(function() {\n$0\n});" "promise-then" nil nil nil nil "direct-keybinding" nil)
                       ("sup" "this._super.apply(this, arguments);" "super" nil nil nil nil "direct-keybinding" nil)))


;;; Do not edit! File generated at Tue Apr 28 17:56:37 2015
