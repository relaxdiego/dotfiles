;; extends

; Match Arrange, Act, and Assert comments
;
; See: Syntax guide <https://tree-sitter.github.io/tree-sitter/using-parsers#pattern-matching-with-queries>
(
  (comment) @comment.arrange_act_assert
  (#match? @comment.arrange_act_assert "// (Arrange|Act|Assert|Act and Assert)")
)
