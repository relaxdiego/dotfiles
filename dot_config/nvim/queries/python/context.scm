(class_definition
  body: (_) @context.end
) @context

; Make sure comments that immediately follow the function signature are not
; included in the context.
;
; See: nvim-treesitter-context <https://github.com/nvim-treesitter/nvim-treesitter-context>
; See: Syntax guide <https://tree-sitter.github.io/tree-sitter/using-parsers#pattern-matching-with-queries>
[
    (function_definition
      . name: (_)
      . parameters: (_)
      . return_type: (_)*
      . (comment) @context.end
    )
    (function_definition
      . name: (_)
      . parameters: (_)
      . return_type: (_)*
      . body: (_) @context.end
    )
] @context

(try_statement
  body: (_) @context.end
) @context

(with_statement
  body: (_) @context.end
) @context

(if_statement
  consequence: (_) @context.end
) @context

(elif_clause
  consequence: (_) @context.end
) @context

(case_clause
  consequence: (_) @context.end
) @context

(while_statement
  body: (_) @context.end
) @context

(except_clause
  (block) @context.end
) @context

(match_statement
  body: (_) @context.end
) @context

([
  (for_statement)
  (finally_clause)
  (else_clause)
  (pair)
] @context)
