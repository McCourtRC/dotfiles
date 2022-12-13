(lexical_declaration) @variable.outer
(variable_declaration) @variable.outer
(variable_declarator value: (_) @variable.inner)

(object 
  (pair
    key: (_) @key
    value: (_) @value
  ) @pair
)

(array (_) @item.inner)
