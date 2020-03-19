(when (buffer-newly-created? (current-buffer))
  (set-document-language "chinese")
  (buffer-pretend-saved (current-buffer)))
