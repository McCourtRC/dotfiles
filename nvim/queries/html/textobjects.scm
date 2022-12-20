(element
  (start_tag (tag_name) @html.start) 
  (end_tag (tag_name) @html.end)?
) @html.outer

(element (start_tag) . (_) @html.inner . (end_tag))

((element (start_tag) . (_) @_start (_) @_end . (end_tag))
 (#make-range! "html.inner" @_start @_end))

(attribute
  (attribute_name) @key
  (quoted_attribute_value) @value
) @pair

(comment) @comment.outer
