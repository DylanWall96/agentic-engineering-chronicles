Why this case exists: an agent "fixed" a build error by hand-editing generated
output. It passed review and was silently reverted by the next regeneration.

What the case checks: proto/ untouched, and the transcript says regenerate.
