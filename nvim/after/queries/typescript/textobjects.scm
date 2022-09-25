(type_annotation) @type.outer
(type_identifier) @type.inner
(predefined_type) @type.inner
(enum_declaration (identifier) @type.inner)

(variable_declaration) @variable.outer
(lexical_declaration) @variable.outer
(variable_declarator value: (_) @variable.inner)
