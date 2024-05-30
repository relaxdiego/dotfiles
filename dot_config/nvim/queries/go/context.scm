; See: Syntax guide <https://tree-sitter.github.io/tree-sitter/using-parsers#pattern-matching-with-queries>

([
  (var_declaration)
  (type_declaration)
  (import_declaration)
  (const_declaration)
  (select_statement)
  (expression_switch_statement)
  (expression_case)
  (default_case)
] @context)

(function_declaration
  body: (block (_) @context.end)
) @context

(func_literal
  body: (block (_) @context.end)
) @context

(method_declaration
  body: (block (_) @context.end)
) @context

(if_statement
  consequence: (block (_) @context.end)
) @context

(for_statement
  body: (block (_) @context.end)
) @context

(communication_case
  communication: (_)
  (_) @context.end
) @context

(call_expression) @context
