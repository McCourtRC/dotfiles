(type_annotation) @type.outer
(type_identifier) @type.inner
(predefined_type) @type.inner
(enum_declaration (identifier) @type.inner)

(variable_declaration) @variable.outer
(lexical_declaration) @variable.outer
(variable_declarator value: (_) @variable.inner)

(object 
  (pair
    key: (_) @key
    value: (_) @value
  ) @pair
)

; arrays
(array 
  ((_) @item.inner . ","? @_end) @item.outer
  (#make-range! "item.outer" @item.inner @_end) 
)

; ; html
; (jsx_element) @html.outer
; ; (jsx_element open_tag: (_) . (_) @html.inner)
;
; (jsx_opening_element
;   name: (identifier) @html.start
; )
;
; (jsx_closing_element
;   name: (identifier) @html.end
; )

